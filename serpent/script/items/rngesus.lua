local Rngesus = {}

-- [����]
Rngesus.id = Isaac.GetItemIdByName('RNGesus')
local DeathCertificateId = 628
local diec_img = { "giantbook_RNGesus1.png", "giantbook_RNGesus2.png", "giantbook_RNGesus3.png", "giantbook_RNGesus4.png", "giantbook_RNGesus5.png", "giantbook_RNGesus6.png", "giantbook_RNGesus7.png", "giantbook_RNGesus8.png" } -- giantbook �̹����� ����� �ֻ��� �� �̹���
local dice_table = { 1, 2, 3, 4, 5, 6, 7, 8 }
local DICEMAX = 8	-- ���̽��� �ִ�(���̺��� �ִ��� �ƴ� ���� �� �ִ� �ִ� ũ���� ��)

-- [����� ����]
local dice_table_text = ""

-- NPC Update �Լ�
function Rngesus:onPostInit(player)
	if player:HasCollectible(Rngesus.id) then
		dice_table = { 1, 2, 3, 4, 5, 6, 7, 8 }
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
			-- dice_table_text = dice_table_text .. table.concat(dice_table, ", ") -- �ڵ����� ������ ���� �ؽ�Ʈ �����ε� ������ \n�� ��ġ�� �ָ���

			local dice_table_sum = { 0, 0, 0, 0, 0, 0, 0, 0 }
			for index = 1, #dice_table do
				dice_table_sum[dice_table[index]] = dice_table_sum[dice_table[index]] + 1
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

	--if sound then
	--	local sfx = SFXManager()
	--	sfx:Play(sound, 1, 0, false, 1)
	--end
	
	local seed = mod.myRNG:GetSeed();
	seed = math.random(seed);
	Isaac.DebugString("[Serpent]: max =  "..(dice_table[1]))
	local dice_rng_Index = math.random(#dice_table) -- dice_table�� ���� �ε��� ��
	local dice_rng = dice_table[dice_rng_Index]
	if dice_rng == 1 then -- Entity ��ü ���(�÷��̾� ����)
		for _, entity in pairs(entities) do
			entity:Die()
		end
	elseif dice_rng == 2 then -- ���� ����
		local curse_index = mod:getRandomIntInclusive(1, 6)
		mod.level:AddCurse(1 << curse_index, true)
	elseif dice_rng == 3 then -- �� �� ���� ��ǥ ����
		player:AnimateTeleport(true)
		local x = mod:getRandomArbitrary(0, mod.room:GetBottomRightPos().X)
		local y = mod:getRandomArbitrary(0, mod.room:GetBottomRightPos().Y)
		player.Position = Vector(x, y)
		-- game:ChangeRoom(level:GetPreviousRoomIndex()) -- �� ������ ����غ����� �̵��� ���ÿ� �״� ���׶����� ����
	elseif dice_rng == 4 then -- è�Ǿ��� �ƴ� ��� �� è�Ǿ� ȭ
		for _, entity in pairs(entities) do
			if entity:IsEnemy() then
				if entity:ToNPC():IsChampion() == false then
					seed = math.random(seed);
					entity:ToNPC():MakeChampion(seed)
				end
			end
		end
	elseif dice_rng == 5 then -- ��� ������ �÷��̾� ���ݷ� * 40 (����) ������ & �ϴÿ��� �� ����.
		for _, entity in pairs(entities) do
			if entity:IsEnemy() then
				entity:TakeDamage(player.Damage * 40, DamageFlag.DAMAGE_EXPLOSION, EntityRef(entity), 0)
				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 0, entity.Position, Vector(0, 0), player)
			end
		end
	elseif dice_rng == 6 then -- �� �ϳ� �� ���� �Ⱦ� �������� ���
		-- ���� �� �ִ� ���� : ��Ʈ=10, ��=20, ����=30, ��ź=40, ����=50, ��� ����=60, �˾�=70, ���͸�=90, Ÿ��ī��=300, ��=350, ���� ����=360
		local randomPickup = { 10, 20, 30, 40, 50, 60, 70, 90, 300, 350, 360 }
		for _, entity in pairs(entities) do
			if entity:IsEnemy() then
				Isaac.Spawn(EntityType.ENTITY_PICKUP, randomPickup[mod:getRandomIntInclusive(1, 11)], 0, Isaac.GetFreeNearPosition(entity.Position, 10), Vector(0, 0), entity) 
			end
		end
	elseif dice_rng == 7 then -- ��� ������ �÷��̾� ���ݷ� * 100 ������(��� ���� x) ���� ���ο� and �ڼ� �ο� & �÷��̾��� �ֺ��� ����ǰ ������ �ϳ� ����
		for _, entity in pairs(entities) do
			if entity:IsEnemy() then
				entity:TakeDamage(player.Damage * 100, DamageFlag.DAMAGE_NOKILL, EntityRef(entity), 0)
				entity:AddEntityFlags(EntityFlag.FLAG_SLOW | EntityFlag.FLAG_MAGNETIZED) -- ���� ���ο� & �ڼ�
			end
		end
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, Isaac.GetFreeNearPosition(player.Position, 10), Vector(0,0), player) -- ������ ����
	elseif dice_rng == 8 then
		mod.game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, mod.room:GetCenterPos(), Vector(0,0), nil, DeathCertificateId, mod.myRNG:GetSeed()) -- ������ܼ� ����
	else -- ������ ����
		DebugString("[Serpent] dice_rng is not range : "..dice_rng)
	end

	-- �ֻ��� ����� max / 2 �̻��� ��� ���� �� ĭ ����
	if (dice_rng > DICEMAX / 2) then
		player:SetActiveCharge(player:GetActiveCharge()+1)
	end

	if (mod:getRandomIntInclusive(1, dice_rng) == dice_rng) then -- 1/dice_rng�� Ȯ���� ���̺� �ش� ���� �߰��Ǿ� �ش� ���� ���� ���ɼ��� ��������(���� ������ ���� ���̺� �� �ȵ����ν� �뷱����ġ)
		table.insert(dice_table, dice_rng);
	end
	GiantBookAPI.playGiantBook("Appear", diec_img[dice_rng], Color(0.2,0.5,0.5,1,0,0,0),Color(0.5,1,1,0.5,0,0,0),Color(0.2,0.5,0.5,0.8,0,0,0), false)
end
mod:AddCallback( ModCallbacks.MC_USE_ITEM, Rngesus.UseRNGesus, Rngesus.id )