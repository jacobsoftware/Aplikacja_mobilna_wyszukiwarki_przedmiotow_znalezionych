import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: item1

    anchors.fill: parent
    property var wielkoscZczytanejTablicy

    Component.onCompleted: {

        wczytajDanezAPI()
    }

    Text {
        id: text1
        text: qsTr("Biuro Przedmiotow Znalezionych")
        font.pixelSize: 16
        font.bold: true
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Row {
        id: row1
        anchors.top: text1.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            id: text2
            text: qsTr("Nazwa przedmiotu")
            font.pixelSize: 14
        }
        spacing: 40
        TextField {
            id: textField
            placeholderText: qsTr("")
        }
    }

    Row {
        id: row2
        anchors.top: row1.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        Text {
            id: text3
            text: qsTr("Zgloszenie od")
            font.pixelSize: 14
        }
        spacing: 70
        TextField {
            id: textField1
            placeholderText: qsTr("")
            validator: RegularExpressionValidator {
                regularExpression: /\d{1,4}(-\d{1,2}(-\d{1,2}))$/
                // /\d{1,3}(?:,\d{1,3})+$/
            }
        }
    }

    Row {
        id: row3
        anchors.top: row2.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        Text {
            id: text4
            text: qsTr("Zgloszenie do")
            font.pixelSize: 14
        }
        spacing: 70
        TextField {
            id: textField2
            placeholderText: qsTr("")
            validator: RegularExpressionValidator {
                regularExpression: /\d{1,4}(-\d{1,2}(-\d{1,2}))$/
                // /\d{1,3}(?:,\d{1,3})+$/
            }
        }
    }

    Button {
        id: przyciskWywolania
        text: qsTr("Wyszukaj")
        anchors.top: row3.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            text5.text = ""
            sprawdzCzyUzytkownikWprowadzilDane()
        }
    }

    Text {
        id: text5
        anchors.top: przyciskWywolania.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        text: qsTr("")
        font.pixelSize: 12
        anchors.topMargin: 10
    }

    ListView {
        id: listaElementow
        //anchors.verticalCenter: parent.verticalCenter
        //anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: przyciskWywolania.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10
        anchors.topMargin: 35
        clip: true

        ScrollBar.vertical: ScrollBar {
            active: true
        }
        delegate: Item {
            x: 5
            width: parent.width
            height: 40
            Row {
                id: row1List
                width: parent.width
                height: parent.height

                Text {
                    text: nazwaPrzedmiotu
                    width: parent.width
                    font.pixelSize: 12
                    font.bold: false
                    wrapMode: Text.WordWrap
                }
                MouseArea {
                    id: mousearea
                    anchors.fill: parent

                    onClicked: {
                        stackview.push("wczytanieElementuUzytkownika.qml", {
                                           "numerID3": numerID,
                                           "nazwaPrzedmiotu3": nazwaPrzedmiotu,
                                           "dataZnalezienia3": dataZnalezienia
                                       })
                    }
                }

                spacing: 10
            }
        }
        model: ListModel {
            id: idListyZnalezionychPrzedmiotow
        }
    }

    function wczytajDanezAPI() {
        var url = "https://bip.poznan.pl/api-json/bip/biuro-rzeczy-znalezionych/"

        var xhr = new XMLHttpRequest()
        xhr.open("GET", url)

        xhr.setRequestHeader("Accept-Language", "pl,en-US;q=0.7,en;q=0.3")
        xhr.setRequestHeader("Accept-Encoding", "gzip, deflate, br")
        xhr.setRequestHeader("Connection", "keep-alive")
        xhr.setRequestHeader(
                    "Referer",
                    "https://bip.poznan.pl/bip/biuro-rzeczy-znalezionych/")
        xhr.setRequestHeader("Upgrade-Insecure-Requests", "1")
        xhr.setRequestHeader("Sec-Fetch-Dest", "document")
        xhr.setRequestHeader("Sec-Fetch-Mode", "navigate")
        xhr.setRequestHeader("Sec-Fetch-Site", "same-origin")
        xhr.setRequestHeader("Sec-Fetch-User", "?1")

        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4) {

                var jsonString = xhr.responseText
                var jsonObject = JSON.parse(jsonString)
                var ileDanych = Object.keys(
                            jsonObject["bip.poznan.pl"].data[0].rzeczy_znalezione.items[0].element).length
                wielkoscZczytanejTablicy = ileDanych

                for (var i = 0; i < ileDanych; i++) {
                    idListyZnalezionychPrzedmiotow.append({
                                                              "numerID": jsonObject["bip.poznan.pl"].data[0].rzeczy_znalezione.items[0].element[i].id,
                                                              "nazwaPrzedmiotu": jsonObject["bip.poznan.pl"].data[0].rzeczy_znalezione.items[0].element[i].nazwa,
                                                              "dataZnalezienia": jsonObject["bip.poznan.pl"].data[0].rzeczy_znalezione.items[0].element[i].data_znalezienia
                                                          })
                }
            }
        }

        xhr.send()
    }
    function sprawdzCzyUzytkownikWprowadzilDane() {
        var dataOdKiedy = new Date(textField1.text)
        var dataDoKiedy = new Date(textField2.text)
        var sprawdzenie1
        var sprawdzenie2

        if (textField.text == "" && textField1.text == ""
                && textField2.text == "") {
            text5.color = "red"
            text5.text = "Wprowadz dane"
        } else {

            if (textField1.text != "") {
                sprawdzenie1 = walidacjaDaty(textField1.text)
                console.log("to wartosc", sprawdzenie1)
            } else {
                sprawdzenie1 = true
            }

            if (textField2.text != "") {
                sprawdzenie2 = walidacjaDaty(textField2.text)
            } else {
                sprawdzenie2 = true
            }
            console.log("czy prawdziwe", sprawdzenie1, sprawdzenie2)

            if (sprawdzenie1 === true && sprawdzenie2 === true) {

                var nazwaPrzedmiotuSzukanego = textField.text

                stackview.push("wczytanieListyPrzedmiotow.qml", {
                                   "dataOd": dataOdKiedy,
                                   "dataDo": dataDoKiedy,
                                   "nazwaPrzedmiotu": nazwaPrzedmiotuSzukanego
                               })
            } else {
                text5.color = "red"
                text5.text = "Blednie wprowadzone daty"
            }
        }
    }
    function walidacjaDaty(dateStr) {

        const date = new Date(dateStr)
        const timestamp = date.getTime()

        if (typeof timestamp !== 'number' || Number.isNaN(timestamp)) {
            return false
        }

        return date.toISOString().startsWith(dateStr)
    }
}
