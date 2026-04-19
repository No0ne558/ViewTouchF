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
        /*tax_rate_bps=*/825, /*restaurant_name=*/"Demo Restaurant");
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

        // ── Build-A-Bowl (demonstrates Choice 1/Choice 2 groups) ───
        {
            viewtouch::MenuItem item;
            item.id = "BWL01";
            item.name = "Build-A-Bowl";
            item.price_cents = 1099;
            item.category = "Entrees";
            item.modifier_groups = {
                {"MG06",
                 "Choice 1: Base",
                 {
                     {"MOD100", "Rice", 0, true},
                     {"MOD101", "Greens", 0, false},
                     {"MOD102", "Noodles", 0, false},
                 },
                 1,
                 1},
                {"MG07",
                 "Choice 2: Protein",
                 {
                     {"MOD110", "Chicken", 0, true},
                     {"MOD111", "Tofu", 0, false},
                     {"MOD112", "Steak", 200, false},
                 },
                 1,
                 1},
                {"MG08",
                 "Choice 3: Toppings",
                 {
                     {"MOD120", "Corn", 0, true},
                     {"MOD121", "Black Beans", 0, true},
                     {"MOD122", "Avocado", 150, false},
                     {"MOD123", "Salsa", 0, false},
                 },
                 0,
                 0},
                {"MG09",
                 "Choice 4: Sauce",
                 {
                     {"MOD130", "Chipotle", 0, true},
                     {"MOD131", "Cilantro Lime", 0, false},
                     {"MOD132", "Peanut", 0, false},
                 },
                 0,
                 1},
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

        // ── Additional demo items covering multiple food truck types ──
        // Coffee & Tea
        {
            viewtouch::MenuItem item;
            item.id = "COF01";
            item.name = "Latte";
            item.price_cents = 399;
            item.category = "Coffee & Tea";
            item.modifier_groups = {
                {"MG_COF_SIZE",
                 "Size",
                 {
                     {"MODCOF_S", "Small", 0, false},
                     {"MODCOF_M", "Medium", 50, true},
                     {"MODCOF_L", "Large", 100, false},
                 },
                 1,
                 1},
                {"MG_COF_MILK",
                 "Milk",
                 {
                     {"MODCOF_REG", "Whole", 0, true},
                     {"MODCOF_SKIM", "Skim", 0, false},
                     {"MODCOF_OAT", "Oat Milk", 50, false},
                 },
                 0,
                 1},
            };
            item.send_to_kitchen = false;
            demo_menu.push_back(std::move(item));
        }
        {
            viewtouch::MenuItem item;
            item.id = "COF02";
            item.name = "Cold Brew";
            item.price_cents = 349;
            item.category = "Coffee & Tea";
            item.send_to_kitchen = false;
            demo_menu.push_back(std::move(item));
        }

        // Smoothies & Juices
        {
            viewtouch::MenuItem item;
            item.id = "SMO01";
            item.name = "Strawberry Smoothie";
            item.price_cents = 599;
            item.category = "Smoothies";
            item.modifier_groups = {
                {"MG_SMO_SIZE",
                 "Size",
                 {{"MODSMO_M", "Medium", 0, true}, {"MODSMO_L", "Large", 150, false}},
                 1,
                 1},
                {"MG_SMO_ADD",
                 "Add-ons",
                 {{"MODSMO_PRO", "Protein", 100, false}, {"MODSMO_CHA", "Chia Seeds", 50, false}},
                 0,
                 2},
            };
            item.send_to_kitchen = false;
            demo_menu.push_back(std::move(item));
        }

        // Pizza
        {
            viewtouch::MenuItem item;
            item.id = "PIZ01";
            item.name = "Margherita Pizza";
            item.price_cents = 1099;
            item.category = "Pizza";
            item.modifier_groups = {
                {"MG_PIZ_SIZE",
                 "Size",
                 {{"MODPIZ_S", "Small", 0, true},
                  {"MODPIZ_M", "Medium", 300, false},
                  {"MODPIZ_L", "Large", 600, false}},
                 1,
                 1},
                {"MG_PIZ_TOPP",
                 "Toppings",
                 {{"MODPIZ_BS", "Basil", 0, true},
                  {"MODPIZ_EXC", "Extra Cheese", 150, false},
                  {"MODPIZ_OLV", "Olives", 100, false}},
                 0,
                 4},
            };
            demo_menu.push_back(std::move(item));
        }

        // Sandwiches
        {
            viewtouch::MenuItem item;
            item.id = "SAN01";
            item.name = "Pulled Pork Sandwich";
            item.price_cents = 1299;
            item.category = "Sandwiches";
            item.modifier_groups = {
                {"MG_SAN_SAUCE",
                 "Sauce",
                 {{"MODSAN_BBQ", "BBQ", 0, true},
                  {"MODSAN_SPICY", "Spicy", 0, false},
                  {"MODSAN_MILD", "Mild", 0, false}},
                 0,
                 1},
                {"MG_SAN_ADD",
                 "Add-ons",
                 {{"MODSAN_CHEE", "Extra Cheese", 100, false}, {"MODSAN_BAC", "Bacon", 199, false}},
                 0,
                 2},
            };
            demo_menu.push_back(std::move(item));
        }

        // Salads
        {
            viewtouch::MenuItem item;
            item.id = "SAL01";
            item.name = "Caesar Salad";
            item.price_cents = 799;
            item.category = "Salads";
            item.modifier_groups = {
                {"MG_SAL_PROT",
                 "Add Protein",
                 {{"MODSAL_CHK", "Chicken", 250, false}, {"MODSAL_SHR", "Shrimp", 300, false}},
                 0,
                 1},
            };
            demo_menu.push_back(std::move(item));
        }

        // Asian / Ramen
        {
            viewtouch::MenuItem item;
            item.id = "RAM01";
            item.name = "Ramen Bowl";
            item.price_cents = 1299;
            item.category = "Entrees";
            item.modifier_groups = {
                {"MG_RAM_BROTH",
                 "Broth",
                 {{"MODRAM_CHIX", "Chicken", 0, true},
                  {"MODRAM_PORK", "Pork", 0, false},
                  {"MODRAM_MISO", "Miso", 0, false}},
                 1,
                 1},
                {"MG_RAM_PROT",
                 "Protein",
                 {{"MODRAM_EGG", "Soft Egg", 0, false},
                  {"MODRAM_PORKB", "Pork Belly", 250, false},
                  {"MODRAM_CHIK", "Chicken", 0, false}},
                 0,
                 1},
            };
            demo_menu.push_back(std::move(item));
        }

        // BBQ / Plates
        {
            viewtouch::MenuItem item;
            item.id = "BBQ01";
            item.name = "Smoked Brisket Plate";
            item.price_cents = 1599;
            item.category = "BBQ";
            item.modifier_groups = {
                {"MG_BBQ_SIDE",
                 "Choose a Side",
                 {{"MODBBQ_FRIES", "Fries", 0, true},
                  {"MODBBQ_COLE", "Coleslaw", 0, false},
                  {"MODBBQ_BNS", "Baked Beans", 0, false}},
                 1,
                 1},
            };
            demo_menu.push_back(std::move(item));
        }

        // Desserts
        {
            viewtouch::MenuItem item;
            item.id = "DES01";
            item.name = "Churros";
            item.price_cents = 399;
            item.category = "Desserts";
            demo_menu.push_back(std::move(item));
        }
        {
            viewtouch::MenuItem item;
            item.id = "DES02";
            item.name = "Ice Cream Scoop";
            item.price_cents = 199;
            item.category = "Desserts";
            item.modifier_groups = {
                {"MG_ICE_FLAV",
                 "Flavor",
                 {{"MODICE_VAN", "Vanilla", 0, true},
                  {"MODICE_CHO", "Chocolate", 0, false},
                  {"MODICE_STR", "Strawberry", 0, false}},
                 1,
                 1},
            };
            demo_menu.push_back(std::move(item));
        }

        // Beverages (alcohol & soda)
        {
            viewtouch::MenuItem item;
            item.id = "ALC01";
            item.name = "Local IPA";
            item.price_cents = 599;
            item.category = "Alcohol";
            item.send_to_kitchen = false;
            demo_menu.push_back(std::move(item));
        }
        {
            viewtouch::MenuItem item;
            item.id = "SOD01";
            item.name = "Soda";
            item.price_cents = 199;
            item.category = "Beverages";
            item.modifier_groups = {
                {"MG_SOD_SIZE",
                 "Size",
                 {{"MODSOD_M", "Medium", 0, true}, {"MODSOD_L", "Large", 100, false}},
                 1,
                 1},
            };
            item.send_to_kitchen = false;
            demo_menu.push_back(std::move(item));
        }

        mgr->load_menu(std::move(demo_menu));
        db.save_setting("menu_seeded", "1");
        std::cout << "[vt_daemon] seeded demo menu (" << mgr->get_menu().size() << " items)\n";
    }  // end first-run seed

    // Ensure Grande Combination Plate exists (up to 3 items, choose meat for each)
    if (!mgr->find_menu_item("GCP01")) {
        viewtouch::MenuItem plate;
        plate.id = "GCP01";
        plate.name = "Grande Combination Plate";
        plate.price_cents = 1599;
        plate.category = "Combination Plates";
        plate.modifier_groups = {
            // Slot 1: choose an item
            {"GCP1_ITEM",
             "Choice 1: Item",
             {
                 {"GCP1_ENC", "Enchilada", 0, false},
                 {"GCP1_TAC", "Taco", 0, false},
                 {"GCP1_TOS", "Tostada", 0, false},
                 {"GCP1_TAM", "Tamal", 0, false},
                 {"GCP1_BUR", "Burrito", 0, false},
                 {"GCP1_CHAL", "Chalupa", 0, false},
                 {"GCP1_CHIM", "Chimichanga", 0, false},
                 {"GCP1_CHRL", "Chile Relleno", 0, false},
             },
             0,
             1},
            // Slot 1: choose meat for the selected item
            {"GCP1_MEAT",
             "Choice 1: Meat",
             {
                 {"GCP1_CHK", "Chicken", 0, false},
                 {"GCP1_BEF", "Beef", 0, false},
                 {"GCP1_PRK", "Pork", 0, false},
                 {"GCP1_CRN", "Carnitas", 0, false},
                 {"GCP1_SHR", "Shrimp", 200, false},
                 {"GCP1_VEG", "Vegetarian", 0, false},
             },
             0,
             1},

            // Slot 2
            {"GCP2_ITEM",
             "Choice 2: Item",
             {
                 {"GCP2_ENC", "Enchilada", 0, false},
                 {"GCP2_TAC", "Taco", 0, false},
                 {"GCP2_TOS", "Tostada", 0, false},
                 {"GCP2_TAM", "Tamal", 0, false},
                 {"GCP2_BUR", "Burrito", 0, false},
                 {"GCP2_CHAL", "Chalupa", 0, false},
                 {"GCP2_CHIM", "Chimichanga", 0, false},
                 {"GCP2_CHRL", "Chile Relleno", 0, false},
             },
             0,
             1},
            {"GCP2_MEAT",
             "Choice 2: Meat",
             {
                 {"GCP2_CHK", "Chicken", 0, false},
                 {"GCP2_BEF", "Beef", 0, false},
                 {"GCP2_PRK", "Pork", 0, false},
                 {"GCP2_CRN", "Carnitas", 0, false},
                 {"GCP2_SHR", "Shrimp", 200, false},
                 {"GCP2_VEG", "Vegetarian", 0, false},
             },
             0,
             1},

            // Slot 3
            {"GCP3_ITEM",
             "Choice 3: Item",
             {
                 {"GCP3_ENC", "Enchilada", 0, false},
                 {"GCP3_TAC", "Taco", 0, false},
                 {"GCP3_TOS", "Tostada", 0, false},
                 {"GCP3_TAM", "Tamal", 0, false},
                 {"GCP3_BUR", "Burrito", 0, false},
                 {"GCP3_CHAL", "Chalupa", 0, false},
                 {"GCP3_CHIM", "Chimichanga", 0, false},
                 {"GCP3_CHRL", "Chile Relleno", 0, false},
             },
             0,
             1},
            {"GCP3_MEAT",
             "Choice 3: Meat",
             {
                 {"GCP3_CHK", "Chicken", 0, false},
                 {"GCP3_BEF", "Beef", 0, false},
                 {"GCP3_PRK", "Pork", 0, false},
                 {"GCP3_CRN", "Carnitas", 0, false},
                 {"GCP3_SHR", "Shrimp", 200, false},
                 {"GCP3_VEG", "Vegetarian", 0, false},
             },
             0,
             1},
        };
        plate.send_to_kitchen = true;
        mgr->add_menu_item(plate);
        std::cout << "[vt_daemon] added Grande Combination Plate\n";
    }

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
