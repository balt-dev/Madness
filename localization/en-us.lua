return {
    descriptions={
        Joker={
            j_wrathful_joker={
                name="Wrathful Joker",
                text={
                    "Gains {C:mult}+#1#{} Mult",
                    "when played card with",
					"{C:spades}#2#{} suit is scored",
                    "{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)",
                },
            },
            j_lusty_joker={
                name="Lusty Joker",
                text={
                    "Gains {C:mult}+#1#{} Mult",
                    "when played card with",
					"{C:hearts}#2#{} suit is scored",
                    "{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)",
                },
            },
            j_greedy_joker={
                name="Greedy Joker",
                text={
                    "Gains {C:mult}+#1#{} Mult",
                    "when played card with",
					"{C:diamonds}#2#{} suit is scored",
                    "{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)",
                },
            },
            j_gluttenous_joker={
                name="Gluttonous Joker",
                text={
                    "Gains {C:mult}+#1#{} Mult",
                    "when played card with",
					"{C:clubs}#2#{} suit is scored",
                    "{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)",
                },
            },
            j_half={
                name="Half Joker",
                text={
                    "{X:mult,C:white}X#1#{} Mult if played",
                    "hand contains",
                    "{C:attention}#2#{} or fewer cards",
                },
            },
            j_credit_card={
                name="Credit Card",
                text={
                    "{C:green}#1# in #2#{} chance to",
                    "create a {C:attention}#3#{}",
                    "at end of round",
                },
            },
            j_ceremonial={
                name="Ceremonial Dagger",
                text={
                    "When {C:attention}Blind{} is selected,",
                    "destroy Joker to the right",
                    "and permanently add {C:attention}X#1#",
                    "its sell value to this {C:red}Mult",
                    "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
                },
            },
            j_banner={
                name="Banner",
                text={
                    "{C:mult}+#1#{} Mult for",
                    "each remaining",
                    "{C:attention}discard",
                },
            },
            j_mystic_summit={
                name="Mystic Summit",
                text={
                    "{X:mult,C:white}X#1#{} Mult when",
                    "{C:attention}#2#{} discards",
                    "remaining",
                },
            },
            j_marble={
                name="Marble Joker",
                text={
                    "If {C:attention}first discard{} of round",
                    "has only {C:attention}#1#{} card,",
                    "turn card into a {C:attention}#2#{}",
                },
            },
            j_raised_fist={
                name="Raised Fist",
                text={
                    "Adds {C:attention}X#1#{} the rank",
                    "of {C:attention}lowest{} ranked card",
                    "held in hand to Mult",
                },
            },
            j_chaos={
                name="Chaos the Clown",
                text={
                    "{C:green}Rerolls{} no longer",
                    "scale their {C:attention}cost"
                },
            },
            j_fibonacci={
                name="Fibonacci",
                text={
                    "{C:green}#1# in #2#{} chance to retrigger",
                    "played cards with rank",
                    "{C:attention}Ace{}, {C:attention}2{}, {C:attention}3{}, {C:attention}5{}, or {C:attention}8{}",
                },
            },
            j_steel_joker={
                name="Steel Joker",
                text={
                    "Gains {X:mult,C:white} X#1# {} Mult",
                    "for each {C:attention}Steel Card",
                    "in the {C:attention}played hand",
                },
            },
            j_abstract={
                name="Abstract Joker",
                text={
                    "Gains {X:mult,C:white}X#1#{} Mult for",
                    "each {C:attention}Joker{} card",
                    "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
                },
            },
            j_hack={
                name="Hack",
                text={
                    "Retrigger each played",
                    "{C:attention}2{}, {C:attention}3{}, {C:attention}4{}, {C:attention}5{}, {C:attention}6{}, or {C:attention}7{}",
                },
            },
            j_gros_michel={
                name="Gros Michel",
                text={
                    "{C:green}#1# in #2#{} chance this card",
                    "is {C:attention}replaced{} by a {C:attention}#3#{}",
                    "at the end of the round"
                },
            },
            j_scholar={
                name="Scholar",
                text={
                    "Played {C:attention}Aces{}",
                    "give {X:mult,C:white}X#1#{} Mult",
                    "when scored",
                },
            },
            j_business={
                name="Business Card",
                text={
                    "Played {C:attention}face{} cards have",
                    "a {C:green}#1# in #2#{} chance to",
                    "give {C:money}$#3#{} when scored",
                },
            },
            j_supernova = {
                name = "Supernova",
                text = {
                    "Adds the number of times",
                    "played {C:attention}poker hand{} has been",
                    "played, times its {C:attention}level{}, to {C:red}Mult",
                    "{C:inactive}(Currently {C:red}+#1#{C:inactive} Mult)",
                },
            },
            j_ride_the_bus={
                name="Ride the Bus",
                text={
                    "This Joker gains {X:mult,C:white}X#1#{} Mult",
                    "per {C:attention}consecutive{} hand",
                    "played without a",
                    "scoring {C:attention}face{} card",
                    "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
                },
            },
            j_space={
                name="Space Joker",
                text={
                    "Upgrade the level of",
                    "the first {C:attention}played",
                    "poker hand each round",
                },
            },
            j_burglar={
                name="Burglar",
                text={
                    "When {C:attention}Blind{} is selected,",
                    "gain {C:blue}+#1#{} Hands and",
                    "{C:attention}lose all but one discard",
                },
            },
            j_blackboard={
                name="Blackboard",
                text={
                    "{X:red,C:white} X#1# {} Mult if",
                    "all scoring cards",
                    "are {C:spades}#2#{} or {C:clubs}#3#{}",
                },
            },
            j_runner={
                name="Runner",
                text={
                    "Gains {C:chips}+#2#{} Chips",
                    "if played hand has",
                    "less than {C:attention}five cards{}",
                    "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)",
                },
            },
            j_runner={
                name="Runner",
                text={
                    "Gains {C:chips}+#2#{} Chips",
                    "if played hand has",
                    "less than {C:attention}five cards{}",
                    "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)",
                },
            },
            j_dna={
                name="DNA",
                text={
                    "If {C:attention}first hand{} of round",
                    "has only {C:attention}1{} card,",
                    "add a permanent copy to deck",
                    "and draw both cards to {C:attention}hand",
                },
            },
            j_blue_joker={
                name="Blue Joker",
                text={
                    "{C:chips}+#1#{} Chips for each",
                    "card in your {C:attention}full deck",
                    "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
                },
            },
            j_sixth_sense = {
                name = "Sixth Sense",
                text = {
                    "If {C:attention}first hand{} of round has",
                    "any {C:attention}6{}'es, destroy each one and",
                    "create a {C:spectral}Spectral{} card for each",
                    "{C:inactive}(Must have room)",
                },
            },
            j_hiker = {
                name = "Hiker",
                text = {
                    "Every played {C:attention}card{}",
                    "permanently gains",
                    "{C:mult}+#1#{} Mult when scored",
                },
            },
            j_faceless = {
                name = "Faceless Joker",
                text = {
                    "Earn {C:attention}$#1#{} when",
                    "discarding a {C:attention}face card",
                },
            },
            j_superposition = {
                name = "Superposition",
                text = {
                    "Create a {C:spectral}Spectral{} card if",
                    "poker hand contains an",
                    "{C:attention}Ace{} and a {C:attention}Straight{}",
                    "{C:inactive}(Must have room)",
                },
            },
            j_todo_list={
                name="To Do List",
                text={
                    "Earn {C:money}$#1#{} if {C:attention}poker hand{}",
                    "contains a {C:attention}#2#{},",
                    "poker hand changes",
                    "at end of round",
                },
            },
            j_red_card={
                name="Red Card",
                text={
                    "This Joker gains",
                    "{X:red,C:white}X#1#{} Mult when any",
                    "{C:attention}Booster Pack{} is skipped",
                    "{C:inactive}(Currently {X:red,C:white}X#2#{C:inactive} Mult)",
                },
            },
            j_madness={
                name="Madness",
                text={
                    "When {C:attention}Small Blind{} or {C:attention}Big Blind{}",
                    "is selected, {C:attention}destroy{} a random Joker",
                    "and gain {C:attention}X#1#{} its sell value as {X:mult,C:white} XMult {} ",
                    "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
                },
            },
            j_square={
                name="Square Joker",
                text={
                    "This Joker gains {C:chips}+#2#{} Chips",
                    "if played hand has",
                    "exactly {C:attention}4{} cards",
                    "{C:inactive}(Currently {C:chips}#1#{C:inactive} Chips)",
                },
            },
            j_seance={
                name="Séance",
                text={
                    "If {C:attention}poker hand{} is a",
                    "{C:attention}#1#{}, turn two random",
                    "played cards {C:dark_edition}Negative{}",
                },
            },
            j_riff_raff={
                name="Riff-Raff",
                text={
                    "When {C:attention}Blind{} is selected,",
                    "fill all empty {C:attention}Joker{} slots",
                    "with {C:blue}Common{C:attention} Jokers",
                },
            },
            j_cloud_9={
                name="Cloud 9",
                text={
                    "Each played {C:attention}9{} gives",
                    "{C:attention}$#1#{} when scored",
                },
            },
            j_rocket={
                name="Rocket",
                text={
                    "Earn {C:money}$#1#{} at end of round",
                    "Payout increases by {C:money}$#2#{}",
                    "when {C:attention}Blind{} is defeated",
                },
            },
            j_obelisk={
                name="Obelisk",
                text={
                    "This Joker gains {X:mult,C:white} X#1# {} Mult per hand played",
                    "Reset {C:red}XMult{} and {C:attention}round score{}",
                    "when playing most played {C:attention}poker hand",
                    "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
                },
            },
            j_midas_mask = {
                name = "Midas Mask",
                text = {
                    "Played cards",
                    "have a {C:green}#1# in #2#{} chance",
                    "to become {C:attention}Gold{} cards",
                    "when scored",
                },
            },  
            j_photograph = {
                name = "Photograph",
                text = {
                    "Played {C:attention}face{} cards",
                    "give {X:mult,C:white} X#1# {} Mult",
                    "when scored",
                },
            },
            j_erosion = {
                name = "Erosion",
                text = {
                    "This Joker gains {X:mult,C:white} X#1# {} Mult",
                    "every time a {C:attention}playing card{}",
                    "is removed from your deck",
                    "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
                },
            },
            j_reserved_parking = {
                name = "Reserved Parking",
                text = {
                    "Each {C:attention}face{} card",
                    "held in hand",
                    "gives {C:money}$#1#{}",
                },
            },
            j_to_the_moon = {
                name = "To The Moon",
                text = {
                    "At end of round,",
                    "earn {C:money}$#1#{} for every",
                    "{C:money}$#2#{} you have",
                    "{C:inactive}(Currently {C:money}$#3#{C:inactive})",
                },
            },
            j_hallucination = {
                name = "Hallucination",
                text = {
                    "Create a {C:tarot}Tarot{} card when",
                    "any {C:attention}Booster Pack{} is opened",
                    "{C:inactive}(Must have room)",
                },
            },
            j_juggler = {
                name = "Juggler",
                text = {
                    "Gain {C:attention}+#1#{} temporary hand size",
                    "when {C:attention}Blind{} is selected",
                },
            },
            j_drunkard = {
                name = "Drunkard",
                text = {
                    "Gain {C:red}+#1#{} discard",
                    "when {C:attention}Blind{} is selected",
                },
            },
            j_flash = {
                name = "Flash Card",
                text = {
                    "This Joker gains {C:mult}+#1#{} Mult",
                    "per {C:attention}reroll{} done in",
                    "the shop this run",
                    "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
                },
            },
        }
    },
    misc={
        dictionary={
			k_activated="Activated!",
            madness_overscoring="Overscoring",
            k_madness_overscoring="Overscore Ante",
            ph_madness_overscore="Overscore:",
            madness_overscore_threshold="Overscore Threshold"
        },
        v_dictionary = {
            a_discards="+#1# Discards",
            a_discards_minus="-#1# Discards",
            madness_overscoring_explain = {
                "If scoring goes above the base Blind requirement",
                "of #1# Antes after the current Ante,",
                "add the difference to the Overscoring Ante.",
                "The next Ante will have a base Blind requirement",
                "larger than the score that triggered overscoring.",
                "This is best used with other mods that add",
                "more unbalanced additions to the game."
            }
        }
    },
}
