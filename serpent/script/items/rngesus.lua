Rngesus = {}

-- [����]
Rngesus.id = Isaac.GetItemIdByName('RNGesus')
local DeathCertificateId = 628
local diec_img = { "giantbook_RNGesus1.png", "giantbook_RNGesus2.png", "giantbook_RNGesus3.png", "giantbook_RNGesus4.png", "giantbook_RNGesus5.png", "giantbook_RNGesus6.png", "giantbook_RNGesus7.png", "giantbook_RNGesus8.png" } -- giantbook �̹����� ����� �ֻ��� �� �̹���
Rngesus.dice_table = { 1, 2, 3, 4, 5, 6, 7, 8 }
local DICEMAX = 8	-- ���̽��� �ִ�(���̺��� �ִ��� �ƴ� ���� �� �ִ� �ִ� ũ���� ��)

SoundEffect.DiceRoll = Isaac.GetSoundIdByName("DiceRoll")

-- [����� ����]
local dice_table_text = ""

-- NPC Update �Լ�
function Rngesus:onPostInit(player)
	if player:HasCollectible(Rngesus.id) then
		-- Rngesus.dice_table = { 1, 2, 3, 4, 5, 6, 7, 8 }
	end
end
mod:AddCallback( ModCallbacks.MC_POST_PLAYER_INIT, Rngesus.onPostInit)

-- Update �Լ�
function Rngesus:onUpdate(player)
	-- [����� �� �ؽ�Ʈ ��� �� �غ�]
	if mod.debug then
		local player = Isaac.GetPlayer(0)
		local index = 0
		if player:HasCollectible(Rngesus.id) then
			dice_table_text = "dice table = { "
			-- dice_table_text = dice_table_text .. table.concat(Rngesus.dice_table, ", ") -- �ڵ����� ������ ���� �ؽ�Ʈ �����ε� ������ \n�� ��ġ�� �ָ���

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
-- Render �Լ�
function Rngesus:onRender(player)
	-- [����� �� �ؽ�Ʈ ���]
	if mod.debug then
		local player = Isaac.GetPlayer(0)
		if player:HasCollectible(Rngesus.id) then
			Isaac.RenderText(dice_table_text, 40, 20, 255, 255, 255, 255)
		end
	end
end
mod:AddCallback( ModCallbacks.MC_POST_RENDER, Rngesus.onRender)

-- RNGesus ���
function Rngesus:UseRNGesus(_Type, RNG, player)
	local entities = Isaac:GetRoomEntities()
	player:AnimateCollectible(Rngesus.id, "UseItem", "PlayerPickupSparkle")
	
	mod.SFX:Play(SoundEffect.DiceRoll)

	local seed = mod.myRNG:GetSeed();
	seed = mod:getRandomInt(0, seed);
	DEBUGMOD:DebugValue(DEBUGMOD.type.debug, "RNGesus.lua", "RNGesus.dice_table.Length", #(Rngesus.dice_table))
	local dice_rng_Index = math.random(#(Rngesus.dice_table)) -- dice_table�� ���� �ε��� ��
	DEBUGMOD:DebugValue(DEBUGMOD.type.debug, "RNGesus.lua", "dice_rng's random index", dice_rng_Index)
	local dice_rng = Rngesus.dice_table[dice_rng_Index]
	if dice_rng == 1 then -- Entity ��ü ���(�÷��̾� ����)
		for _, entity in pairs(entities) do
			entity:Die()
		end
	elseif dice_rng == 2 then -- ���� ���� & �� �� ���� ��ǥ ����
		local curse_index = mod:getRandomIntInclusive(1, 6)
		mod.level:AddCurse(1 << curse_index, true)
		player:AnimateTeleport(true)
		local x = mod:getRandomArbitrary(0, mod.room:GetBottomRightPos().X)
		local y = mod:getRandomArbitrary(0, mod.room:GetBottomRightPos().Y)
		player.Position = Vector(x, y)
		-- game:ChangeRoom(level:GetPreviousRoomIndex()) -- �� ������ ����غ����� �̵��� ���ÿ� �״� ���׶����� ����
	elseif dice_rng == 3 then -- ������ ����
		Isaac.ExecuteCommand("goto s.error.#")
	elseif dice_rng == 4 then -- è�Ǿ��� �ƴ� ��� �� è�Ǿ� ȭ
		Rngesus:IsChampionDice(seed)
	elseif dice_rng == 5 then -- ��� ������ ���� ���ο� and �ڼ� �ο�
		Rngesus:IsAllSlowDice()
	elseif dice_rng == 6 then -- ��� ������ �÷��̾� ���ݷ� * 20 (��� ���� x) ������ & �ϴÿ��� �� ����.
		for _, entity in pairs(entities) do
			if entity:IsEnemy() then
				entity:TakeDamage(player.Damage * 20, DamageFlag.DAMAGE_NOKILL, EntityRef(entity), 0)
				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 0, entity.Position, Vector(0, 0), player)
			end
		end
	elseif dice_rng == 7 then -- �� �ϳ� �� ���� �Ⱦ� �������� ��� & �÷��̾��� �ֺ��� ����ǰ ������ �ϳ� ����
		-- ���� �� �ִ� ���� : ��Ʈ=10, ��=20, ����=30, ��ź=40, ����=50, ��� ����=60, �˾�=70, ���͸�=90, Ÿ��ī��=300, ��=350, ���� ����=360
		local randomPickup = { 10, 20, 30, 40, 50, 60, 70, 90, 300, 350, 360 }
		for _, entity in pairs(entities) do
			if entity:IsEnemy() then
				Isaac.Spawn(EntityType.ENTITY_PICKUP, randomPickup[mod:getRandomIntInclusive(1, 11)], 0, Isaac.GetFreeNearPosition(entity.Position, 10), Vector(0, 0), entity) 
			end
		end
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, Isaac.GetFreeNearPosition(player.Position, 10), Vector(0,0), player) -- ������ ����
	elseif dice_rng == 8 then
		mod.game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, mod.room:GetCenterPos(), Vector(0,0), nil, DeathCertificateId, mod.myRNG:GetSeed()) -- ������ܼ� ����
	else -- ������ ����
		DEBUGMOD:DebugString(DEBUGMOD.type.error, "dice_rng is not range!")
		DEBUGMOD:DebugValue(DEBUGMOD.type.error, "RNGesus.lua", "dice_rng", dice_rng)
		DEBUGMOD:DebugValue(DEBUGMOD.type.error, "RNGesus.lua", "Rngesus.dice_table.Length", #(Rngesus.dice_table))
	end

	-- �ֻ��� ����� max / 2 �̻��� ��� ���� �� ĭ ����
	if (dice_rng > DICEMAX / 2) then
		player:SetActiveCharge(player:GetActiveCharge()+1)
	end

	if (mod:getRandomIntInclusive(1, dice_rng) == dice_rng) then -- 1/dice_rng�� Ȯ���� ���̺� �ش� ���� �߰��Ǿ� �ش� ���� ���� ���ɼ��� ��������(���� ������ ���� ���̺� �� �ȵ����ν� �뷱����ġ)
		table.insert(Rngesus.dice_table, dice_rng);
	end

	-- GiantBookAPI ��尡 ���� �� ���� �ֻ��� �� ǥ��
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
			entity:AddEntityFlags(EntityFlag.FLAG_SLOW | EntityFlag.FLAG_MAGNETIZED) -- ���� ���ο� & �ڼ�
		end
	end
end