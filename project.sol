// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BlockchainDevelopmentHub {
    
    // Struct for storing course details
    struct Course {
        uint id;
        string name;
        string description;
        uint price;
        uint enrolledCount;
    }
    
    // Struct for storing user enrollment details
    struct User {
        address userAddress;
        uint[] enrolledCourses;
    }
    
    // Mapping of courseId to Course
    mapping(uint => Course) public courses;
    
    // Mapping of user address to User struct
    mapping(address => User) public users;
    
    // Event to notify when a new course is added
    event CourseAdded(uint courseId, string courseName, uint price);
    
    // Event to notify when a user enrolls in a course
    event EnrolledInCourse(address user, uint courseId);
    
    uint public courseCount;
    
    // Function to add a new course
    function addCourse(string memory name, string memory description, uint price) public {
        courseCount++;
        courses[courseCount] = Course(courseCount, name, description, price, 0);
        emit CourseAdded(courseCount, name, price);
    }
    
    // Function to enroll a user in a course
    function enrollInCourse(uint courseId) public payable {
        Course storage course = courses[courseId];
        
        require(course.id != 0, "Course not found");
        require(msg.value == course.price, "Incorrect payment amount");
        
        // Add course to user's list of enrolled courses
        users[msg.sender].enrolledCourses.push(courseId);
        course.enrolledCount++;
        
        emit EnrolledInCourse(msg.sender, courseId);
    }
    
    // Function to get list of courses user is enrolled in
    function getEnrolledCourses() public view returns (uint[] memory) {
        return users[msg.sender].enrolledCourses;
    }
    
    // Function to withdraw contract balance (only owner)
    address public owner;
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }
    
    constructor() {
        owner = msg.sender;
    }
    
    function withdraw() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}
