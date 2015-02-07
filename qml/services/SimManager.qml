/*
 * Copyright (C) 2015 Simon Busch <morphis@gravedo.de>
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

Item {
    id: simManager

    // Possible values: none, pin1, puk
    property string pinRequired: "none"

    onPinRequiredChanged: console.log("pinRequired: " + pinRequired)

    function isPinRequired() {
        return pinRequired !== "none";
    }

    LunaService {
        id: simStatusQuery
        usePrivateBus: true
        service: "palm://com.palm.telephony"
        method: "simStatusQuery"

        onInitialized: {
            simStatusQuery.subscribe({"subscribe":true});
        }

        onResponse: function (message) {
            var response = JSON.parse(message.payload);
            console.log("Response: " + message.payload);
            console.log("state: " + response.extended.state);

            switch (response.extended.state) {
            case "pinrequired":
                pinRequired = "pin1";
                break;
            case "simready":
                pinRequired = "none";
                break;
            default:
                break;
            }
        }
    }
}
