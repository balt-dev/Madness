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
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.chips, 50)
    end
}

Balatest.TestPlay {
    name = "greedy_2pair",
    jokers = { 'j_greedy_joker' },
    execute = function()
        Balatest.play_hand { '2D', '2C', '4D', '4C', '7D' }
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.chips, 20)
    end
}

Balatest.TestPlay {
    name = "jolly",
    jokers = { 'j_jolly' },
    execute = function()
        Balatest.play_hand { '2D', '2S', '4D', '4H', '4C' }
    end,
    assert = function()
        Balatest.assert_chips(1120)
    end
}

Balatest.TestPlay {
    name = "half",
    jokers = { 'j_half' },
    execute = function()
        Balatest.play_hand { '2S', '3S', '4S', '5S', '6D' }
        Balatest.play_hand { 'AC', 'AD', 'AH' }
    end,
    assert = function()
        Balatest.assert_chips(
            (30 + (2 + 3 + 4 + 5 + 6)) * 4 +
            (30 + (11 * 3)) * (3 * 2)
        )
    end,
    no_autostart = true
}

Balatest.TestPlay {
    name = "stencil",
    jokers = { 'j_stencil' },
    execute = function()
        Balatest.play_hand { 'KS' }
    end,
    assert = function()
        Balatest.assert_chips(
            (5 + 10) * (1 * 5)
        )
    end,
    no_autostart = true
}

Balatest.TestPlay {
    name = "four_fingers",
    jokers = { 'j_four_fingers' },
    execute = function()
        Balatest.play_hand { 'KS', 'QS', 'JS', '10S' }
    end,
    assert = function()
        Balatest.assert_chips(1120) -- Royal Flush
    end,
    no_autostart = true
}

Balatest.TestPlay {
    name = "credit",
    jokers = { 'j_credit_card', 'j_oops', 'j_oops' },
    execute = function()
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.GAME.tags, 1)
    end
}

Balatest.TestPlay {
    name = "dagger",
    jokers = { 'j_ceremonial', 'j_blueprint' },
    execute = function()
        Balatest.start_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.jokers.cards, 1)
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.mult, 5 * 3)
    end,
    no_autostart = true
}

Balatest.TestPlay {
    name = "banner",
    jokers = { 'j_banner' },
    discards = 5,
    execute = function()
        Balatest.play_hand({"KS"})
    end,
    assert = function()
        Balatest.assert_chips((5 + 10) * (1 + 5 * 5))
    end,
}

Balatest.TestPlay {
    name = "summit",
    jokers = { 'j_mystic_summit' },
    discards = 0,
    execute = function()
        Balatest.play_hand({"KS"})
    end,
    assert = function()
        Balatest.assert_chips(math.floor((5 + 10) * 1.75))
    end,
}

Balatest.TestPlay {
    name = "marble",
    jokers = { 'j_marble' },
    execute = function()
        Balatest.discard({"KS"})
    end,
    assert = function()
        Balatest.assert(SMODS.has_enhancement(G.discard.cards[1], 'm_stone'))
    end,
}

Balatest.TestPlay {
    name = "loyalty",
    jokers = { 'j_loyalty_card' },
    execute = function()
        Balatest.play_hand({"KS"})
        Balatest.play_hand({"KD"})
        Balatest.play_hand({"KH"}) -- sora?
    end,
    assert = function()
        Balatest.assert_chips(
            15 + 15 + (15 * 4)
        )
    end,
}

Balatest.TestPlay {
    name = "8ball",
    jokers = { 'j_8_ball', 'j_oops' },
    execute = function()
        G.consumeables.config.card_limit = 4
        Balatest.play_hand({"8S"})
        Balatest.play_hand({"8H"})
        Balatest.play_hand({"8D"})
        Balatest.play_hand({"8C"})
    end,
    assert = function()
        Balatest.assert_eq(
            #G.consumeables.cards, 4
        )
    end,
}

Balatest.TestPlay {
    name = "misprint",
    jokers = { 'j_misprint' },
    execute = function()
        Balatest.play_hand({"2S"})
        Balatest.play_hand({"3S"})
        Balatest.play_hand({"4S"})
        Balatest.play_hand({"5S"})
        Balatest.play_hand({"6S"})
    end,
    assert = function()
        Balatest.assert(
            G.GAME.chips ~= (12 + 13 + 14 + 15 + 16)
        )
    end,
}

Balatest.TestPlay {
    name = "dusk",
    jokers = { 'j_dusk' },
    hands = 1,
    execute = function()
        Balatest.play_hand({"AS", "2S", "3S", "4S", "5S"})
    end,
    assert = function()
        Balatest.assert_chips((100 + (11 + 2 + 3 + 4 + 5) * 2) * 8)
    end,
}

Balatest.TestPlay {
    name = "raised_fist",
    jokers = { 'j_raised_fist' },
    deck = { { r = 'A', s = 'S' }, { r = '2', s = 'S' } },
    execute = function()
        Balatest.play_hand({"AS"})
    end,
    assert = function()
        Balatest.assert_chips((5 + 11) * (1 + 2 * 3))
    end,
}

Balatest.TestPlay {
    name = "fib",
    jokers = { 'j_fibonacci', 'j_oops' },
    execute = function()
        Balatest.play_hand({"AS", "2S", "3S", "4S", "5S"})
    end,
    assert = function()
        Balatest.assert_chips((100 + (11 + 2 + 3 + 5) * 2 + 4) * 8)
    end,
}

