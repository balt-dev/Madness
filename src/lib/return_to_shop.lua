function MADNESS.return_to_shop(card)
    if G.blind_select then
        G.blind_select:remove()
        G.blind_prompt_box:remove()
        G.blind_select = nil
    end
    G:save_settings()
    G.FILE_HANDLER.force = true
    G.STATE_COMPLETE = false

    G.FUNCS.draw_from_hand_to_discard()
    G.FUNCS.draw_from_discard_to_deck()

    if G.GAME.round_resets.temp_handsize then
        G.hand:change_size(-G.GAME.round_resets.temp_handsize); G.GAME.round_resets.temp_handsize = nil
    end
    if G.GAME.round_resets.temp_reroll_cost then
        G.GAME.round_resets.temp_reroll_cost = nil; calculate_reroll_cost(true)
    end

    reset_idol_card()
    reset_mail_rank()
    reset_ancient_card()
    reset_castle_card()
    for _, mod in ipairs(SMODS.mod_list) do
        if mod.reset_game_globals and type(mod.reset_game_globals) == 'function' then
            mod.reset_game_globals(false)
        end
    end
    for k, v in ipairs(G.playing_cards) do
        v.ability.discarded = nil
        v.ability.forced_selection = nil
    end

    stop_use()
    G.deck:hard_set_T()
    G.GAME.blind:defeat()

    G.STATE = G.STATES.SHOP
    G.STATE_COMPLETE = false

    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            G.GAME.current_round.jokers_purchased = 0
            G.GAME.current_round.discards_left = math.max(0, G.GAME.round_resets.discards + G.GAME.round_bonus.discards)
            G.GAME.current_round.hands_left = (math.max(1, G.GAME.round_resets.hands + G.GAME.round_bonus.next_hands))
            G.GAME.shop_free = nil
            G.GAME.shop_d6ed = nil
            ease_chips(0)
            G.deck:shuffle('cashout' .. G.GAME.round_resets.ante)
            return true
        end
    }))
    reset_blinds()
    MADNESS.returning_to_shop = false
end
