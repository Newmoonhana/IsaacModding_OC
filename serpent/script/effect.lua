EFFECT = {}

EFFECT.ScreenSize = { WindowSize = { 0, 0 }, CurrSize = { 0, 0 } }
EFFECT.ColorShader = false

local function GetScreenSize() -- DDLC 모드 참고
  local pos = mod.room:WorldToScreenPosition(Vector.Zero) - mod.room:GetRenderScrollOffset() - mod.game.ScreenShakeOffset

  local rx = pos.X + 60 * 26 / 40
  local ry = pos.Y + 140 * (26 / 40)

  return rx*2 + 13*26, ry*2 + 7*26
end

local function PostGameStarted(isContinued)
	EFFECT.ScreenSize.WindowSize = { GetScreenSize() }
	EFFECT.ScreenSize.CurrSize = EFFECT.ScreenSize.WindowSize
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, PostGameStarted)

function EFFECT:GetShaderParams(shaderName)
    if shaderName == 'RandomColors' then
		if EFFECT.ColorShader == true then
			return { R = 2, G = 0.5, B = mod:getRandomArbitrary(0,0.1) }
		else
			return { R = 1, G = 1, B = 1 }
		end
    end
end
mod:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, EFFECT.GetShaderParams)