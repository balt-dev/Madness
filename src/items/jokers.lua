SMODS.Joker:take_ownership(
	'joker', {
		config = {mult = 10}, 
		calculate = function(self, card, context)
			if context.joker_main or context.forcetrigger then
				return {
					mult = card.ability.mult
				}
			end
		end
	}
)

-- Suit jokers

local suit_joker_calc = function(self, card, context)
    if context.individual and context.cardarea == G.play and
        context.other_card:is_suit(card.ability.extra.suit) then
        SMODS.scale_card(card, {
            ref_table = card.ability.extra,
            ref_value = "chips",
            scalar_table = card.ability.extra,
            scalar_value = "s_chips",
            operation = "+",
            no_message = true
        })
    end
    if context.joker_main or context.forcetrigger then
        return {
            chips = card.ability.extra.chips
        }
    end
end

local suit_joker_loc = function(self, info_queue, card)
    return { vars = { card.ability.extra.s_chips, localize(card.ability.extra.suit, 'suits_singular'), card.ability.extra.chips} }
end

SMODS.Joker:take_ownership('greedy_joker',
    {
		config = { extra = { s_chips = 10, chips = 0, suit = 'Diamonds' }, },
        loc_vars = suit_joker_loc,
        calculate = suit_joker_calc
    }
)

SMODS.Joker:take_ownership('lusty_joker',
    {
		config = { extra = { s_chips = 10, chips = 0, suit = 'Hearts' }, },
        loc_vars = suit_joker_loc,
        calculate = suit_joker_calc
    }
)

SMODS.Joker:take_ownership('gluttenous_joker',
    {
		config = { extra = { s_chips = 10, chips = 0, suit = 'Clubs' }, },
        loc_vars = suit_joker_loc,
        calculate = suit_joker_calc
    }
)

SMODS.Joker:take_ownership('wrathful_joker',
    {
		config = { extra = { s_chips = 10, chips = 0, suit = 'Spades' }, },
        loc_vars = suit_joker_loc,
        calculate = suit_joker_calc
    }
)

-- Poker hand jokers

local mult_loc_vars = function(self, info_queue, card) return { vars = { card.ability.extra.t_mult, localize(card.ability.extra.type, 'poker_hands') } } end
local mult_calc = function(self, card, context)
	if context.joker_main and next(context.poker_hands[card.ability.extra.type]) or context.forcetrigger then
		return {
			mult = card.ability.extra.t_mult
		}
	end
end

SMODS.Joker:take_ownership('jolly', {calculate = mult_calc, loc_vars = mult_loc_vars, config = { extra = { t_mult = 16, type = 'Pair' } }})
SMODS.Joker:take_ownership('zany', {calculate = mult_calc, loc_vars = mult_loc_vars, config = { extra = { t_mult = 24, type = 'Three of a Kind' } }})
SMODS.Joker:take_ownership('mad', {calculate = mult_calc, loc_vars = mult_loc_vars, config = { extra = { t_mult = 20, type = 'Two Pair' } }})
SMODS.Joker:take_ownership('crazy', {calculate = mult_calc, loc_vars = mult_loc_vars, config = { extra = { t_mult = 24, type = 'Straight' } }})
SMODS.Joker:take_ownership('droll', {calculate = mult_calc, loc_vars = mult_loc_vars, config = { extra = { t_mult = 20, type = 'Flush' } }})

local chip_loc_vars = function(self, info_queue, card) return { vars = { card.ability.extra.t_chips, localize(card.ability.extra.type, 'poker_hands') } } end
local chip_calc = function(self, card, context)
	if context.joker_main and next(context.poker_hands[card.ability.extra.type]) or context.forcetrigger then
		return {
			chips = card.ability.extra.t_chips
		}
	end
end

SMODS.Joker:take_ownership('sly', {calculate = chip_calc, loc_vars = chip_loc_vars, config = { extra = { t_chips = 100, type = 'Pair' } }})
SMODS.Joker:take_ownership('wily', {calculate = chip_calc, loc_vars = chip_loc_vars, config = { extra = { t_chips = 200, type = 'Three of a Kind' } }})
SMODS.Joker:take_ownership('clever', {calculate = chip_calc, loc_vars = chip_loc_vars, config = { extra = { t_chips = 160, type = 'Two Pair' } }})
SMODS.Joker:take_ownership('devious', {calculate = chip_calc, loc_vars = chip_loc_vars, config = { extra = { t_chips = 200, type = 'Straight' } }})
SMODS.Joker:take_ownership('crafty', {calculate = chip_calc, loc_vars = chip_loc_vars, config = { extra = { t_chips = 160, type = 'Flush' } }})

SMODS.Joker:take_ownership('half', {
	rarity = 2,
    config = { extra = { x_mult = 2, size = 3 } },
	loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult, card.ability.extra.size } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and #context.full_hand <= card.ability.extra.size then
            return {
                xmult = card.ability.extra.x_mult
            }
        end
    end
})

SMODS.Joker:take_ownership('credit_card', {
	rarity = 2,
    blueprint_compat = true,
    config = { extra = { odds = 3 } },
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'madness_credit_card')
        return {
            vars = { numerator, denominator, localize{type = 'name_text', key="tag_coupon", set="Tag"} },
        }
    end,
	calculate = function(self, card, context)
		if context.end_of_round and context.cardarea == G.jokers 
			and SMODS.pseudorandom_probability(card, 'madness_credit_card', 1, card.ability.extra.odds)
		then
            G.E_MANAGER:add_event(Event({
                func = (function()
                    add_tag(Tag('tag_coupon'))
                    play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                    card:juice_up(0.8, 0.8)
                    return true
                end)
            }))
		end	
	end,
    add_to_deck = function(self, card, from_debuff)
        return {}
    end,
    remove_from_deck = function(self, card, from_debuff)
        return {}
    end
})

SMODS.Joker:take_ownership('ceremonial', {
    config = { extra = { mult = 0, multiplier = 3 } },
    loc_vars = function(self, info_queue, card)
    	return { vars = { card.ability.extra.multiplier, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            local my_pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then my_pos = i; break end
            end
            if my_pos and G.jokers.cards[my_pos+1] and not card.getting_sliced and not SMODS.is_eternal(G.jokers.cards[my_pos+1], card) and not G.jokers.cards[my_pos+1].getting_sliced then
                local sliced_card = G.jokers.cards[my_pos+1]
                sliced_card.getting_sliced = true
                G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                G.E_MANAGER:add_event(Event({func = function()
                    G.GAME.joker_buffer = 0

                    card:juice_up(0.8, 0.8)
                    sliced_card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                    play_sound('slice1', 0.96+math.random()*0.08)
                return true end }))
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "mult",
                    scalar_table = sliced_card,
                    scalar_value = "sell_cost",
                    operation = function(ref_table, ref_value, initial, scaling)
                        ref_table[ref_value] = initial + card.ability.extra.multiplier * scaling
                    end,
                    scaling_message = {
                        message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult + card.ability.extra.multiplier * sliced_card.sell_cost}},
                        colour = G.C.RED,
                        no_juice = true
                    }
                })
                return nil, true
            end
        end
        if context.joker_main or context.forcetrigger then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
})

