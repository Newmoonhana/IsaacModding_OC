local SpeedRunner = {}

-- [����]
SpeedRunner.id = Isaac.GetItemIdByName('Speed Runner')

-- Update �Լ�
function SpeedRunner:onUpdate(player)
	-- [Speed Runner �нú�]
	--if player:HasCollectible(SpeedRunner) then
		
	--end
end
mod:AddCallback( ModCallbacks.MC_POST_UPDATE, SpeedRunner.onUpdate)