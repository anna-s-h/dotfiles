import QtQuick 
import QtQuick.Controls 
import Quickshell
import Quickshell.Services.Notifications

Item {
  id: root
  required property Notification notification
  height: card.implicitHeight
  Rectangle {
    id: card
    anchors {
      left: parent.left
      right: parent.right
      margins: 10
    }

    implicitHeight: contentColumn.implicitHeight + 16

    color: "#00005f"
    radius: 8

    Column {
      id: contentColumn
      spacing: 10

      anchors.left: parent.left
      anchors.right: parent.right

      Text {
        text: notification.appName
        font.pointSize: 14
        font.bold: true
        color: "white"
        elide: Text.ElideRight
        anchors.left: parent.left
        anchors.right: parent.right
      }

      Text {
        text: notification.summary + "<br>" + notification.body
        font.pointSize: 12
        color: "#dddddd"
        wrapMode: Text.WordWrap
        anchors.left: parent.left
        anchors.right: parent.right
      }
    }

    Timer {
      interval: (notification.expireTimeout > 0 ? notification.expireTimeout*1000 : 5000)
      running: true
      repeat: false
      onTriggered: card.state = "closing"
    }

    MouseArea {
      anchors.fill: parent
      onClicked: card.state = "closing"
    }

    states: State {
      name: "closing"
      PropertyChanges { target: card; opacity: 0 }
    }

    Behavior on opacity { NumberAnimation { duration: 300 } }

    Component.onCompleted: card.opacity = 1

    onOpacityChanged: {
      if (card.opacity === 0 && card.state === "closing") {
        notification.tracked = false
      }
    }
  }
}