SMODS.Joker:take_ownership('banner', {
    config = { extra = { mult = 5 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
	calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            return {
                mult = G.GAME.current_round.discards_left * card.ability.extra.mult
            }
        end
	end
})

SMODS.Joker:take_ownership('mystic_summit', {
    config = { extra = { x_mult = 1.75, d_remaining = 0 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult, card.ability.extra.d_remaining } }
    end,
	calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.discards_left == card.ability.extra.d_remaining then
            return {
                xmult = card.ability.extra.x_mult
            }
        end
	end
})

SMODS.Joker:take_ownership('marble', {
	config = { extra = { max_discard = 1 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
		return { vars = { math.floor(card.ability.extra.max_discard), localize{type = 'name_text', key="m_stone", set="Enhanced"} } }
    end,
	calculate = function(self, card, context)
        if context.first_hand_drawn then
            local eval = function() return G.GAME.current_round.discards_used == 0 and not G.RESET_JIGGLES end
            juice_card_until(card, eval, true)
        end
        if context.pre_discard and not context.blueprint and
            G.GAME.current_round.discards_used <= 0 and
			#context.full_hand == math.floor(card.ability.extra.max_discard)
		then
            for _, discarded_card in ipairs(context.full_hand) do
				discarded_card:set_ability('m_stone', nil, true)
    			discarded_card:juice_up()
            end
            return { message = localize("k_plus_stone") }
        end
	end
})

SMODS.Joker:take_ownership('loyalty_card', {
    config = { extra = { Xmult = 4, every = 2, loyalty_remaining = 2 } },
	loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.Xmult,
                card.ability.extra.every + 1,
                localize { type = 'variable', key = (card.ability.extra.loyalty_remaining == 0 and 'loyalty_active' or 'loyalty_inactive'), vars = { card.ability.extra.loyalty_remaining } }
            }
        }
    end,
	calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            card.ability.extra.loyalty_remaining = (card.ability.extra.every - 1 - (G.GAME.hands_played - card.ability.hands_played_at_create)) %
                (card.ability.extra.every + 1)
            if not context.blueprint then
                if card.ability.extra.loyalty_remaining == 0 then
                    local eval = function(card) return card.ability.extra.loyalty_remaining == 0 and not G.RESET_JIGGLES end
                    juice_card_until(card, eval, true)
                end
            end
            if card.ability.extra.loyalty_remaining == card.ability.extra.every or context.forcetrigger then
                return {
                    xmult = card.ability.extra.Xmult
                }
            end
        end
    end
})

SMODS.Joker:take_ownership('8_ball', {
    config = { extra = 2 },
})

SMODS.Joker:take_ownership('misprint', {
	rarity = 2,
    config = { extra = { max = 3, min = 0.5 } },
    loc_vars = function(self, info_queue, card)
        local r_mults = {}
        for i = card.ability.extra.min * 10, card.ability.extra.max * 10 do
            r_mults[#r_mults + 1] = tostring(i / 10)
        end
        local loc_mult = ' ' .. (localize('k_mult')) .. ' '
        local main_start = {
			{
				n = G.UIT.C,
				config = { ref_table = card, align = "m", colour = G.C.RED, r = 0.05, padding = 0.03, res = 0.15 },
				nodes = {
					{ n = G.UIT.T, config = { text = 'X', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 } },
					{ n = G.UIT.O, config = { object = DynaText({ string = r_mults, colours = { G.C.UI.TEXT_LIGHT }, pop_in_rate = 9999999, silent = true, random_element = true, pop_delay = 0.5, scale = 0.32, min_cycle_time = 0 }) } },
				}
			},
            {
                n = G.UIT.O,
                config = {
                    object = DynaText({
                        string = {
                            { string = 'rand()', colour = G.C.JOKER_GREY }, { string = "#@" .. (G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards].base.id or 11) .. (G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards].base.suit:sub(1, 1) or 'D'), colour = G.C.RED },
                            loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult,
                            loc_mult, loc_mult, loc_mult, loc_mult },
                        colours = { G.C.UI.TEXT_DARK },
                        pop_in_rate = 9999999,
                        silent = true,
                        random_element = true,
                        pop_delay = 0.2011,
                        scale = 0.32,
                        min_cycle_time = 0
                    })
                }
            },
        }
        return { main_start = main_start }
    end,
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            return {
                xmult = pseudorandom('madness_misprint', card.ability.extra.min, card.ability.extra.max)
            }
        end
    end
})

SMODS.Joker:take_ownership('raised_fist', {
    config = { extra = { mult = 3 } },
    loc_vars = function(self, info_queue, card)
		return { card.ability.extra.mult }
	end,
	calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and not context.end_of_round then
            local temp_Mult, temp_ID = 15, 15
            local raised_card = nil
            for i = 1, #G.hand.cards do
                if temp_ID >= G.hand.cards[i].base.id and not SMODS.has_no_rank(G.hand.cards[i]) then
                    temp_Mult = G.hand.cards[i].base.nominal
                    temp_ID = G.hand.cards[i].base.id
                    raised_card = G.hand.cards[i]
                end
            end
            if raised_card == context.other_card then
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED
                    }
                else
                    return {
                        mult = card.ability.extra.mult * temp_Mult
                    }
                end
            end
        end
    end
})

SMODS.Joker:take_ownership('chaos', {
	rarity = 3,
	calculate = function(self, card, context)
		if context.reroll_scaling and not card.debuff then
			context.reroll_increase = 0
		end
	end
})

SMODS.Joker:take_ownership('fibonacci', {
    config = { extra = { odds = 2 } },
	loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'madness_fibonacci')
        return { vars = { numerator, denominator } }
	end,
	calculate = function(self, card, context)
        if 
			context.repetition and context.cardarea == G.play
			and SMODS.pseudorandom_probability(card, 'madness_fibonacci', 1, card.ability.extra.odds)	
            and (
				context.other_card:get_id() == 2 or
                context.other_card:get_id() == 3 or
                context.other_card:get_id() == 5 or
                context.other_card:get_id() == 8 or
                context.other_card:get_id() == 14
			)
		then return {
				repetitions = 1
			}
		end
	end
})

SMODS.Joker:take_ownership('steel_joker', {
    config = { extra = 2 },
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            local steel_tally = 0
            for _, playing_card in ipairs(G.play.cards) do
                if SMODS.has_enhancement(playing_card, 'm_steel') then steel_tally = steel_tally + 1 end
            end
            return {
                Xmult = 1 + card.ability.extra * steel_tally,
            }
        end
    end,
})

SMODS.Joker:take_ownership('scary_face', {
    config = { extra = 50 }
})

SMODS.Joker:take_ownership('abstract', {
	rarity = 2,
    config = { extra = .3 },
	loc_vars = function(self, info_queue, card)
		local joker_count = 0
		if G.jokers then
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i].ability.set == 'Joker' then joker_count = joker_count + 1 end
			end
		end
        return { vars = { card.ability.extra, 1 + card.ability.extra * joker_count } }
	end,
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            local joker_count = 0
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.set == 'Joker' then joker_count = joker_count + 1 end
            end
            return {
                xmult = 1 + card.ability.extra * joker_count
            }
        end
    end
})

SMODS.Joker:take_ownership('delayed_grat', {
    config = { extra = 7 },
})

SMODS.Joker:take_ownership('hack', {
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            if context.other_card:get_id() == 2 or
                context.other_card:get_id() == 3 or
                context.other_card:get_id() == 4 or
                context.other_card:get_id() == 5 or
                context.other_card:get_id() == 6 or
                context.other_card:get_id() == 7 then
                return {
                    repetitions = card.ability.extra
                }
            end
        end
    end
})


SMODS.Joker:take_ownership('gros_michel', {
    config = { extra = { odds = 8 } },
	loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'madness_gros_michel')
		info_queue[#info_queue + 1] = G.P_CENTERS.j_cavendish
		return { vars = {
			numerator, denominator,
			localize {type = 'name_text', key="j_cavendish", set="Joker"}
		} }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			if SMODS.pseudorandom_probability(card, 'madness_gros_michel', 1, card.ability.extra.odds) then 
				SMODS.destroy_cards(card, nil, nil, true)
				local card = SMODS.add_card {
					set = "Joker",
					key = "j_cavendish"
				}
				return {message = localize('k_extinct_ex')}
			else
				return {message = localize('k_safe_ex')}
			end
		end
	end
})

SMODS.Joker:take_ownership('cavendish', {
	rarity = 3,
    config = { extra = { xmult = 7, odds = 1000 } },
	loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'madness_cavendish')
		return { vars = {
			card.ability.extra.xmult,
			numerator, denominator,
		} }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			if SMODS.pseudorandom_probability(card, 'madness_cavendish', 1, card.ability.extra.odds) then 
				SMODS.destroy_cards(card, nil, nil, true)
				return {message = localize('k_extinct_ex')}
			else
				return {message = localize('k_safe_ex')}
			end
		elseif context.joker_main or context.forcetrigger then
			return {xmult = card.ability.extra.xmult}
		end
	end
})

SMODS.Joker:take_ownership('even_steven', {
    config = { extra = 10 }
})

SMODS.Joker:take_ownership('odd_todd', {
    config = { extra = 69 }
})

SMODS.Joker:take_ownership('chaos', {
	rarity = 3,
	calculate = function(self, card, context)
		if context.reroll_scaling then
			context.reroll_increase = 0
		end
	end
})

SMODS.Joker:take_ownership('scholar', {
    config = { extra = { mult = 1.5 } },
	rarity = 2,
	calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 14 then
            return {
                xmult = card.ability.extra.mult,
            }
        end
	end
})

