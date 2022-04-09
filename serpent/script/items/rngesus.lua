Rngesus = {}

-- [변수]
Rngesus.id = Isaac.GetItemIdByName('RNGesus')
local DeathCertificateId = 628
local diec_img = { "giantbook_RNGesus1.png", "giantbook_RNGesus2.png", "giantbook_RNGesus3.png", "giantbook_RNGesus4.png", "giantbook_RNGesus5.png", "giantbook_RNGesus6.png", "giantbook_RNGesus7.png", "giantbook_RNGesus8.png" } -- giantbook 이미지로 사용할 주사위 눈 이미지
Rngesus.dice_table = { 1, 2, 3, 4, 5, 6, 7, 8 }
local DICEMAX = 8	-- 다이스의 최댓값(테이블의 최댓값이 아닌 나올 수 있는 최대 크기의 수)

SoundEffect.DiceRoll = Isaac.GetSoundIdByName("DiceRoll")

-- [디버깅 변수]
local dice_table_text = ""

-- NPC Update 함수
function Rngesus:onPostInit(player)
	if player:HasCollectible(Rngesus.id) then
		-- Rngesus.dice_table = { 1, 2, 3, 4, 5, 6, 7, 8 }
	end
end
mod:AddCallback( ModCallbacks.MC_POST_PLAYER_INIT, Rngesus.onPostInit)

