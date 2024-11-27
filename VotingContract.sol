// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
 
contract VotingContract {
    address public owner;
    //string[] public optionen;
    //uint256[] public anzvotes;
    mapping (string => uint) votes;
    bool public votingactive;
    string[] public optionen;
    mapping (address => bool) hasvoted;
 
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
        require(isValidOption(option), "Die Abstimmung ist ungueltig");
        require(hasvoted[msg.sender] == false, "Sie haben schon abgestimmt");
        hasvoted[msg.sender] = true;
        votes[option]+=1;
       
    }
    // Abrufen der Stimmen für eine Option
    function getVotes(string memory option) view public returns (uint256) {
        return votes[option];
    }
 
    // Abrufen der Gewinnenden Option
    function WinningOption() public view returns (string memory, uint256, string memory) {
        require(votingactive == false, "Abstimmung ist noch aktiv. Ergebnis ist noch nicht verfuegbar.");
       
        string memory winningOption = "";
        uint256 highestVotes = 0;
 
        for (uint256 i = 0; i < optionen.length; i++) {
            if (votes[optionen[i]] > highestVotes) {
                highestVotes = votes[optionen[i]];
                winningOption = optionen[i];
            }
        }
 
        uint256 winningPercentage = (highestVotes * 100) / getTotalVotes();
        string memory prozentsymbol = "%";
        return (winningOption, winningPercentage, prozentsymbol);
    }
 
    // hilffunktion
    function isValidOption(string memory option) private view returns(bool) {
        for (uint256 i = 0; i < optionen.length; i++) {
            if (keccak256(bytes(optionen[i])) == keccak256(bytes(option))) {
                return true;
            }
        }
        return false;
    }
    // hilffunktion
    function getTotalVotes() public view returns(uint256) {
    uint256 totalVotes = 0;
    for (uint256 i = 0; i < optionen.length; i++) {
        totalVotes += votes[optionen[i]];
    }
    return totalVotes;
    }
}