SMODS.Joker:take_ownership('business', {
	rarity = 2,
    config = { extra = 5, p_dollars = 5 },
	loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra, 'business')
        return { vars = { numerator, denominator, card.ability.p_dollars } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            context.other_card:is_face() and
            SMODS.pseudorandom_probability(card, 'business', 1, card.ability.extra) then
            return {
                dollars = card.ability.p_dollars,
            }
        end
    end
})

SMODS.Joker:take_ownership('supernova', {
    loc_vars = function(self, info_queue, card)
        local mult = 0
        if  
            G and G.GAME and G.GAME.current_round and G.GAME.current_round.current_hand 
            and G.GAME.current_round.current_hand.handname
            and G.GAME.hands[G.GAME.current_round.current_hand.handname]
        then
            local hand = G.GAME.current_round.current_hand.handname
            mult = (G.GAME.hands[hand].played + 1) * G.GAME.hands[hand].level
        end
        return { vars = { mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            return {
                mult = G.GAME.hands[context.scoring_name].played * G.GAME.hands[context.scoring_name].level
            }
        end
    end
})

SMODS.Joker:take_ownership('ride_the_bus', {
    rarity = 2,
    config = { extra = { xmult = 1, xmult_gain = 0.25 } },
	loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult_gain, card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local faces = false
            for _, playing_card in ipairs(context.scoring_hand) do
                if playing_card:is_face() then
                    faces = true
                    break
                end
            end
            if faces then
                local last_mult = card.ability.extra.xmult
                card.ability.extra.xmult = 1
                if last_mult > 0 then
                    return {
                        message = localize('k_reset')
                    }
                end
            else
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "xmult",
                    scalar_value = "xmult_gain",
                    no_message = true
                })
            end
        end
        if context.joker_main or context.forcetrigger then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
})

SMODS.Joker:take_ownership('space', {
    loc_vars = function(self, info_queue, card)
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            local eval = function() return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES end
            juice_card_until(card, eval, true)
        end
        if context.before and G.GAME.current_round.hands_played == 0 then
            return {
                level_up = true,
                message = localize('k_level_up_ex')
            }
        end
    end
})


SMODS.Joker:take_ownership('burglar', {
    config = { extra = 3 },
    loc_vars = function(self, info_queue, card)
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            G.E_MANAGER:add_event(Event({
                func = function()
                    ease_discard(math.min(0, 1 - G.GAME.current_round.discards_left), nil, true)
                    ease_hands_played(card.ability.extra)
                    SMODS.calculate_effect(
                        { message = localize { type = 'variable', key = 'a_hands', vars = { card.ability.extra } } },
                        context.blueprint_card or card)
                    return true
                end
            }))
            return nil, true -- This is for Joker retrigger purposes
        end
    end
})

SMODS.Joker:take_ownership('blackboard', {
    config = { extra = 3 },
    loc_vars = function(self, info_queue, card)
    end,
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            local all_black_suits = true
            for _, playing_card in ipairs(context.scoring_hand) do
                if not playing_card:is_suit('Clubs', nil, true) and not playing_card:is_suit('Spades', nil, true) then
                    all_black_suits = false
                    break
                end
            end
            if all_black_suits or context.forcetrigger then
                return {
                    xmult = card.ability.extra
                }
            end
        end
    end
})

SMODS.Joker:take_ownership('runner', {
	config = { extra = { chips = 0, chip_mod = 16 } },
    calculate = function(self, card, context)
        if context.before and not context.blueprint and #G.play.cards < 5 then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "chips",
                scalar_table = card.ability.extra,
                scalar_value = "chip_mod",
                operation = "+",
                no_message = true
            })
        end
        if context.joker_main or context.forcetrigger then
            return {
                chips = card.ability.extra.chips
            }
        end
    end
})

SMODS.Joker:take_ownership('ice_cream', {
	config = { extra = { chips = 250, chip_mod = 25 } },
    calculate = function(self, card, context)
        if context.after and not context.blueprint then
	        if card.ability.extra.chips - card.ability.extra.chip_mod <= 0 then
	            SMODS.destroy_cards(card, nil, nil, true)
	            return {
	                message = localize('k_melted_ex'),
	                colour = G.C.CHIPS
	            }
	        else
	            SMODS.scale_card(card, {
	                ref_table = card.ability.extra,
	                ref_value = "chips",
	                scalar_value = "chip_mod",
	                no_message = true,
	                operation = "-"
	            })
	            return {
	                message = localize { type = 'variable', key = 'a_chips_minus', vars = { card.ability.extra.chip_mod } },
	                colour = G.C.CHIPS
	            }
	        end
        end
        if context.joker_main or context.forcetrigger then
            return {
                chips = card.ability.extra.chips
            }
        end
    end
})

SMODS.Joker:take_ownership('dna', {
    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            local eval = function() return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES end
            juice_card_until(card, eval, true)
        end
        if context.before and G.GAME.current_round.hands_played == 0 and #context.full_hand == 1 then
            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
            local played_card = context.full_hand[1]
            played_card.dna_flag = true
            local card_copied = copy_card(played_card, nil, nil, G.playing_card)
            card_copied:add_to_deck()
            G.deck.config.card_limit = G.deck.config.card_limit + 1
            table.insert(G.playing_cards, card_copied)
            G.hand:emplace(card_copied)
            card_copied.states.visible = nil

            G.E_MANAGER:add_event(Event({
                func = function()
                    card_copied:start_materialize()
					draw_card(G.play, G.hand, 1, 'up', false, played_card)
                    return true
                end
            }))
            return {
                message = localize('k_copied_ex'),
                colour = G.C.CHIPS,
                func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            SMODS.calculate_context({ playing_card_added = true, cards = { card_copied } })
                            return true
                        end
                    }))
                end
            }
        end
    end
})

-- Draw DNA'd cards back to hand after played

G.FUNCS.draw_from_play_to_discard = function(e)
	local play_count = #G.play.cards
	local it = 1
	for k, v in ipairs(G.play.cards) do
	    local was_dna
	    was_dna, v.dna_flag = v.dna_flag, nil
	    if (not v.shattered) and (not v.destroyed) and (not was_dna) then
	        draw_card(G.play,G.discard, it*100/play_count,'down', false, v)
	        it = it + 1
	    end
	end
end

SMODS.Joker:take_ownership('blue_joker', {
	config = { extra = 2 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra, card.ability.extra * ((G.playing_cards and #G.playing_cards) or 52) } }
    end,
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            return {
                chips = card.ability.extra * #G.playing_cards
            }
        end
    end
})

SMODS.Joker:take_ownership('sixth_sense', {
	blueprint_compat = true,
    calculate = function(self, card, context)
        if context.destroy_card and context.cardarea == G.play then
            if context.destroy_card:get_id() == 6 and G.GAME.current_round.hands_played == 0 then
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            SMODS.add_card {
                                set = 'Spectral',
                                key_append = 'sixth_sense' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
                            }
                            G.GAME.consumeable_buffer = 0
                            return true
                        end)
                    }))
                    return {
                        message = localize('k_plus_spectral'),
                        colour = G.C.SECONDARY_SET.Spectral,
                        remove = true
                    }
                end
                return {
                    remove = true
                }
            end
        end
    end
})

SMODS.Joker:take_ownership('hiker', {
    config = { extra = 1 },
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            context.other_card.ability.perma_mult = context.other_card.ability.perma_mult or 0
            SMODS.scale_card(card, {
                ref_table = context.other_card.ability,
                ref_value = "perma_mult",
                scalar_table = card.ability,
                scalar_value = "extra",
                no_message = true,
                operation = "+"
            })
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.MULT
            }
        end
    end
})

SMODS.Joker:take_ownership('faceless', {
    config = { extra = { dollars = 3 } },
    calculate = function(self, card, context)
        if context.discard and context.other_card:is_face() then
            return { dollars = card.ability.extra.dollars }
        end
    end
})

