Balatest.TestPlay {
    name = "joker",
    jokers = { 'j_joker' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(77)
    end,
}

Balatest.TestPlay {
    name = "greedy_flush",
    jokers = { 'j_greedy_joker' },
    execute = function()
        Balatest.play_hand { '2D', '3D', '4D', '5D', '7D' }
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.mult, 10)
    end
}

Balatest.TestPlay {
    name = "greedy_2pair",
    jokers = { 'j_greedy_joker' },
    execute = function()
        Balatest.play_hand { '2D', '2C', '4D', '4C', '7D' }
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.mult, 4)
    end
}


Balatest.TestPlay {
    name = "space",
    jokers = { 'j_space', 'j_oops', 'j_oops' },
    execute = function()
        Balatest.play_hand { '2S' }
        Balatest.play_hand { '3S' }
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.hands["High Card"].level, 2)
    end
}

Balatest.TestPlay {
    name = "burglar",
    jokers = { 'j_burglar' },
    hands = 4,
    discards = 3,
    execute = function()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.current_round.hands_left, 7)
        Balatest.assert_eq(G.GAME.current_round.discards_left, 1)
    end
}

Balatest.TestPlay {
    name = "burglar_nodis",
    jokers = { 'j_burglar' },
    hands = 4,
    discards = 0,
    execute = function()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.current_round.hands_left, 7)
        Balatest.assert_eq(G.GAME.current_round.discards_left, 0)
    end
}


Balatest.TestPlay {
    name = "blackboard",
    jokers = { 'j_blackboard' },
    deck = { cards = { { r = 'A', s = 'S' }, { r = 'A', s = 'S' }, { r = '6', s = 'C' }, { r = '6', s = 'C' }, { r = 'Q', s = 'D' }, { r = 'J', s = 'D' } } },
    execute = function()
        Balatest.play_hand { 'AS', 'AS', '6C', '6C', 'QD' }
    end,
    assert = function()
        Balatest.assert_chips(324)
    end
}


Balatest.TestPlay {
    name = "blackboard_nope",
    jokers = { 'j_blackboard', 'j_splash' },
    deck = { cards = { { r = 'A', s = 'S' }, { r = 'A', s = 'S' }, { r = '6', s = 'C' }, { r = '6', s = 'C' }, { r = 'Q', s = 'D' }, { r = 'J', s = 'D' } } },
    execute = function()
        Balatest.play_hand { 'AS', 'AS', '6C', '6C', 'QD' }
    end,
    assert = function()
        Balatest.assert_chips(128)
    end
}

Balatest.TestPlay {
    name = "runner_nonscoring",
    jokers = { 'j_runner' },
    execute = function()
        Balatest.play_hand { 'AS', 'AD', '6C', '6H', 'QD' }
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.chips, 0)
    end
}

Balatest.TestPlay {
    name = "runner_scoring",
    jokers = { 'j_runner', 'j_splash' },
    execute = function()
        Balatest.play_hand { 'AS', 'AD', '6C', '6H', 'QD' }
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.chips, 0)
    end
}

Balatest.TestPlay {
    name = "runner_upgrade",
    jokers = { 'j_runner' },
    execute = function()
        Balatest.play_hand { 'AS', 'AD', '6C', '6H' }
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.chips, G.jokers.cards[1].ability.extra.chip_mod)
    end
}

Balatest.TestPlay {
    name = "ice_cream",
    jokers = { 'j_ice_cream' },
    execute = function()
        Balatest.play_hand { 'AS' }
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.chips, 225)
    end
}


