MADNESS.config_tab = function()
	local overscoring_toggle = create_toggle {
		label = localize("madness_overscoring"),
		ref_table = MADNESS.config,
		ref_value = "overscoring"
	}
	overscoring_toggle.config.tooltip = { text = localize("madness_overscoring_explain") }

	return {
		n=G.UIT.ROOT,
		config = {align = "cm", padding = 0.05, r = 0.1, minw=8, minh=6, colour = G.C.BLACK}, 
		nodes = {
			{
				n=G.UIT.C,
				config = {align = "cm", colour = G.C.TRANSPARENT},
				nodes = {overscoring_toggle}
			}
		}
	}
end
