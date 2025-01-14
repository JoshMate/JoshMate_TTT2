
AddCSLuaFile()

SWEP.HoldType              = "normal" 

if CLIENT then
   SWEP.PrintName          = "Agent Maker"
   SWEP.Slot               = 6

   SWEP.ViewModelFOV       = 54
   SWEP.ViewModelFlip      = false

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = [[A Set-Up Weapon
	
Using this on a player makes them an agent

Granting you vision of each other and giving them Detective tools

Does not Overwrite or Reveal their current role
]]
};

   function SWEP:GetViewModelPosition(pos, ang)
      return pos + ang:Forward() * 15 - ang:Right() * -5 - ang:Up() * 4, ang
   end

   SWEP.Icon               = "vgui/ttt/joshmate/icon_jm_agentmaker.png"
end

SWEP.Base                  = "weapon_jm_base_gun"

SWEP.Primary.Recoil        = 0
SWEP.Primary.Damage        = 0
SWEP.HeadshotMultiplier    = 0
SWEP.Primary.Delay         = 0.1
SWEP.Primary.Cone          = 0
SWEP.Primary.ClipSize      = 1
SWEP.Primary.DefaultClip   = 1
SWEP.Primary.ClipMax       = 0
SWEP.DeploySpeed           = 4
SWEP.Primary.SoundLevel    = 75
SWEP.Primary.Automatic     = false

SWEP.Primary.Sound         = nil
SWEP.Kind                  = WEAPON_EQUIP
SWEP.CanBuy                = {ROLE_DETECTIVE} -- only traitors can buy
SWEP.LimitedStock          = true -- only buyable once
SWEP.WeaponID              = AMMO_AGENTMAKER
SWEP.UseHands              = false
SWEP.ViewModel             = "models/props_lab/clipboard.mdl"
SWEP.WorldModel            = "models/props_lab/clipboard.mdl"

local JM_Shoot_Range                = 150

function SWEP:HitEffectsInit(ent)
   if not IsValid(ent) then return end

   local effect = EffectData()
   local ePos = ent:GetPos()
   if ent:IsPlayer() then ePos:Add(Vector(0,0,40))end
   effect:SetStart(ePos)
   effect:SetOrigin(ePos)
   
   
   
   util.Effect("cball_explode", effect, true, true)
end

function SWEP:ApplyEffect(ent,weaponOwner)

   if not IsValid(ent) then return end
   
   if SERVER then

      -- Give a Hit Marker to This Player
      local hitMarkerOwner = self:GetOwner()
      JM_Function_GiveHitMarkerToPlayer(hitMarkerOwner, 0, false)

      -- Make you and the target Agents
      JM_RemoveBuffFromThisPlayer("jm_buff_agent",ent)
      JM_GiveBuffToThisPlayer("jm_buff_agent",ent,self:GetOwner())
      ent:SetModel("models/player/leet.mdl")
      ent:SetColor(Color( 0, 255, 50 ))

      if ent:IsTraitor() then
         ent:AddCredits(1)
         JM_Function_PrintChat(ent, "Equipment","Agent Traitors earn +1 Credit")
      end


      local det = self:GetOwner()
      JM_RemoveBuffFromThisPlayer("jm_buff_agent",det)
      JM_GiveBuffToThisPlayer("jm_buff_agent",det,det)
      -- End of

      -- Play Sound to ALL
      JM_Function_PlaySound("shoot_agentmaker.wav") 

      -- Announce to all
      JM_Function_PrintChat_All("Equipment", self:GetOwner():Nick() .. " has made " .. ent:Nick() .. " an Agent")

      -- KARMA Reward
      JM_Function_Karma_Reward(ent, JM_KARMA_REWARD_ACTION_AGENT, "You got made an Agent")
      JM_Function_Karma_Reward(det, JM_KARMA_REWARD_ACTION_AGENT, "You made an Agent")

      -- Effects
      self:HitEffectsInit(ent)
      -- End of 

      -- Gives them DNA Scanner
      ent:Give("weapon_jm_equip_dna")
      ent:Give("weapon_jm_equip_binoculars")
      ent:Give("weapon_jm_equip_placer_visualiser")
      -- End Of

      -- Gives them Armour
      ent:GiveArmor(GetConVar("ttt_item_armor_value"):GetInt())
         

   end
end

function SWEP:PrimaryAttack()

   -- Weapon Animation, Sound and Cycle data
   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
   if not self:CanPrimaryAttack() then return end
   -- ####

   -- Fire Shot and apply on hit effects (Now with lag compensation to prevent whiffing)
   
   local owner = self:GetOwner()
   if not IsValid(owner) then return end

   if isfunction(owner.LagCompensation) then -- for some reason not always true
      owner:LagCompensation(true)
   end
   
   local tr = util.TraceLine({start = owner:GetShootPos(), endpos = owner:GetShootPos() + owner:GetAimVector() * JM_Shoot_Range, filter = owner})
   if (tr.Entity:IsValid() and tr.Entity:IsPlayer() and tr.Entity:IsTerror() and tr.Entity:Alive() and not tr.Entity:IsDetective())then
      if SERVER then
         self:ApplyEffect(tr.Entity, owner)
         self:Remove()
      end
   else
      if SERVER then
         JM_Function_PrintChat(owner, "Agent Maker","You can only use this on a Non-Detective, Alive Player")
      end
   end

   owner:LagCompensation(false)

   -- #########

end


function SWEP:SecondaryAttack()
   return
end





-- ##############################################
-- Josh Mate Various SWEP Quirks
-- ##############################################

-- HUD Controls Information
if CLIENT then
	function SWEP:Initialize()
	   self:AddTTT2HUDHelp("Turn a player into an Agent", nil, true)
 
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
