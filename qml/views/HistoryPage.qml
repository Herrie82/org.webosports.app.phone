/*
 * Copyright (C) 2014 Roshan Gunasekara <roshan@mobileteck.com>
 * Copyright (C) 2015 Herman van Hazendonk <github.com@herrie.org>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>
 */

import QtQuick 2.0
import QtQuick.Controls 1.1
import LunaNext.Common 0.1
import "../model"

Rectangle {
    anchors.fill: parent
    color: main.appTheme.backgroundColor

    ListView {
        id:historyList
        anchors {/*top:parent.bottom;bottom:parent.bottom;*/margins:5;horizontalCenter:parent.horizontalCenter}
        anchors.fill: parent
        spacing: Units.gu(0.4) //4
        clip:true
        model: CallHistory {}

        delegate: Item {
        
            MouseArea {
                anchors.fill: parent
                onClicked:main.dial(model.remoteUid);
            }

            width:parent.width
            height: Units.gu(5)

            property Contact contact: Contact{}

            Component.onCompleted: contact = people.personByPhoneNumber(model.remoteUid);


            Row {
                anchors {left:parent.left; leftMargin:10; verticalCenter:parent.verticalCenter}
                spacing:10

                Item {
                    clip: true
                    anchors.verticalCenter: parent.verticalCenter
                    width: Units.gu (4.4) //44
                    height: Units.gu (4.4) //44
                    Image{
                        x: 0
                        y: model.isMissedCall ? 0 : ((model.direction === "inbound") ? -44 : -88)
                        source: 'images/call-log-list-sprite.png'
                    }

                }

                Column {
                    Text {
                        color:model.isMissedCall ? 'red' : 'white'
                        font.pixelSize: FontUtils.sizeToPixels("20pt") //Units.dp(20)
                        text:contact ? contact.displayLabel : model.remoteUid
                    }
                    Text {
                        color:'grey'
                        font.pixelSize: FontUtils.sizeToPixels("10pt") //Units.dp(10)
                        text:Qt.formatDateTime(model.startTime, Qt.DefaultLocaleShortDate)
                    }
                }
            }

            Row {
                anchors {
                    right:parent.right
                    rightMargin: Units.gu(1.0) //10
                    verticalCenter:parent.verticalCenter
                }
                spacing:10
                Button {
                    width:Units.gu(5);
                    height:Units.gu(5)
                    iconSource:'images/generic-details-view-avatar-small.png'
                }
            }
        }

        Rectangle {
            visible: historyList.count === 0
            Text {
                color: "white"
                font.pixelSize: FontUtils.sizeToPixels("20pt") // Units.dp(20)
                text: "No calls yet"
            }
        }
    }


}

