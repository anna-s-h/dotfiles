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

    displaced: Transition {
      NumberAnimation { properties: "x,y"; duration: 100; easing.type: Easing.outQuart}
    }

    delegate: NotificationCard {
      required property var modelData
      notification: modelData
      implicitWidth: root.implicitWidth
    }

  }
}
