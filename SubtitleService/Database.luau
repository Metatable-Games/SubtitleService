-- Copyright (c) 2024 RAMPAGE Interactive. All rights reserved.
-- Copyright (c) 2024 Metatable Games. All rights reserved.
-- Written by vq9o <business@vq9o.com>

--[[
    
["SKULL_BLACKBEARD_INTRO_C"] = {
        {
            POINT = 0.1,
            CONTENT = "AAAAAAAAAA"
        };
    };
]]

-- Never start at 0, use 0.1

return {
	AUDIO = {
		["SKULL_BLACKBEARD_INTRO_A"] = "rbxassetid://17366199838",
	},
	SUBS = {
		["SKULL_BLACKBEARD_INTRO_A"] = {
			{
				POINT = 0.1,
				CONTENT = "Ahoy there! Welcome to Trader's Treasure Trove, the heart of Skull Island!",
			},
			{
				POINT = 6,
				CONTENT = "I be Captain Blackbeard, yer guide on this grand adventure.",
			},
			{
				POINT = 11,
				CONTENT = "Before we set sail, let's go over the basics of navigation and plunderin'.",
			},
		},
	},
}
