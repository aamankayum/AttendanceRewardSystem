// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AttendanceReward {

    address public owner;
    uint256 public requiredAttendance; // Minimum attendance required to receive a reward

    // Student structure
    struct Student {
        uint256 totalAttendance;
        bool exists;
    }

    mapping(address => Student) public students;

    event AttendanceMarked(address indexed student, uint256 attendance);
    event RewardIssued(address indexed student, string message);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier studentExists(address _student) {
        require(students[_student].exists, "Student does not exist");
        _;
    }

    constructor(uint256 _requiredAttendance) {
        owner = msg.sender;
        requiredAttendance = _requiredAttendance;
    }

    // Register a new student
    function registerStudent(address _student) public onlyOwner {
        require(!students[_student].exists, "Student already registered");
        students[_student] = Student({
            totalAttendance: 0,
            exists: true
        });
    }

    // Mark attendance for a student
    function markAttendance(address _student) public onlyOwner studentExists(_student) {
        students[_student].totalAttendance += 1;
        emit AttendanceMarked(_student, students[_student].totalAttendance);

        // Issue reward if attendance meets the requirement
        if (students[_student].totalAttendance >= requiredAttendance) {
            _rewardStudent(_student);
        }
    }

    // Internal function to reward the student with a message
    function _rewardStudent(address _student) internal {
        string memory message = "Congratulations! You have achieved the required attendance.";
        emit RewardIssued(_student, message);
    }

    // Update the required attendance
    function setRequiredAttendance(uint256 _newRequiredAttendance) public onlyOwner {
        requiredAttendance = _newRequiredAttendance;
    }

    // Check a student's attendance
    function getAttendance(address _student) public view studentExists(_student) returns (uint256) {
        return students[_student].totalAttendance;
    }
}






