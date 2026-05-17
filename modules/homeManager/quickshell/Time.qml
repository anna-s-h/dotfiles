pragma Singleton
import Quickshell
import QtQuick

Singleton {
  id: root

  readonly property string popupTime: Qt.formatDateTime(clock.date, "hh:mm:ss AP")
  readonly property string popupDate: Qt.formatDateTime(clock.date, "dddd, MMMM d")

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }
}