SMODS.Joker:take_ownership('green_joker', {
    config = { extra = { hand_add = 3, discard_sub = 2 } },
    calculate = function(self, card, context)
        if context.pre_discard and not context.blueprint then
            SMODS.scale_card(card, {
                ref_table = card.ability,
                ref_value = "mult",
                scalar_table = card.ability.extra,
                scalar_value = "discard_sub",
                operation = "-",
                no_message = true
            })
            card.ability.mult = math.max(card.ability.mult, 0)
            return {
                message = localize { type = 'variable', key = 'a_mult_minus', vars = { card.ability.extra.discard_sub } }
            }
        end
        if context.before and not context.blueprint then
            SMODS.scale_card(card, {
                ref_table = card.ability,
                ref_value = "mult",
                scalar_table = card.ability.extra,
                scalar_value = "hand_add",
                operation = "+",
                no_message = true
            })
            return {
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.hand_add } }
            }
        end
        if context.joker_main or context.forcetrigger then
            return { mult = card.ability.mult }
        end
    end
})

SMODS.Joker:take_ownership('superposition', {
    rarity = 2,
    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands["Straight"]) and
            #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            local ace_check = false
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:get_id() == 14 then
                    ace_check = true
                    break
                end
            end
            if ace_check then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        SMODS.add_card {
                            set = 'Spectral',
                            key_append = 'superposition' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
                        }
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                return {
                    message = localize('k_plus_spectral'),
                    colour = G.C.SECONDARY_SET.Spectral,
                }
            end
        end
    end
})

SMODS.Joker:take_ownership('todo_list', {
    rarity = 2, 
    config = { extra = { dollars = 4, poker_hand = 'High Card' } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars, localize(card.ability.extra.poker_hand, 'poker_hands') } }
    end,
    calculate = function(self, card, context)
        if context.before and next(context.poker_hands[card.ability.extra.poker_hand]) then
            return {
                dollars = card.ability.extra.dollars
            }
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            local _poker_hands = {}
            for handname, _ in pairs(G.GAME.hands) do
                if SMODS.is_poker_hand_visible(handname) and handname ~= card.ability.extra.poker_hand then
                    _poker_hands[#_poker_hands + 1] = handname
                end
            end
            card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, 'to_do')
            return {
                message = localize('k_reset')
            }
        end
    end,
})

SMODS.Joker:take_ownership('card_sharp', {
    key = "card_sharp",
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    pos = { x = 6, y = 11 },
    config = { extra = { Xmult = 5 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and G.GAME.hands[context.scoring_name] and G.GAME.hands[context.scoring_name].played_this_round > 1 then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end,
})

SMODS.Joker:take_ownership('red_card', {
    rarity = 2,
    config = { extra = { xmult_gain = 0.5, xmult = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult_gain, card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.skipping_booster and not context.blueprint then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "xmult",
                scalar_table = card.ability.extra,
                scalar_value = "xmult_gain",
                operation = "+",
                no_message = true
            })
            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.xmult_gain } },
                colour = G.C.RED,
            }
        end
        if context.joker_main or context.forcetrigger then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,
})

local madness_quips = {
    "mrrp mroaw mrrp :3c",
    "made by one (1) developer",
    "pog baron pog",
    "baron pog baron",
    "* Hey, first off, it's they/them, fuckface.",
    "{C:red,s:0.75}impl {C:attention,s:0.75}Joker {C:red,s:0.75}for {C:blue,s:0.75}jokers{C:inactive,s:0.75}::{C:attention,s:0.75}Madness",
    "brought to you by a queer furry with autism",
    "Also try Inkbleed!",
    "Also try BaltsWarehouse!",
    "Also try Hyper's Stuff!",
    "fuck blue stake all my homies hate blue stake",
    "human... i remember you're {C:red,s:0.75}genocides",
    "my brother has a very {C:blue,s:0.75}special attack",
    "this joker is {X:attention,C:white,s:0.75}Pissing{C:inactive,s:0.75} me off",
    "photochad op pls nerf",
    "twitter really puts the cult in cancel culture",
    "ayo hop on balala",
    "rain worl. slugcar <3",
    "remember to check on your friends",
    "remember to set boundaries",
    "remember to drink water",
    "sina ken toki e toki pona la sina pona",
    "acab 8647",
    "fuck terfs all my homies hate terfs",
    "transmisogyny and transmisandry hurt everyone",
    "docta pebba",
    "the creator of this mod has over {C:attention,s:0.75}$400{C:inactive,s:0.75} in rain world merch",
    "what do you MEAN 2017 was " .. tostring(math.floor((os.time() - 1514786399) / 31536000)) .. " years ago",
    "sudo rm -rf /boot",
    "eval {C:blue,s:0.75}G{C:inactive,s:0.75}.{C:blue,s:0.75}GAME{C:inactive,s:0.75}.{C:blue,s:0.75}dollars{C:inactive,s:0.75} = {C:attention,s:0.75}math{C:inactive,s:0.75}.{C:blue,s:0.75}huge",
    "my fursuit ate my homework",
    "{C:red,s:0.75}char{C:inactive,s:0.75}* {C:blue,s:0.75}t {C:inactive,s:0.75}= {C:green,s:0.75}malloc{C:inactive,s:0.75}({C:attention,s:0.75}1{C:inactive,s:0.75}<<{C:attention,s:0.75}32{C:inactive,s:0.75});",
    "banjo kazyaoi?",
    "big tail never fail",
    "ayo who else on prozac",
    "#staff-furry-rp exists and it's called my dms",
    "it is currently {C:attention,s:0.75}12:10 AM{C:inactive,s:0.75} as of me writing this quote. such is life"
}

local madness_index = 1
function shuffle_quips()
    for i = 1, #madness_quips do
        local j = math.random(1, #madness_quips)
        madness_quips[i], madness_quips[j] = madness_quips[j], madness_quips[i]
    end
end
shuffle_quips()

SMODS.Joker:take_ownership('madness', {
    rarity = 2,
    config = { extra = { xmult_gain = 0.25, xmult = 1 } },
    loc_vars = function(self, info_queue, card)
        local quip = "{C:inactive,s:0.75}" .. madness_quips[madness_index]
        madness_index = madness_index + 1
        if madness_index > #madness_quips then
            madness_index = 1
            shuffle_quips()
        end
 
        local parsed_quip = loc_parse_string(quip)
        return {
            vars = { card.ability.extra.xmult_gain, card.ability.extra.xmult },
            main_end = SMODS.localize_box(parsed_quip, {})
        }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint and not context.blind.boss then
            local d_jokers = {}
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] ~= card and not G.jokers.cards[i].getting_sliced then
                    d_jokers[#d_jokers + 1] =
                        G.jokers.cards[i]
                end
            end
            local joker_to_destroy = pseudorandom_element(d_jokers, 'madness')

            if joker_to_destroy then
                if not SMODS.is_eternal(joker_to_destroy) then
                    joker_to_destroy.getting_sliced = true
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            (context.blueprint_card or card):juice_up(0.8, 0.8)
                            joker_to_destroy:start_dissolve({ G.C.RED }, nil, 1.6)
                            return true
                        end
                    }))
                end
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "xmult",
                    scalar_table = {v = joker_to_destroy.sell_cost * card.ability.extra.xmult_gain},
                    scalar_value = "v",
                    operation = "+",
                    no_message = true
                })
            end
            return { message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.xmult } } }
        end
        if context.joker_main or context.forcetrigger then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,
})

SMODS.Joker:take_ownership('square', {
    config = { extra = { mult = 0, mult_mod = 4 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.mult_mod } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and #context.full_hand == 4 then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "mult",
                scalar_table = card.ability.extra,
                scalar_value = "mult_mod",
                operation = "+",
                no_message = true
            })
        end
        if context.joker_main or context.forcetrigger then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,
})

SMODS.Joker:take_ownership('hologram', {
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            return {
                xmult = card.ability.x_mult
            }
        end
    end
})

