import QtQuick 
import QtQuick.Controls 
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Widgets

Item { id: root

  required property Notification notification

  property real timeoutProgress: 1
  property int timeoutMs: notification.expireTimeout > 0 ? notification.expireTimeout * 1000 : 10000
  property int elapsedMs: 0
  
  height: card.implicitHeight

  function iconSource(icon, fallback) {
    if (icon && icon.length > 0) {
      if (icon.startsWith("/") || icon.startsWith("file:")) {
        return icon.startsWith("file:") ? icon : `file://${icon}`;
      }

      const themed = Quickshell.iconPath(icon, true);
      if (themed.length > 0) {
        return themed;
      }
    }

    return fallback && fallback.length > 0 ? Quickshell.iconPath(fallback) : "";
  }

  function imageSource(image) {
    if (!image || image.length === 0) {
      return "";
    }

    if (image.startsWith("/") || image.startsWith("file:")) {
      return image.startsWith("file:") ? image : `file://${image}`;
    }

    const themed = Quickshell.iconPath(image, true);
    return themed.length > 0 ? themed : image;
  }

  function urgencyColor() {
    switch (notification.urgency) {
    case NotificationUrgency.Critical:
      return "#f38ba8";
    case NotificationUrgency.Low:
      return "#6c7086"; 
    default:
      return "#89b4fa";
    }
  }

  Rectangle { id: card
    anchors {
      left: parent.left
      right: parent.right
      margins: 10
    }

    implicitHeight: contentColumn.implicitHeight + 16

    radius: 12
    color: "#dd1e1e2e"
    border.width: 2
    border.color: root.urgencyColor()

    Column { id: contentColumn
      spacing: 10

      anchors {
        left: parent.left
        right: parent.right
        top: parent.top
        margins: 9
      }

      Row { id: summaryRow
        spacing: 8

          IconImage { id: notifIcon
            anchors.fill: parent
            source: notificationImage.visible ? "" : root.iconSource(notification.appIcon || notification.desktopEntry, "dialog-information")
            visible: source.length > 0
          }

          Text {
            text: notification.summary
            font.pointSize: 12
            font.bold: true
            color: "#f5e0dc"
            elide: Text.ElideRight
            anchors.left: parent.left
            anchors.right: parent.right
          }
      }

      Row { id: appRow
        spacing: 8

        IconImage {
          id: appIcon
          implicitSize: 8
          source: root.iconSource(notification.appIcon || notification.desktopEntry, "dialog-information")
          visible: source.length > 0
          anchors.verticalCenter: parent.verticalCenter
        }

        Text {
          text: notification.appName || "Unknown app"
          font.pixelSize: 8
          font.bold: true
          color: "#cdd6f4"
          elide: Text.ElideRight
        }
      }

      Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        height: 2
        color: "#313244"

        Rectangle {
          anchors.left: parent.left
          anchors.top: parent.top
          anchors.bottom: parent.bottom
          width: parent.width * root.timeoutProgress
          color: root.urgencyColor()
        }
      }

      Row { id: contentRow
        spacing: 10
        anchors.left: parent.left
        anchors.right: parent.right

        Item { id: imageFrame
          width: notificationImage.visible || fallbackImage.visible ? 64 : 0
          height: width
          visible: width > 0

          Image { id: notificationImage
            anchors.fill: parent
            source: root.imageSource(notification.image)
            visible: source.length > 0
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            mipmap: true
            sourceSize.width: 128
            sourceSize.height: 128
          }

        }

        Column { id: bodyColumn
          spacing: 4
          width: contentRow.width - imageFrame.width - (imageFrame.visible ? contentRow.spacing : 0)

          Text {
            text: notification.body
            visible: text.length > 0
            font.pointSize: 11
            color: "#cdd6f4"
            wrapMode: Text.WordWrap
            textFormat: Text.RichText
            anchors.left: parent.left
            anchors.right: parent.right
          }
        }
      }

      Row {
        id: actionRow
        spacing: 6
        visible: notification.actions.length > 0
        anchors.left: parent.left
        anchors.right: parent.right

        Repeater {
          model: notification.actions

          delegate: Button {
            required property var modelData
            width: (actionRow.width - (notification.actions.length - 1) * actionRow.spacing) / notification.actions.length
            height: 30
            padding: 6

            onClicked: modelData.invoke()

            contentItem: Row {
              spacing: 6
              anchors.centerIn: parent

              IconImage {
                implicitSize: 16
                source: notification.hasActionIcons ? root.iconSource(modelData.identifier, "") : ""
                visible: source.length > 0
              }

              Text {
                text: modelData.text
                color: "#cdd6f4"
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
              }
            }

            background: Rectangle {
              color: parent.down ? "#45475a" : "#313244"
              radius: 6
              border.width: 1
              border.color: "#585b70"
            }
          }
        }
      }

      Button {
        anchors.left: parent.left
        anchors.right: parent.right
        height: 30
        text: "Dismiss"
        onClicked: root.close("dismissed")

        contentItem: Text {
          text: parent.text
          color: "#cdd6f4"
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
        }

        background: Rectangle {
          color: parent.down ? "#45475a" : "#313244"
          radius: 6
          border.width: 1
          border.color: "#585b70"
        }
      }
    }

    Timer {
      id: progressTimer
      interval: 1000 / 60
      running: true
      repeat: true
      onTriggered: {
        root.elapsedMs = Math.min(root.elapsedMs + interval, root.timeoutMs);
        root.timeoutProgress = Math.max(0, 1 - root.elapsedMs / root.timeoutMs);
      }
    }

    Timer {
      // interval: (notification.expireTimeout > 0 ? notification.expireTimeout*1000 : 5000)
      interval: root.timeoutMs
      running: true
      repeat: false
      onTriggered:  notification.expire();
    }

    MouseArea {
      anchors.fill: parent
      onClicked: card.state = "closing"
    }

  }
}
