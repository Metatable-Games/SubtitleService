-- Copyright (c) 2024 RAMPAGE Interactive. All rights reserved.
-- Copyright (c) 2024 Metatable Games. All rights reserved.
-- Written by vq9o <business@vq9o.com>

local Class = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextService = game:GetService("TextService")

local PreloadService = require(script.Parent:WaitForChild("PreloadService"))
local Database = require(script:WaitForChild("Database"))
local BulkFade = require(ReplicatedStorage.Knight.Objects.BulkFade)

export type void = nil
export type Callable = () -> void
export type VoicelineId = string
export type VoicelineSub = {
	POINT: number,
	CONTENT: string,
}

local function formatString(chance: number): string
	local formatted = string.format("%.3f", chance)
	formatted = formatted:gsub("%.?0+$", "")
	return formatted
end

local function countWords(str)
	local count = 0
	local inWord = false

	for char in str:gmatch("%S+") do
		count = count + 1
	end

	return count
end

function Class.preload(List: { VoicelineId }, OnReady: Callable): void
	local AudioList = {}

	for i, v: VoicelineId in pairs(List) do
		local Audio = Instance.new("Sound")
		Audio.SoundId = Database.AUDIO[v]
		table.insert(AudioList, Audio)
	end

	PreloadService.new(AudioList, function()
		for i, v in pairs(AudioList) do
			v:Destroy()
		end

		OnReady()
	end)
end

function Class.display(DisplayContents: string, WPM: string | nil)
	if WPM == nil then
		WPM = DisplayContents
	end

	local Subtitle = ReplicatedStorage.Assets.UI.Subtitle:Clone()
	Subtitle.Label.Text = DisplayContents

	local textBounds = TextService:GetTextSize(
		DisplayContents,
		Subtitle.Label.TextSize,
		Enum.Font.Fondamento,
		Vector2.new(Subtitle.Label.AbsoluteSize.X, Subtitle.Label.AbsoluteSize.Y)
	)

	-- -300
	Subtitle.Size = UDim2.new(0, textBounds.X + 20, 0.25, 0)

	local Group = BulkFade.CreateGroup(Subtitle:GetChildren(), TweenInfo.new(0))

	Group:FadeOut(TweenInfo.new(0))
	Subtitle.Parent = Players.LocalPlayer.PlayerGui.Cinematic.Sub
	Group:FadeIn(TweenInfo.new(0.5))

	-- avg wpm is 40, artifically set low wpm due it being too fast.
	task.delay(countWords(WPM) / 3, function()
		Group:FadeOut(TweenInfo.new(1))
		task.wait(1)
		Subtitle:Destroy()
	end)
end

function Class.play(CharacterName: string, VoicelineId: VoicelineId): boolean
	local Audio: Sound = Instance.new("Sound")
	Audio.SoundId = Database.AUDIO[VoicelineId]
	Audio.Volume = 1
	Audio.Parent = Players.LocalPlayer.PlayerGui.Cinematic
	Audio:Play()

	local AudioIsReady = false
	PreloadService.new({ Audio }, function()
		AudioIsReady = true
	end)

	repeat
		task.wait()
	until AudioIsReady

	local success = 0
	local Lines = Database.SUBS[VoicelineId]
	local timeProgress = 0

	while Audio.IsPlaying do
		task.wait(0.1)
		timeProgress += 0.1
		timeProgress = tonumber(formatString(timeProgress))

		for _, subtitleData in ipairs(Lines) do
			if subtitleData.POINT == timeProgress then
				Class.display(string.format("[%s]: %s", CharacterName, subtitleData.CONTENT))
				success += 1
				break
			end
		end

		if not Audio.IsPlaying then
			break
		end
	end

	Audio:Destroy()

	return true
end

return Class