SMODS.Joker:take_ownership('seance', {
    config = { extra = { poker_hand = 'Straight' } },
    loc_vars = function(self, info_queue, card)
        return { vars = { localize(card.ability.extra.poker_hand, 'poker_hands') } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands[card.ability.extra.poker_hand]) then
            local card_index_1 = math.random(1, #G.play.cards)
            local card_index_2 = math.random(1, #G.play.cards - 1)
            if card_index_2 >= card_index_1 then card_index_2 = card_index_2 + 1 end

            G.play.cards[card_index_1]:set_edition('e_negative', true)
            G.play.cards[card_index_2]:set_edition('e_negative', true)
        end
    end,
})

SMODS.Joker:take_ownership('riff_raff', {
    calculate = function(self, card, context)
        if context.setting_blind and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
            local jokers_to_create = G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer)
            G.GAME.joker_buffer = G.GAME.joker_buffer + jokers_to_create
            G.E_MANAGER:add_event(Event({
                func = function()
                    for _ = 1, jokers_to_create do
                        SMODS.add_card {
                            set = 'Joker',
                            rarity = 'Common',
                            key_append = 'riff_raff'
                        }
                        G.GAME.joker_buffer = 0
                    end
                    return true
                end
            }))
            return {
                message = localize('k_plus_joker'),
                colour = G.C.BLUE,
            }
        end
    end,
})

SMODS.Joker:take_ownership('vampire', {
    config = { extra = 0.25, xmult = 1 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra, card.ability.xmult } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local enhanced = {}
            for _, scored_card in ipairs(context.scoring_hand) do
                if next(SMODS.get_enhancements(scored_card)) and not scored_card.debuff and not scored_card.vampired then
                    enhanced[#enhanced + 1] = scored_card
                    scored_card.vampired = true
                    scored_card:set_ability('c_base', nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            scored_card:juice_up()
                            scored_card.vampired = nil
                            return true
                        end
                    }))
                end
            end

            if #enhanced > 0 then
                SMODS.scale_card(card, {
                    ref_table = card.ability,
                    ref_value = "xmult",
                    scalar_table = {v=card.ability.extra * #enhanced},
                    scalar_value = "v",
                    operation = "+",
                    no_message = true
                })
            end
        end
        if context.joker_main or context.forcetrigger then
            return {
                xmult = card.ability.xmult
            }
        end
    end,
})

SMODS.Joker:take_ownership('vagabond', {
    config = { extra = 10 },
    calculate = function(self, card, context)
        if context.joker_main and
            #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            if to_big(G.GAME.dollars) <= to_big(card.ability.extra) then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        SMODS.add_card {
                            set = 'Tarot',
                            key_append = 'vagabond'
                        }
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                return {
                    message = localize('k_plus_tarot'),
                }
            end
        end
    end,
})

SMODS.Joker:take_ownership('baron', {
    config = { extra = 2 },
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and not context.end_of_round and context.other_card:get_id() == 13 then
            if context.other_card.debuff then
                return {
                    message = localize('k_debuffed'),
                    colour = G.C.RED
                }
            else
                return {
                    x_mult = card.ability.extra
                }
            end
        end
    end,
})

SMODS.Joker:take_ownership('cloud_9', {
    config = { extra = 2 },
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 9 or context.forcetrigger then
            return { dollars = card.ability.extra }
        end
    end,
})

SMODS.Joker:take_ownership('rocket', {
    config = { extra = { dollars = 1, increase = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars, card.ability.extra.increase } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval or context.forcetrigger then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "dollars",
                scalar_table = card.ability.extra,
                scalar_value = "increase",
                operation = "+",
                no_message = true
            })
        end
    end,
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.dollars
    end
})

SMODS.Joker:take_ownership('obelisk', {
    config = { extra = { Xmult_gain = 0.5, Xmult = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult_gain, card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local reset = true
            local play_more_than = (G.GAME.hands[context.scoring_name].played or 0)
            for handname, values in pairs(G.GAME.hands) do
                if handname ~= context.scoring_name and values.played >= play_more_than and SMODS.is_poker_hand_visible(handname) then
                    reset = false
                    break
                end
            end
            if reset then
                if card.ability.extra.Xmult > 1 then
                    card.ability.extra.Xmult = 1
                    G.GAME.chips = 0
                    return {
                        message = localize('k_reset')
                    }
                end
            else
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "Xmult",
                    scalar_table = card.ability.extra,
                    scalar_value = "Xmult_gain",
                    operation = "+",
                    no_message = true
                })
            end
        end
        if context.joker_main or context.forcetrigger then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end,
})

SMODS.Joker:take_ownership('midas_mask', {
    config = { extra = { odds = 2 } },
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds,
            'midas_mask')
        return { vars = { numerator, denominator } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local cards = 0
            for _, scored_card in ipairs(context.scoring_hand) do
                if not scored_card.midas_flag then
                    scored_card.midas_flag = true
                    if SMODS.pseudorandom_probability(card, 'midas_mask', 1, card.ability.extra.odds) then
                        cards = cards + 1
                        scored_card:set_ability('m_gold', nil, true)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                scored_card:juice_up()
                                return true
                            end
                        }))
                    end
                end
            end
            if cards > 0 then
                return {
                    message = localize('k_gold'),
                    colour = G.C.MONEY
                }
            end
        end
        if context.joker_main then
            for i, card in ipairs(G.playing_cards) do
                card.midas_flag = nil
            end
        end
    end
})

SMODS.Joker:take_ownership('photograph', {
    config = { extra = 1.5 },
    rarity = 2,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_face() or context.forcetrigger then
            return {
                xmult = card.ability.extra
            }
        end
    end
})

SMODS.Joker:take_ownership('gift', {
    config = { extra = 3 }
})

SMODS.Joker:take_ownership('turtle_bean', {
    config = { extra = { h_size = 10, h_mod = 2 } },
    add_to_deck = function(self, card, from_debuff)
        G.hand:change_size(card.ability.extra.h_size)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.h_size)
    end
})

SMODS.Joker:take_ownership('erosion', {
    config = { extra = { Xmult_gain = 0.25, Xmult = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult_gain, card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.remove_playing_cards and not context.blueprint then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "Xmult",
                scalar_table = {v=card.ability.extra.Xmult_gain * #context.removed},
                scalar_value = "v",
                operation = "+",
            })
        end
        if context.joker_main or context.forcetrigger then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end,
})

SMODS.Joker:take_ownership('reserved_parking', {
    config = { extra = { dollars = 3 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and not context.end_of_round then
            if context.other_card:is_face() then
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED
                    }
                else
                    G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
                    return {
                        dollars = card.ability.extra.dollars,
                        func = function()
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    G.GAME.dollar_buffer = 0
                                    return true
                                end
                            }))
                        end
                    }
                end
            end
        end
    end
})

SMODS.Joker:take_ownership('to_the_moon', {
    config = { extra = { dollars = 1, per = 5 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars, card.ability.extra.per, card.ability.extra.dollars * math.floor(G.GAME.dollars / card.ability.extra.per) } }
    end,
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.dollars * math.floor(G.GAME.dollars / card.ability.extra.per)
    end
})

SMODS.Joker:take_ownership('hallucination', {
    demicolon_compat = true,
    calculate = function(self, card, context)
        if context.open_booster and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit or context.forcetrigger then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = (function()
                    SMODS.add_card {
                        set = 'Tarot',
                        key_append = 'hallucination' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
                    }
                    G.GAME.consumeable_buffer = 0
                    return true
                end)
            }))
            return {
                message = localize('k_plus_tarot'),
                colour = G.C.PURPLE,
            }
        end
    end
})

SMODS.Joker:take_ownership('fortune_teller', {
    config = { extra = 3 },
    demicolon_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra, card.ability.extra * (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.tarot or 0) } }
    end,
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            return { 
                mult = card.ability.extra *
                    (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.tarot or 0)
            }
        end
    end
})

SMODS.Joker:take_ownership('juggler', {
    config = { extra = 1 },
    demicolon_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra } }
    end,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.setting_blind or context.forcetrigger then
            G.GAME.current_round.hsize_remove = (G.GAME.current_round.hsize_remove or 0) + card.ability.extra
            G.hand:change_size(card.ability.extra)
            return { message = localize { type = 'variable', key = 'a_handsize', vars = { card.ability.extra } } }, true
        end
        if context.end_of_round and context.cardarea == G.jokers then
            return { 
                message = localize { type = 'variable', key = 'a_handsize_minus', vars = { card.ability.extra } }
            }
        end
    end
})

SMODS.Joker:take_ownership('drunkard', {
    config = { extra = 1 },
    blueprint_compat = true,
    demicolon_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra } }
    end,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.setting_blind or context.forcetrigger then   
            ease_discard(card.ability.extra)
            return { message = localize { type = 'variable', key = 'a_discards', vars = { card.ability.extra } } }, true
        end
    end
})

SMODS.Joker:take_ownership('stone', {
    rarity = 1,
    config = { extra = 50 },
    demicolon_compat = true,
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            local stone_tally = 0
            for _, playing_card in ipairs(G.playing_cards) do
                if SMODS.has_enhancement(playing_card, 'm_stone') then stone_tally = stone_tally + 1 end
            end
            return {
                chips = card.ability.extra * stone_tally
            }
        end
    end,
})

