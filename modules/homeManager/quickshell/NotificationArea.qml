import QtQuick
import Quickshell
import Quickshell.Services.Notifications

PanelWindow {
  id: root
  anchors.top: true
  anchors.right: true
  anchors.bottom: true
  implicitWidth: 400
  focusable: false
  color: "transparent"
  exclusionMode: ExclusionMode.Ignore

  mask: Region { item: list.contentItem }

  ListView {
    id: list
    model: NotificationService.server.trackedNotifications
    spacing: 10
    anchors.fill: parent

    delegate: NotificationCard {
      required property var modelData
      notification: modelData
      implicitWidth: root.implicitWidth
    }

  }
}
