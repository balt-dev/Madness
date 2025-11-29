local blind_amt = get_blind_amount
function get_blind_amount(ante)
	if to_big(ante) <= to_big(8) then ante = to_number(ante) end
	return blind_amt(target_ante)
end
local blind_amt = get_blind_amount

MADNESS.orig_get_blind_amount = blind_amt

function get_blind_amount(ante)
	G.GAME.overscoring_ante = G.GAME.overscoring_ante or 0
	local target_ante = ante + G.GAME.overscoring_ante
	local res = blind_amt(target_ante)
	return res
end

function get_inverse_blind_amount(raw_score)
	G.GAME.overscoring_ante = G.GAME.overscoring_ante or 0
	raw_score = to_big(raw_score)
	local score = to_big(raw_score) / to_big(blind_amt(8))
	if score < to_big(1) then
		for i = 0, 8 do
			if raw_score < blind_amt(i + G.GAME.overscoring_ante) then return to_big(i - 1) end
		end
	end
	if score < to_big(2.3) then
		return math.floor(1.148 * (math.log(score) ^ 0.752)) + 8
	elseif score < to_big(50) then
		return math.floor(1.728 * (math.log(score) ^ 0.458) - 0.595) + 8
	elseif score < to_big(1e6) then
		return math.floor(1.877 * (math.log(score) ^ 0.4235) - 0.701) + 8
	elseif score < to_big(1e20) then
		return math.floor(1.688 * (math.log(score) ^ 0.433) - 0.386) + 8
	else
		return math.floor(1.0205 * math.sqrt(10 * math.log(score) / math.log(math.log(score))) - 2.425) + 8
	end
end

function MADNESS.ease_overscoring(mod, instant)
    local function _mod(mod)
        local overscore_UI = G.HUD:get_UIE_by_ID('madness_overscoring_dyna')
        mod = mod or 0
        local text = '+'
        local col = G.C.GREEN
        if to_big(mod) < to_big(0) then
            text = '-'
            col = G.C.RED              
        end
        G.GAME.overscoring_ante = G.GAME.overscoring_ante + mod
        overscore_UI.config.object:update()
        G.HUD:recalculate()
        attention_text({
          text = text..tostring(math.abs(mod)),
          scale = 0.6, 
          hold = 0.7,
          cover = overscore_UI.parent,
          cover_colour = col,
          align = 'cm',
      	})
		play_sound('highlight2', 0.685, 0.2)
		play_sound('generic1')
    end
    if instant then
        _mod(mod)
    else
        G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            _mod(mod)
            return true
        end
        }))
    end
end

function MADNESS.overscoring_hook(scored_chips)
	if not MADNESS.config.overscoring then return end
	local target_ante = get_inverse_blind_amount(scored_chips)
	local effective_ante = G.GAME.round_resets.ante + G.GAME.overscoring_ante
	local overscore_ante = effective_ante + MADNESS.config.overscore_threshold
	if to_big(target_ante) >= to_big(overscore_ante) then
		MADNESS.ease_overscoring(to_big(target_ante) - to_big(effective_ante))
	end
end