SMODS.Joker:take_ownership('golden', {
    config = { extra = 10 },
    demicolon_compat = true,
    calculate = function(self, card, context)
        if context.forcetrigger then
            return {
                dollars = card.ability.extra
            }
        end
    end
})

SMODS.Joker:take_ownership('lucky_cat', {
    config = { extra = 0.5 },
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.x_mult
            }
        end
    end
})

SMODS.Joker:take_ownership('baseball', {
    rarity = 2,
    config = { extra = 2 },
    calculate = function(self, card, context)
        if context.other_joker and (context.other_joker.config.center.rarity == 2 or context.other_joker.config.center.rarity == "Uncommon") then
            return {
                xmult = card.ability.extra
            }
        end
    end,
})

SMODS.Joker:take_ownership('bull', {
    rarity = 1,
    config = { extra = 5 },
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            return {
                chips = card.ability.extra * G.GAME.dollars
            }
        end
    end
})

SMODS.Joker:take_ownership('flash', {
    config = { extra = 3 },
    loc_vars = function(self, info_queue, card)
        G.GAME.reroll_tally = G.GAME.reroll_tally or 0
        return { vars = { card.ability.extra, card.ability.extra * G.GAME.reroll_tally } }
    end,
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            return {
                mult = card.ability.extra * (G.GAME.reroll_tally or 0)
            }
        end
    end
})

SMODS.Joker:take_ownership('popcorn', {
    config = { extra = 5, mult = 50 },
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            return { mult = card.ability.mult }
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if card.ability.mult - card.ability.extra <= 0 then
                SMODS.destroy_cards(card, nil, nil, true)
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.RED
                }
            else
                SMODS.scale_card(card, {
                    ref_table = card.ability,
                    ref_value = "mult",
                    scalar_table = card.ability,
                    scalar_value = "extra",
                    operation = "-",
                    no_message = true
                })
                return {
                    message = localize { type = 'variable', key = 'a_mult_minus', vars = { card.ability.extra } },
                    colour = G.C.MULT
                }
            end
        end
    end
})

SMODS.Joker:take_ownership('trousers', {
    blueprint_compat = true,
    config = { extra = 3, mult = 0 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra, localize('Pair', 'poker_hands'), card.ability.mult } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and (next(context.poker_hands['Pair']) or next(context.poker_hands['Full House'])) then
            SMODS.scale_card(card, {
                ref_table = card.ability,
                ref_value = "mult",
                scalar_table = card.ability,
                scalar_value = "extra",
                operation = "+",
            })
        end
        if context.joker_main or context.forcetrigger then
            return {
                mult = card.ability.mult
            }
        end
    end
})

SMODS.Joker:take_ownership('ancient', {
    config = { extra = 2 },
    loc_vars = function(self, info_queue, card)
        local suit = (G.GAME.current_round.ancient_card or {}).suit or 'Spades'
        return { vars = { card.ability.extra, localize(suit, 'suits_singular'), colours = { G.C.SUITS[suit] } } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_suit(G.GAME.current_round.ancient_card.suit) or context.forcetrigger then
            return {
                xmult = card.ability.extra
            }
        end
    end
})

SMODS.Joker:take_ownership('ramen', {
    config = { extra = 0.02, x_mult=2 },
    calculate = function(self, card, context)
        if context.pre_discard and not context.blueprint then
            if card.ability.x_mult - card.ability.extra <= 0 then
                SMODS.destroy_cards(card, nil, nil, true)
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.CHIPS
                }
            else
                SMODS.scale_card(card, {
                    ref_table = card.ability,
                    ref_value = "x_mult",
                    scalar_table = card.ability,
                    scalar_value = "extra",
                    operation = "-",
                    no_message = true,
                    colour = G.C.RED
                })
                return {
                    message = localize { type = 'variable', key = 'a_xmult_minus', vars = { card.ability.extra } }
                }
            end
        end
        if context.joker_main or context.forcetrigger then
            return {
                xmult = card.ability.x_mult,
            }
        end
    end
})

SMODS.Joker:take_ownership('castle', {
    rarity = 1,
    config = { extra = 5, h_chips = 0 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra, card.ability.h_chips } }
    end,
    calculate = function(self, card, context)
        if context.discard and not context.blueprint then
            SMODS.scale_card(card, {
                ref_table = card.ability,
                ref_value = "h_chips",
                scalar_table = card.ability,
                scalar_value = "extra",
                operation = "+"
            })
        end
        if context.joker_main or context.forcetrigger then
            return {
                chips = card.ability.h_chips,
            }
        end
    end
})

SMODS.Joker:take_ownership('walkie_talkie', {
    cost = 5,
    rarity = 2,
    config = { extra = 4, h_chips = 10 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.h_chips, card.ability.extra } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            (context.other_card:get_id() == 10 or context.other_card:get_id() == 4) then
            return {
                chips = card.ability.h_chips,
                dollars = card.ability.extra
            }
        end
    end
})

SMODS.Joker:take_ownership('smiley', {
    config = { extra = 10 },
})

SMODS.Joker:take_ownership('campfire', {
    config = { x_mult = 1, extra = 0.25 },
    calculate = function(self, card, context)
        if context.selling_card and not context.blueprint then
            SMODS.scale_card(card, {
                ref_table = card.ability,
                ref_value = "x_mult",
                scalar_table = {v=card.ability.extra * context.card.sell_cost},
                scalar_value = "v",
                operation = "+",
            })
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if context.beat_boss and card.ability.x_mult > 1 then
                card.ability.x_mult = 1
                return {
                    message = localize('k_reset'),
                    colour = G.C.RED
                }
            end
        end
        if context.joker_main then
            return {
                xmult = card.ability.x_mult
            }
        end
    end
})

SMODS.Joker:take_ownership('ticket', {
    rarity = 2,
    calculate = function(self, card, context)
        if
            context.repetition and context.cardarea == G.hand and SMODS.has_enhancement(context.other_card, 'm_gold') then
            return {
                repetitions = 1
            }
        end
    end
})

SMODS.Joker:take_ownership('mr_bones', {
    config = { extra = 10 },
    loc_vars = function(self, info_queue, voucher)
        table.insert(info_queue, { set = "Tag", key = "tag_coupon" })
        table.insert(info_queue, { set = "Tag", key = "tag_d_six" })
        return {vars = {
            voucher.ability.extra,
            localize{type = 'name_text', key="tag_coupon", set="Tag"},
            localize{type = 'name_text', key="tag_d_six", set="Tag"},
            localize{type = 'name_text', key="v_warehouse_1up", set="Voucher"}
        }}
    end,
    calculate = function(self, card, context)
        if context.check_return_to_shop and context.game_over then
            ease_dollars(card.ability.extra)
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.hand_text_area.blind_chips:juice_up()
                    G.hand_text_area.game_chips:juice_up()
                    play_sound('tarot1')
                    delay(0.4)
                    add_tag(Tag('tag_coupon'))
                    add_tag(Tag('tag_d_six'))
                    play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                    card:start_dissolve()
                    return true
                end
            }))
            return {
                return_to_shop = true,
                message = localize('k_saved_ex'),
                colour = G.C.RED
            }
        end
    end
})

