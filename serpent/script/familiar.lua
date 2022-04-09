Familiar = {}

-- !!!!!unique minisaacs ��� ����

function Familiar:GetData(entity)
	if entity and entity.GetData then
		local data = entity:GetData()
		if not data.UniqueMinisaacs then
			data.UniqueMinisaacs = {}
		end
		return data.UniqueMinisaacs
	end
	return nil
end

-- Replace Sprites!
function Familiar:ReplaceSpritesheet(minisaac)
	local player = minisaac.Player
	local sprite = minisaac:GetSprite()
	local data = Familiar:GetData(minisaac)

	if Serpent:IsPlayerSerpent(player) or
	TSerpent:IsPlayerTSerpent(player) then -- ����Ʈ�� ���
		sprite:ReplaceSpritesheet(0, "gfx/familiar/familiar_minisaac_serpent.png")
		sprite:ReplaceSpritesheet(1, "gfx/familiar/familiar_minisaac_serpent.png")
	end
	sprite:LoadGraphics()
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, Familiar.ReplaceSpritesheet, FamiliarVariant.MINISAAC)