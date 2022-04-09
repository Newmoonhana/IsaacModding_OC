Serpent = {}

-- [변수]


-- 캐릭터
Serpent.type = Isaac.GetPlayerTypeByName('Serpent')
Serpent.COSTUME = Isaac.GetCostumeIdByPath("gfx/characters/serpenthair.anm2")
Serpent.Stat = -- 설정할 스탯 값(베이스를 수정은 못해서 베이스에 값을 더하거나 빼는 식으로 설정될 것임. 즉 (고정 값을 제외하면) 앞에 마이너스는 값 초기화)
{
	DAMAGE = -1, -- 공격력 = 스피드로 설정할 것이므로 노말 서펀트의 공격력 스탯은 쓰이지 않음
	SPEED = -1 + 1,
	SHOTSPEED = -2.73 + 1,
	TEARHEIGHT = 2, -- Range
	TEARFALLINGSPEED = 0, -- Range
	LUCK = 8,
	FLYING = false,
	TEARFLAG = 0, -- 디폴트 = 0
	TEARCOLOR = Color(0.0, 0.3, 0.2, 1.0, 0, 0, 0)	-- 디폴트 = (1.0, 1.0, 1.0, 1.0, 0, 0, 0)
}
local hasCostume_deadcat = { hasCostume = false };

-- 아이템
local RngesusId = Rngesus.id
local SpecterSwordId = SpecterSword.id
local item_Sword = 579 --영혼검

-- 플레이어 캐싱
function Serpent:onCache(player, cacheFlag)
	if Serpent:IsPlayerSerpent(player) then -- 노말 서펀트의 경우
		if cacheFlag == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.MoveSpeed * 2
		end
		if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
			player.ShotSpeed = player.ShotSpeed + Serpent.Stat.SHOTSPEED
		end
		if cacheFlag == CacheFlag.CACHE_RANGE then
			player.TearHeight = player.TearHeight + Serpent.Stat.TEARHEIGHT
			player.TearFallingSpeed = player.TearFallingSpeed + Serpent.Stat.TEARFALLINGSPEED
		end
		if cacheFlag == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + Serpent.Stat.SPEED
			player.Damage = player.MoveSpeed * 2
		end
		if cacheFlag == CacheFlag.CACHE_LUCK then
			player.Luck = player.Luck + Serpent.Stat.LUCK
		end
		if cacheFlag == CacheFlag.CACHE_FLYING and Serpent.Stat.FLYING then
			player.CanFly = true
		end
		if cacheFlag == CacheFlag.CACHE_TEARFLAG then
			player.TearFlags = player.TearFlags | Serpent.Stat.TEARFLAG
		end
		if cacheFlag == CacheFlag.CACHE_TEARCOLOR then
			player.TearColor = Serpent.Stat.TEARCOLOR
		end
	end
end
mod:AddCallback( ModCallbacks.MC_EVALUATE_CACHE, Serpent.onCache)

-- 플레이어 생성자
function Serpent:PostPlayerInit(player)
	if Serpent:IsPlayerSerpent(player) then -- 노말 서펀트의 경우
		player:TryRemoveNullCostume( Serpent.COSTUME )
		player:AddNullCostume(Serpent.COSTUME)
		costumeEquipped = true
		hasCostume_deadcat.hasCostume = false

		-- 아이템 추가
		if RngesusId > 0 then        --should prevent error, when the item cant be found
			if REPENTANCE then
				player:SetPocketActiveItem( RngesusId, ActiveSlot.SLOT_POCKET, false)
			else
				player:AddCollectible( RngesusId, 0, 1 )
			end
		end
		if SpecterSwordId > 0 then
			player:AddCollectible( SpecterSwordId, 0, false )
		end
		if item_Sword > 0 then
			player:AddCollectible( item_Sword, 0, false )
		end

		-- 코옵 사망 시 유령으로 등장하는 거 코스튬 세팅(CustomCoopGhost 모드 필요)
		if CustomCoopGhost then
			CustomCoopGhost.ChangeSkin(Serpent.type, 'serpent')
			CustomCoopGhost.AddCostume(Serpent.type, 'serpenthair')
		end
	end
end
mod:AddCallback( ModCallbacks.MC_POST_PLAYER_INIT, Serpent.PostPlayerInit)

-- 플레이어 캐릭터 체크
function Serpent:IsPlayerSerpent(player)
	if player:GetPlayerType() == Serpent.type then
		return true
	else
		return false
	end
end

-- Update
function Serpent:onUpdate(player)
	if hasCostume_deadcat.hasCostume == true then
		DEADCAT:GetDeadCat(player, hasCostume_deadcat)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, Serpent.onUpdate)