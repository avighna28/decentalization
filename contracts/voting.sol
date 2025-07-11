// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Voting {
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    struct Voter {
        bool hasVoted;
        uint vote;
    }

    address public admin;
    bool public votingActive;
    uint public candidateCount;
    mapping(uint => Candidate) public candidates;
    mapping(address => Voter) public voters;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    modifier voteOngoing() {
        require(votingActive, "Voting is not active");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function startVoting() public onlyAdmin {
        votingActive = true;
    }

    function endVoting() public onlyAdmin {
        votingActive = false;
    }

    function addCandidate(string memory _name) public onlyAdmin {
        candidates[candidateCount] = Candidate(candidateCount, _name, 0);
        candidateCount++;
    }

    function vote(uint _candidateId) public voteOngoing {
        require(!voters[msg.sender].hasVoted, "Already voted");
        require(_candidateId < candidateCount, "Invalid candidate");

        voters[msg.sender] = Voter(true, _candidateId);
        candidates[_candidateId].voteCount++;
    }

    function getCandidate(uint _id) public view returns (string memory, uint) {
        require(_id < candidateCount, "Invalid candidate");
        Candidate memory candidate = candidates[_id];
        return (candidate.name, candidate.voteCount);
    }
}