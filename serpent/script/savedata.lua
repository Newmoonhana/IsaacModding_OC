local json = require("json")

local defaultSaveData = 
{
	debug_text = "None SaveData",
	hasCostume_deadcat = { hasCostume = false }, -- serpent, tserpent
	dice_table = { 1, 2, 3, 4, 5, 6, 7, 8 } -- rngesus
}

function mod:WriteData()
	defaultSaveData.debug_text = "IsSaving!"

	defaultSaveData.dice_table = Rngesus.dice_table

	local jsonstr = json.encode(defaultSaveData)
	mod:SaveData(jsonstr)
end

function mod:ReadData()
	if mod:HasData() then
		defaultSaveData = json.decode(mod:LoadData())
		if mod.debug == true then
			Isaac.DebugString("[Serpent]: SaveData Load Debug - "..(defaultSaveData.debug_text))
		end

		Rngesus.dice_table = defaultSaveData.dice_table
	end
end

function mod:PreGameExit(Curses)
	mod:WriteData()
	return Curses
end
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.PreGameExit)

function mod:PostGameStarted(isContinued)
	if isContinued then
		mod:ReadData()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.PostGameStarted)