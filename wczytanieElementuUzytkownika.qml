import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: item1
    //width: 360
    anchors.fill: parent

    property string dataZnalezienia3
    property string numerID3
    property string nazwaPrzedmiotu3

    Row {
        id: row1
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        Button {
            id: backButton

            text: qsTr("<")
            onClicked: stackview.pop()
        }
        Button {
            id: homeButton

            text: qsTr("Home")
            onClicked: stackview.pop(null)
        }
    }
    Row {
        id: row2
        anchors.top: row1.bottom
        anchors.topMargin: 40
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        Text {
            id: text1
            text: qsTr("Nazwa Przedmiotu")
            font.pixelSize: 14
            width: parent.width / 2
        }
        spacing: 0

        Text {
            id: text2
            text: nazwaPrzedmiotu3
            font.pixelSize: 14
            width: parent.width / 2
            wrapMode: Text.WordWrap
        }
    }
    Row {
        id: row3
        anchors.top: row2.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        Text {
            id: text3
            text: qsTr("Data znalezienia")
            font.pixelSize: 14
            width: parent.width / 2
        }

        Text {
            id: text4
            text: dataZnalezienia3
            font.pixelSize: 14
            width: parent.width / 2
        }
    }
    Row {
        id: row4
        anchors.top: row3.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        Text {
            id: text5
            text: qsTr("Nazwa Przedmiotu")
            font.pixelSize: 14
            width: parent.width / 2
        }

        Text {
            id: text6
            text: numerID3
            font.pixelSize: 14
            width: parent.width / 2
        }
    }
}
