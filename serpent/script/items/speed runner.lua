local SpeedRunner = {}

-- [변수]
SpeedRunner.id = Isaac.GetItemIdByName('Speed Runner')

-- Update 함수
function SpeedRunner:onUpdate(player)
	-- [Speed Runner 패시브]
	--if player:HasCollectible(SpeedRunner) then
		
	--end
end
mod:AddCallback( ModCallbacks.MC_POST_UPDATE, SpeedRunner.onUpdate)