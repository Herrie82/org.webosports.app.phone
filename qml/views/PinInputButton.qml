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
import LunaNext.Common 0.1

MouseArea {
    id: button

    property string text: ""
    property bool emergency: false

    property bool _highlighted: pressed && containsMouse

    visible: text != ""

    Text {
        anchors.centerIn: parent
        text: button.text
        font.pixelSize: FontUtils.sizeToPixels("x-large")
        font.bold: button.emergency
        color: {
            if (button.emergency)
                return button.highlighted ? "black" : "red";
            return button.highlighted ? "black" : "white";
        }
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: _highlighted || pressTimer.running ? "white": "transparent"
    }

    onPressed: {
        pressTimer.start();
    }

    onCanceled: {
        pressTimer.stop();
    }

    Timer {
        id: pressTimer
        interval: 45
    }
}