SMODS.Joker:take_ownership('swashbuckler', {
    config = { extra = 1 },
    loc_vars = function(self, info_queue, card)
        local sell_cost = 0
        for _, joker in ipairs(G.jokers and G.jokers.cards or {}) do
            sell_cost = sell_cost + joker.sell_cost
        end
        for _, consumeable in ipairs(G.consumeables and G.consumeables.cards or {}) do
            sell_cost = sell_cost + consumeable.sell_cost
        end
        return { vars = { card.ability.extra * sell_cost } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local sell_cost = 0
            for _, joker in ipairs(G.jokers and G.jokers.cards or {}) do
                sell_cost = sell_cost + joker.sell_cost
            end
            for _, consumeable in ipairs(G.consumeables and G.consumeables.cards or {}) do
                sell_cost = sell_cost + consumeable.sell_cost
            end
            return {
                mult = card.ability.extra * sell_cost
            }
        end
    end,
})

SMODS.Joker:take_ownership('acrobat', {
    rarity = 2,
    config = { x_mult = 3 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.x_mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            return {
                x_mult = card.ability.x_mult
            }
        end
    end
})

SMODS.Joker:take_ownership('troubadour', {
    config = { extra = { h_size = 1, h_plays = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.h_size, card.ability.extra.h_plays } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.h_plays
        G.hand:change_size(card.ability.extra.h_size)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.h_plays
        G.hand:change_size(-card.ability.extra.h_size)
    end,
})

SMODS.Joker:take_ownership('certificate', {
    key = "certificate",
    unlocked = false,
    demicolon_compat = false,
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    pos = { x = 8, y = 8 },
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            local eval = function() return G.GAME.current_round.discards_used == 0 and not G.RESET_JIGGLES end
            juice_card_until(card, eval, true)
        end
        if context.pre_discard and not context.blueprint and
            G.GAME.current_round.discards_used <= 0 and #context.full_hand == 1
        then
            local discarded_card = context.full_hand[1]
            discarded_card.seal = SMODS.poll_seal({ guaranteed = true, type_key = 'certificate_seal' })
            play_sound('tarot1')
            discarded_card:juice_up(0.3, 0.5)
            delay(0.6)
        end
    end,
    check_for_unlock = function(self, args) -- equivalent to `unlock_condition = { type = 'double_gold' }`
        return args.type == 'double_gold'
    end
})

SMODS.Joker:take_ownership('smeared', {
    rarity = 3,
    calculate = function(self, card, context)
        if context.setting_blind and
            context.blind.debuff and
            context.blind.debuff.suit
        then
            G.E_MANAGER:add_event(Event({
                func = function()
                    if G.STATE ~= G.STATES.SELECTING_HAND then return false end
                    SMODS.calculate_effect({ message = localize('ph_boss_disabled') }, card)
                    G.GAME.blind:disable()
                    return true
                end,
                blocking = false
            }))
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if
            G.GAME.blind and G.GAME.blind.boss 
            and not G.GAME.blind.disabled and
            G.GAME.blind.debuff and
            G.GAME.blind.debuff.suit
        then
            G.GAME.blind:disable()
            play_sound('timpani')
            SMODS.calculate_effect({ message = localize('ph_boss_disabled') }, card)
        end
    end
})

SMODS.Joker:take_ownership('throwback', {
    config = { extra = 0.75 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra, 1 + G.GAME.skips * card.ability.extra } }
    end,
    calculate = function(self, card, context)
        if context.skip_blind and not context.blueprint then
            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { 1 + G.GAME.skips * card.ability.extra } }
            }
        end
        if context.joker_main or context.forcetrigger then
            return {
                xmult = 1 + G.GAME.skips * card.ability.extra
            }
        end
    end,
})

SMODS.Joker:take_ownership('bloodstone', {
    config = { x_mult = 2 },
    loc_vars = function(self, info_queue, card)
        return { vars = { nil, nil, card.ability.x_mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_suit("Hearts") then
            return {
                xmult = card.ability.x_mult
            }
        end
    end
})

SMODS.Joker:take_ownership('arrowhead', {
    config = { h_chips = 100 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.h_chips } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_suit("Spades") then
            return {
                chips = card.ability.h_chips
            }
        end
    end
})

SMODS.Joker:take_ownership('onyx_agate', {
    config = { mult = 15 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_suit("Clubs") then
            return {
                mult = card.ability.mult
            }
        end
    end
})

SMODS.Joker:take_ownership('rough_gem', {
    config = { extra = 4 },
})

SMODS.Joker:take_ownership('flower_pot', {
    config = { x_mult = 5 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.x_mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            local suits = {
                ['Hearts'] = false,
                ['Diamonds'] = false,
                ['Spades'] = false,
                ['Clubs'] = false
            }
            for suit, _ in pairs(suits) do 
                for i = 1, #context.scoring_hand do
                    if context.scoring_hand[i]:is_suit(suit, true) then
                        suits[suit] = true
                        break
                    end
                end
            end
            if suits["Hearts"] and suits["Diamonds"] and suits["Spades"] and suits["Clubs"] or context.forcetrigger then
                return {
                    xmult = card.ability.x_mult
                }
            end
        end
        if context.modify_scoring_hand then
            local suits = {
                ['Hearts'] = false,
                ['Diamonds'] = false,
                ['Spades'] = false,
                ['Clubs'] = false
            }
            for suit, _ in pairs(suits) do 
                for i = 1, #context.scoring_hand do
                    if context.scoring_hand[i]:is_suit(suit, true) then
                        suits[suit] = true
                        break
                    end
                end
            end
            local activate = suits["Hearts"] and suits["Diamonds"] and suits["Spades"] and suits["Clubs"]
            if activate and not card.active then
                card.active = true
                local eval = function() return
                    G.STATE == G.STATES.SELECTING_HAND 
                    and card.active
                    and not G.RESET_JIGGLES
                end
                juice_card_until(card, eval, true)
            elseif not activate then
                card.active = false
            end
        end
    end,
})

SMODS.Joker:take_ownership('glass', {
    config = { extra = 1, x_mult = 1 },
    calculate = function(self, card, context)
        if context.remove_playing_cards and not context.blueprint then
            local glass_cards = 0
            for _, removed_card in ipairs(context.removed) do
                if SMODS.has_enhancement(removed_card, "m_glass") then glass_cards = glass_cards + 1 end
            end
            if glass_cards > 0 then
                SMODS.scale_card(card, {
                    ref_table = card.ability,
                    ref_value = "x_mult",
                    scalar_table = {v=card.ability.extra * glass_cards},
                    scalar_value = "v",
                    operation = "+",
                    no_message = true
                })
                SMODS.calculate_effect({
                    message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.x_mult } }
                }, card)
                return nil, true
            end
        end
        if context.joker_main or context.forcetrigger then
            return {
                xmult = card.ability.x_mult
            }
        end
    end
})

SMODS.Joker:take_ownership('seeing_double', {
    loc_vars = function(self, info_queue, card)
        return { vars = { localize("ph_4_7_of_clubs") } }
    end,
    calculate = function(self, card, context)
        if (context.before and context.cardarea == G.jokers) or context.forcetrigger then
            local card_tally = 0
            for _, card in ipairs(context.scoring_hand) do
                if card:is_suit("Clubs") and card.base.id == 7 then
                    card_tally = card_tally + 1
                end
            end
            if card_tally >= 4 or context.forcetrigger then
                G.E_MANAGER:add_event(Event{func = function() SMODS.add_card {
                    set = 'Spectral',
                    key_append = 'seeing_double',
                    edition = 'e_negative'
                } return true end})
                return {
                    message = localize('k_plus_spectral'),
                    colour = G.C.DARK_EDITION,
                }
            end
        end
        if context.modify_scoring_hand then
            local card_tally = 0
            for _, card in ipairs(context.scoring_hand) do
                if card:is_suit("Clubs") and card.base.id == 7 then
                    card_tally = card_tally + 1
                end
            end
            local activate = card_tally >= 4
            if activate and not card.active then
                card.active = true
                local eval = function() return
                    G.STATE == G.STATES.SELECTING_HAND 
                    and card.active
                    and not G.RESET_JIGGLES
                end
                juice_card_until(card, eval, true)
            elseif not activate then
                card.active = false
            end
        end
    end
})


SMODS.Joker:take_ownership('matador', {
    config = { p_dollars = 5, extra = 'madness_matador' },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.p_dollars}}
    end,
    calculate = function(self, card, context)
        if context.madness_debuff then
            return {dollars = card.ability.p_dollars}
        end
    end
})

local _card_eval_status_text = card_eval_status_text
function card_eval_status_text(card, text, ...)
    local res = _card_eval_status_text(card, text, ...)
    if text == 'debuff' then
        for i, jok in ipairs(G.jokers.cards) do
            local effects = eval_card(jok, {madness_debuff = true})
            if effects.jokers then
                SMODS.calculate_effect(effects.jokers, jok)
            end
        end
    end
    return res
end

SMODS.Joker:take_ownership('hit_the_road', {
    config = { extra = 0.25, x_mult = 1 },
    calculate = function(self, card, context)
        if context.discard and context.other_card.base.id == 11 then
            SMODS.scale_card(card, {
                ref_table = card.ability,
                ref_value = 'x_mult',
                scalar_table = card.ability,
                scalar_value = 'extra',
                operation = '+'
            })
        end
        if context.joker_main then
            return { x_mult = card.ability.x_mult }
        end
    end
})

SMODS.Joker:take_ownership('satellite', {
    config = { extra = 1 },
    calculate = function(self, card, context)
        if context.joker_main then 
            local planets_used = 0
            for k, v in pairs(G.GAME.consumeable_usage) do
                if v.set == 'Planet' then planets_used = planets_used + 1 end
            end
            return { dollars = planets_used > 0 and planets_used * card.ability.extra or nil }
        end
    end
})

