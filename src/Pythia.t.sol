// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity ^0.6.12;

import "ds-test/test.sol";

import "./Pythia.sol";

contract PythiaTest is DSTest {
    Pythia pythia;

    function setUp() public {
        pythia = new Pythia();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
