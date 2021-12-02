// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./RockPaperScissors.sol";

contract AdditionalContract {
    event MyEvent (
      uint256 data
    );

    address rps;

    function init(address addr) public {
        rps = addr;
    }
    
    function join() external payable {
        emit MyEvent(msg.value);
        // rps.join({from:msg.sender, value:msg.value});

        (bool success, bytes memory data) =
            rps.call{value:msg.value}(abi.encodeWithSignature("join()"));
    }
} 