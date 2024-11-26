// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
 
contract VotingContract {
    address public owner;
    //string[] public optionen;
    //uint256[] public anzvotes;
    mapping (string => uint) votes;
    bool public votingactive;
    string[] public optionen;
 
    constructor(string[] memory Namen_Optionen) {
        owner = msg.sender;
        optionen = Namen_Optionen;
        for (uint256 i = 0; i < Namen_Optionen.length; i++) {
            votes[Namen_Optionen[i]] = 0;
        }
    }
 
    function startVoting()public{
        require(msg.sender == owner, "Nur Besiter darf das Voting starten");
        votingactive = true;
    }
    function endVoting()public{
        require(msg.sender == owner, "Nur Besiter darf das Voting beenden");
        votingactive = false;
    }
    function Vote(string memory option)public{
        require(votingactive == true, "Die Abstimmung ist nicht aktiv");
        require(isValidOption(option), "Die Abstimmung ist ungültig");
        votes[option]+=1;
       
    }
    function isValidOption(string memory option) private view returns (bool) {
        for (uint256 i = 0; i < optionen.length; i++) {
            if (keccak256(bytes(optionen[i])) == keccak256(bytes(option))) {
                return true;
            }
        }
        return false;
    }
}
hat Kontextmenü