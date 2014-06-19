/*
 * Copyright (C) 2014 Roshan Gunasekara <roshan@mobileteck.com>
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
import MeeGo.QOfono 0.2

Item {
    id: telephonyManager

    /**
     * public API
     **/

    property bool present: true

    property string subscriberIdentity: "1234-5678-9012-3456"
    property string mobileCountryCode: "UK"
    property string mobileNetworkCode: "Vodaphone"

    property string pinRequired: "no-pin"

    function changePin(type, ldPin, newPin) {
    }

    function enterPin(type, pin) {
        if (!_validatePin(pin))
            return false;

        simManager.enterPin(_convertPinType(type), pin);
        return true;
    }

    function resetPin(type, puk, newpin) {
    }

    function lockPin(type, pin) {
    }

    function unlockPin(type, pin) {
        if (!_validatePin(pin))
            return false;
        simManager.unlockPin(_convertPinType(type), pin);
        return true;
    }

    function getPinRetries(type) {
        return simManager.pinRetries[_convertPinType(type)];
    }

    /**
     * private API
     **/

    function _convertPinType(type) {
        switch (type) {
            case 'pin':
                return OfonoSimManager.SimPin;
            default:
                break;
        }

        return OfonoSimManager.NoPin;
    }

    function _validatePin(pin) {
        return (pin >= OfonoSimManager.minimumPinLength() && pin <= OfonoSimManager.maxmimumPinLength());
    }

    OfonoManager {
        id: modemManager
    }

    OfonoModem {
        id: modem
        modemPath: modemManager.modems[0]
    }

    OfonoSimManager {
        id: simManager
        modemPath: modemManager.modems[0]

        onPinRequiredChanged: {
            if (simManager.pinRequired == OfonoSimManager.SimPin)
                telephonyManager.pinRequired = true;
            else
                telephonyManager.pinRequired = false;
            /* FIXME support other pin types too */
        }
    }
}

