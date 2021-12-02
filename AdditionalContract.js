const RockPaperScissors = artifacts.require("RockPaperScissors");
const AdditionalContract = artifacts.require("AdditionalContract");

contract('AdditionalContract', (accounts) => {
    it('join game', async () => {
        const game = await RockPaperScissors.deployed();
        const additional = await AdditionalContract.deployed();
        await additional.init(game.address);

        await additional.join({from: accounts[0], value: web3.utils.toWei('42', 'wei')})

        player1 = await game.player1.call();
        stake = await game.stake.call();


        assert.equal(player1, additional.address);
        assert.equal(stake.toString(10), '42');
    });
});
