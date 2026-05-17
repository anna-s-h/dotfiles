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

  property bool entering: true
  property bool exiting: false
  property string exitAction: ""
  
  implicitHeight: card.implicitHeight
  height: implicitHeight
  opacity: 0
  x: 24
  scale: 1
  transformOrigin: Item.Center

  Component.onCompleted: enterAnimation.start()

  function beginExit(action) {
    if (!root.exiting) {
      root.exitAction = action || "";
      root.exiting = true;
      enterAnimation.stop();
      progressTimer.stop();
      expiryTimer.stop();
      exitAnimation.start();
    }
  }

  RetainableLock { id: notificationLock
    object: root.notification
    locked: true

    onDropped: {
      if (!root.exiting) {
        root.exiting = true;
        progressTimer.stop();
        expiryTimer.stop();
        exitAnimation.start();
      }
    }
  }

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

  ParallelAnimation { id: enterAnimation
    onStarted: root.entering = true
    onFinished: root.entering = false

    NumberAnimation {
      target: root
      property: "opacity"
      from: 0
      to: 1
      duration: 1
      easing.type: Easing.OutCubic
    }

    NumberAnimation {
      target: root
      property: "x"
      from: card.width
      to: 0
      duration: 180
      easing.type: Easing.OutCubic
    }
  }

  ParallelAnimation { id: exitAnimation

    NumberAnimation {
      target: root
      property: "opacity"
      to: 0
      duration: 120
      easing.type: Easing.InCubic
    }

    NumberAnimation {
      target: root
      property: "scale"
      to: 0
      duration: 160
      easing.type: Easing.InCubic
    }

    onFinished: {
      if (root.exitAction === "dismiss") {
        notification.dismiss();
      } else if (root.exitAction === "expire") {
        notification.expire();
      }
      notificationLock.locked = false
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

      Row { id: headerRow
        spacing: 8

        width: parent.width
        height: Math.max(notifIcon.visible ? notifIcon.height : 0, headerText.implicitHeight)
        visible: summaryLine.visible || appRow.visible || notifIcon.visible

        IconImage { id: notifIcon
          width: visible ? 28 : 0
          height: 28
          source: notificationImage.visible ? "" : root.iconSource(notification.appIcon || notification.desktopEntry, "dialog-information")
          visible: source.length > 0
          anchors.verticalCenter: parent.verticalCenter
        }

        Column { id: headerText
          spacing: 1
          width: headerRow.width - notifIcon.width - (notifIcon.visible ? headerRow.spacing : 0)

          height: 10
          anchors.verticalCenter: parent.verticalCenter
          visible: summaryLine.visible || appRow.visible

          Text { id: summaryLine
            width: parent.width
            height: 10
            text: notification.summary
            visible: text.length > 0
            font.pointSize: 12
            font.bold: true
            color: "#89b4fa"
            elide: Text.ElideRight
            maximumLineCount: 2
            wrapMode: Text.WordWrap
            verticalAlignment: Text.AlignVCenter
          }

          Row { id: appRow
            spacing: 4
            width: parent.width
            visible: notification.appName.length > 0 || appIcon.visible

            IconImage { id: appIcon
              width: visible ? 14 : 0
              height: 14
              source: root.iconSource(notification.appIcon || notification.desktopEntry, "application-x-executable")
              visible: source.length > 0
              anchors.verticalCenter: parent.verticalCenter
            }

            Text {
              width: appRow.width - appIcon.width - (appIcon.visible ? appRow.spacing : 0)
              text: notification.appName || "Unknown app"
              font.pixelSize: 10
              color: "#bac2de"
              elide: Text.ElideRight
            }
          }
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


        Text { id: bodyText
          width: contentRow.width - imageFrame.width - (imageFrame.visible ? contentRow.spacing : 0)
          text: notification.body
          visible: text.length > 0
          font.pointSize: 11
          color: "#cdd6f4"
          wrapMode: Text.WordWrap
          textFormat: Text.RichText
          linkColor: "#89b4fa"
        }

      }

      Row { id: actionRow
        spacing: 6
        visible: notification.actions.length > 0
        width: parent.width

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
        onClicked: root.beginExit("dismiss")

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
  }

  Timer { id: progressTimer
    interval: 1000 / 60
    running: true
    repeat: true
    onTriggered: {
      root.elapsedMs = Math.min(root.elapsedMs + interval, root.timeoutMs);
      root.timeoutProgress = Math.max(0, 1 - root.elapsedMs / root.timeoutMs);
    }
  }

  Timer { id: expiryTimer
    // interval: (notification.expireTimeout > 0 ? notification.expireTimeout*1000 : 5000)
    interval: root.timeoutMs
    running: true
    repeat: false
    onTriggered: root.beginExit("expire")
  }
}
