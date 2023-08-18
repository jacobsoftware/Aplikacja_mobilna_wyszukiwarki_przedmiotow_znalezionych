import QtQuick
import QtQuick.Window
import QtQuick.Controls

Window {
    width: 360
    height: 480
    visible: true
    title: qsTr("Aplikacja do szukania rzeczy zagubionych")

    StackView {
        id: stackview
        anchors.fill: parent
        initialItem: "stronaGlownaAplikacji.qml"
    }
}
