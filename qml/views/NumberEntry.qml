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
import QtQuick.Controls.Styles 1.1
import LunaNext.Common 0.1

Item {
    id: numberEntry

    property alias text: textEdit.text
    property string textColor: "white"
    property alias alignment: textEdit.horizontalAlignment
    property alias inputMethodHints: textEdit.inputMethodHints
    property alias echoMode: textEdit.echoMode

    property bool isPhoneNumber: true

    property string __previousCharacter

    function insert(character) {
        var text = textEdit.text
        var cpos = textEdit.cursorPosition;

        if(text.length == 0) {
            textEdit.text = character
            textEdit.cursorPosition = textEdit.text.length
        } else {
            var newText = text.slice(0, cpos) + character + text.slice(cpos,text. length);
            textEdit.text = newText;
            textEdit.cursorPosition = cpos + (textEdit.text.length - text.length);
        }

        numberEntry.__previousCharacter = character;
        interactionTimeout.restart();
    }

    function backspace() {
        var cpos = textEdit.cursorPosition == 0 ? 1 : textEdit.cursorPosition;
        var text = textEdit.text

        if(text.length == 0)
            return;

        var newText = text.slice(0, cpos - 1) + text.slice(cpos, text.length);
        textEdit.text = newText;
        textEdit.cursorPosition = cpos - (text.length - textEdit.text.length);

        numberEntry.__previousCharacter = '';
        interactionTimeout.restart();
    }

    function resetCursor() {
        textEdit.cursorPosition = textEdit.text.length;
    }

    function clear() {
        resetCursor();
        textEdit.text = '';
    }

    function getPhoneNumber(){
        if(numEntry.text.length > 0) {
            return numEntry.text.replace(/\D/g, '');
        } else {
            return ''
        }
    }

    Timer {
        id: interactionTimeout
        interval: 10000
        running: false
        repeat: false
        onTriggered: numberEntry.resetCursor();
    }

    Image {
        id:backspace

        width: Units.gu(5)
        height: Units.gu(3)
        fillMode: Image.PreserveAspectFit

        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            margins: Units.gu(3)
        }
        source: 'images/icon-m-common-backspace.svg'

        MouseArea {
            anchors.fill: parent

            onClicked: numberEntry.backspace();
            onPressAndHold: numberEntry.clear();
        }
    }

    TextField {
        id: textEdit

        anchors {
            verticalCenter: backspace.verticalCenter
            horizontalCenter: parent.horizontalCenter
            leftMargin: Units.gu(1.5)
            rightMargin: Units.gu(1)
        }

        activeFocusOnPress: false
        inputMethodHints: Qt.ImhDialableCharactersOnly
        font.pixelSize: FontUtils.sizeToPixels("large")
        textColor: "white"
        horizontalAlignment: TextInput.AlignHCenter
        placeholderText: "Enter phone number"

        Component.onCompleted: {
            // On desktop we don't have this field
            if (textEdit.passwordCharacter)
                textEdit.passwordCharacter = "\u2022";
        }

        style: TextFieldStyle {
            textColor: "white"
            placeholderTextColor: "white"
            background: Rectangle {
                color: phoneUiAppTheme.backgroundColor
            }
        }
    }

    MouseArea {
        anchors.fill:textEdit

        onPressed: {
            interactionTimeout.restart();
            mouse.accepted = false;
        }
    }
}