Balatest.TestPlay {
    name = "steel",
    jokers = { 'j_steel_joker' },
    deck = { cards = {
        { r = 'A', s = 'S', e = 'm_steel' },
        { r = '2', s = 'S', e = 'm_steel' },
        { r = '3', s = 'S', e = 'm_steel' },
        { r = '4', s = 'S', e = 'm_steel' },
        { r = '5', s = 'S', e = 'm_steel' },
        { r = '6', s = 'S' },
    } },
    execute = function()
        Balatest.play_hand({"AS", "2S", "3S", "4S", "5S"})
    end,
    assert = function()
        Balatest.assert_chips((100 + (11 + 2 + 3 + 5) + 4) * (8 * 11))
    end,
}

Balatest.TestPlay {
    name = "scaryface",
    jokers = { 'j_scary_face' },
    deck = { cards = {
        { r = 'K', s = 'S' },
        { r = 'Q', s = 'S' },
        { r = 'J', s = 'S' },
        { r = 'T', s = 'S' },
        { r = '9', s = 'S' },
    } },
    execute = function()
        Balatest.play_hand({"KS", "QS", "JS", "TS", "9S"})
    end,
    assert = function()
        Balatest.assert_chips(
            (100 + 10 + 50 + 10 + 50 + 10 + 50 + 10 + 9) * 
            (8)
        )
    end,
}

Balatest.TestPlay {
    name = "abstract",
    jokers = { 'j_joker', 'j_abstract' },
    deck = { cards = {
        { r = 'A', s = 'S' },
        { r = '2', s = 'S' },
    } },
    execute = function()
        Balatest.play_hand({"AS"})
    end,
    assert = function()
        Balatest.assert_chips(math.floor(
            (5 + 11) * 
            ((1 + 10) * 1.6)
        ))
    end,
}

Balatest.TestPlay {
    name = "delayed_grat",
    jokers = { 'j_delayed_grat' },
    discards = 5,
    execute = function()
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 7 * 5)
    end,
}

Balatest.TestPlay {
    name = "hack",
    jokers = { 'j_hack' },
    execute = function()
        Balatest.play_hand {"2S", "3S", "5S", "6S", "7S"}
    end,
    assert = function()
        Balatest.assert_chips(
            (35 + 2 + 2 + 3 + 3 + 5 + 5 + 6 + 6 + 7 + 7)
            * 4
        )
    end,
}

Balatest.TestPlay {
    name = "plantfuck",
    jokers = { 'j_pareidolia', 'j_photograph' },
    execute = function()
        Balatest.play_hand {"2S"}
    end,
    assert = function()
        Balatest.assert_chips(math.floor(
            (5 + 2)
            * 1.5
        ))
    end,
}

Balatest.TestPlay {
    name = "gross_michael",
    jokers = { 'j_gros_michel', 'j_oops', 'j_oops', 'j_oops' },
    execute = function()
        Balatest.play_hand {'2S'}
    end,
    assert = function()
        Balatest.assert_chips(7)
        Balatest.assert(G.jokers.cards[1].config.center_key, 'j_cavendish')
    end,
}

Balatest.TestPlay {
    name = "gross_michael_2",
    jokers = { 'j_gros_michel', 'j_oops', 'j_oops', 'j_oops' },
    execute = function()
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[4].config.center_key, 'j_cavendish')
    end,
}

Balatest.TestPlay {
    name = "even_steven",
    jokers = { 'j_even_steven' },
    execute = function()
        Balatest.play_hand({"2S", "6S", "4S", "TS", "8S"})
    end,
    assert = function()
        Balatest.assert_chips(
            (35 + 2 + 4 + 6 + 8 + 10) *
            (4 + 10 * 5)
        )
    end,
}

Balatest.TestPlay {
    name = "odd_todd",
    jokers = { 'j_odd_todd' },
    execute = function()
        Balatest.play_hand({"AS", "5S", "3S", "9S", "7S"})
    end,
    assert = function()
        Balatest.assert_chips(
            (35 + 11 + 3 + 5 + 7 + 9 + 69 * 5) *
            (4)
        )
    end,
}

Balatest.TestPlay {
    name = "scholar",
    jokers = { 'j_scholar' },
    execute = function()
        Balatest.play_hand({"AS", "AC", "AH", "AD"})
    end,
    assert = function()
        Balatest.assert_chips(math.floor(
            (60 + 11 * 4) *
            (7 * (1.5 ^ 4))
        ))
    end,
}

Balatest.TestPlay {
    name = "business",
    jokers = { 'j_business', 'j_oops', 'j_oops', 'j_oops' },
    execute = function()
        Balatest.play_hand({"KH", "KD", "KS", "KC"})
    end,
    assert = function()
        Balatest.assert_eq(
            G.GAME.dollars, 5 * 4
        )
    end,
}

Balatest.TestPlay {
    name = "supernova",
    jokers = { 'j_supernova' },
    consumeables = { 'c_pluto' },
    execute = function()
        Balatest.play_hand({"AS"})
        Balatest.play_hand({"AH"})
        Balatest.play_hand({"AD"})
        Balatest.next_round()        
        Balatest.use(G.consumeables.cards[1])
        Balatest.play_hand({"AC"})
    end,
    assert = function()
        Balatest.assert_chips(
            (15 + 11) *
            (2 + (4 * 2))
        )
    end,
}

