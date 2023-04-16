// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
contract MetaCourse is Ownable {
    //Owner Address
    address public _owner;

    // Creator Object
    struct Creator {
        uint256 creatorId;
        address creatorAddress;
        uint256 totalSubscribers;
    }

    //Course Object
    struct Course {
        uint256 courseId;
        address courseCreator;
        bool isSubscriberOnly; 
        string courseMetadata;
        string contentUri;
        uint256 totalBuys;
        uint256 fee;
    }

    struct MeetingReq {
        address meetingRequester;
        bool isApproved;
    }

    //Mappings

    mapping (uint256=> Course[]) _coursesByCreators;

    mapping (address => Course[]) _addressToCoursesPurchased;

    mapping (address => MeetingReq[]) _creatorToMeetingReqs;

    constructor() {
        _owner = msg.sender;
    }

    //View functions
    function getCoursesByCreator(uint256 id) external view returns (Course[] memory) {
        
    }

    function getMyMeetingRequests(address creatorAddress) external view returns (address[]) {
        return _creatorToMeetingReqs[address]
    }

    // State changing functions
    function setOwner(address calldata newOwner) external onlyOwner returns () {
        _owner=newOwner
    }
}