Balatest.TestPlay {
    name = "ice_cream_melt",
    jokers = { 'j_ice_cream' },
    execute = function()
        G.jokers.cards[1].ability.extra.chips = 25
        Balatest.play_hand { 'AS' }
    end,
    assert = function()
        Balatest.assert_eq(#G.jokers.cards, 0)
    end
}

Balatest.TestPlay {
    name = "dna",
    jokers = { 'j_dna' },
    deck = { cards = { { r = 'A', s = 'S' }, { r = '2', s = 'D' }, { r = '2', s = 'D' }, { r = '2', s = 'D' }, { r = '2', s = 'D' } } },
    hand_size = 5,
    execute = function()
        Balatest.play_hand { 'AS' }
        Balatest.play_hand { 'AS' }
        Balatest.play_hand { 'AS' }
    end,
    assert = function()
        Balatest.assert_eq(#G.hand.cards, 4)
        Balatest.assert_eq(#G.discard.cards, 2)
    end
}

Balatest.TestPlay {
    name = "dabadee_dabadie",
    jokers = { 'j_blue_joker' },
    execute = function()
        Balatest.discard { 'AS', 'KS', 'QS', 'JS', '10S' }
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(5 + 2 + 52 * G.jokers.cards[1].ability.extra)
    end
}

Balatest.TestPlay {
    name = "6sense",
    jokers = { 'j_blueprint', 'j_blueprint', 'j_sixth_sense' },
    deck = { cards = { {r='6',s='S'}, {r='6',s='S'}, {r='6',s='S'}, {r='6',s='S'}, {r='6',s='S'}, {r='6',s='S'}, {r='6',s='S'}, {r='6',s='S'}, {r='6',s='S'}, {r='6',s='S'} } },
    execute = function()
        G.consumeables.config.card_limit = 7
        Balatest.play_hand { '6S', '6S', '6S', '6S', '6S' }
    end,
    assert = function()
        Balatest.assert_eq(#G.consumeables.cards, 7)
        Balatest.assert_eq(#G.playing_cards, 5)
    end
}

Balatest.TestPlay {
    name = "hike",
    jokers = { 'j_hiker' },
    execute = function()
        Balatest.play_hand { 'AS' }
        Balatest.next_round()
        Balatest.play_hand { 'AS' }
    end,
    assert = function()
        Balatest.assert_eq(G.discard.cards[1].ability.perma_mult, 2)
    end
}

Balatest.TestPlay {
    name = "faceless",
    jokers = { 'j_faceless' },
    execute = function()
        Balatest.discard { 'KS', 'KC', 'KD', 'KH', 'QS' }
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, G.jokers.cards[1].ability.extra.dollars * 5)
    end
}

Balatest.TestPlay {
    name = "todo",
    jokers = { 'j_todo_list' },
    execute = function()
        G.jokers.cards[1].ability.extra.poker_hand = 'Pair'
        Balatest.wait()
        Balatest.play_hand { 'KS', 'KD', 'QH', 'QS', 'QC' }
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, G.jokers.cards[1].ability.extra.dollars)
    end
}

Balatest.TestPlay {
    name = "madness",
    jokers = { 'j_madness', 'j_blueprint' },
    hand_size = 7,
    execute = function()
    end,
    assert = function()
        Balatest.assert_eq(#G.jokers.cards, 1)
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.xmult, G.jokers.cards[1].ability.extra.xmult_gain * 5 + 1)
    end
}

Balatest.TestPlay {
    name = "madness_eternal",
    jokers = { 'j_madness', 'j_blueprint' },
    hand_size = 7,
    execute = function()
        Balatest.q(function() G.jokers.cards[2].ability.eternal = true end)
        Balatest.wait()
        Balatest.start_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.jokers.cards, 2)
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.xmult, G.jokers.cards[1].ability.extra.xmult_gain * 5 + 1)
    end,
    no_auto_start = true
}

Balatest.TestPlay {
    name = "riffraff",
    jokers = { 'j_riff_raff' },
    hand_size = 7,
    execute = function()
        Balatest.start_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.jokers.cards, 5)
    end,
    no_autostart = true
}


Balatest.TestPlay {
    name = "overscoring",
    jokers = { 'j_baron', 'j_mime' },
    hand_size = 10,
    deck = { cards = {{r='K',s='S'},{r='K',s='S'},{r='K',s='S'},{r='K',s='S'},{r='K',s='S'},{r='K',s='S'},{r='K',s='S'},{r='K',s='S'},{r='K',s='S'},{r='K',s='S'}}},
    execute = function()
        Balatest.assert(MADNESS.config.overscoring, "Overscoring has to be enabled to test overscoring")
        Balatest.play_hand { 'KS' }
        Balatest.cash_out()
        Balatest.exit_shop()
        Balatest.start_round()
        Balatest.play_hand { 'KS' }
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.overscoring_ante, 9)
    end,
}