Balatest.TestPlay {
    name = "rtb",
    jokers = { 'j_ride_the_bus' },
    execute = function()
        Balatest.play_hand({"AS"})
        Balatest.play_hand({"AH"})
        Balatest.play_hand({"AD"})
        Balatest.next_round()        
        Balatest.play_hand({"AC"})
    end,
    assert = function()
        Balatest.assert_eq(
            G.jokers.cards[1].ability.extra.xmult,
            2
        )
        Balatest.assert_chips(
            (5 + 11) *
            (1 * 2)
        )
    end,
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
    name = "egg",
    jokers = { 'j_egg' },
    execute = function()
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(
            G.jokers.cards[1].sell_cost, 5
        )
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
    name = "splash",
    jokers = { 'j_splash' },
    execute = function()
        Balatest.play_hand { 'AS', '2D', '3S', '4S', '6S' }
    end,
    assert = function()
        Balatest.assert_chips(
            ( 5 + 11 + 2 + 3 + 4 + 6 )
        )
    end
}

Balatest.TestPlay {
    name = "blue",
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
    name = "const",
    jokers = { 'j_constellation' },
    consumeables = { 'c_eris' },
    execute = function()
        Balatest.use(G.consumeables.cards[1])
        Balatest.play_hand { 'AS' }
    end,
    assert = function()
        Balatest.assert_chips(math.floor(
            (5 + 11) * (1.25)
        ))
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
    name = "grimbo",
    jokers = { 'j_green_joker' },
    execute = function()
        Balatest.discard { '2S' }
        Balatest.play_hand { '3S' }
        Balatest.discard { '4S' }
    end,
    assert = function()
        Balatest.assert_chips((5 + 3) * (1 + 3))
        Balatest.assert_eq(
            G.jokers.cards[1].ability.mult,
            1
        )
    end
}

Balatest.TestPlay {
    name = "supos",
    jokers = { 'j_superposition' },
    execute = function()
        Balatest.play_hand { 'AS', '2S', '3S', '4S', '5S' }
    end,
    assert = function()
        Balatest.assert_eq( G.consumeables.cards[1].config.center.set, "Spectral" )
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
    name = "cavendish",
    jokers = { 'j_cavendish' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(
            (2 + 5) * 7
        )
    end
}

Balatest.TestPlay {
    name = "csharp",
    jokers = { 'j_card_sharp' },
    execute = function()
        Balatest.play_hand { '2S' }
        Balatest.play_hand { '3S' }
    end,
    assert = function()
        Balatest.assert_chips(
            (5 + 2) + ((5 + 3) * 5)
        )
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
    name = "rcard",
    jokers = { 'j_red_card' },
    execute = function()
        add_tag(Tag('tag_standard'))
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.exit_shop()
        Balatest.q(Event{
            func = function()
                if G.STATE ~= G.STATES.SMODS_BOOSTER_OPENED then return false end
                local e = {config = {}}
                G.FUNCS.can_skip_booster(e)
                if not e.config.button then return false end
                G.FUNCS.skip_booster()
                return true
            end,
            blocking = false,
            blockable = false
        })
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.xmult, 1.5)
    end
}

Balatest.TestPlay {
    name = "rcard2",
    jokers = { 'j_red_card' },
    execute = function()
        G.jokers.cards[1].ability.extra.xmult = 1.5
        Balatest.play_hand({"2S"})
    end,
    assert = function()
        Balatest.assert_chips(math.floor((5 + 2) * 1.5))
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
    name = "^2",
    jokers = { 'j_square' },
    execute = function()
        Balatest.play_hand { 'AS', 'AD', '6C', '6H' }
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.mult, G.jokers.cards[1].ability.extra.mult_mod)
        Balatest.assert_chips(
            (20 + 11 + 11 + 6 + 6) *
            (2 + 4)
        )
    end,
}

