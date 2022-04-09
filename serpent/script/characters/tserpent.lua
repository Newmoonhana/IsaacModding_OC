TSerpent = {}

-- [����]


-- ĳ����
TSerpent.type = Isaac.GetPlayerTypeByName('Tainted Serpent')
if REPENTANCE then
	TSerpent.type = Isaac.GetPlayerTypeByName('Tainted Serpent',true)
end
TSerpent.COSTUME = Isaac.GetCostumeIdByPath("gfx/characters/tainted_serpenthair.anm2")
local hasCostume_deadcat = { hasCostume = false };

-- ������
local SpeedRunnerId = SpeedRunner.id

-- �÷��̾� ������
function TSerpent:PostPlayerInit(player)
	if TSerpent:IsPlayerTSerpent(player) then -- ��Ʈ ����Ʈ�� ���
		player:TryRemoveNullCostume( TSerpent.COSTUME )
		player:AddNullCostume(TSerpent.COSTUME)
		costumeEquipped = true
		hasCostume_deadcat.hasCostume = false

		-- ������ �߰�
		if SpeedRunnerId > 0 then        --should prevent error, when the item cant be found
			player:AddCollectible( SpeedRunnerId, 0, false )
		end

		-- �ڿ� ��� �� �������� �����ϴ� �� �ڽ�Ƭ ����(CustomCoopGhost ��� �ʿ�)
		if CustomCoopGhost then
			CustomCoopGhost.ChangeSkin(TSerpent.type, 'tserpent')
			CustomCoopGhost.AddCostume(TSerpent.type, 'tserpenthair')
		end
	end
end
mod:AddCallback( ModCallbacks.MC_POST_PLAYER_INIT, TSerpent.PostPlayerInit)

-- �÷��̾� ĳ���� üũ
function TSerpent:IsPlayerTSerpent(player)
	if player:GetPlayerType() == TSerpent.type then
		return true
	else
		return false
	end
end

-- Update
function TSerpent:onUpdate(player)
	if hasCostume_deadcat.hasCostume == true then
		DEADCAT:GetDeadCat(player, hasCostume_deadcat)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, TSerpent.onUpdate)