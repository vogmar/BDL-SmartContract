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
    uint public waitingPeriodInBlocks;
    uint timeStampStart;
    bool started;
    constructor(string[] memory Namen_Optionen, uint _waitingPeriodInBlocks) {
        require(Namen_Optionen.length < 1000, "Zu hohe Anzahl Optionen, aufgrund hoher Kosten nicht moeglich");
        owner = msg.sender;
        optionen = Namen_Optionen;
        waitingPeriodInBlocks = _waitingPeriodInBlocks;
        //mapping der Optionen - votes zugehörigkeit initialisieren
        for (uint256 i = 0; i < Namen_Optionen.length; i++) {
            votes[Namen_Optionen[i]] = 0;
        }
    }
    //Basis Funktionen
    function startVoting()public{
        require(msg.sender == owner, "Nur Besiter darf das Voting starten");
        require(started == false, "Dieser Contract wurde schon mal gestartet, neuen Contract erstellen");
        votingactive = true;
        timeStampStart = block.number;
 
    }
    function endVoting()public{
        /*ohne diese zeile kann jeder nach ablauf der zeit schliessen sont kann owner wenn abstimmung
         gegen ihn geht z.b. nie beenden*/
        //require(msg.sender == owner, "Nur Besiter darf das Voting beenden");
        require(block.number - timeStampStart > waitingPeriodInBlocks, "Zeit noch nicht abgelaufen");
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
    function WinningOption() public view returns (string memory, uint256) {
        require(votingactive == false, "Abstimmung ist noch aktiv. Ergebnis ist noch nicht verfuegbar.");
       
        string memory winningOption = "";
        uint256 highestVotes = 0;
        for (uint256 i = 0; i < optionen.length; i++) {
            if (votes[optionen[i]] > highestVotes) {
                highestVotes = votes[optionen[i]];
                winningOption = optionen[i];
            }
        }
        require(isTie(winningOption) == false, "abstimmung hat einen Gleichstand ergeben");
 
        uint256 winningPercentage = (highestVotes * 100) / getTotalVotes();
        return (winningOption, winningPercentage);
    }
    //_____________________________________Hilfsfunktionen_______________________________________________________________________
    // hilffunktion
    function isValidOption(string memory option) private view returns(bool) {
        for (uint256 i = 0; i < optionen.length; i++) {
            if (keccak256(bytes(optionen[i])) == keccak256(bytes(option))) { //vergleichen ob wahl gleich wie eine option
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
 
    //hilffunktion gleichstand prüfen
    function isTie(string memory option) private  view returns (bool) {
    require(isValidOption(option), "Die Option ist ungueltig.");
    uint256 targetVotes = votes[option];
    // Prüfen, ob eine andere Option dieselbe Anzahl von Stimmen hat
    for (uint256 i = 0; i < optionen.length; i++) {
        if (
            keccak256(bytes(optionen[i])) != keccak256(bytes(option)) && // Ignoriere die geprüfte Option selbst
            votes[optionen[i]] == targetVotes // Stimmenanzahl vergleichen
        ) {
            return true;
        }
    }
    return false;
    }
}