Balatest.TestPlay {
    name = "seance",
    jokers = { 'j_seance' },
    execute = function()
        Balatest.play_hand { 'AS', '2D', '3H', '4C', '5S' }
    end,
    assert = function()
        local neg_tally = 0
        for i, card in ipairs(G.playing_cards) do
            if card.edition and card.edition.negative then
                neg_tally = neg_tally + 1
            end
        end
        Balatest.assert_eq(neg_tally, 2)
        Balatest.assert_eq(#G.consumeables.cards, 0)
    end,
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
    name = "that_one_smp_thats_blowing_up_my_dash",
    jokers = { 'j_vampire' },
    deck = { cards = {
        { r = 'A', s = 'S', e = 'm_steel' },
        { r = '2', s = 'S', e = 'm_steel' },
        { r = '3', s = 'S', e = 'm_steel' },
        { r = '4', s = 'S', e = 'm_steel' },
        { r = '5', s = 'S', e = 'm_steel' },
        { r = '6', s = 'S' },
    } },
    execute = function()
        Balatest.play_hand({"AS", "2S", "3S", "4S", "5S"})
    end,
    assert = function()
        Balatest.assert_chips(math.floor(
            (100 + 11 + 2 + 3 + 4 + 5) *
            (8 * 2.25)
        ))
        for i, card in ipairs(G.playing_cards) do
            Balatest.assert(not SMODS.has_enhancement(card, 'm_steel'))
        end
    end,
}

Balatest.TestPlay {
    name = "shtct",
    jokers = { 'j_shortcut' },
    deck = { cards = {
        { r = 'A', s = 'S', },
        { r = '2', s = 'S', },
        { r = '3', s = 'S', },
        { r = '4', s = 'S', },
        { r = '5', s = 'S', },
        { r = '6', s = 'S' },
    } },
    execute = function()
        Balatest.play_hand({"AS", "2S", "3S", "5S", "6S"})
    end,
    assert = function()
        Balatest.assert_chips(math.floor(
            (100 + 11 + 2 + 3 + 5 + 6) *
            (8)
        ))
    end,
}

Balatest.TestPlay {
    name = "holo",
    jokers = { 'j_hologram' },
    consumeables = { 'c_cryptid' },
    execute = function()
        Balatest.highlight {'AS'}
        Balatest.use(G.consumeables.cards[1])
        Balatest.unhighlight_all()
        Balatest.play_hand {'2S'}
    end,
    assert = function()
        Balatest.assert_chips(math.floor(
            (5 + 2) *
            (1 * 1.5)
        ))
    end,
}

Balatest.TestPlay {
    name = "vaga",
    jokers = { 'j_vagabond' },
    execute = function()
        ease_dollars(10)
        Balatest.play_hand {'2S'}
        Balatest.play_hand {'3S'}
    end,
    assert = function()
        Balatest.assert_eq(
            #G.consumeables.cards, 2
        )
    end,
}

Balatest.TestPlay {
    name = "baron",
    jokers = { 'j_baron' },
    execute = function()
        Balatest.play_hand {'AS'}
    end,
    assert = function()
        Balatest.assert_chips(math.floor(
            (5 + 11) *
            (2 ^ 4)
        ))
    end,
}

Balatest.TestPlay {
    name = "c9",
    jokers = { 'j_cloud_9' },
    execute = function()
        Balatest.play_hand {'9S', '9D', '9H', '9C'}
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 8)
    end,
}

Balatest.TestPlay {
    name = "rocket",
    jokers = { 'j_rocket' },
    execute = function()
        Balatest.next_round()
        Balatest.next_round()
        Balatest.next_round()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 1 + 1 + 2 + 1 + 2 + 2)
    end,
}


Balatest.TestPlay {
    name = "obl",
    jokers = { 'j_obelisk' },
    execute = function()
        G.GAME.hands["Flush"].played = math.huge
        Balatest.play_hand { "2S" }
        Balatest.play_hand { "3S" }
        Balatest.play_hand { "4S" }
        Balatest.next_round()
        Balatest.play_hand { "2S" }
    end,
    assert = function()
        Balatest.assert_chips(math.floor(
            (5 + 2) * 3
        ))
    end,
}

Balatest.TestPlay {
    name = "obl_fuckyoy",
    jokers = { 'j_obelisk' },
    execute = function()
        G.GAME.hands["High Card"].played = math.huge
        Balatest.play_hand { "3S", "3D" }
        Balatest.play_hand { "2S" }
    end,
    assert = function()
        Balatest.assert_chips(7)
    end,
}

Balatest.TestPlay {
    name = "midas",
    jokers = { 'j_midas_mask', 'j_oops' },
    execute = function()
        Balatest.play_hand { "AS", "AH", "AD", "AC" }
    end,
    assert = function()
        local gold_tally = 0
        for i, card in ipairs(G.playing_cards) do
            if SMODS.has_enhancement(card, 'm_gold') then
                gold_tally = gold_tally + 1
            end
        end
        Balatest.assert_eq(gold_tally, 4)
    end,
}

Balatest.TestPlay {
    name = "lucha",
    blind = 'bl_psychic',
    jokers = { 'j_luchador' },
    execute = function()
        Balatest.q(function() G.jokers.cards[1]:sell_card() end)
        Balatest.play_hand { "AS", "AH", "AD", "AC" }
    end,
    assert = function()
        Balatest.assert(G.GAME.chips ~= 0)
    end,
}

Balatest.TestPlay {
    name = "photo",
    jokers = { 'j_photograph' },
    execute = function()
        Balatest.play_hand { "KH", "KS", "KD", "KC" }
    end,
    assert = function()
        Balatest.assert_chips(math.floor(
            (60 + 10 * 4) *
            (7 * 1.5 ^ 4)
        ))
    end,
}

Balatest.TestPlay {
    name = "gift",
    jokers = { 'j_gift', 'j_egg' },
    execute = function()
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(
            G.jokers.cards[2].sell_cost, 8
        )
    end,
}

Balatest.TestPlay {
    name = "bean",
    jokers = { 'j_turtle_bean' },
    hand_size = 10,
    execute = function()
        Balatest.next_round()
    end,
    assert = function()
        Balatest.assert_eq(
            G.hand.config.card_limit, 18
        )
    end,
}

Balatest.TestPlay {
    name = "ero",
    jokers = { 'j_erosion' },
    consumeables = { 'c_immolate' },
    execute = function()
        Balatest.use(G.consumeables.cards[1])
        Balatest.play_hand { "2S" }
    end,
    assert = function()
        Balatest.assert_chips(math.floor(
            (5 + 2) * (2.25)
        ))
    end,
}

Balatest.TestPlay {
    name = "rpark",
    jokers = { 'j_reserved_parking' },
    execute = function()
        Balatest.play_hand { "2S" }
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 3 * 12)
    end,
}

Balatest.TestPlay {
    name = "lttm",
    jokers = { 'j_to_the_moon' },
    execute = function()
        G.GAME.dollars = 100
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 120)
    end,
}

