SMODS.Stake:take_ownership("blue", {
    modifiers = function()
        if MADNESS.config.blue_stake_rework then
        	G.GAME.starting_params.hand_size = G.GAME.starting_params.hand_size - 1
        else
        	G.GAME.starting_params.discards = G.GAME.starting_params.discards - 1
        end
    end,
}, not MADNESS.config.blue_stake_rework)