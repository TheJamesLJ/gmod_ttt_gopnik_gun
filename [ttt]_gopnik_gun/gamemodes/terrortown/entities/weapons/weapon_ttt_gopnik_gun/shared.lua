if SERVER then
    AddCSLuaFile("shared.lua")

    resource.AddFile("materials/entities/vgui/ttt/icon_weapon_ttt_gopnik_gun.png")
    resource.AddFile("sound/weapons/gopnik_gun/shoot1.wav")
    resource.AddFile("sound/weapons/gopnik_gun/shoot2.wav")
    resource.AddFile("sound/weapons/gopnik_gun/day28_1.wav")
    resource.AddFile("sound/weapons/gopnik_gun/day28_2.wav")
    resource.AddFile("sound/weapons/gopnik_gun/day28_3.wav")
    resource.AddFile("sound/weapons/gopnik_gun/day28_4.wav")
    resource.AddFile("sound/weapons/gopnik_gun/day28_5.wav")
    resource.AddFile("sound/weapons/gopnik_gun/day28_6.wav")

    sound.Add({
        name = "Gopnik Gun.Shoot1",
        channel = CHAN_WEAPON,
        volume = 1.0,
        level = 80,
        pitch = {100, 100},
        sound = "weapons/gopnik_gun/shoot1.wav"
    })
    sound.Add({
        name = "Gopnik Gun.Shoot2",
        channel = CHAN_WEAPON,
        volume = 1.0,
        level = 80,
        pitch = {100, 100},
        sound = "weapons/gopnik_gun/shoot2.wav"
    })
    sound.Add({
        name = "Gopnik Gun.Hit1",
        channel = CHAN_WEAPON,
        volume = 1.0,
        level = 80,
        pitch = {100, 100},
        sound = "weapons/gopnik_gun/day28_1.wav"
    })
    sound.Add({
        name = "Gopnik Gun.Hit2",
        channel = CHAN_WEAPON,
        volume = 1.0,
        level = 80,
        pitch = {100, 100},
        sound = "weapons/gopnik_gun/day28_2.wav"
    })
    sound.Add({
        name = "Gopnik Gun.Hit3",
        channel = CHAN_WEAPON,
        volume = 1.0,
        level = 80,
        pitch = {100, 100},
        sound = "weapons/gopnik_gun/day28_3.wav"
    })
    sound.Add({
        name = "Gopnik Gun.Hit4",
        channel = CHAN_WEAPON,
        volume = 1.0,
        level = 80,
        pitch = {100, 100},
        sound = "weapons/gopnik_gun/day28_4.wav"
    })
    sound.Add({
        name = "Gopnik Gun.Hit5",
        channel = CHAN_WEAPON,
        volume = 1.0,
        level = 80,
        pitch = {100, 100},
        sound = "weapons/gopnik_gun/day28_5.wav"
    })
    sound.Add({
        name = "Gopnik Gun.Hit6",
        channel = CHAN_WEAPON,
        volume = 1.0,
        level = 80,
        pitch = {100, 100},
        sound = "weapons/gopnik_gun/day28_6.wav"
    })
end

if CLIENT then
    SWEP.PrintName = "Gopnik Gun"
    SWEP.Slot = 6

    SWEP.EquipMenuData = {
        type = "Weapon",
        desc = "Three Stripes"
}  ;

SWEP.Icon = "vgui/ttt/icon_weapon_ttt_gopnik_gun.png"
end

SWEP.Base = "weapon_tttbase"
SWEP.HoldType = "pistol"
SWEP.Kind = WEAPON_EQUIP1
SWEP.InLoadoutFor = nil
SWEP.LimitedStock = true
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.AllowDrop = true
SWEP.IsSilent = false
SWEP.NoSights = false
SWEP.AutoSpawnable = false

SWEP.Primary.Recoil = 3
SWEP.Primary.Damage = 1
SWEP.Primary.Delay = 1
SWEP.Primary.Cone = 0.01
SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = false
SWEP.Primary.DefaultClip = 1
SWEP.Primary.ClipMax = 1
SWEP.Primary.Ammo = "none"
SWEP.AmmoEnt = "none"

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel	= "models/weapons/w_pistol.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 60

SWEP.CanBuy = {ROLE_TRAITOR}
SWEP.LimitedStock = true

function SWEP:PrimaryAttack()
    if not self:CanPrimaryAttack() then return end
    self.Owner:EmitSound('Gopnik Gun.Shoot' .. math.random(1,2))
    local cone = self.Primary.Cone
    local num = 1
 
    local bullet = {}
    bullet.Num = num
    bullet.Src = self.Owner:GetShootPos()
    bullet.Dir = self.Owner:GetAimVector()
    bullet.Spread = Vector(cone, cone, 0)
    bullet.Tracer = 1
    bullet.Force = 10
    bullet.Damage = 1
    bullet.TracerName = "ToolTracer"

    bullet.Callback = function(attacker, tr)
        if SERVER or (CLIENT and IsFirstTimePredicted()) then
            local ent = tr.Entity
            if SERVER and ent:IsPlayer() then
    
                ent:EmitSound('Gopnik Gun.hit' .. math.random(1,6))
                ent:SelectWeapon("weapon_ttt_unarmed")
                ent:GodEnable()
                
                local timerName = "gopnik_gun_" .. math.random(1,10000)
                timer.Create(timerName, 1, 10, function()
                    ent:SelectWeapon("weapon_ttt_unarmed")
                    ent:DoAnimationEvent(ACT_MP_CROUCH_IDLE, 991)
                    if !ent:IsFrozen() then ent:Freeze(true) end
                end)

                ent:Freeze(true)
    
                timer.Simple(10, function() 
                    if ent:Alive() then
                        ent:GodDisable()
                        ent:Freeze(false)
                        local totalHealth = ent:Health() + 10
                        ent:TakeDamage(totalHealth, attacker, self.Weapon)
                        timer.Simple(2, function() if ent:IsFrozen() then ent:Freeze(false) end end)
                    end
                end)              
            end
        end
    end

    self.Owner:FireBullets(bullet)

    if SERVER then
      self:TakePrimaryAmmo(1)
    end
 end
 
 function SWEP:OnDrop()
     self:Remove()
 end