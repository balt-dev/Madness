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

SMODS.Joker:take_ownership('greedy_joker',
    {
		config = { extra = { s_mult = 2, mult = 0, suit = 'Diamonds' }, },
		loc_vars = function(self, info_queue, card)
			return { vars = { card.ability.extra.s_mult, localize(card.ability.extra.suit, 'suits_singular'), card.ability.extra.mult} }
		end,
		calculate = function(self, card, context)
			if context.individual and context.cardarea == G.play and
				context.other_card:is_suit(card.ability.extra.suit) then
				card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.s_mult
				return {message = localize("k_upgrade_ex"), message_card = card}
			end
			if context.joker_main then
				return {
					mult = card.ability.extra.mult
				}
			end
		end
    }
)

SMODS.Joker:take_ownership('lusty_joker',
    {
		config = { extra = { s_mult = 2, mult = 0, suit = 'Hearts' }, },
		loc_vars = function(self, info_queue, card)
			return { vars = { card.ability.extra.s_mult, localize(card.ability.extra.suit, 'suits_singular'), card.ability.extra.mult} }
		end,
		calculate = function(self, card, context)
			if context.individual and context.cardarea == G.play and
				context.other_card:is_suit(card.ability.extra.suit) then
				card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.s_mult
				return {message = localize("k_upgrade_ex"), message_card = card}
			end
			if context.joker_main then
				return {
					mult = card.ability.extra.mult
				}
			end
		end
    }
)

SMODS.Joker:take_ownership('gluttenous_joker',
    {
		config = { extra = { s_mult = 2, mult = 0, suit = 'Clubs' }, },
		loc_vars = function(self, info_queue, card)
			return { vars = { card.ability.extra.s_mult, localize(card.ability.extra.suit, 'suits_singular'), card.ability.extra.mult} }
		end,
		calculate = function(self, card, context)
			if context.individual and context.cardarea == G.play and
				context.other_card:is_suit(card.ability.extra.suit) then
				card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.s_mult
				return {message = localize("k_upgrade_ex"), message_card = card}
			end
			if context.joker_main then
				return {
					mult = card.ability.extra.mult
				}
			end
		end
    }
)

SMODS.Joker:take_ownership('wrathful_joker',
    {
		config = { extra = { s_mult = 2, mult = 0, suit = 'Spades' }, },
		loc_vars = function(self, info_queue, card)
			return { vars = { card.ability.extra.s_mult, localize(card.ability.extra.suit, 'suits_singular'), card.ability.extra.mult} }
		end,
		calculate = function(self, card, context)
			if context.individual and context.cardarea == G.play and
				context.other_card:is_suit(card.ability.extra.suit) then
				card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.s_mult
				return {message = localize("k_upgrade_ex"), message_card = card}
			end
			if context.joker_main then
				return {
					mult = card.ability.extra.mult
				}
			end
		end
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

-- Half Joker

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
        return { vars = { numerator, denominator, localize{type = 'name_text', key="tag_coupon", set="Tag"} } }
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
    config = { extra = 3 },
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
		elseif context.joker_main then
			return { mult = card.ability.extra.mult }
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

--[[ SMODS.Joker:take_ownership('supernova', {
    what do i do?
}) ]]

SMODS.Joker:take_ownership('ride_the_bus', {
    rarity = 2,
    config = { extra = { xmult = 1, xmult_gain = 0.1 } },
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
                card.ability.extra.xmult = card.ability.extra.mult + card.ability.extra.mult_gain
            end
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
})


-- Fix this getting yote by lovely patch

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