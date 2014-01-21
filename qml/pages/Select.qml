import QtQuick 2.0
import Sailfish.Silica 1.0

import 'api.js' as API

Page {
    id: page

    Column {
        id: column
        width: parent.width
        spacing: 10

        PageHeader {
            title: 'slovnik.cz'
        }

        ListModel {
            id: languageModel

            ListElement {
                name: 'English to Czech'
                dict: 'encz.en'
            }

            ListElement {
                name: 'Czech to English'
                dict: 'encz.cz'
            }

            ListElement {
                name: 'Latin to Czech'
                dict: 'lacz.la'
            }

            ListElement {
                name: 'Czech to Latin'
                dict: 'lacz.cz'
            }

            ListElement {
                name: 'German to Czech'
                dict: 'gecz.ge'
            }

            ListElement {
                name: 'Czech to German'
                dict: 'gecz.cz'
            }

            ListElement {
                name: 'Italian to Czech'
                dict: 'itcz.it'
            }

            ListElement {
                name: 'Czech to Italian'
                dict: 'itcz.cz'
            }

            ListElement {
                name: 'Spanish to Czech'
                dict: 'spcz.sp'
            }

            ListElement {
                name: 'Czech to Spanish'
                dict: 'spcz.cz'
            }

            ListElement {
                name: 'Russian to Czech'
                dict: 'rucz.ru'
            }

            ListElement {
                name: 'Czech to Russian'
                dict: 'rucz.cz'
            }

            ListElement {
                name: 'Esperanto to Czech'
                dict: 'eocz.eo'
            }

            ListElement {
                name: 'Czech to Esperanto'
                dict: 'eocz.cz'
            }

            ListElement {
                name: 'Esperanto to Slovak'
                dict: 'eosk.eo'
            }

            ListElement {
                name: 'Slovak to Esperanto'
                dict: 'eosk.sk'
            }

            ListElement {
                name: 'Polish to Czech'
                dict: 'plcz.pl'
            }

            ListElement {
                name: 'Czech to Polish'
                dict: 'plcz.cz'
            }
        }

        Component {
            id: languageDelegate

            MenuItem {
                text: name
            }
        }

        ComboBox {
            width: parent.width
            label: 'Translate'

            menu: ContextMenu {
                Repeater {
                    model: languageModel
                    delegate: languageDelegate
                }
            }

            onCurrentIndexChanged: {
                search.dict = languageModel.get(currentIndex).dict;

                if (search.request)
                    search.request.abort();

                search.request = null;
                resultsModel.clear();
            }
        }

        SearchField {
            id: search
            width: parent.width
            placeholderText: 'Have fun'
            focus: true

            property string dict: 'encz.en'
            property var request: null

            onTextChanged: {
                if (request)
                    request.abort();

                request = null;
                resultsModel.clear();
            }

            EnterKey.onClicked: {
                search.focus = false;

                if (request)
                    request.abort();

                console.log('lookup /' + dict + '/' + text);

                request = new API.Translate(dict, text, 30);
                request.ondata = function(data) {
                    request = null;
                    resultsModel.clear();
                    for (var i in data)
                        resultsModel.append(data[i]);
                };

                request.onerror = function(error) {
                    request = null;
                    console.log('request failed: ' + error);
                };

                request.send();
            }
        }

        ListModel {
            id: resultsModel
        }

        Component {
            id: resultsDelegate

            Item {
                width: parent.width * 0.90
                height: fromLabel.height + toLabel.height + 20

                anchors {
                    horizontalCenter: parent.horizontalCenter
                }

                Label {
                    id: fromLabel
                    width: parent.width
                    text: from

                    color: Theme.secondaryColor

                    anchors {
                        top: parent.top
                    }
                }

                Label {
                    id: toLabel
                    width: parent.width
                    text: to

                    Text {
                        color: Theme.primaryColor
                    }

                    anchors {
                        top: fromLabel.bottom
                    }
                }
            }
        }

        SilicaListView {
            id: resultsView
            width: parent.width
            height: 600
            model: resultsModel
            delegate: resultsDelegate

            BusyIndicator {
                running: search.request

                anchors {
                    centerIn: parent
                }
            }

            VerticalScrollDecorator {
                flickable: resultsView
            }
        }
    }
}

/* vim:set sw=4 ts=4 et: */