Balatest.TestPlay {
    name = "haluc",
    jokers = { 'j_hallucination' },
    execute = function()
        add_tag(Tag('tag_standard'))
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.exit_shop()
        Balatest.q(Event{
            func = function()
                if G.STATE ~= G.STATES.SMODS_BOOSTER_OPENED then return false end
                local e = {config = {}}
                G.FUNCS.can_skip_booster(e)
                if not e.config.button then return false end
                G.FUNCS.skip_booster()
                return true
            end,
            blocking = false,
            blockable = false
        })
    end,
    assert = function()
        Balatest.assert_eq(#G.consumeables.cards, 1)
    end,
}

Balatest.TestPlay {
    name = "ftell",
    jokers = { 'j_fortune_teller' },
    consumeables = { 'c_hermit', 'c_hermit' },
    execute = function()
        Balatest.use(G.consumeables.cards[2])
        Balatest.wait_for_input(G.STATES.SELECTING_HAND)
        Balatest.use(G.consumeables.cards[1])
        Balatest.play_hand {"2S"}
    end,
    assert = function()
        Balatest.assert_chips(7 * 7)
    end,
}

Balatest.TestPlay {
    name = "jugg",
    jokers = { 'j_blueprint', 'j_juggler' },
    hand_size = 8,
    execute = function()
    end,
    assert = function()
        Balatest.assert_eq(G.hand.config.card_limit, 10)
    end,
}

Balatest.TestPlay {
    name = "drunk",
    jokers = { 'j_blueprint', 'j_drunkard' },
    discards = 0,
    execute = function()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.current_round.discards_left, 2)
    end,
}

Balatest.TestPlay {
    name = "estrogen",
    jokers = { 'j_stone' },
    consumeables = { "c_tower", "c_tower" },
    execute = function()
        Balatest.highlight {"2S"}
        Balatest.use(G.consumeables.cards[1])
        Balatest.unhighlight_all()
        Balatest.highlight {"3S"}
        Balatest.use(G.consumeables.cards[1])
        Balatest.unhighlight_all()
        Balatest.play_hand {"2D"}
    end,
    assert = function()
        Balatest.assert_chips(107)
    end,
}

Balatest.TestPlay {
    name = "au",
    jokers = { 'j_golden' },
    execute = function()
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 10)
    end,
}

Balatest.TestPlay {
    name = "lucky",
    jokers = { 'j_lucky_cat', 'j_oops', 'j_oops', 'j_oops', 'j_oops' },
    consumeables = { "c_magician", "c_magician" },
    execute = function()
        Balatest.highlight {"2S"}
        Balatest.use(G.consumeables.cards[1])        
        Balatest.unhighlight_all()
        Balatest.play_hand {"2S"}
        Balatest.highlight {"2D"}
        Balatest.use(G.consumeables.cards[1])        
        Balatest.unhighlight_all()
        Balatest.play_hand {"2D"}
        Balatest.cash_out()
        Balatest.exit_shop()
        Balatest.start_round()
        Balatest.play_hand {"2C"}
    end,
    assert = function()
        Balatest.assert_chips(7 * 2)
    end,
}

Balatest.TestPlay {
    name = "baseball",
    jokers = { 'j_pareidolia', 'j_pareidolia', 'j_pareidolia', 'j_pareidolia', 'j_baseball' },
    execute = function()
        Balatest.play_hand {"2S"}
    end,
    assert = function()
        Balatest.assert_chips(7 * (2^5))
    end,
}

Balatest.TestPlay {
    name = "bull",
    jokers = { 'j_bull' },
    execute = function()
        ease_dollars(50)
        Balatest.play_hand {"2S"}
    end,
    assert = function()
        Balatest.assert_chips(7 + (5 * 50))
    end,
}

Balatest.TestPlay {
    name = "cola",
    jokers = { 'j_diet_cola' },
    execute = function()
        G.jokers.cards[1]:sell_card()
    end,
    assert = function()
        Balatest.assert_eq(#G.GAME.tags, 1)
    end,
}

Balatest.TestPlay {
    name = "trading",
    jokers = { 'j_trading' },
    execute = function()
        Balatest.discard { "2S" }
    end,
    assert = function()
        Balatest.assert_eq(#G.playing_cards, 51)
        Balatest.assert_eq(G.GAME.dollars, 3)
    end,
}

Balatest.TestPlay {
    name = "flash",
    execute = function()
        Balatest.end_round()
        Balatest.cash_out()
        ease_dollars(500)
        Balatest.q(Event{func = function()
            if G.STATE ~= G.STATES.SHOP then return false end
            for i = 1, 10 do G.FUNCS.reroll_shop() end
            return true
        end})
        Balatest.exit_shop()
        SMODS.add_card {
            set = "Joker",
            key = "j_flash"
        }
        Balatest.start_round()
        Balatest.play_hand { "2S" }
    end,
    assert = function()
        Balatest.assert_chips(7 * 31)
    end,
}

Balatest.TestPlay {
    name = "chaos",
    jokers = { 'j_chaos' },
    hand_size = 5,
    execute = function()
        Balatest.end_round()
        Balatest.cash_out()
        ease_dollars(10)

        Balatest.q(Event{func = function()
            if G.STATE ~= G.STATES.SHOP then return false end
            for i = 1, 10 do G.FUNCS.reroll_shop() end
            return true
        end})
        Balatest.exit_shop()
        Balatest.wait_for_input(G.GAME.BLIND_SELECT)
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.current_round.reroll_cost, 5 + (0.25 * 10))
    end,
}

Balatest.TestPlay {
    name = "popcorn",
    jokers = {"j_popcorn"},
    execute = function()
        Balatest.play_hand { "2S" }
    end,
    assert = function()
        Balatest.assert_chips(7 * 51)
        Balatest.assert_eq(G.jokers.cards[1].ability.mult, 45)
    end,
}

Balatest.TestPlay {
    name = "popcorn_nom",
    jokers = {"j_popcorn"},
    execute = function()
        G.jokers.cards[1].ability.mult = 1
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.jokers.cards, 0)
    end,
}

