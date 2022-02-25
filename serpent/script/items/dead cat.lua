DEADCAT = {}

-- 변수
local BG = Isaac.GetMusicIdByName("CatInTheBox")
SoundEffect.CatInTheBox = Isaac.GetSoundIdByName("CatInTheBox")
DEADCAT.COSTUME = Isaac.GetCostumeIdByPath("gfx/characters/cb_serpent.anm2")
DEADCAT.COSTUME_HAIR = Isaac.GetCostumeIdByPath("gfx/characters/cb_serpenthair.anm2")
hasCostume = false

-- 아이템
DEADCAT.id = 81

function DEADCAT:onUpdate()
	if hasCostume then
		if MusicManager():GetCurrentMusicID() ~= BG and
		(mod.room:GetType() == RoomType.ROOM_NULL or
		mod.room:GetType() == RoomType.ROOM_DEFAULT or
		mod.room:GetType() == RoomType.ROOM_DUNGEON or
		mod.room:GetType() == RoomType.ROOM_BOSSRUSH or
		mod.room:GetType() == RoomType.ROOM_SACRIFICE) then
			MusicManager():Play(BG, 0)
			MusicManager():UpdateVolume()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, DEADCAT.onUpdate)

function DEADCAT:GetDeadCat(player, hasCostume_deadcat)
	if (Serpent:IsPlayerSerpent(player) or TSerpent:IsPlayerTSerpent(player)) then -- 서펀트의 경우
		if player:HasCollectible(DEADCAT.id) and not hasCostume_deadcat.hasCostume then
			hasCostume_deadcat.hasCostume = true
			hasCostume = true
			
			player:TryRemoveNullCostume( DEADCAT.COSTUME )
			player:TryRemoveNullCostume( DEADCAT.COSTUME_HAIR )
			player:AddNullCostume(DEADCAT.COSTUME)
			player:AddNullCostume(DEADCAT.COSTUME_HAIR)

			MusicManager():Play(BG, 0)
			MusicManager():UpdateVolume()
			mod.game:GetHUD():ShowFortuneText('Cat in the box!')
			mod.SFX:Play(SoundEffect.CatInTheBox)
		end
	end
end


function mod:GetShaderParams(shaderName)
    if shaderName == 'RandomColors' then
		if hasCostume == true then
			return { R = 2, G = 0.5, B = 0 }
		else
			return { R = 1, G = 1, B = 1 }
		end
    end
end
mod:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, mod.GetShaderParams)

function mod:PostGameStarted(isContinued)
	if isContinued == false then
		hasCostume = false
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.PostGameStarted)