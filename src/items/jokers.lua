SMODS.Joker:take_ownership(
	'joker', {
		config = {mult = 10}, 
		calculate = function(self, card, context)
			if context.joker_main then
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
            ref_value = "mult",
            scalar_table = card.ability.extra,
            scalar_value = "s_mult",
            operation = "+",
            no_message = true
        })
    end
    if context.joker_main then
        return {
            mult = card.ability.extra.mult
        }
    end
end

local suit_joker_loc = function(self, info_queue, card)
    return { vars = { card.ability.extra.s_mult, localize(card.ability.extra.suit, 'suits_singular'), card.ability.extra.mult} }
end

SMODS.Joker:take_ownership('greedy_joker',
    {
        rarity = 2,
		config = { extra = { s_mult = 2, mult = 0, suit = 'Diamonds' }, },
        loc_vars = suit_joker_loc,
        calculate = suit_joker_calc
    }
)

SMODS.Joker:take_ownership('lusty_joker',
    {
        rarity = 2,
		config = { extra = { s_mult = 2, mult = 0, suit = 'Hearts' }, },
        loc_vars = suit_joker_loc,
        calculate = suit_joker_calc
    }
)

SMODS.Joker:take_ownership('gluttenous_joker',
    {
        rarity = 2,
		config = { extra = { s_mult = 2, mult = 0, suit = 'Clubs' }, },
        loc_vars = suit_joker_loc,
        calculate = suit_joker_calc
    }
)

SMODS.Joker:take_ownership('wrathful_joker',
    {
        rarity = 2,
		config = { extra = { s_mult = 2, mult = 0, suit = 'Spades' }, },
        loc_vars = suit_joker_loc,
        calculate = suit_joker_calc
    }
)

-- Poker hand jokers

local mult_loc_vars = function(self, info_queue, card) return { vars = { card.ability.extra.t_mult, localize(card.ability.extra.type, 'poker_hands') } } end
local mult_calc = function(self, card, context)
	if context.joker_main and next(context.poker_hands[card.ability.extra.type]) then
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
	if context.joker_main and next(context.poker_hands[card.ability.extra.type]) then
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
                    return true
                end)
            }))
			return { message = localize "k_activated", colour = G.C.GREEN}
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
        if context.joker_main then
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
        if context.joker_main then
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
				G.E_MANAGER:add_event(Event({
					func = function()
						discarded_card:juice_up()
						return true
					end
				}))
            end
			return {
				message = localize('k_activated'),
				colour = G.C.ATTENTION
			}
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
        if context.joker_main then
            card.ability.extra.loyalty_remaining = (card.ability.extra.every - 1 - (G.GAME.hands_played - card.ability.hands_played_at_create)) %
                (card.ability.extra.every + 1)
            if not context.blueprint then
                if card.ability.extra.loyalty_remaining == 0 then
                    local eval = function(card) return card.ability.extra.loyalty_remaining == 0 and not G.RESET_JIGGLES end
                    juice_card_until(card, eval, true)
                end
            end
            if card.ability.extra.loyalty_remaining == card.ability.extra.every then
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
        if context.joker_main then
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
		if context.reroll_scaling then
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
    config = { extra = 1 },
    calculate = function(self, card, context)
        if context.joker_main then
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
        if context.joker_main then
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
    config = { extra = { xmult = 15, odds = 1000 } },
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
		elseif context.joker_main then
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
    config = { extra = { odds = 5, dollars = 15 } },
	loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'vremade_business')
        return { vars = { numerator, denominator, card.ability.extra.dollars } }
    end,
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
        if context.joker_main then
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
        if context.joker_main then
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
        if context.joker_main then
            local all_black_suits = true
            for _, playing_card in ipairs(context.scoring_hand) do
                if not playing_card:is_suit('Clubs', nil, true) and not playing_card:is_suit('Spades', nil, true) then
                    all_black_suits = false
                    break
                end
            end
            if all_black_suits then
                return {
                    xmult = card.ability.extra
                }
            end
        end
    end
})

SMODS.Joker:take_ownership('runner', {
	config = { extra = { chips = 0, chip_mod = 20 } },
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
        if context.joker_main then
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
        if context.joker_main then
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
        if context.joker_main then
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
        if context.joker_main then
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
    config = { extra = { xmult_gain = 0.1, xmult = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult_gain, card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.skipping_booster and not context.blueprint then
            SMODS.scale_card(card, {
                ref_table = card.ability,
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
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,
})

local madness_quips = {
    ":3c",
    "made by one (1) developer",
    "pog baron pog",
    "* Hey, first off, it's they/them, fuckface.",
    "impl Joker for jokers::Madness",
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
    "eval G.GAME.dollars = math.huge"
}

local madness_index = 1

SMODS.Joker:take_ownership('madness', {
    rarity = 2,
    config = { extra = { xmult_gain = 0.25, xmult = 1 } },
    loc_vars = function(self, info_queue, card)
        local quip = "{C:inactive,s:0.75}" .. madness_quips[madness_index]
        madness_index = (madness_index % #madness_quips) + 1 
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
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,
})

SMODS.Joker:take_ownership('square', {
    config = { extra = { chips = 0, chip_mod = 16 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.chip_mod } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and #context.full_hand == 4 then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "chips",
                scalar_table = card.ability.extra,
                scalar_value = "chip_mod",
                operation = "+",
                no_message = true
            })
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
    end,
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
        if context.joker_main then
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
            if G.GAME.dollars <= card.ability.extra then -- See note about Talisman compatibility on the wiki
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        SMODS.add_card {
                            set = 'Tarot',
                            key_append = 'vagabond' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
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
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 9 then
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
        if context.end_of_round and context.game_over == false and context.main_eval  then
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
        if context.joker_main then
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
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_face() then
            return {
                xmult = card.ability.extra
            }
        end
    end
})

SMODS.Joker:take_ownership('gift_card', {
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_face() then
            return {
                xmult = card.ability.extra
            }
        end
    end
})


-- Fix these getting yote by lovely patch

SMODS.Joker:take_ownership('stencil', {
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = math.max(1,
                    (G.jokers.config.card_limit - #G.jokers.cards) + #SMODS.find_card("j_stencil", true))
            }
        end
    end
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
