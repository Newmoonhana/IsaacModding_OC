DEBUGMOD = {}
DEBUGMOD.isDebug = true

DEBUGMOD.type = { debug="Debug String", error = "ERROR!" }

function DEBUGMOD:DebugString(type, str)
	if DEBUGMOD.isDebug == true then
		local debugstr = "[Serpent] "..type..": "..str.."\n"
		Isaac.DebugString(debugstr)
		Isaac.ConsoleOutput(debugstr)
	end
end

function DEBUGMOD:DebugValue(type, path, desc, val)
	local debugstr = "[Serpent] "..path..", "..type..": '"..desc.."="..val.."'\n"
	if DEBUGMOD.isDebug == true then
		Isaac.DebugString(debugstr)
		Isaac.ConsoleOutput(debugstr)
	end
end