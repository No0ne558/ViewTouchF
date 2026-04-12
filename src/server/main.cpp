#include <grpcpp/grpcpp.h>
#include <unistd.h>

#include <atomic>
#include <chrono>
#include <csignal>
#include <filesystem>
#include <iostream>
#include <memory>
#include <thread>

#include "core/database.h"
#include "core/pos_manager.h"
#include "printing/cups_printer.h"
#include "server/pos_service_impl.h"

namespace {
std::unique_ptr<grpc::Server> g_server;
std::atomic<bool> g_shutdown_requested{false};

void signal_handler(int /*sig*/) {
    // Only set the flag — never call Shutdown() from a signal handler
    // because gRPC 1.48's abseil mutex is not async-signal-safe.
    g_shutdown_requested.store(true, std::memory_order_relaxed);
}
}  // namespace

int main(int argc, char* argv[]) {
    // ── Parse optional args ──────────────────────────────────
    std::string data_dir = "/opt/viewtouchf";
    std::string listen_addr;   // set after args
    std::string printer_name;  // empty = CUPS default

    for (int i = 1; i < argc; ++i) {
        std::string arg = argv[i];
        if (arg == "--listen" && i + 1 < argc) {
            listen_addr = argv[++i];
        } else if (arg == "--printer" && i + 1 < argc) {
            printer_name = argv[++i];
        } else if (arg == "--data-dir" && i + 1 < argc) {
            data_dir = argv[++i];
        }
    }

    // Ensure data directories exist
    namespace fs = std::filesystem;
    for (const auto& sub : {"data", "menu", "logs", "config", "run"}) {
        fs::create_directories(fs::path(data_dir) / sub);
    }

    // Default socket lives under the data dir
    if (listen_addr.empty()) {
        listen_addr = "unix://" + data_dir + "/run/pos.sock";
    }

    // Remove stale socket from a previous run / crash
    {
        std::string sock_path = data_dir + "/run/pos.sock";
        std::error_code ec;
        fs::remove(sock_path, ec);
    }

    std::cout << "[vt_daemon] data directory: " << data_dir << "\n";

    // ── Bootstrap core objects ───────────────────────────────
    viewtouch::Database db(data_dir + "/data/viewtouchf.db");

    auto mgr = std::make_shared<viewtouch::PosManager>(
        /*tax_rate_bps=*/825, /*restaurant_name=*/"El Mirador Express");
    mgr->set_database(&db);
    mgr->load_from_database();

    auto printer =
        std::make_shared<viewtouch::CupsPrinter>(printer_name, mgr->get_restaurant_name());

    // Seed demo menu only on first run — never re-seed after initial setup
    // even if the user deletes all items.
    if (db.load_setting("menu_seeded") != "1") {
        std::vector<viewtouch::MenuItem> demo_menu;

        // ── Entrees (with modifier groups) ───────────────────────
        {
            viewtouch::MenuItem item;
            item.id = "BUR01";
            item.name = "Classic Burger";
            item.price_cents = 1299;
            item.category = "Entrees";
            item.modifier_groups = {
                {"MG01",
                 "Toppings",
                 {
                     {"MOD01", "Lettuce", 0, true},
                     {"MOD02", "Tomato", 0, true},
                     {"MOD03", "Onion", 0, true},
                     {"MOD04", "Pickles", 0, true},
                     {"MOD05", "Cheese", 0, true},
                     {"MOD06", "Bacon", 199, false},
                     {"MOD07", "Jalapeños", 50, false},
                     {"MOD08", "Avocado", 150, false},
                 },
                 0,
                 0},
                {"MG02",
                 "Cooking Temp",
                 {
                     {"MOD10", "Rare", 0, false},
                     {"MOD11", "Medium Rare", 0, true},
                     {"MOD12", "Medium", 0, false},
                     {"MOD13", "Well Done", 0, false},
                 },
                 1,
                 1},
            };
            demo_menu.push_back(std::move(item));
        }
        {
            viewtouch::MenuItem item;
            item.id = "BUR02";
            item.name = "Cheese Burger";
            item.price_cents = 1499;
            item.category = "Entrees";
            item.modifier_groups = {
                {"MG03",
                 "Toppings",
                 {
                     {"MOD40", "Lettuce", 0, true},
                     {"MOD41", "Tomato", 0, true},
                     {"MOD42", "Onion", 0, true},
                     {"MOD43", "Pickles", 0, true},
                     {"MOD44", "Extra Cheese", 100, false},
                     {"MOD45", "Bacon", 199, false},
                     {"MOD46", "Jalapeños", 50, false},
                 },
                 0,
                 0},
            };
            demo_menu.push_back(std::move(item));
        }
        {
            viewtouch::MenuItem item;
            item.id = "TAC01";
            item.name = "Street Tacos (3)";
            item.price_cents = 999;
            item.category = "Entrees";
            item.modifier_groups = {
                {"MG04",
                 "Protein",
                 {
                     {"MOD30", "Carne Asada", 0, true},
                     {"MOD31", "Pollo", 0, false},
                     {"MOD32", "Al Pastor", 0, false},
                     {"MOD33", "Carnitas", 0, false},
                 },
                 1,
                 1},
                {"MG05",
                 "Extras",
                 {
                     {"MOD34", "Cilantro", 0, true},
                     {"MOD35", "Onion", 0, true},
                     {"MOD36", "Salsa Verde", 0, true},
                     {"MOD37", "Guacamole", 150, false},
                     {"MOD38", "Sour Cream", 75, false},
                 },
                 0,
                 0},
            };
            demo_menu.push_back(std::move(item));
        }

        // ── Beverages & Sides (no modifiers) ─────────────────────
        {
            viewtouch::MenuItem bev1;
            bev1.id = "BEV01";
            bev1.name = "Iced Tea";
            bev1.price_cents = 299;
            bev1.category = "Beverages";
            bev1.send_to_kitchen = false;
            demo_menu.push_back(std::move(bev1));
        }
        {
            viewtouch::MenuItem bev2;
            bev2.id = "BEV02";
            bev2.name = "Horchata";
            bev2.price_cents = 399;
            bev2.category = "Beverages";
            bev2.send_to_kitchen = false;
            demo_menu.push_back(std::move(bev2));
        }
        demo_menu.push_back({"SID01", "Fries", 499, "Sides", {}, true});
        demo_menu.push_back({"SID02", "Rice & Beans", 399, "Sides", {}, true});

        mgr->load_menu(std::move(demo_menu));
        db.save_setting("menu_seeded", "1");
        std::cout << "[vt_daemon] seeded demo menu (" << mgr->get_menu().size() << " items)\n";
    }  // end first-run seed

    // ── Build and start gRPC server ──────────────────────────
    PosServiceImpl service(mgr, printer);
    service.set_shutdown_callback([]() {
        std::cerr << "\n[vt_daemon] shutdown requested via RPC\n";
        g_shutdown_requested.store(true, std::memory_order_relaxed);
    });

    grpc::ServerBuilder builder;
    builder.AddListeningPort(listen_addr, grpc::InsecureServerCredentials());
    builder.RegisterService(&service);

    // Tune for low-memory POS terminal:
    builder.SetMaxReceiveMessageSize(1 * 1024 * 1024);  // 1 MB
    builder.SetMaxSendMessageSize(1 * 1024 * 1024);

    g_server = builder.BuildAndStart();
    if (!g_server) {
        std::cerr << "[vt_daemon] Failed to start server on " << listen_addr << "\n";
        return 1;
    }

    std::cout << "[vt_daemon] listening on " << listen_addr << "\n";

    // Graceful shutdown on SIGINT / SIGTERM
    std::signal(SIGINT, signal_handler);
    std::signal(SIGTERM, signal_handler);

    // Dedicated thread polls the atomic flag and calls Shutdown()
    // from a clean context — avoids the abseil deadlock in gRPC 1.48
    // that occurs when Shutdown() is called from a signal handler
    // or from within a gRPC handler thread.
    std::thread shutdown_watcher([&]() {
        while (!g_shutdown_requested.load(std::memory_order_relaxed))
            std::this_thread::sleep_for(std::chrono::milliseconds(100));
        std::cerr << "[vt_daemon] shutting down...\n";
        if (g_server) g_server->Shutdown();
    });

    g_server->Wait();
    shutdown_watcher.join();
    return 0;
}
