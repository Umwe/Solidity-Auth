// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleAuth {
    // Struct to represent a user
    struct User {
        string username;
        bytes32 passwordHash;
    }

    // Mapping to store users by their Ethereum address
    mapping(address => User) private users;

    // Event to be emitted when a user is registered
    event UserRegistered(address userAddress, string username);

    // Function to sign up a new user
    function signUp(string memory _username, string memory _password) public {
        require(bytes(_username).length > 0, "Username cannot be empty");
        require(bytes(_password).length > 0, "Password cannot be empty");
        require(users[msg.sender].passwordHash == 0x0, "User already registered");

        // Hash the password and store the user's data
        users[msg.sender] = User({
            username: _username,
            passwordHash: keccak256(abi.encodePacked(_password))
        });

        emit UserRegistered(msg.sender, _username);
    }

    // Function to log in
    function login(string memory _password) public view returns (bool) {
        require(users[msg.sender].passwordHash != 0x0, "User not registered");
        
        // Compare the hash of the provided password with the stored hash
        if (users[msg.sender].passwordHash == keccak256(abi.encodePacked(_password))) {
            return true;
        } else {
            return false;
        }
    }

    // Function to get the current user's username
    function getUsername() public view returns (string memory) {
        require(users[msg.sender].passwordHash != 0x0, "User not registered");
        return users[msg.sender].username;
    }
}
