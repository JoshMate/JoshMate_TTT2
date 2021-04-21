SWEP.HoldType = "melee"

if CLIENT then
	SWEP.PrintName = "Ninja Stick"
	SWEP.Slot = 0

	SWEP.DrawCrosshair = false
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 54

	SWEP.Icon = "vgui/ttt/joshmate/icon_jm_gun_mel"
end

SWEP.Base = "weapon_tttbase"

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/weapons/w_stunbaton.mdl"

SWEP.Primary.Damage = 55
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Delay = 0.30
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 2.5

SWEP.Kind                  = WEAPON_EQUIP
SWEP.WeaponID = AMMO_NINJASTICK

SWEP.NoSights = true
SWEP.IsSilent = true

SWEP.Weight = 5
SWEP.AutoSpawnable = false

SWEP.AllowDelete = true -- never removed for weapon reduction
SWEP.AllowDrop = true

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	local owner = self:GetOwner()
	if not IsValid(owner) then return end

	if isfunction(owner.LagCompensation) then -- for some reason not always true
		owner:LagCompensation(true)
	end

	local spos = owner:GetShootPos()
	local sdest = spos + owner:GetAimVector() * 100

	local tr_main = util.TraceLine({
		start = spos,
		endpos = sdest,
		filter = owner,
		mask = MASK_SHOT_HULL
	})

	local hitEnt = tr_main.Entity

	self:EmitSound("ninjastick_swing.wav")

	if IsValid(hitEnt) or tr_main.HitWorld then
		self:SendWeaponAnim(ACT_VM_HITCENTER)

		if SERVER or IsFirstTimePredicted() then
			local edata = EffectData()
			edata:SetStart(spos)
			edata:SetOrigin(tr_main.HitPos)
			edata:SetNormal(tr_main.Normal)
			edata:SetSurfaceProp(tr_main.SurfaceProps)
			edata:SetHitBox(tr_main.HitBox)
			--edata:SetDamageType(DMG_CLUB)
			edata:SetEntity(hitEnt)

			if hitEnt:IsPlayer() or hitEnt:GetClass() == "prop_ragdoll" then
				util.Effect("BloodImpact", edata)

				-- does not work on players rah
				--util.Decal("Blood", tr_main.HitPos + tr_main.HitNormal, tr_main.HitPos - tr_main.HitNormal)

				-- do a bullet just to make blood decals work sanely
				-- need to disable lagcomp because firebullets does its own
				owner:LagCompensation(false)
				owner:FireBullets({
					Num = 1,
					Src = spos,
					Dir = owner:GetAimVector(),
					Spread = Vector(0, 0, 0),
					Tracer = 0,
					Force = 1,
					Damage = 0
				})
				self:EmitSound("ninjastick_hit.wav")
			else
				util.Effect("Impact", edata)
			end
		end
	else
		self:SendWeaponAnim(ACT_VM_MISSCENTER)
	end

	if SERVER then

		-- Do another trace that sees nodraw stuff like func_button
		local tr_all = util.TraceLine({
			start = spos,
			endpos = sdest,
			filter = owner
		})

		local trEnt = tr_all.Entity

		owner:SetAnimation(PLAYER_ATTACK1)

		if IsValid(hitEnt) then
			local dmg = DamageInfo()
			dmg:SetDamage(self.Primary.Damage)
			dmg:SetAttacker(owner)
			dmg:SetInflictor(self)
			dmg:SetDamageForce(owner:GetAimVector() * 1500)
			dmg:SetDamagePosition(owner:GetPos())
			dmg:SetDamageType(DMG_CLUB)

			hitEnt:DispatchTraceAttack(dmg, spos + owner:GetAimVector() * 3, sdest)
		elseif IsValid(trEnt) then -- See if our nodraw trace got the goods
			self:OpenEnt(trEnt)
		end
	end

	if isfunction(owner.LagCompensation) then
		owner:LagCompensation(false)
	end
end

function SWEP:SecondaryAttack()

	self:SetNextSecondaryFire(CurTime() + 0.1)
	
	local owner = self:GetOwner()
	if not IsValid(owner) then return end
	
	local vel = owner:GetVelocity()
	vel.x = vel.x * 2.5
	vel.y = vel.y * 2.5
	vel.z = 300
	owner:SetVelocity(vel)

	self:EmitSound("ninjastick_dash.wav")
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)

end

-- Hud Help Text
if CLIENT then
	function SWEP:Initialize()
		self:AddTTT2HUDHelp("Melee attack", "Jump Dash", true)
 
	   return self.BaseClass.Initialize(self)
	end
end
if SERVER then
   function SWEP:OnRemove()
      if self.Owner:IsValid() and self.Owner:IsTerror() then
         self:GetOwner():SelectWeapon("weapon_ttt_unarmed")
      end
   end
end
--

function SWEP:OnDrop()
	self:Remove()
end
