#pragma once

#include "core/pos_manager.h"
#include "printing/cups_printer.h"
#include "pos_service.grpc.pb.h"

#include <grpcpp/grpcpp.h>
#include <memory>
#include <mutex>

// Aliases to disambiguate proto-generated types from core C++ types.
namespace pb = ::vt_proto;            // proto-generated namespace
namespace core = ::viewtouch;         // core C++ namespace

/// gRPC service implementation — thin adapter between the proto API and
/// the PosManager + CupsPrinter core objects.
class PosServiceImpl final : public ::vt_proto::PosService::Service {
public:
    PosServiceImpl(std::shared_ptr<core::PosManager> mgr,
                   std::shared_ptr<core::CupsPrinter> printer);

    grpc::Status GetMenu(grpc::ServerContext* ctx,
                         const pb::GetMenuRequest* req,
                         pb::GetMenuResponse* resp) override;

    grpc::Status NewTicket(grpc::ServerContext* ctx,
                           const pb::NewTicketRequest* req,
                           pb::NewTicketResponse* resp) override;

    grpc::Status AddItem(grpc::ServerContext* ctx,
                         const pb::AddItemRequest* req,
                         pb::AddItemResponse* resp) override;

    grpc::Status RemoveItem(grpc::ServerContext* ctx,
                            const pb::RemoveItemRequest* req,
                            pb::RemoveItemResponse* resp) override;

    grpc::Status DecreaseItem(grpc::ServerContext* ctx,
                              const pb::DecreaseItemRequest* req,
                              pb::DecreaseItemResponse* resp) override;

    grpc::Status GetTicket(grpc::ServerContext* ctx,
                           const pb::GetTicketRequest* req,
                           pb::GetTicketResponse* resp) override;

    grpc::Status Checkout(grpc::ServerContext* ctx,
                          const pb::CheckoutRequest* req,
                          pb::CheckoutResponse* resp) override;

    grpc::Status PrintReceipt(grpc::ServerContext* ctx,
                              const pb::PrintReceiptRequest* req,
                              pb::PrintReceiptResponse* resp) override;

    grpc::Status WatchPrintStatus(grpc::ServerContext* ctx,
                                  const pb::PrintReceiptRequest* req,
                                  grpc::ServerWriter<pb::PrintStatusEvent>* writer) override;

    // ── Admin RPCs ───────────────────────────────────────────
    grpc::Status GetSettings(grpc::ServerContext* ctx,
                             const pb::GetSettingsRequest* req,
                             pb::GetSettingsResponse* resp) override;

    grpc::Status UpdateSettings(grpc::ServerContext* ctx,
                                const pb::UpdateSettingsRequest* req,
                                pb::UpdateSettingsResponse* resp) override;

    grpc::Status AddMenuItem(grpc::ServerContext* ctx,
                             const pb::AddMenuItemRequest* req,
                             pb::AddMenuItemResponse* resp) override;

    grpc::Status UpdateMenuItem(grpc::ServerContext* ctx,
                                const pb::UpdateMenuItemRequest* req,
                                pb::UpdateMenuItemResponse* resp) override;

    grpc::Status DeleteMenuItem(grpc::ServerContext* ctx,
                                const pb::DeleteMenuItemRequest* req,
                                pb::DeleteMenuItemResponse* resp) override;

    // ── Reporting RPCs ───────────────────────────────────────
    grpc::Status GetDailyReport(grpc::ServerContext* ctx,
                                const pb::DailyReportRequest* req,
                                pb::DailyReportResponse* resp) override;

    grpc::Status GetReportHistory(grpc::ServerContext* ctx,
                                  const pb::ReportHistoryRequest* req,
                                  pb::ReportHistoryResponse* resp) override;

    // ── Printer discovery ────────────────────────────────────
    grpc::Status ListPrinters(grpc::ServerContext* ctx,
                              const pb::ListPrintersRequest* req,
                              pb::ListPrintersResponse* resp) override;

    grpc::Status PrintKitchen(grpc::ServerContext* ctx,
                              const pb::PrintKitchenRequest* req,
                              pb::PrintKitchenResponse* resp) override;

    // ── Ticket history & actions ─────────────────────────────
    grpc::Status ListTickets(grpc::ServerContext* ctx,
                             const pb::ListTicketsRequest* req,
                             pb::ListTicketsResponse* resp) override;

    grpc::Status TicketAction(grpc::ServerContext* ctx,
                              const pb::TicketActionRequest* req,
                              pb::TicketActionResponse* resp) override;

    // ── Extended reporting ───────────────────────────────────
    grpc::Status GetDateRangeReport(grpc::ServerContext* ctx,
                                    const pb::DateRangeReportRequest* req,
                                    pb::DateRangeReportResponse* resp) override;

    grpc::Status PrintReport(grpc::ServerContext* ctx,
                             const pb::PrintReportRequest* req,
                             pb::PrintReportResponse* resp) override;

    // ── End of day ───────────────────────────────────────────
    grpc::Status EndDay(grpc::ServerContext* ctx,
                        const pb::EndDayRequest* req,
                        pb::EndDayResponse* resp) override;

private:
    /// Convert a core Ticket struct into the protobuf Ticket message.
    static void fill_proto_ticket(const core::Ticket& src, pb::Ticket* dst);
    /// Format a DailyReport as printable text.
    static std::string format_report_text(const core::DailyReport& rpt,
                                           const std::string& title);

    std::shared_ptr<core::PosManager>  mgr_;
    std::shared_ptr<core::CupsPrinter> printer_;
};
