// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract SchoolAttendance {
    address public owner;

    struct Student {
        string name;
        bool isEnrolled;
        bool hasAttended;
    }

    struct Teacher {
        bool isTeacher;
    }

    mapping(address => Student) public students;
    mapping(address => Teacher) public teachers;

    address[] public studentList;

    constructor() {
        owner = msg.sender; // Set the contract deployer as the owner (e.g., the principal)
        teachers[owner] = Teacher(true); // The owner is also a teacher by default
    }

    // Modifier to restrict access to the owner or teachers
    modifier onlyOwnerOrTeacher() {
        require(
            msg.sender == owner || teachers[msg.sender].isTeacher,
            "Not authorized"
        );
        _;
    }

    // Function to add a teacher
    function addTeacher(address _teacherAddress) public {
        require(msg.sender == owner, "Only owner can add a teacher");
        teachers[_teacherAddress] = Teacher(true);
    }

    // Function to enroll a student
    function enrollStudent(address _studentAddress, string memory _name)
        public
        onlyOwnerOrTeacher
    {
        require(!students[_studentAddress].isEnrolled, "Student is already enrolled");
        students[_studentAddress] = Student(_name, true, false);
        studentList.push(_studentAddress);
    }

    // Function to mark a student as present
    function markAttendance(address _studentAddress) public onlyOwnerOrTeacher {
        require(students[_studentAddress].isEnrolled, "Student is not enrolled");
        students[_studentAddress].hasAttended = true;
    }

    // Function to check if a student attended (callable by anyone)
    function checkAttendance(address _studentAddress) public view returns (bool) {
        require(students[_studentAddress].isEnrolled, "Student is not enrolled");
        return students[_studentAddress].hasAttended;
    }

    // Function to get a list of all students (callable by anyone)
    function getStudents() public view returns (address[] memory) {
        return studentList;
    }

    // Function to reset attendance for all students
    function resetAttendance() public onlyOwnerOrTeacher {
        for (uint i = 0; i < studentList.length; i++) {
            students[studentList[i]].hasAttended = false;
        }
    }
}
