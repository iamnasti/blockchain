// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;


contract RockPaperScissors {

    event Event (
      bytes32 data
    );
    
    function get_event() public
    {
        emit Event(keccak256(abi.encodePacked("R", "66")));
    }

    address payable public player1;
    address payable public player2;

    string public player1_choice;
    string public player2_choice;

    bytes32 public player1_commit;
    bytes32 public player2_commit;

    bool public player1_made_commit;
    bool public player2_made_commit;

    bool public player1_made_choice;
    bool public player2_made_choice;
    
    // When a player joins the game, they have to pay a playing fee 
    uint256 public stake; //the stake should be visible to Player2

    // A matrix containing result of the game depedning on its states
    mapping(string => mapping(string => uint8)) public states;

    // The constructor initialise the game environment
    constructor() public{
        states['R']['R'] = 0;
        states['R']['P'] = 2;
        states['R']['S'] = 1;
        states['P']['R'] = 1;
        states['P']['P'] = 0;
        states['P']['S'] = 2;
        states['S']['R'] = 2;
        states['S']['P'] = 1;
        states['S']['S'] = 0;

    }
    
    // Modifiers
    
    modifier isJoinable() {
        require(player1 == address(0) || player2 == address(0),
                "The room is full."
        );
        require((player1 != address(0) && msg.value == stake) || (player1 == address(0)), //Player1 can choose the stake, Player2 has to match. 
                "You must pay the stake to play the game."
        );
        _;
    }

        
    modifier playersMadeChoice() {
        require(player1_made_choice && player2_made_choice,
                "The player(s) have not made their choice yet."
        );
        _;
    }
    
    modifier isPlayer() {
        require(msg.sender == player1 || msg.sender == player2,
                "You are not player"
        );
        _;
    }

    modifier playersMadeCommit() {
        require(player1_made_commit && player2_made_commit,
                "The player(s) have not made their commit yet."
        );
        _;
    }

    // Functions
     
    function join() external payable  isJoinable() { // To join the game, there must be a free space
        
        if (player1 == address(0)) {
            player1 = msg.sender;
            stake = msg.value; //Player1 determines the stake
        } else if (player2 == address(0)){
            player2 = msg.sender;
        } else {
            require(false,
                "The player(s) have not made their choice yet."
            );
            require(true,
                "The player(s) have not made their choice yet. t"
            );
        }
    }
    
    function commit(bytes32 commitment) external isPlayer() {
        if (msg.sender == player1 && !player1_made_choice) {
            player1_commit = commitment;
            player1_made_commit = true;
        } else if (msg.sender == player2 && !player2_made_choice) {
            player2_commit = commitment;
            player2_made_commit = true;
        }
    }
    // Check hash 
    function check(string calldata choice, string calldata blinding_factor) external
        isPlayer()
        playersMadeCommit()
    {
        bytes32 hash = keccak256(abi.encodePacked(choice, blinding_factor));

        if (msg.sender == player1) {
            require( hash == player1_commit, "Error hash");
            player1_made_choice = true;
            player1_choice = choice;
        } else if (msg.sender == player2) {
            require(hash == player2_commit, "Error. hash");
            player2_made_choice = true;
            player2_choice = choice;
        }
    }
    
    function disclose() external 
        isPlayer()          // Only players can disclose the game result
        playersMadeChoice() // Can disclose the result when choices are made
    {
        // Disclose the game result
        int result = states[player1_choice][player2_choice];
        if (result == 0) {
            player1.transfer(stake); 
            player2.transfer(stake);
        } else if (result == 1) {
            player1.transfer(address(this).balance);
        } else if (result == 2) {
            player2.transfer(address(this).balance);
        }
        
        // Reset the game
        player1 = address(0);
        player2 = address(0);

        player1_choice = "";
        player2_choice = "";
        
        player1_made_choice = false;
        player2_made_choice = false;
        
    }

    
}
