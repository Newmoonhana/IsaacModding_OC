-- 전체적으로 Lyterbringr의 유튜브 강좌 & Mei 캐릭터 모드 소스코드 참고

mod = RegisterMod("Serpent",1) -- Register the mod

include('script/debugmod.lua')
DEBUGMOD:DebugString(DEBUGMOD.type.debug, "Serpent Mod Is Enable!")

-- [변수]
mod.game = Game()
mod.room = mod.game:GetRoom()
mod.level = mod.game:GetLevel()
mod.level:GetCurrentRoomIndex()
mod.roomDescriptor = mod.level:GetCurrentRoomDesc()
mod.roomConfigRoom = mod.roomDescriptor.Data
mod.myRNG = RNG()
mod.Music = MusicManager()
mod.SFX = SFXManager()
-- mod.option = Options()

mod.ZeroVector = Vector(0, 0)
mod.Direction = { Up = Vector(0, -1), Left = Vector(-1, 0), Down = Vector(0, 1), Right = Vector(1, 0),
					UpLeft = Vector(-1, -1), UpRight = Vector(1, -1), DownLeft = Vector(-1, 1), DownRight = Vector(1, 1) }

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

include('script/items/rngesus.lua')
include('script/items/speed runner.lua')
include('script/items/specter sword.lua')
include('script/items/dead cat.lua')

include('script/characters/serpent.lua')
include('script/characters/tserpent.lua')

include('script/familiar.lua')
include('script/savedata.lua')