Balatest.TestPlay {
    name = "pants",
    jokers = {"j_trousers"},
    execute = function()
        Balatest.play_hand { "2S", "2D" }
    end,
    assert = function()
        Balatest.assert_chips((10 + 2 + 2) * (2 + 3))
    end,
}

Balatest.TestPlay {
    name = "majuna",
    jokers = {"j_ancient"},
    execute = function()
        G.GAME.current_round.ancient_card.suit = "Spades"
        Balatest.play_hand { "2S" }
    end,
    assert = function()
        Balatest.assert_chips(7 * 2)
    end,
}

Balatest.TestPlay {
    name = "majuna_ala",
    jokers = {"j_ancient"},
    execute = function()
        G.GAME.current_round.ancient_card.suit = "Hearts"
        Balatest.play_hand { "2S" }
    end,
    assert = function()
        Balatest.assert_chips(7)
    end,
}

Balatest.TestPlay {
    name = "ramen",
    jokers = {"j_ramen"},
    execute = function()
        Balatest.discard { "3S", "4S", "5S", "6S", "7S" }
        Balatest.discard { "3H", "4H", "5H", "6H", "7H" }
        Balatest.discard { "3D", "4D", "5D", "6D", "7D" }
        Balatest.discard { "3C", "4C", "5C", "6C", "7C" }
        Balatest.play_hand { "2S" }
    end,
    assert = function()
        Balatest.assert_chips(math.floor(7 * 1.92))
    end,
}

Balatest.TestPlay {
    name = "wt",
    jokers = {"j_walkie_talkie"},
    execute = function()
        Balatest.play_hand { "4S", "4C" }
    end,
    assert = function()
        Balatest.assert_chips((10 + 4 + 4 + 10 + 10) * 2)
        Balatest.assert_eq(G.GAME.dollars, 8)
    end,
}

Balatest.TestPlay {
    name = "selt",
    jokers = {"j_selzer"},
    consumeables = {"c_talisman"},
    execute = function()
        Balatest.highlight { "AS" }
        Balatest.use(G.consumeables.cards[1])
        Balatest.play_hand { "AS" }
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 6)
    end,
}

Balatest.TestPlay {
    name = "castle",
    jokers = {"j_castle"},
    execute = function()
        Balatest.discard { "AS", "2S", "3S", "4S", "5S" }
        Balatest.play_hand { "2D" }
    end,
    assert = function()
        Balatest.assert_chips(7 + 5 * 5)
    end,
}

Balatest.TestPlay {
    name = ":)",
    jokers = {"j_smiley"},
    execute = function()
        Balatest.play_hand { "KH" }
    end,
    assert = function()
        Balatest.assert_chips((5 + 10) * 11)
    end,
}

Balatest.TestPlay {
    name = "fire",
    jokers = {"j_campfire"},
    consumeables = {"c_talisman"},
    execute = function()
        G.FUNCS.sell_card({config={ref_table=G.consumeables.cards[1]}})
        Balatest.play_hand { "2S" }
    end,
    assert = function()
        Balatest.assert_chips(math.floor(7 * 1.5))
    end,
}

Balatest.TestPlay {
    name = "fire_r",
    jokers = {"j_campfire"},
    consumeables = {"c_talisman"},
    blind = 'bl_eye',
    execute = function()
        G.FUNCS.sell_card({config={ref_table=G.consumeables.cards[1]}})
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.x_mult, 1)
    end,
}

Balatest.TestPlay {
    name = "ticket",
    jokers = {"j_ticket"},
    consumeables = {"c_devil"},
    execute = function()
        Balatest.highlight { "AS" }
        Balatest.use(G.consumeables.cards[1])
        Balatest.unhighlight_all()
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 6)
    end,
}

