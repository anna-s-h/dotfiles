pragma Singleton
import Quickshell
import QtQuick 
import Quickshell.Services.Notifications

Singleton {
  id: root
  // single NotificationServer for the whole app
  property NotificationServer server: NotificationServer {
    id: notiServer
    keepOnReload: true
    onNotification: notif => notif.tracked = true
  }
}
