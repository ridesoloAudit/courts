pragma solidity ^0.4.0;

import "@aragon/os/contracts/apps/AragonApp.sol";
//import "@aragon/os/contracts/lib/math/SafeMath.sol";
import "./RewardCourts.sol";


contract CourtWrapper is AragonApp {
    //using SafeMath for uint256;

    /// ACL
    bytes32 constant public JUDGE_ROLE = keccak256("JUDGE_ROLE");

    RewardCourts public ownedContract;
    uint256 public courtId;

    function initialize() public onlyInit {
        initialized();
    }

    function postInitialize(RewardCourts _ownedContract, uint256 _courtId) public { // not external!
        ownedContract = _ownedContract;
        courtId = _courtId;
    }

    /**
      * @notice Transfers `_value` tokens of an `_id` from the `_from` address to the `_to` address specified (with safety call).
      */
    function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes _data) external auth(JUDGE_ROLE) {
        ownedContract.safeTransferFrom(_from, _to, _id, _value, _data);
    }

    /**
      * @notice Mints `_value` intercourt tokens #`_intercourtToken` from the `_from` address to the `_to` address specified (with safety call).
      */
    function mintFrom(address _from, address _to, uint256 _intercourtToken, uint256 _value, bytes _data) external auth(JUDGE_ROLE) {
        uint256 _id = ownedContract._uncheckedGenerateTokenId(courtId, _intercourtToken);
        ownedContract.mintFrom(_from, _to, _id, _value, _data);
    }
}
