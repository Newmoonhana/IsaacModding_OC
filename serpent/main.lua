-- 전체적으로 Lyterbringr의 유튜브 강좌 & Mei 캐릭터 모드 소스코드 참고

mod = RegisterMod("Serpent",1) -- Register the mod

-- [변수]
mod.game = Game()
mod.room = mod.game:GetRoom()
mod.level = Game():GetLevel()
mod.level:GetCurrentRoomIndex()
mod.roomDescriptor = mod.level:GetCurrentRoomDesc()
mod.roomConfigRoom = mod.roomDescriptor.Data
mod.myRNG = RNG()
mod.Music = MusicManager()
mod.SFX = SFXManager()
-- mod.option = Options()

mod.debug = true

-- [모드 설정]
mod.ModCallbacks = {
		MC_CONVERT_HEARTS = 0,
		MC_MORPH_TEAR = 1,
		MC_TELEKINESIS_VALIDITY = 3,
		MC_REFRESH_TEAR_SPRITE = 5
	}
local modCallbacks = {}
-- This function returns a key that can be used to remove the mod callback.	/	이 함수는 모드 콜백을 제거하는 데 사용할 수 있는 키를 반환합니다
-- If nil was returned, the callback was not successfully added.	/	0이 반환되면 콜백이 성공적으로 추가되지 않은 것입니다
function mod:AddModCallback(callbackId,callback,...)
	if callbackId == nil then
		error("[Serpent] Callback Id invalid")
	end
	if type(callback) == "function" then
		if modCallbacks[callbackId] == nil then
			modCallbacks[callbackId] = {}
		end
		table.insert(modCallbacks[callbackId],callback)
		local key = #modCallbacks[callbackId]-1
		Isaac.DebugString("[Serpent]: Mod callback added for ID "..callbackId.." with key "..key)
		return key
	end
	return nil
end

-- This function takes the key that AddModCallback returned to remove the the mod callback	/	이 함수는 AddModCallback이 모드 콜백을 제거하기 위해 반환한 키를 사용합니다
-- main.lua에선 쓰이는 곳이 안보이는데 중요해보여서 일단 가져옴
function mod:RemoveModCallback(callbackId,key)
	if modCallbacks[callbackId] ~= nil then
		Isaac.DebugString("[Serpent]: Mod callback remove for ID "..callbackId.." with key "..key)
		modCallbacks[callbackId][key] = -1
	end
end

-- 멀티 플레이 용 GetPlayer(다인 플레이어)
function mod:GetPlayers()
	local players = {}
	for i=0,Game():GetNumPlayers()-1 do
		local player = Game():GetPlayer(i)
		players[i] = player
	end
	return players
end

-- [랜덤값 함수]
-- 0 이상 1 미만의 난수
function mod:getRandom()
	return mod.myRNG:RandomFloat()
end
-- 두 값 사이의 난수(최대값 미만)
function mod:getRandomArbitrary(min, max)
	return mod.myRNG:RandomFloat() * (max - min) + max
end
-- 최댓값을 포함하는 두 값 사이의 난수
function mod:getRandomArbitraryInclusive(min, max)
	return mod.myRNG:RandomFloat() * (max + 1 - min) + max
end
-- 두 값 사이의 정수 난수(최대값 미만)
function mod:getRandomInt(min, max)
	return mod.myRNG:RandomInt(max - min) + min
end
-- 최댓값을 포함하는 정수 난수
function mod:getRandomIntInclusive(min, max)
	return mod.myRNG:RandomInt(max + 1 - min) + min
end

include('script/effect.lua')

include('script/characters/serpent.lua')
include('script/characters/tserpent.lua')
include('script/items/rngesus.lua')
include('script/items/speed runner.lua')
include('script/items/dead cat.lua')

include('script/savedata.lua')