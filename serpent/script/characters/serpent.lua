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
local item_RNGesus = Isaac.GetItemIdByName("RNGesus") -- 아이템 체킹용 변수
local item_Sword = 579 --영혼검

-- 플레이어 캐싱
function Serpent:onCache(player, cacheFlag)
	if Serpent:IsPlayerSerpent(player) then -- 노말 서펀트의 경우
		if cacheFlag == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.MoveSpeed * 3
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
		hasCostume_deadcat.hasCostume = false ;

		-- 아이템 추가
		if item_RNGesus > 0 then        --should prevent error, when the item cant be found
			if REPENTANCE then
				player:SetPocketActiveItem( item_RNGesus, ActiveSlot.SLOT_POCKET, false)
			else
				player:AddCollectible( item_RNGesus, 0, 1 )
			end
			player:AddCollectible( item_Sword, 0, false )
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
	DEADCAT:GetDeadCat(player, hasCostume_deadcat)
end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, Serpent.onUpdate)