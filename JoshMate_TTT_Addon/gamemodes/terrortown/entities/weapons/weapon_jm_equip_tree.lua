AddCSLuaFile()

if CLIENT then
	SWEP.PrintName          = "Tree of Life"
	SWEP.Slot               = 6
 
	SWEP.ViewModelFlip      = false
 
	SWEP.EquipMenuData = {
	   type = "item_weapon",
	   desc = [[A Utility Weapon
	 
 Left Click: Place down a TOL
	
 Heals all players who stand nearby

 Must be placed of flat ground away from other TOLs
	
 3 uses and each tree lasts for (30 seconds)
 ]]
	};
 
	SWEP.Icon               = "vgui/ttt/joshmate/icon_jm_tree.png"

	function SWEP:GetViewModelPosition(pos, ang)
		return pos + ang:Forward() * 17 - ang:Right() * -7 - ang:Up() * 8, ang
	end
end

SWEP.Base                  = "weapon_jm_base_gun"
SWEP.HoldType              = "normal"

SWEP.Primary.Recoil        = 0
SWEP.Primary.Damage        = 0
SWEP.HeadshotMultiplier    = 0
SWEP.Primary.Delay         = 0.45
SWEP.Primary.Cone          = 0
SWEP.Primary.ClipSize      = 3
SWEP.Primary.DefaultClip   = 3
SWEP.Primary.ClipMax       = 0
SWEP.DeploySpeed           = 4
SWEP.Primary.SoundLevel    = 75
SWEP.Primary.Automatic     = false

SWEP.Kind                  = WEAPON_EQUIP
SWEP.CanBuy                = {ROLE_DETECTIVE} -- only traitors can buy
SWEP.LimitedStock          = true -- only buyable once
SWEP.WeaponID              = AMMO_TREE

SWEP.IsSilent              = true
SWEP.ViewModel             = "models/props_lab/cactus.mdl"
SWEP.WorldModel            = "models/props_lab/cactus.mdl"
SWEP.UseHands              = false

local JM_Tree_Place_Range		= 300




function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	if (CLIENT) then return end

	local tr = util.TraceLine({start = self.Owner:GetShootPos(), endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * JM_Tree_Place_Range, filter = self.Owner})
	if (tr.HitWorld or (tr.Entity:GetClass() == "func_breakable"))then
		local dot = vector_up:Dot(tr.HitNormal)
		if dot > 0.55 and dot <= 1 then
			local ent = ents.Create("ent_jm_equip_tree")
			ent:SetPos(tr.HitPos + tr.HitNormal)
			local ang = tr.HitNormal:Angle()
			ang:RotateAroundAxis(ang:Right(), -90)
			ent:SetAngles(ang)
			ent:Spawn()
			ent:SetOwner(self:GetOwner())
			ent.owner = self:GetOwner()
			ent.fingerprints = self.fingerprints
			self:TakePrimaryAmmo(1)
			if SERVER then
				if self:Clip1() <= 0 then
					self:Remove()
				end
			end
		end
	end	
end

function SWEP:SecondaryAttack()
end

-- ##############################################
-- Josh Mate Various SWEP Quirks
-- ##############################################

-- HUD Controls Information
if CLIENT then
	function SWEP:Initialize()
	   self:AddTTT2HUDHelp("Place where you are looking", nil, true)
 
	   return self.BaseClass.Initialize(self)
	end
end
-- Equip Bare Hands on Remove
if SERVER then
   function SWEP:OnRemove()
      if self:GetOwner():IsValid() and self:GetOwner():IsTerror() and self:GetOwner():Alive() then
         self:GetOwner():SelectWeapon("weapon_jm_special_hands")
      end
   end
end
-- Hide World Model when Equipped
function SWEP:DrawWorldModel()
   if IsValid(self:GetOwner()) then return end
   self:DrawModel()
end
function SWEP:DrawWorldModelTranslucent()
   if IsValid(self:GetOwner()) then return end
   self:DrawModel()
end
-- Delete on Drop
function SWEP:OnDrop() 
   self:Remove()
end

-- ##############################################
-- End of Josh Mate Various SWEP Quirks
-- ##############################################