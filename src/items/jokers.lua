SMODS.Joker:take_ownership('joker', {config = {mult = 10}})

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
                chips = G.GAME.current_round.discards_left * card.ability.extra.mult
            }
        end
	end
})
