import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: item1
    anchors.fill: parent

    property string dataOd
    property string dataDo
    property string nazwaPrzedmiotu
    property var wielkoscZczytanejTablicy

    Component.onCompleted: {

        wczytajDanezAPIV2()
    }

    ListModel {
        id: tablicaDoDzialan
    }
    Row {
        id: row1
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        Button {
            id: backButton

            text: qsTr("<")
            onClicked: stackview.pop()

            anchors.left: parent.left
            anchors.leftMargin: -175
        }

        Text {
            id: text1
            text: qsTr("Znalezione przedmioty")

            font.pixelSize: 16

            minimumPixelSize: 16
            font.bold: true

            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
    ListView {
        id: listView
        width: 344
        height: 370
        anchors.top: row1.bottom
        anchors.bottom: parent.bottom
        anchors.topMargin: 70
        anchors.left: parent.left
        anchors.right: parent.right
        delegate: Item {
            x: 5
            width: parent.width
            height: 40
            Row {
                id: row2
                width: parent.width
                height: parent.height

                Text {
                    text: nazwaPrzedmiotuListyWidzianej
                    wrapMode: Text.WordWrap
                    width: parent.width

                    font.bold: false
                    MouseArea {
                        id: mousearea
                        anchors.fill: parent

                        onClicked: {

                            stackview.push("wczytanieElementuUzytkownika.qml", {
                                               "numerID3": numerIDlistyWidzianej,
                                               "nazwaPrzedmiotu3": nazwaPrzedmiotuListyWidzianej,
                                               "dataZnalezienia3": dataZnalezieniaListyWidzianej
                                           })
                        }
                    }
                }
                spacing: 10
            }
        }
        model: ListModel {
            id: listaPrzedmiotowKtoreInteresujaUzytkownika
        }
    }

    function wczytajDanezAPIV2() {
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
                    tablicaDoDzialan.append({
                                                "numerID": jsonObject["bip.poznan.pl"].data[0].rzeczy_znalezione.items[0].element[i].id,
                                                "nazwaPrzedmiotu": jsonObject["bip.poznan.pl"].data[0].rzeczy_znalezione.items[0].element[i].nazwa,
                                                "dataZnalezienia": jsonObject["bip.poznan.pl"].data[0].rzeczy_znalezione.items[0].element[i].data_znalezienia
                                            })
                }
                sprawdzKryteriaV2()
            }
        }

        xhr.send()
    }
    function sprawdzKryteriaV2() {

        var dataOdKiedy = new Date(dataOdKiedy)
        var dataDoKiedy = new Date(dataDoKiedy)
        var nazwaPrzedmiotuwFunkcji = nazwaPrzedmiotu
        var dataDowFunkcji = dataDo
        var dataOdwFunkcji = dataOd
        var stringPrzeszukiwany
        let znajdz
        let znajdz2
        var nazwaPrzedmiotuZeZmienionaLitera
        var i = 0
        var wartoscCzasuOd
        var wartoscCzasuDo

        if (nazwaPrzedmiotuwFunkcji !== "" && dataDowFunkcji.length === 0
                && dataOdwFunkcji.length === 0) {

            if (sprawdzCzyPierwszaLiteraJestDuza(
                        nazwaPrzedmiotuwFunkcji) === true) {

                nazwaPrzedmiotuZeZmienionaLitera = wprowadzonaNazwa.charAt(
                            0).toLowerCase() + wprowadzonaNazwa.slice(1)
            } else {

                nazwaPrzedmiotuZeZmienionaLitera = nazwaPrzedmiotuwFunkcji.charAt(
                            0).toUpperCase() + nazwaPrzedmiotuwFunkcji.slice(1)
            }

            for (i = 0; i < wielkoscZczytanejTablicy; i++) {

                stringPrzeszukiwany = tablicaDoDzialan.get(i).nazwaPrzedmiotu
                znajdz = stringPrzeszukiwany.includes(nazwaPrzedmiotuwFunkcji)
                znajdz2 = stringPrzeszukiwany.includes(
                            nazwaPrzedmiotuZeZmienionaLitera)
                if (znajdz === true || znajdz2 === true) {
                    listaPrzedmiotowKtoreInteresujaUzytkownika.append({
                                                                          "nazwaPrzedmiotuListyWidzianej": tablicaDoDzialan.get(i).nazwaPrzedmiotu,
                                                                          "numerIDlistyWidzianej": tablicaDoDzialan.get(i).numerID,
                                                                          "dataZnalezieniaListyWidzianej": tablicaDoDzialan.get(i).dataZnalezienia
                                                                      })
                }
            }
        } else if (nazwaPrzedmiotuwFunkcji !== "" && dataOdwFunkcji.length !== 0
                   && dataDowFunkcji.length === 0) {
            if (sprawdzCzyPierwszaLiteraJestDuza(
                        nazwaPrzedmiotuwFunkcji) === true) {

                nazwaPrzedmiotuZeZmienionaLitera = wprowadzonaNazwa.charAt(
                            0).toLowerCase() + wprowadzonaNazwa.slice(1)
            } else {

                nazwaPrzedmiotuZeZmienionaLitera = nazwaPrzedmiotuwFunkcji.charAt(
                            0).toUpperCase() + nazwaPrzedmiotuwFunkcji.slice(1)
            }
            for (i = 0; i < wielkoscZczytanejTablicy; i++) {


                /*
                przeksztalcenieFormatuZmiennych(i, znajdz, wartoscCzasuDo,
                                                wartoscCzasuOd,
                                                stringPrzeszukiwany)
                                                */
                stringPrzeszukiwany = tablicaDoDzialan.get(i).nazwaPrzedmiotu

                znajdz = stringPrzeszukiwany.includes(nazwaPrzedmiotuwFunkcji)
                znajdz2 = stringPrzeszukiwany.includes(
                            nazwaPrzedmiotuZeZmienionaLitera)

                wartoscCzasuOd = new Date(tablicaDoDzialan.get(
                                              i).dataZnalezienia)

                wartoscCzasuOd = wartoscCzasuOd.toISOString().split('T')[0]

                wartoscCzasuDo = new Date(tablicaDoDzialan.get(
                                              i).dataZnalezienia)
                wartoscCzasuDo = wartoscCzasuDo.toISOString().split('T')[0]

                if (znajdz === true && dataOdwFunkcji < wartoscCzasuOd) {
                    listaPrzedmiotowKtoreInteresujaUzytkownika.append({
                                                                          "nazwaPrzedmiotuListyWidzianej": tablicaDoDzialan.get(i).nazwaPrzedmiotu,
                                                                          "numerIDlistyWidzianej": tablicaDoDzialan.get(i).numerID,
                                                                          "dataZnalezieniaListyWidzianej": tablicaDoDzialan.get(i).dataZnalezienia
                                                                      })
                }
                if (znajdz2 === true && dataOdwFunkcji < wartoscCzasuOd) {
                    listaPrzedmiotowKtoreInteresujaUzytkownika.append({
                                                                          "nazwaPrzedmiotuListyWidzianej": tablicaDoDzialan.get(i).nazwaPrzedmiotu,
                                                                          "numerIDlistyWidzianej": tablicaDoDzialan.get(i).numerID,
                                                                          "dataZnalezieniaListyWidzianej": tablicaDoDzialan.get(i).dataZnalezienia
                                                                      })
                }
            }
        } else if (nazwaPrzedmiotuwFunkcji !== "" && dataOdwFunkcji.length !== 0
                   && dataDowFunkcji.length !== 0) {
            if (sprawdzCzyPierwszaLiteraJestDuza(
                        nazwaPrzedmiotuwFunkcji) === true) {

                nazwaPrzedmiotuZeZmienionaLitera = wprowadzonaNazwa.charAt(
                            0).toLowerCase() + wprowadzonaNazwa.slice(1)
            } else {

                nazwaPrzedmiotuZeZmienionaLitera = nazwaPrzedmiotuwFunkcji.charAt(
                            0).toUpperCase() + nazwaPrzedmiotuwFunkcji.slice(1)
            }

            for (i = 0; i < wielkoscZczytanejTablicy; i++) {

                stringPrzeszukiwany = tablicaDoDzialan.get(i).nazwaPrzedmiotu

                znajdz = stringPrzeszukiwany.includes(nazwaPrzedmiotuwFunkcji)
                znajdz2 = stringPrzeszukiwany.includes(
                            nazwaPrzedmiotuZeZmienionaLitera)

                wartoscCzasuOd = new Date(tablicaDoDzialan.get(
                                              i).dataZnalezienia)

                wartoscCzasuOd = wartoscCzasuOd.toISOString().split('T')[0]

                wartoscCzasuDo = new Date(tablicaDoDzialan.get(
                                              i).dataZnalezienia)
                wartoscCzasuDo = wartoscCzasuDo.toISOString().split('T')[0]

                if (znajdz === true && dataOdwFunkcji < wartoscCzasuOd
                        && dataDowFunkcji > wartoscCzasuDo) {
                    listaPrzedmiotowKtoreInteresujaUzytkownika.append({
                                                                          "nazwaPrzedmiotuListyWidzianej": tablicaDoDzialan.get(i).nazwaPrzedmiotu,
                                                                          "numerIDlistyWidzianej": tablicaDoDzialan.get(i).numerID,
                                                                          "dataZnalezieniaListyWidzianej": tablicaDoDzialan.get(i).dataZnalezienia
                                                                      })
                }

                if (znajdz2 === true && dataOdwFunkcji < wartoscCzasuOd
                        && dataDowFunkcji > wartoscCzasuDo) {
                    listaPrzedmiotowKtoreInteresujaUzytkownika.append({
                                                                          "nazwaPrzedmiotuListyWidzianej": tablicaDoDzialan.get(i).nazwaPrzedmiotu,
                                                                          "numerIDlistyWidzianej": tablicaDoDzialan.get(i).numerID,
                                                                          "dataZnalezieniaListyWidzianej": tablicaDoDzialan.get(i).dataZnalezienia
                                                                      })
                }
            }
        } else if (nazwaPrzedmiotuwFunkcji !== "" && dataOdwFunkcji.length === 0
                   && dataDowFunkcji.length !== 0) {
            if (sprawdzCzyPierwszaLiteraJestDuza(
                        nazwaPrzedmiotuwFunkcji) === true) {

                nazwaPrzedmiotuZeZmienionaLitera = wprowadzonaNazwa.charAt(
                            0).toLowerCase() + wprowadzonaNazwa.slice(1)
            } else {

                nazwaPrzedmiotuZeZmienionaLitera = nazwaPrzedmiotuwFunkcji.charAt(
                            0).toUpperCase() + nazwaPrzedmiotuwFunkcji.slice(1)
            }

            for (i = 0; i < wielkoscZczytanejTablicy; i++) {

                stringPrzeszukiwany = tablicaDoDzialan.get(i).nazwaPrzedmiotu

                znajdz = stringPrzeszukiwany.includes(nazwaPrzedmiotuwFunkcji)
                znajdz2 = stringPrzeszukiwany.includes(
                            nazwaPrzedmiotuZeZmienionaLitera)

                wartoscCzasuOd = new Date(tablicaDoDzialan.get(
                                              i).dataZnalezienia)

                wartoscCzasuOd = wartoscCzasuOd.toISOString().split('T')[0]

                wartoscCzasuDo = new Date(tablicaDoDzialan.get(
                                              i).dataZnalezienia)
                wartoscCzasuDo = wartoscCzasuDo.toISOString().split('T')[0]

                if (znajdz === true && dataDowFunkcji > wartoscCzasuDo) {
                    listaPrzedmiotowKtoreInteresujaUzytkownika.append({
                                                                          "nazwaPrzedmiotuListyWidzianej": tablicaDoDzialan.get(i).nazwaPrzedmiotu,
                                                                          "numerIDlistyWidzianej": tablicaDoDzialan.get(i).numerID,
                                                                          "dataZnalezieniaListyWidzianej": tablicaDoDzialan.get(i).dataZnalezienia
                                                                      })
                }
                if (znajdz2 === true && dataDowFunkcji > wartoscCzasuDo) {
                    listaPrzedmiotowKtoreInteresujaUzytkownika.append({
                                                                          "nazwaPrzedmiotuListyWidzianej": tablicaDoDzialan.get(i).nazwaPrzedmiotu,
                                                                          "numerIDlistyWidzianej": tablicaDoDzialan.get(i).numerID,
                                                                          "dataZnalezieniaListyWidzianej": tablicaDoDzialan.get(i).dataZnalezienia
                                                                      })
                }
            }
        } else if (nazwaPrzedmiotuwFunkcji === "" && dataOdwFunkcji.length !== 0
                   && dataDowFunkcji.length !== 0) {
            for (i = 0; i < wielkoscZczytanejTablicy; i++) {

                stringPrzeszukiwany = tablicaDoDzialan.get(i).nazwaPrzedmiotu

                znajdz = stringPrzeszukiwany.includes(nazwaPrzedmiotuwFunkcji)

                wartoscCzasuOd = new Date(tablicaDoDzialan.get(
                                              i).dataZnalezienia)

                wartoscCzasuOd = wartoscCzasuOd.toISOString().split('T')[0]

                wartoscCzasuDo = new Date(tablicaDoDzialan.get(
                                              i).dataZnalezienia)
                wartoscCzasuDo = wartoscCzasuDo.toISOString().split('T')[0]

                if (dataOdwFunkcji < wartoscCzasuOd
                        && dataDowFunkcji > wartoscCzasuDo) {
                    listaPrzedmiotowKtoreInteresujaUzytkownika.append({
                                                                          "nazwaPrzedmiotuListyWidzianej": tablicaDoDzialan.get(i).nazwaPrzedmiotu,
                                                                          "numerIDlistyWidzianej": tablicaDoDzialan.get(i).numerID,
                                                                          "dataZnalezieniaListyWidzianej": tablicaDoDzialan.get(i).dataZnalezienia
                                                                      })
                }
            }
        } else if (nazwaPrzedmiotuwFunkcji === "" && dataOdwFunkcji.length !== 0
                   && dataDowFunkcji.length === 0) {
            for (i = 0; i < wielkoscZczytanejTablicy; i++) {

                stringPrzeszukiwany = tablicaDoDzialan.get(i).nazwaPrzedmiotu

                znajdz = stringPrzeszukiwany.includes(nazwaPrzedmiotuwFunkcji)

                wartoscCzasuOd = new Date(tablicaDoDzialan.get(
                                              i).dataZnalezienia)

                wartoscCzasuOd = wartoscCzasuOd.toISOString().split('T')[0]

                wartoscCzasuDo = new Date(tablicaDoDzialan.get(
                                              i).dataZnalezienia)
                wartoscCzasuDo = wartoscCzasuDo.toISOString().split('T')[0]

                if (dataOdwFunkcji < wartoscCzasuOd) {
                    listaPrzedmiotowKtoreInteresujaUzytkownika.append({
                                                                          "nazwaPrzedmiotuListyWidzianej": tablicaDoDzialan.get(i).nazwaPrzedmiotu,
                                                                          "numerIDlistyWidzianej": tablicaDoDzialan.get(i).numerID,
                                                                          "dataZnalezieniaListyWidzianej": tablicaDoDzialan.get(i).dataZnalezienia
                                                                      })
                }
            }
        } else if (nazwaPrzedmiotuwFunkcji === "" && dataOdwFunkcji.length == 0
                   && dataDowFunkcji.length !== 0) {
            for (i = 0; i < wielkoscZczytanejTablicy; i++) {

                stringPrzeszukiwany = tablicaDoDzialan.get(i).nazwaPrzedmiotu

                znajdz = stringPrzeszukiwany.includes(nazwaPrzedmiotuwFunkcji)

                wartoscCzasuOd = new Date(tablicaDoDzialan.get(
                                              i).dataZnalezienia)

                wartoscCzasuOd = wartoscCzasuOd.toISOString().split('T')[0]

                wartoscCzasuDo = new Date(tablicaDoDzialan.get(
                                              i).dataZnalezienia)
                wartoscCzasuDo = wartoscCzasuDo.toISOString().split('T')[0]

                if (dataDowFunkcji > wartoscCzasuDo) {
                    listaPrzedmiotowKtoreInteresujaUzytkownika.append({
                                                                          "nazwaPrzedmiotuListyWidzianej": tablicaDoDzialan.get(i).nazwaPrzedmiotu,
                                                                          "numerIDlistyWidzianej": tablicaDoDzialan.get(i).numerID,
                                                                          "dataZnalezieniaListyWidzianej": tablicaDoDzialan.get(i).dataZnalezienia
                                                                      })
                }
            }
        }
    }
    function sprawdzCzyPierwszaLiteraJestDuza(wprowadzonaNazwa) {
        return wprowadzonaNazwa.charAt(0) === wprowadzonaNazwa.charAt(
                    0).toUpperCase()
    }


    /*
    function zmienPierwszaLitereNaDuza(wprowadzonaNazwa) {

        function zmienPierwszaLitereNaDuza(wprowadzonaNazwa) {
            return wprowadzonaNazwa.charAt(0).toUpperCase(
                        ) + wprowadzonaNazwa.slice(1)
        }
    }
    function zmienPierwszaLitereNaMala(wprowadzonaNazwa) {
        function zmienPierwszaLitereNaDuza() {
            return wprowadzonaNazwa.charAt(0).toLowerCase(
                        ) + wprowadzonaNazwa.slice(1)
        }
    */


    /* function przeksztalcenieFormatuZmiennych(wartosc, znajdzwLiscie, dataDoKiedyZnalezione, dataOdKiedyZnalezione, szukanyString) {
        szukanyString = tablicaDoDzialan.get(wartosc).nazwaPrzedmiotu

        znajdzwLiscie = szukanyString.includes(nazwaPrzedmiotu)

        dataOdKiedyZnalezione = new Date(tablicaDoDzialan.get(
                                             wartosc).dataZnalezienia)
        dataOdKiedyZnalezione = dataOdKiedyZnalezione.toISOString(
                    ).split('T')[0]

        dataDoKiedyZnalezione = new Date(tablicaDoDzialan.get(
                                             wartosc).dataZnalezienia)
        dataDoKiedyZnalezione = dataDoKiedyZnalezione.toISOString(
                    ).split('T')[0]
        return [dataDoKiedyZnalezione, dataOdKiedyZnalezione, znajdzwLiscie]
    }*/
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:1}D{i:3}D{i:4}D{i:2}D{i:5}
}
##^##*/