SMODS.Joker:take_ownership('drivers_license', {
    config = { x_mult = 10, extra = 16 },
    loc_vars = function(self, info_queue, card)
        local driver_tally = 0
        for _, playing_card in pairs(G.playing_cards or {}) do
            if
                next(SMODS.get_enhancements(playing_card))
                or playing_card.edition
                or playing_card.ability.seal
            then driver_tally = driver_tally + 1 end
        end
        return { vars = { card.ability.x_mult, card.ability.extra, driver_tally } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local driver_tally = 0
            for _, playing_card in pairs(G.playing_cards) do
                if 
                    next(SMODS.get_enhancements(playing_card))
                    or playing_card.edition
                    or playing_card.ability.seal
                then driver_tally = driver_tally + 1 end
            end
            if driver_tally >= card.ability.extra then
                return {
                    xmult = card.ability.x_mult
                }
            end
        end
    end,
})

local rep_hand_calc = function(self, card, context)
    if context.repetition and context.cardarea == G.play and context.scoring_name == card.ability.extra.type then
        return { repetitions = 1 }
    end
end

local rep_hand_loc = function(self, info_queue, card)
    return { vars = { localize(card.ability.extra.type, 'poker_hands') } }
end

SMODS.Joker:take_ownership('duo', { rarity = 2, config = { extra = { type = 'Pair' } }, calculate = rep_hand_calc, loc_vars = rep_hand_loc })
SMODS.Joker:take_ownership('trio', { rarity = 2, config = { extra = { type = 'Three of a Kind' } }, calculate = rep_hand_calc, loc_vars = rep_hand_loc })
SMODS.Joker:take_ownership('family', { rarity = 2, config = { extra = { type = 'Four of a Kind' } }, calculate = rep_hand_calc, loc_vars = rep_hand_loc })
SMODS.Joker:take_ownership('order', { rarity = 2, config = { extra = { type = 'Straight' } }, calculate = rep_hand_calc, loc_vars = rep_hand_loc })
SMODS.Joker:take_ownership('tribe', { rarity = 2, config = { extra = { type = 'Flush' } }, calculate = rep_hand_calc, loc_vars = rep_hand_loc })

SMODS.Joker:take_ownership('stuntman', {
    config = { extra = { chip_mod = 500, h_size = 3 } },
    calculate = function(self, card, context)
        if context.joker_main then
            return { chips = card.ability.extra.chip_mod }
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.h_size)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(card.ability.extra.h_size)
    end
})

SMODS.Joker:take_ownership('invisible', {
    calculate = function(self, card, context)
        if context.selling_self then
            local jokers = {}
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] ~= card then
                    jokers[#jokers + 1] = G.jokers.cards[i]
                end
            end
            if #jokers > 0 then
                if #G.jokers.cards <= G.jokers.config.card_limit then
                    local chosen_joker = pseudorandom_element(jokers, 'invisible')
                    local copied_joker = copy_card(chosen_joker)
                    copied_joker:add_to_deck()
                    G.jokers:emplace(copied_joker)
                    return { message = localize('k_duplicated_ex') }
                else
                    return { message = localize('k_no_room_ex') }
                end
            else
                return { message = localize('k_no_other_jokers') }
            end
        end
    end,
})

SMODS.Joker:take_ownership('bootstraps', {
    config = { extra = { dollars = 3, mult = 3 } },
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                 mult = card.ability.extra.mult *
                    math.floor(((G.GAME.dollars or 0) + (G.GAME.dollar_buffer or 0)) / card.ability.extra.dollars)
            }
        end
    end,
})

SMODS.Joker:take_ownership('constellation', { 
    config = { extra = 0.25 },
    calculate = function(self, card, context) if context.joker_main then return {xmult = card.ability.x_mult} end end
} )


-- Fix these getting yote by lovely patch

SMODS.Joker:take_ownership('stencil', {
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            return {
                xmult = math.max(1,
                    (G.jokers.config.card_limit - #G.jokers.cards) + #SMODS.find_card("j_stencil", true))
            }
        end
    end
}, true)

SMODS.Joker:take_ownership('mail', {
    calculate = function(self, card, context)
        if context.discard and not context.other_card.debuff and
            context.other_card:get_id() == G.GAME.current_round.mail_card.id then
            return {
                dollars = card.ability.extra,
            }
        end
    end,
}, true)

SMODS.Joker:take_ownership('oops', {
	add_to_deck = function(self, card)
		for k, v in pairs(G.GAME.probabilities) do 
			G.GAME.probabilities[k] = v*2
		end
	end,
	remove_from_deck = function(self, card)
		for k, v in pairs(G.GAME.probabilities) do 
			G.GAME.probabilities[k] = v/2
		end
	end
}, true)

SMODS.Joker:take_ownership('cartomancer', {
    calculate = function(self, card, context)
        if context.setting_blind and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = (function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            SMODS.add_card {
                                set = 'Tarot',
                                key_append = 'cartomancer'
                            }
                            G.GAME.consumeable_buffer = 0
                            return true
                        end
                    }))
                    SMODS.calculate_effect({ message = localize('k_plus_tarot'), colour = G.C.PURPLE },
                        context.blueprint_card or card)
                    return true
                end)
            }))
            return nil, true
        end
    end
}, true)

SMODS.Joker:take_ownership('caino', {
    calculate = function(self, card, context)
        if context.remove_playing_cards and context.scoring_hand and not context.blueprint then
            for i, c in ipairs(context.removed) do
                if c:is_face() then
                    SMODS.scale_card(card, {
                        ref_table = card.ability,
                        ref_value = "caino_xmult",
                        scalar_table = card.ability,
                        scalar_value = "x_mult",
                        operation = "+",
                        no_message = true
                    })
                    return {
                        message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.caino_xmult } },
                        colour = G.C.RED
                    }
                end
            end
        end
        if context.joker_main or context.forcetrigger then return {xmult = card.ability.caino_xmult} end
    end
}, true)

SMODS.Joker:take_ownership('yorick', {
    calculate = function(self, card, context)
        if context.discard and not context.blueprint then
            if card.ability.yorick_discards <= 1 then
                card.ability.yorick_discards = card.ability.extra.discards
                SMODS.scale_card(card, {
                    ref_table = card.ability,
                    ref_value = "x_mult",
                    scalar_table = card.ability.extra,
                    scalar_value = "xmult",
                    operation = "+",
                    no_message = true
                })
                return {
                    message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.x_mult } },
                    colour = G.C.RED
                }
            else
                card.ability.yorick_discards = card.ability.yorick_discards - 1
                return nil, true -- This is for Joker retrigger purposes
            end
        end
        if context.joker_main then
            return {
                xmult = card.ability.x_mult
            }
        end
    end
}, true)

SMODS.Joker:take_ownership('chicot', {
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint and context.blind.boss then
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.GAME.blind:disable()
                            play_sound('timpani')
                            delay(0.4)
                            return true
                        end
                    }))
                    SMODS.calculate_effect({ message = localize('ph_boss_disabled') }, card)
                    return true
                end
            }))
            return nil, true -- This is for Joker retrigger purposes
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if G.GAME.blind and G.GAME.blind.boss and not G.GAME.blind.disabled then
            G.GAME.blind:disable()
            play_sound('timpani')
            SMODS.calculate_effect({ message = localize('ph_boss_disabled') }, card)
        end
    end
}, true)

SMODS.Joker:take_ownership('trading', {
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            local eval = function() return G.GAME.current_round.discards_used == 0 and not G.RESET_JIGGLES end
            juice_card_until(card, eval, true)
        end
        if context.discard and not context.blueprint and
            G.GAME.current_round.discards_used <= 0 and #context.full_hand == 1 then
            return {
                dollars = card.ability.extra,
                remove = true
            }
        end
    end
}, true)

SMODS.Joker:take_ownership('wee', {
    config = { extra = { chips = 0, chip_mod = 20 } },
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
            }
        end
    end
})

SMODS.Joker:take_ownership('idol', {
    config = { extra = 3 },
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            context.other_card:get_id() == G.GAME.current_round.idol_card.id and
            context.other_card:is_suit(G.GAME.current_round.idol_card.suit) then
            return {
                xmult = card.ability.extra
            }
        end
    end,
})