Balatest.TestPlay {
    name = "bones",
    jokers = {"j_mr_bones"},
    hands = 1,
    execute = function()
        Balatest.play_hand {"2S"}
        Balatest.wait_for_input(G.STATES.SHOP)
    end,
    assert = function()
        Balatest.assert_eq(#G.jokers.cards, 0)
        Balatest.assert_eq(G.STATE, G.STATES.SHOP)
    end,
}

Balatest.TestPlay {
    name = "acro",
    jokers = {"j_acrobat"},
    execute = function()
        Balatest.play_hand {"2S"}
    end,
    assert = function()
        Balatest.assert_chips(7 * 3)
    end,
}

Balatest.TestPlay {
    name = "sock",
    jokers = {"j_sock_and_buskin"},
    execute = function()
        Balatest.play_hand {"KS"}
    end,
    assert = function()
        Balatest.assert_chips(5 + 10 * 2)
    end,
}

Balatest.TestPlay {
    name = "swash",
    jokers = {"j_swashbuckler", "j_pareidolia"},
    execute = function()
        Balatest.play_hand {"2S"}
    end,
    assert = function()
        Balatest.assert_chips((5 + 2) * (1 + 4))
    end,
}

Balatest.TestPlay {
    name = "troub",
    hands = 5,
    jokers = {"j_troubadour"},
    hand_size = 9,
    execute = function()
    end,
    assert = function()
        Balatest.assert_eq(G.hand.config.card_limit, 10)
        Balatest.assert_eq(G.GAME.current_round.hands_left, 6)
    end,
}

Balatest.TestPlay {
    name = "cert",
    jokers = {"j_certificate"},
    execute = function()
        Balatest.discard {"AS"}
    end,
    assert = function()
        local tally = 0
        for i, card in ipairs(G.playing_cards) do
            if card.seal then
                tally = tally + 1
            end
        end
        Balatest.assert_eq(tally, 1)
        Balatest.assert_eq(#G.playing_cards, 52)
    end,
}

Balatest.TestPlay {
    name = "smear",
    blind = 'bl_goad',
    jokers = {"j_smeared"},
    execute = function()
        Balatest.play_hand {"2S"}
    end,
    assert = function()
        Balatest.assert_chips(7)
    end,
}

Balatest.TestPlay {
    name = "tback",
    jokers = {"j_throwback"},
    execute = function()
        Balatest.skip_blind("tag_coupon")
        Balatest.skip_blind("tag_coupon")
        Balatest.start_round()
        Balatest.play_hand {"2S"}
    end,
    assert = function()
        Balatest.assert_chips(math.floor(7 * 2.5))
    end,
    no_auto_start = true
}

Balatest.TestPlay {
    name = "chad",
    jokers = {"j_hanging_chad"},
    execute = function()
        Balatest.play_hand {"2S"}
    end,
    assert = function()
        Balatest.assert_chips(5 + 2 * 3)
    end,
}

Balatest.TestPlay {
    name = "rgem",
    jokers = {"j_rough_gem"},
    execute = function()
        Balatest.play_hand {"2D"}
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 4)
    end,
}

Balatest.TestPlay {
    name = "bstone",
    jokers = {"j_bloodstone"},
    execute = function()
        Balatest.play_hand {"2H"}
    end,
    assert = function()
        Balatest.assert_chips(7 * 2)
    end,
}

Balatest.TestPlay {
    name = "ahead",
    jokers = {"j_arrowhead"},
    execute = function()
        Balatest.play_hand {"2S"}
    end,
    assert = function()
        Balatest.assert_chips(107)
    end,
}

Balatest.TestPlay {
    name = "oagate",
    jokers = {"j_onyx_agate"},
    execute = function()
        Balatest.play_hand {"2C"}
    end,
    assert = function()
        Balatest.assert_chips(7 * 16)
    end,
}

Balatest.TestPlay {
    name = "fpot",
    jokers = {"j_flower_pot"},
    blind = 'bl_goad',
    execute = function()
        Balatest.play_hand {"AS", "AH", "AD", "AC"}
    end,
    assert = function()
        Balatest.assert_chips(
            (60 + 11 * 3) *
            (7 * 5)
        )
    end,
}

Balatest.TestPlay {
    name = "wee",
    jokers = {"j_wee"},
    execute = function()
        Balatest.play_hand {"2S", "2H", "2D"}
        Balatest.next_round()
        Balatest.play_hand {"2S"}
    end,
    assert = function()
        Balatest.assert_chips(
            7 + 20 * 4
        )
    end,
}

Balatest.TestPlay {
    name = "mandy",
    jokers = {"j_merry_andy"},
    hand_size = 11,
    discards = 7,
    execute = function()
    end,
    assert = function()
        Balatest.assert_eq(
            G.GAME.current_round.discards_left, 10
        )
        Balatest.assert_eq(
            G.hand.config.card_limit, 10
        )
    end,
}

Balatest.TestPlay {
    name = "idol",
    jokers = {"j_idol"},
    execute = function()
        G.GAME.current_round.idol_card = { id = 2, rank = '2', suit = 'Spades' }
        Balatest.play_hand {"2S"}
    end,
    assert = function()
        Balatest.assert_chips(7 * 3)
    end,
}

Balatest.TestPlay {
    name = "sdouble",
    jokers = {"j_seeing_double"},
    deck = {cards = {{r="7",s="C"}, {r="7",s="C"}, {r="7",s="C"}, {r="7",s="C"}, {r="7",s="C"}}},
    execute = function()
        Balatest.play_hand {"7C", "7C", "7C", "7C"}
    end,
    assert = function()
        Balatest.assert_eq(#G.consumeables.cards, 1)
    end,
}

Balatest.TestPlay {
    name = "mata",
    jokers = {"j_matador", "j_splash"},
    blind = 'bl_goad',
    execute = function()
        Balatest.play_hand {"2S", "3S", "4S"}
    end,
    assert = function()
        Balatest.assert_chips(5)
        Balatest.assert_eq(G.GAME.dollars, 15)
    end,
}

Balatest.TestPlay {
    name = "htr",
    jokers = {"j_hit_the_road"},
    execute = function()
        Balatest.discard {"JS", "JH"}
        Balatest.next_round()
        Balatest.discard {"JS", "JH"}
        Balatest.play_hand {"2S"}
    end,
    assert = function()
        Balatest.assert_chips(7 * 2)
    end,
}

Balatest.TestPlay {
    name = "duo",
    jokers = {"j_duo"},
    execute = function()
        Balatest.play_hand {"2S", "2D"}
    end,
    assert = function()
        Balatest.assert_chips((10 + 2 * 4) * 2)
    end,
}

Balatest.TestPlay {
    name = "stunt",
    jokers = {"j_stuntman"},
    hand_size = 100,
    execute = function()
        Balatest.play_hand {"2S"}
    end,
    assert = function()
        Balatest.assert_chips(507)
    end,
}

Balatest.TestPlay {
    name = "invis",
    jokers = {"j_invisible", "j_joker"},
    execute = function()
        G.jokers.cards[1]:sell_card()
        Balatest.wait_for_input(G.STATES.SELECTING_HAND)
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.jokers.cards, 2)
        Balatest.assert_eq(G.jokers.cards[1].config.center_key, "j_joker")
        Balatest.assert_eq(G.jokers.cards[2].config.center_key, "j_joker")
    end,
}

Balatest.TestPlay {
    name = "sat",
    jokers = {"j_satellite"},
    consumeables = {"c_pluto", "c_eris"},
    execute = function()
        Balatest.use(G.consumeables.cards[2])
        Balatest.use(G.consumeables.cards[1])
        Balatest.play_hand {"2S"}
        Balatest.play_hand {"2D"}
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 4)
    end,
}

