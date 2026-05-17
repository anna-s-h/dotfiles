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
    actionsSupported: true
    actionIconsSupported: true
    imageSupported: true
    bodyImagesSupported: true
    bodyMarkupSupported: true
    bodyHyperlinksSupported: true
    persistenceSupported: true
    onNotification: notif => notif.tracked = true
  }
}
