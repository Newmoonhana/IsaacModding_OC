TSerpent = {}

-- [변수]


-- 캐릭터
TSerpent.type = Isaac.GetPlayerTypeByName('Tainted Serpent')
if REPENTANCE then
	TSerpent.type = Isaac.GetPlayerTypeByName('Tainted Serpent',true)
end
TSerpent.COSTUME = Isaac.GetCostumeIdByPath("gfx/characters/tainted_serpenthair.anm2")
local hasCostume_deadcat = { hasCostume = false };

-- 아이템
local SpeedRunnerId = SpeedRunner.id

-- 플레이어 생성자
function TSerpent:PostPlayerInit(player)
	if TSerpent:IsPlayerTSerpent(player) then -- 알트 서펀트의 경우
		player:TryRemoveNullCostume( TSerpent.COSTUME )
		player:AddNullCostume(TSerpent.COSTUME)
		costumeEquipped = true
		hasCostume_deadcat.hasCostume = false

		-- 아이템 추가
		if SpeedRunnerId > 0 then        --should prevent error, when the item cant be found
			player:AddCollectible( SpeedRunnerId, 0, false )
		end

		-- 코옵 사망 시 유령으로 등장하는 거 코스튬 세팅(CustomCoopGhost 모드 필요)
		if CustomCoopGhost then
			CustomCoopGhost.ChangeSkin(TSerpent.type, 'tserpent')
			CustomCoopGhost.AddCostume(TSerpent.type, 'tserpenthair')
		end
	end
end
mod:AddCallback( ModCallbacks.MC_POST_PLAYER_INIT, TSerpent.PostPlayerInit)

-- 플레이어 캐릭터 체크
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