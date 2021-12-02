const RockPaperScissors = artifacts.require("RockPaperScissors");

contract('RockPaperScissors', (accounts) => {
    
    it('first test about initialization', async () => {
        const game = await RockPaperScissors.deployed();
        player1 = await game.player1.call();
        player2 = await game.player2.call();

        player1_made_choice = await game.player1_choice.call();
        player2_made_choice = await game.player2_choice.call();

        commitmentOfPlayer1 = await game.player1_commit.call();
        commitmentOfPlayer2 = await game.player2_commit.call();

        player1_made_commit = await game.player1_made_commit.call();
        player2_made_commit = await game.player2_made_commit.call();
        
        hasPlayer1MadeChoice = await game.player1_made_choice.call();
        hasPlayer2MadeChoice = await game.player2_made_choice.call();
        stake = await game.stake.call();
        
        expect_res = '0x0000000000000000000000000000000000000000';

        assert.equal(player1, expect_res);
        assert.equal(player2, '0x0000000000000000000000000000000000000000');

        assert.equal(player1_made_choice, '');
        assert.equal(player2_made_choice, '');
        assert.equal(commitmentOfPlayer1, '0x0000000000000000000000000000000000000000000000000000000000000000');
        assert.equal(commitmentOfPlayer2, '0x0000000000000000000000000000000000000000000000000000000000000000');
        
        assert.equal(player1_made_commit, false);
        assert.equal(player2_made_commit, false);
        assert.equal(player1_made_choice, false);
        assert.equal(player2_made_choice, false);
        assert.equal(stake.toString(10), '0'); 
    });

    it('second test about join', async () => {
        const game = await RockPaperScissors.deployed();
        balance_before = await web3.eth.getBalance(accounts[0]);
        await game.join({from: accounts[0], value: web3.utils.toWei('10', 'ether')})
        
        player1 = await game.player1.call();
        stake = await game.stake.call();
        balance_after = await web3.eth.getBalance(accounts[0]);

        assert.equal(player1, accounts[0]);
        assert.equal(stake.toString(10), '10000000000000000000'); 
        assert.ok(
            balance_before - balance_after - web3.utils.toWei('10', 'ether')
            < web3.utils.toWei('5', 'finney') 
        )

        player2 = await game.player2.call();
        await game.join({from: accounts[2], value: web3.utils.toWei('10', 'ether')})
        player2 = await game.player2.call();
        assert.equal(player2, accounts[2]);
    });

});
