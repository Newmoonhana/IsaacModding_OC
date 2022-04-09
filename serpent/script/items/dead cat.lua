DEADCAT = {}

-- ����
local BG = Isaac.GetMusicIdByName("CatInTheBox")
SoundEffect.CatInTheBox = Isaac.GetSoundIdByName("CatInTheBox")
DEADCAT.COSTUME = Isaac.GetCostumeIdByPath("gfx/characters/cb_serpent.anm2")
DEADCAT.COSTUME_HAIR = Isaac.GetCostumeIdByPath("gfx/characters/cb_serpenthair.anm2")
hasCostume = false

-- ������
DEADCAT.id = 81

function DEADCAT:onUpdate()
	if hasCostume then
		if mod.Music:GetCurrentMusicID() ~= BG and
		(mod.room:GetType() == RoomType.ROOM_NULL or
		mod.room:GetType() == RoomType.ROOM_DEFAULT or
		mod.room:GetType() == RoomType.ROOM_DUNGEON or
		mod.room:GetType() == RoomType.ROOM_BOSSRUSH or
		mod.room:GetType() == RoomType.ROOM_SACRIFICE) then
			mod.Music:Play(BG, 0)
			mod.Music:UpdateVolume()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, DEADCAT.onUpdate)

function DEADCAT:GetDeadCat(player, hasCostume_deadcat)
	if (Serpent:IsPlayerSerpent(player) or TSerpent:IsPlayerTSerpent(player)) then -- ����Ʈ�� ���
		if player:HasCollectible(DEADCAT.id) and not hasCostume_deadcat.hasCostume then
			hasCostume_deadcat.hasCostume = true
			hasCostume = true
			EFFECT.ColorShader = true
			
			player:TryRemoveNullCostume( DEADCAT.COSTUME )
			player:TryRemoveNullCostume( DEADCAT.COSTUME_HAIR )
			player:AddNullCostume(DEADCAT.COSTUME)
			player:AddNullCostume(DEADCAT.COSTUME_HAIR)
			player:AnimateSad();

			-- ����Ʈ�� ���� ����� ���� �� ���� �ݰ�
			player.Damage = player.Damage * 0.5
			player.ShotSpeed = player.ShotSpeed * 0.5
			player.TearHeight = player.TearHeight * 0.5
			player.TearFallingSpeed = player.TearFallingSpeed * 0.5
			player.MoveSpeed = player.MoveSpeed * 0.5
			player.Luck = player.Luck * 0.5

			mod.Music:Play(BG, 0)
			mod.Music:UpdateVolume()
				mod.game:GetHUD():ShowFortuneText('Cat in the box!')
			mod.SFX:Play(SoundEffect.CatInTheBox)
		end
	end
end

function DEADCAT:PostGameStarted(isContinued)
	if isContinued == false then
		hasCostume = false
		EFFECT.ColorShader = false
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, DEADCAT.PostGameStarted)