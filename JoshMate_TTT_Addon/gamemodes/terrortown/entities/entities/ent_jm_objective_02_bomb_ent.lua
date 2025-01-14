if SERVER then
	AddCSLuaFile()
else
	ENT.PrintName = "Bomb"
end

ENT.Type = "anim"
ENT.Model = Model("models/Combine_Helicopter/helicopter_bomb01.mdl")

function ENT:Initialize()

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetModel(self.Model)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	self:SetRenderMode( RENDERMODE_TRANSCOLOR )
	self:SetColor(Color( 255, 0, 0, 255))
	
	self.Objective_Bomb_Press_Count 	= 0
	self.Objective_Bomb_Press_Max 		= 10
	self.Objective_Bomb_Press_Colour	= Color( 255, 0, 0, 255)

	if SERVER then
		self:SetUseType(SIMPLE_USE)
	end

	-- Josh Mate New Warning Icon Code
	JM_Function_SendHUDWarning(true,self:EntIndex(),"icon_warn_objective_bomb",self:GetPos(),0,0)
end

function ENT:Use( activator, caller )

	if CLIENT then return end

	if GetRoundState() == ROUND_POST or GetRoundState() == ROUND_PREP then return end

    if IsValid(activator) and activator:IsPlayer() and IsValid(self) and activator:IsTerror() and activator:Alive() then

		self:TakesHit(activator) 

	end
end

function ENT:TakesHit(activator) 

	if CLIENT then return end

	self.Objective_Bomb_Press_Count = self.Objective_Bomb_Press_Count + 1
	self:EmitSound("gamemode/file_hit.mp3")

	self.Objective_Bomb_Press_Colour = (self.Objective_Bomb_Press_Count * (255 / self.Objective_Bomb_Press_Max))
	self.Objective_Bomb_Press_Colour = Color( 255, 0 + self.Objective_Bomb_Press_Colour, 0 + self.Objective_Bomb_Press_Colour, 255)
	self:SetColor(self.Objective_Bomb_Press_Colour)

	if self.Objective_Bomb_Press_Count >= self.Objective_Bomb_Press_Max then

		JM_Function_PlaySound("pulsepad_hit.wav")

		local effect = EffectData()
		effect:SetOrigin(self:GetPos())
		util.Effect("cball_explode", effect)
		sound.Play(Sound("npc/assassin/ball_zap1.wav"), self:GetPos())

		self:Remove()

		if GetRoundState() == ROUND_POST or GetRoundState() == ROUND_PREP then return end

		local listOfObjectives = ents.FindByClass( "ent_jm_objective_02_bomb_ent" )
		local numberOfFilesLeft = (#listOfObjectives - 1)
		JM_Function_PrintChat_All("Defuse The Bombs", "A Bomb has been defused! (" .. tostring(numberOfFilesLeft) .. " Left!)")
		-- When removing this ent, also remove the HUD icon, by changing isEnabled to false
		JM_Function_SendHUDWarning(false,self:EntIndex())

		JM_Function_Karma_Reward(activator, JM_KARMA_REWARD_ACTION_OBJECTIVE_Bomb, "Bomb defused")

		if numberOfFilesLeft <= 0 then

			JM_Function_PrintChat_All("Defuse The Bombs", "All bombs have been defused!")
			JM_Function_PlaySound("gamemode/bomb_alldefused.wav")

		end
		
	end
end

function ENT:OnRemove()

	-- When removing this ent, also remove the HUD icon, by changing isEnabled to false
	JM_Function_SendHUDWarning(false,self:EntIndex())

end


-- ESP Halo effect

local JM_Server_Halo_Colour = Color(255,0,0,255)

hook.Add( "PreDrawHalos", "Halos_Bombs", function()

    halo.Add( ents.FindByClass( "ent_jm_objective_02_bomb" ), JM_Server_Halo_Colour, 5, 5, 2, true, true )
 
end )