Balatest.TestPlay {
    name = "stm",
    jokers = {"j_shoot_the_moon"},
    execute = function()
        Balatest.play_hand {"2S"}
    end,
    assert = function()
        Balatest.assert_chips(7 * (1 + 13 * 4))
    end,
}

Balatest.TestPlay {
    name = "dlic",
    jokers = {"j_drivers_license"},
    deck = {cards = {
        {r="A",s="S",g="Gold"},
        {r="A",s="S",g="Gold"},
        {r="A",s="S",g="Gold"},
        {r="A",s="S",g="Gold"},
        {r="A",s="S",g="Gold"},
        {r="A",s="S",g="Gold"},
        {r="A",s="S",g="Gold"},
        {r="A",s="S",g="Gold"},
        {r="A",s="S",g="Gold"},
        {r="A",s="S",g="Gold"},
        {r="A",s="S",g="Gold"},
        {r="A",s="S",g="Gold"},
        {r="A",s="S",g="Gold"},
        {r="A",s="S",g="Gold"},
        {r="A",s="S",g="Gold"},
        {r="A",s="S",g="Gold"},
        {r="2",s="S"},
    }},
    execute = function()
        Balatest.play_hand {"2S"}
    end,
    assert = function()
        Balatest.assert_chips(7 * 10)
    end,
}

Balatest.TestPlay {
    name = "carto",
    jokers = {"j_cartomancer"},
    execute = function()
    end,
    assert = function()
        Balatest.assert_eq(#G.consumeables.cards, 1)
    end,
}

Balatest.TestPlay {
    name = "burnt",
    jokers = {"j_burnt"},
    execute = function()
        Balatest.discard {"2S"}
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.hands["High Card"].level, 2)
    end,
}

Balatest.TestPlay {
    name = "boot",
    jokers = {"j_bootstraps"},
    execute = function()
        ease_dollars(21)
        Balatest.play_hand {"2S"}
    end,
    assert = function()
        Balatest.assert_chips(7 * 22)
    end,
}

Balatest.TestPlay {
    name = "canio",
    jokers = {"j_caino", "j_trading"},
    execute = function()
        Balatest.discard {"KS"}
        Balatest.play_hand {"2S"}
    end,
    assert = function()
        Balatest.assert_chips(7 * 2)
    end,
}

Balatest.TestPlay {
    name = "trib",
    jokers = {"j_triboulet"},
    execute = function()
        Balatest.play_hand {"KS"}
    end,
    assert = function()
        Balatest.assert_chips((5 + 10) * 2)
    end,
}

Balatest.TestPlay {
    name = "rick",
    jokers = {"j_yorick"},
    execute = function()
        Balatest.discard {"AS",       "3S", "4S", "5S"}
        Balatest.discard {"AD", "2D", "3D", "4D", "5D"}
        Balatest.discard {"AH", "2H", "3H", "4H", "5H"}
        Balatest.discard {"AC", "2C", "3C", "4C", "5C"}
        Balatest.discard {"6S", "6H", "6D", "6C"}
        Balatest.play_hand {"2S"}
    end,
    assert = function()
        Balatest.assert_chips(14)
    end,
}

Balatest.TestPlay {
    name = "chicot",
    jokers = {"j_chicot"},
    blind = "bl_psychic",
    execute = function()
        Balatest.play_hand {"2S"}
    end,
    assert = function()
        Balatest.assert_chips(7)
    end,
}

Balatest.TestPlay {
    name = "perkeo",
    jokers = {"j_perkeo"},
    consumeables = {"c_talisman"},
    execute = function()
        Balatest.next_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.consumeables.cards, 2)
    end,
}

Balatest.TestPlay {
    name = "mail",
    jokers = {"j_mail"},
    execute = function()
        G.GAME.current_round.mail_card = { id = 2, rank = '2', suit = 'Spades' }
        Balatest.discard { "2S", "3S", "4S" }
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 2)
    end,
}

Balatest.TestPlay {
    name = "smeared",
    jokers = { 'j_smeared', 'j_four_fingers' },
    blind = "bl_goad",
    execute = function()
        Balatest.play_hand { '2S', '3D', '4H', '5C' }
    end,
    assert = function()
        Balatest.assert_chips((100 + (2 + 3 + 4 + 5)) * 8) -- Straight flush
    end,
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