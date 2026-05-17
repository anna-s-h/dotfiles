import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick

Scope {
  id: root

  property bool popupVisible: false

  IpcHandler {
    target: "clock"

    function toggle(): bool {
      root.popupVisible = !root.popupVisible;
      return root.popupVisible;
    }

    function show(): void {
      root.popupVisible = true;
    }

    function hide(): void {
      root.popupVisible = false;
    }

    function isVisible(): bool {
      return root.popupVisible;
    }
  }

Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData
      visible: root.popupVisible
      color: "transparent"
      focusable: false
      aboveWindows: true
      exclusionMode: ExclusionMode.Ignore
      WlrLayershell.layer: WlrLayer.Overlay
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
      WlrLayershell.namespace: "quickshell-clock"

      anchors {
        top: true
        bottom: true
        left: true
        right: true
      }

      mask: Region { item: clockBox }

      Rectangle {
        anchors.centerIn: parent
        radius: 12
        color: "#dd1e1e2e"
        border.width: 1
        border.color: "#aa6c7086"
        width: 360
        height: 140

        Column {
          spacing: 8
          anchors.centerIn: parent

          Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Time.popupTime
            color: "#cdd6f4"
            font.pixelSize: 40
            font.bold: true
          }

          Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Time.popupDate
            color: "#a6adc8"
            font.pixelSize: 19
          }
        }
      }
    }
  }
}
