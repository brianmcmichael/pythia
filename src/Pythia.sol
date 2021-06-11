// SPDX-License-Identifier: AGPL-3.0-or-later
//
// Pythia - Instant access for oracle whitelist
//
// Copyright (C) 2021 Dai Foundation
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

pragma solidity 0.6.12;

interface Tollable {
    function kiss(address) external;
    function kiss(address[] calldata) external;
}

contract Pythia {

    // --- Auth ---
    mapping (address => uint256) public wards;
    function rely(address usr) external auth { wards[usr] = 1; emit Rely(usr); }
    function deny(address usr) external auth { wards[usr] = 0; emit Deny(usr); }
    modifier auth {
        require(wards[msg.sender] == 1, "Pythia/not-authorized");
        _;
    }

    mapping (address => uint256) public scribes;
    modifier anointed {
        require(scribes[msg.sender] == 1, "Pythia/not-authorized");
        _;
    }

    // --- Events ---
    event Rely(address indexed usr);
    event Deny(address indexed usr);
    event Anoint(address indexed scribe);
    event Dismiss(address indexed scribe);

    /**
        @dev Pythia is an instant-access oracle management solution.
              This contract must be made a `ward` on the desired OSM or Medianizer.
              Scribes then have the ability to add, but not remove reader authorization.
     */
    constructor() public {
        wards[msg.sender] = 1;
        emit Rely(msg.sender);
    }

    function anoint(address _scribe) external auth {
        scribes[_scribe] = 1;
        emit Anoint(_scribe);
    }

    function dismiss(address _scribe) external {
        require(wards[msg.sender] == 1 || msg.sender == _scribe, "Pythia/not-authorized");
        scribes[_scribe] = 0;
        emit Dismiss(_scribe);
    }

    function kiss(address _oracle, address _reader) external anointed {
        Tollable(_oracle).kiss(_reader);
    }

    function kiss(address _oracle, address[] calldata _readers) external anointed {
        Tollable(_oracle).kiss(_readers);
    }
}
