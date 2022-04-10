SpecterSword = {}

-- [변수]
SpecterSword.id = Isaac.GetItemIdByName('Specter Sword')
SpecterSword.playersword = nil
SpecterSword.SwordCount = 1
SpecterSword.animpath = "gfx/spectersword.anm2"

SpecterSword.Sword = {
    State = 0,
    Id = Isaac.GetEntityTypeByName("Specter Sword"),
    Type = "default",
    SubType = 580,
    Variant = Isaac.GetEntityVariantByName("Specter Sword"),

    TargetRotation = 0,

    SpriteOffset = Vector(0, -10)
};
SpecterSword.Hitbox = {
    Id = Isaac.GetEntityTypeByName("Specter Sword Hitbox"),
    Type = "default",
    Variant = Isaac.GetEntityVariantByName("Specter Sword Hitbox"),
    SubType = 581,
    DashSubType = 582
};
SpecterSword.Config = {
    
};

function ChangeDir(dirval)
	Sword.Direct = dirval
end

--------------------------------------------------
---- Sword
--------------------------------------------------
local sword_rotation
local aimname = "Center"
function SpecterSword:onUpdateSword(player)
    local sword = Isaac.Spawn(SpecterSword.Sword.Id, childIndex or 0, SpecterSword.Sword.SubType, player.Position, mod.ZeroVector, player)
    local sprite = sword:GetSprite()
    sword.DepthOffset = 10

    --local aimdir = player:GetShootingJoystick()

    -- 검이 일반 장착된 상태(Idle, Attack)일 때 4방향만 조작 가능
    local aimdir = player:GetAimDirection()
    if aimdir.Y == mod.Direction.Up.Y then
        aimname = "Up"
        sword.DepthOffset = -10
        sword_rotation = 180
    elseif aimdir.Y == mod.Direction.Down.Y then
        aimname = "Down"
        sword_rotation = 0
    elseif aimdir.X == mod.Direction.Left.X then
        aimname = "Left"
        sword_rotation = 90
    elseif aimdir.X == mod.Direction.Right.X then
        aimname = "Right"
        sword_rotation = 270
    end

    if aimname == "Center" then
        return
    end
    
    if sprite:IsPlaying("Attack"..aimname) == false then
        sword.SpriteRotation = sword_rotation
        sprite:Play("Attack"..aimname, false)
        --sprite:Play("Idle"..aimname, true)
    end

    -- At the start of a new room
    if (mod.room:GetFrameCount() == 1 or player.FrameCount == 1) and (SpecterSword.playersword == nil or not SpecterSword.playersword:Exists()) then
      SpecterSword.playersword = sword
    end
end

-- Post Player Update
function SpecterSword:PostPlayerUpdate(player)
    SpecterSword:onUpdateSword(player)
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, SpecterSword.PostPlayerUpdate)

-- Loads the correct graphics for the scythe.
--[[function SpecterSword:LoadSwordGraphics(Sprite, Type)
  local animFile = ""
  if Type == "sword" then
    animFile = SpecterSword.animpath
  else
    DEBUGMOD:DebugString(DEBUGMOD.type.error, "Sword Type is null")
    return
  end
  
  if Sprite:GetFilename() ~= animFile then
    Sprite:Load(animFile, true)
  end
  
  Sprite:ReplaceSpritesheet(0, "gfx/effects/specter sword/" .. Type .. ".png")
  Sprite:LoadGraphics()
end

-- Reloads the graphics for all scythes currently out (master + all children)
function SpecterSword:ReloadAllScytheGraphics(player)
  local sword = SpecterSword.playersword
  local Type = SpecterSword.Sword.Type
  local Sprite = sword:GetSprite()
  
  SpecterSword:LoadSwordGraphics(Sprite, Type)
  
  --for i=1,SwordCount - 1 do
  --  local childScytheSprite = sword:GetSprite()
  --  SpecterSword:LoadSwordGraphics(childScytheSprite, Type)
  --end
end

-- Spawn
function SpecterSword:SpawnSword(player, childIndex)
  local sword = Isaac.Spawn(SpecterSword.Sword.Id, childIndex or 0, 0, player.Position, mod.ZeroVector, player)
  sword.Parent = player
  sword.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
  sword:ClearEntityFlags(EntityFlag.FLAG_APPEAR) --Skip spawning animations
  sword:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
  sword:GetSprite().Rotation = SpecterSword.Sword.TargetRotation
  
  sword:Update()
  
  return sword
end

-- Determine the type of scythe the player should have (default, brimstone, etc)
function SpecterSword:UpdateSwordType(player)
  local newType = "default"

  if REPENTANCE and player:HasWeaponType(WeaponType.WEAPON_SPIRIT_SWORD) then
    newType = "sword"
  end
  
  if newType ~= SpecterSword.Sword.Type then
    SpecterSword.Sword.Type = newType
    SpecterSword:ReloadAllScytheGraphics(player)
  end
end

-- Post Player Update
function SpecterSword:PostPlayerUpdate(player)
    -- At the start of a new room
    if (mod.room:GetFrameCount() == 1 or player.FrameCount == 1) and (SpecterSword.playersword == nil or not SpecterSword.playersword:Exists()) then
      SpecterSword.playersword = SpecterSword:SpawnSword(player)
      SpecterSword:UpdateSwordType(player)
      
      if player.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_ALL then
        player.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
      end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, SpecterSword.PostPlayerUpdate)]]