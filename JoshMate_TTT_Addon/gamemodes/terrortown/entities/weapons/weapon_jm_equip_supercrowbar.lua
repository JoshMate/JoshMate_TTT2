local JM_SuperCrowBar_Force_Forward = 2000
local JM_SuperCrowBar_Force_Up = 600

if SERVER then
	AddCSLuaFile()

end

SWEP.HoldType = "melee"

if CLIENT then
	SWEP.PrintName = "Super Crowbar"
	SWEP.Slot = 7

	SWEP.EquipMenuData = {
		type = "item_weapon",
		desc = [[A Lethal Melee Weapon
	  
A regular looking crowbar that has huge push force

Right or Left Click a player to launch them

Has 2 uses
]]
	 };

	SWEP.DrawCrosshair = false
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 54

	SWEP.Icon = "vgui/ttt/joshmate/icon_jm_supercrowbar.png"

	function SWEP:GetViewModelPosition(pos, ang)
		return pos + ang:Forward() * 5 - ang:Right() * -5 - ang:Up() * -10, ang
	end
end

local SuperCrowbar_Range	= 130

SWEP.Base = "weapon_jm_base_gun"

SWEP.UseHands = false
SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

SWEP.Primary.Damage = 0
SWEP.Primary.ClipSize = 2
SWEP.Primary.DefaultClip = 2
SWEP.Primary.Automatic = true
SWEP.Primary.Delay = 1
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 1

SWEP.Kind = WEAPON_EQUIP1
SWEP.WeaponID = AMMO_SUPERCROWBAR

SWEP.NoSights = true
SWEP.IsSilent = true

SWEP.Weight					= 5
SWEP.Slot			    	= 7
SWEP.AutoSpawnable = false

SWEP.AllowDrop = true
SWEP.CanBuy 				= { ROLE_TRAITOR}
SWEP.LimitedStock 			= true

local sound_single = Sound("Weapon_Crowbar.Single")

function SWEP:Push()
	self:SetNextPrimaryFire(CurTime() + 0.1)
	self:SetNextSecondaryFire(CurTime() + 0.1)

	local owner = self:GetOwner()
	if not IsValid(owner) then return end

	if isfunction(owner.LagCompensation) then
		owner:LagCompensation(true)
	end

	local tr = owner:GetEyeTrace(MASK_SHOT)
	local ply = tr.Entity

	if tr.Hit and IsValid(ply) and ply:IsPlayer() and (owner:EyePos() - tr.HitPos):Length() < SuperCrowbar_Range then
		if SERVER and not ply:IsFrozen() and not hook.Run("TTT2PlayerPreventPush", owner, ply) then
			local pushvel = tr.Normal * JM_SuperCrowBar_Force_Forward

			pushvel.z = JM_SuperCrowBar_Force_Up -- limit the upward force to prevent launching

			ply:SetVelocity(ply:GetVelocity() + pushvel)
			owner:SetAnimation(PLAYER_ATTACK1)

			 -- Give a Hit Marker to This Player
			 local hitMarkerOwner = self:GetOwner()
			 JM_Function_GiveHitMarkerToPlayer(hitMarkerOwner, 0, false)

			 -- Disorientated Debuff on Explosion
			if (SERVER) then
				JM_GiveBuffToThisPlayer("jm_buff_explosion",ply,self:GetOwner())
			end

			 -- JM New Was Pushed Attribution System
			 newWasPushedContract = ents.Create("ent_jm_equip_waspushed")
			 newWasPushedContract.pusher = owner
			 newWasPushedContract.target = ply
			 newWasPushedContract.weapon = self:GetClass()
			 newWasPushedContract:Spawn()
			 ply.was_pushed = newWasPushedContract
			 --
		end

		self:TakePrimaryAmmo( 1 )
		self:EmitSound(sound_single)
		self:SendWeaponAnim(ACT_VM_HITCENTER)
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	end

	if isfunction(owner.LagCompensation) then
		owner:LagCompensation(false)
	end

	if SERVER then
		if self:Clip1() <= 0 then
		   self:Remove()
		end
	 end

end


function SWEP:PrimaryAttack()

	self:Push()

end

function SWEP:SecondaryAttack()
	
	self:Push()

end

-- ##############################################
-- Josh Mate Various SWEP Quirks
-- ##############################################

-- HUD Controls Information
if CLIENT then
	function SWEP:Initialize()
	   self:AddTTT2HUDHelp("YEET a player across map", "YEET a player across map", true)
 
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
-- Delete on Drop
function SWEP:OnDrop() 
	self:Remove()
 end

-- ##############################################
-- End of Josh Mate Various SWEP Quirks
-- ##############################################
