DEADCAT = {}

-- ������
DEADCAT.id = 81
DEADCAT.COSTUME = Isaac.GetCostumeIdByPath("gfx/characters/deadcat.anm2")
DEADCAT.COSTUME_HAIR = Isaac.GetCostumeIdByPath("gfx/characters/deadcathair.anm2")

-- �÷��̾� ������
function DEADCAT:PostPlayerInit(player)
	if (Serpent:IsPlayerSerpent(player) or TSerpent:IsPlayerTSerpent(player)) then -- ��Ʈ ����Ʈ�� ���
		if player:HasCollectible(DEADCAT.id) and hasCostume_deadcat.hasCostume then
			player:AddNullCostume(DEADCAT.COSTUME)
			player:AddNullCostume(DEADCAT.COSTUME_HAIR)
		end
	end
end
mod:AddCallback( ModCallbacks.MC_POST_PLAYER_INIT, DEADCAT.PostPlayerInit)

function DEADCAT:GetDeadCat(player, hasCostume_deadcat)
	if (Serpent:IsPlayerSerpent(player) or TSerpent:IsPlayerTSerpent(player)) then -- ��Ʈ ����Ʈ�� ���
		if player:HasCollectible(DEADCAT.id) and not hasCostume_deadcat.hasCostume then
			player:AddNullCostume(DEADCAT.COSTUME)
			player:AddNullCostume(DEADCAT.COSTUME_HAIR)
			hasCostume_deadcat.hasCostume = true
			mod.game:GetHUD():ShowFortuneText('Cat in the box!')
			mod.SFX:Play(SoundEffect.SOUND_EDEN_GLITCH)
		end
	end
end