-- Update 함수
function Rngesus:onUpdate(player)
	-- [디버깅 용 텍스트 출력 전 준비]
	if mod.debug then
		local player = Isaac.GetPlayer(0)
		local index = 0
		if player:HasCollectible(Rngesus.id) then
			dice_table_text = "dice table = { "
			-- dice_table_text = dice_table_text .. table.concat(Rngesus.dice_table, ", ") -- 자동으로 구분자 포함 텍스트 대입인데 문제는 \n할 위치가 애매함

			local dice_table_sum = { 0, 0, 0, 0, 0, 0, 0, 0 }
			for index = 1, #(Rngesus.dice_table) do
				dice_table_sum[Rngesus.dice_table[index]] = dice_table_sum[Rngesus.dice_table[index]] + 1
			end
			for index = 1, #dice_table_sum do
				dice_table_text = dice_table_text .. tostring(index) .. "= " .. tostring(dice_table_sum[index])
				if (index ~= #dice_table_sum) then
					dice_table_text = dice_table_text .. ", "
				end
			end
			dice_table_text = dice_table_text .. " }"
		end
	end
end
mod:AddCallback( ModCallbacks.MC_POST_UPDATE, Rngesus.onUpdate)
-- Render 함수
function Rngesus:onRender(player)
	-- [디버깅 용 텍스트 출력]
	if mod.debug then
		local player = Isaac.GetPlayer(0)
		if player:HasCollectible(Rngesus.id) then
			Isaac.RenderText(dice_table_text, 40, 20, 255, 255, 255, 255)
		end
	end
end
mod:AddCallback( ModCallbacks.MC_POST_RENDER, Rngesus.onRender)

-- RNGesus 사용
function Rngesus:UseRNGesus(_Type, RNG, player)
	local entities = Isaac:GetRoomEntities()
	player:AnimateCollectible(Rngesus.id, "UseItem", "PlayerPickupSparkle")
	
	mod.SFX:Play(SoundEffect.DiceRoll)

	local seed = mod.myRNG:GetSeed();
	seed = mod:getRandomInt(0, seed);
	DEBUGMOD:DebugValue(DEBUGMOD.type.debug, "RNGesus.lua", "RNGesus.dice_table.Length", #(Rngesus.dice_table))
	local dice_rng_Index = math.random(#(Rngesus.dice_table)) -- dice_table의 랜덤 인덱스 값
	DEBUGMOD:DebugValue(DEBUGMOD.type.debug, "RNGesus.lua", "dice_rng's random index", dice_rng_Index)
	local dice_rng = Rngesus.dice_table[dice_rng_Index]
	if dice_rng == 1 then -- Entity 전체 즉사(플레이어 포함)
		for _, entity in pairs(entities) do
			entity:Die()
		end
	elseif dice_rng == 2 then -- 랜덤 저주 & 방 안 랜덤 좌표 워프
		local curse_index = mod:getRandomIntInclusive(1, 6)
		mod.level:AddCurse(1 << curse_index, true)
		player:AnimateTeleport(true)
		local x = mod:getRandomArbitrary(0, mod.room:GetBottomRightPos().X)
		local y = mod:getRandomArbitrary(0, mod.room:GetBottomRightPos().Y)
		player.Position = Vector(x, y)
		-- game:ChangeRoom(level:GetPreviousRoomIndex()) -- 방 워프도 고려해봤으나 이동과 동시에 죽는 버그때문에 보류
	elseif dice_rng == 3 then -- 에러방 워프
		Isaac.ExecuteCommand("goto s.error.#")
	elseif dice_rng == 4 then -- 챔피언이 아닌 모든 적 챔피언 화
		Rngesus:IsChampionDice(seed)
	elseif dice_rng == 5 then -- 모든 적에게 영구 슬로우 and 자석 부여
		Rngesus:IsAllSlowDice()
	elseif dice_rng == 6 then -- 모든 적에게 플레이어 공격력 * 20 (사망 판정 x) 데미지 & 하늘에서 빛 공격.
		for _, entity in pairs(entities) do
			if entity:IsEnemy() then
				entity:TakeDamage(player.Damage * 20, DamageFlag.DAMAGE_NOKILL, EntityRef(entity), 0)
				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 0, entity.Position, Vector(0, 0), player)
			end
		end
	elseif dice_rng == 7 then -- 적 하나 당 랜덤 픽업 아이템을 드롭 & 플레이어의 주변에 수집품 아이템 하나 생성
		-- 나올 수 있는 종류 : 하트=10, 돈=20, 열쇠=30, 폭탄=40, 상자=50, 잠긴 상자=60, 알약=70, 배터리=90, 타로카드=300, 룬=350, 빨간 상자=360
		local randomPickup = { 10, 20, 30, 40, 50, 60, 70, 90, 300, 350, 360 }
		for _, entity in pairs(entities) do
			if entity:IsEnemy() then
				Isaac.Spawn(EntityType.ENTITY_PICKUP, randomPickup[mod:getRandomIntInclusive(1, 11)], 0, Isaac.GetFreeNearPosition(entity.Position, 10), Vector(0, 0), entity) 
			end
		end
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, Isaac.GetFreeNearPosition(player.Position, 10), Vector(0,0), player) -- 아이템 생성
	elseif dice_rng == 8 then
		mod.game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, mod.room:GetCenterPos(), Vector(0,0), nil, DeathCertificateId, mod.myRNG:GetSeed()) -- 사망진단서 생성
	else -- 랜덤값 오류
		DEBUGMOD:DebugString(DEBUGMOD.type.error, "dice_rng is not range!")
		DEBUGMOD:DebugValue(DEBUGMOD.type.error, "RNGesus.lua", "dice_rng", dice_rng)
		DEBUGMOD:DebugValue(DEBUGMOD.type.error, "RNGesus.lua", "Rngesus.dice_table.Length", #(Rngesus.dice_table))
	end

	-- 주사위 결과가 max / 2 이상일 경우 차지 한 칸 충전
	if (dice_rng > DICEMAX / 2) then
		player:SetActiveCharge(player:GetActiveCharge()+1)
	end

	if (mod:getRandomIntInclusive(1, dice_rng) == dice_rng) then -- 1/dice_rng의 확률로 테이블에 해당 값이 추가되어 해당 값이 나올 가능성이 높아진다(높은 숫자일 수록 테이블에 잘 안들어감으로써 밸런스패치)
		table.insert(Rngesus.dice_table, dice_rng);
	end

	-- GiantBookAPI 모드가 있을 시 나온 주사위 값 표시
	if GiantBookAPI then
		GiantBookAPI.playGiantBook("Appear", diec_img[dice_rng], Color(0.2,0.5,0.5,1,0,0,0),Color(0.5,1,1,0.5,0,0,0),Color(0.2,0.5,0.5,0.8,0,0,0), false)
	end
end
mod:AddCallback( ModCallbacks.MC_USE_ITEM, Rngesus.UseRNGesus, Rngesus.id )

function Rngesus:IsChampionDice(seed)
	local entities = Isaac:GetRoomEntities()
	for _, entity in pairs(entities) do
		if entity:IsEnemy() then
			if entity:ToNPC():IsChampion() == false then
				entity:ToNPC():MakeChampion(seed)
			end
		end
	end
end

function Rngesus:IsAllSlowDice()
	local entities = Isaac:GetRoomEntities()
	for _, entity in pairs(entities) do
		if entity:IsEnemy() then
			entity:AddEntityFlags(EntityFlag.FLAG_SLOW | EntityFlag.FLAG_MAGNETIZED) -- 영구 슬로우 & 자석
		end
	end
end