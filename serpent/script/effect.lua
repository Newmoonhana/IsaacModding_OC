EFFECT = {}

EFFECT.ColorShader = false

local function GetScreenSize()
  local room = Game():GetRoom()
  local pos = room:WorldToScreenPosition(Vector.Zero) - room:GetRenderScrollOffset() - Game().ScreenShakeOffset

  local rx = pos.X + 60 * 26 / 40
  local ry = pos.Y + 140 * (26 / 40)

  return rx*2 + 13*26, ry*2 + 7*26
end

function EFFECT:GetShaderParams(shaderName)
    if shaderName == 'RandomColors' then
		if EFFECT.ColorShader == true then
			return { R = 2, G = 0.5, B = 0 }
		else
			return { R = 1, G = 1, B = 1 }
		end
    end
end
mod:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, EFFECT.GetShaderParams)