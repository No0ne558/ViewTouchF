#include <glib.h>

#include "my_application.h"

// Global GLib log handler that filters out noisy XDG portal warnings which
// are benign on some systems where the desktop portal lacks certain settings.
// This prevents spamming the console with repeated:
//   Failed to read XDG desktop portal settings: GDBus.Error:org.freedesktop.portal.Error.NotFound
static void gtk_log_filter(const gchar* log_domain, GLogLevelFlags log_level, const gchar* message,
                           gpointer user_data) {
    if (message &&
        g_strstr_len(message, -1, "Failed to read XDG desktop portal settings") != nullptr) {
        // Silently ignore this specific message.
        return;
    }
    // Forward all other messages to the default GLib handler.
    g_log_default_handler(log_domain, log_level, message, user_data);
}

int main(int argc, char** argv) {
    // Install the log filter as early as possible to catch startup messages.
    g_log_set_default_handler(gtk_log_filter, nullptr);

    g_autoptr(MyApplication) app = my_application_new();
    return g_application_run(G_APPLICATION(app), argc, argv);
}
