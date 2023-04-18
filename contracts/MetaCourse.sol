// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";

contract MetaCourse is Ownable {
    //Owner Address
    address public _owner;

    // Creator Object
    struct Creator {
        address payable creatorAddress;
        string metadataUri;
    }

    //Course Object
    struct Course {
        string courseId;
        address payable courseCreator;
        bool isSubscriberOnly;
        string courseMetadata;
        string contentUri;
        uint256 fee;
        uint256 timestamp;
    }

    struct MeetingReq {
        uint256 id;
        address meetingRequester;
        string courseId;
        string email;
        bool isApproved;
    }

    //Mappings

    mapping(address => Course[]) _coursesByCreators;

    mapping(address => Course[]) _addressToCoursesPurchased;

    mapping(address => MeetingReq[]) _creatorToMeetingReqs;

    mapping(address => string) _creatorAdressToMetadata;

    Course[] _allCourses;

    constructor() {
        _owner = msg.sender;
    }

    //View functions
    function getCoursesByCreator(
        address creatorAddress
    ) external view returns (Course[] memory) {
        return _coursesByCreators[creatorAddress];
    }

    function getMyMeetingRequests(
        address creatorAddress
    ) external view returns (MeetingReq[] memory) {
        return _creatorToMeetingReqs[creatorAddress];
    }

    function getMyPurchasedCourse() external view returns (Course[] memory) {
        return _addressToCoursesPurchased[msg.sender];
    }

    function addCourse(
        string calldata courseId,
        address payable courseCreator,
        bool isSubscriberOnly,
        string calldata courseMetadata,
        string calldata contentUri,
        uint256 fee
    ) external {
        _allCourses.push(
            Course(
                courseId,
                courseCreator,
                isSubscriberOnly,
                courseMetadata,
                contentUri,
                fee,
                block.timestamp
            )
        );

        _coursesByCreators[msg.sender].push(
            Course(
                courseId,
                courseCreator,
                isSubscriberOnly,
                courseMetadata,
                contentUri,
                fee,
                block.timestamp
            )
        );
    }

    function purchaseCourse(
        string calldata courseId,
        address payable courseCreator,
        bool isSubscriberOnly,
        string calldata courseMetadata,
        string calldata contentUri,
        uint256 fee
    ) external payable {
        if (isSubscriberOnly) {
            require(msg.value < fee, "paise leke aa");
            (bool sent, ) = courseCreator.call{value: msg.value}("");
            require(sent, "Failed to send");
            _addressToCoursesPurchased[msg.sender].push(
                Course(
                    courseId,
                    courseCreator,
                    isSubscriberOnly,
                    courseMetadata,
                    contentUri,
                    fee,
                    block.timestamp
                )
            );
        } else {
            _addressToCoursesPurchased[msg.sender].push(
                Course(
                    courseId,
                    courseCreator,
                    isSubscriberOnly,
                    courseMetadata,
                    contentUri,
                    fee,
                    block.timestamp
                )
            );
        }
    }

    function requestMeeting(
        address meetingRequester,
        string calldata courseId,
        string calldata email
    ) external {
        _creatorToMeetingReqs[msg.sender].push(
            MeetingReq(
                _creatorToMeetingReqs[msg.sender].length,
                meetingRequester,
                courseId,
                email,
                false
            )
        );
    }

    function approveRequest(uint256 id, address requesterAdress) external {
        MeetingReq[] memory temp = _creatorToMeetingReqs[requesterAdress];
        for (uint256 i = 0; i < temp.length; i++) {
            if (temp[i].id == id) {
                _creatorToMeetingReqs[requesterAdress][i].isApproved = true;
            }
        }
    }
}
