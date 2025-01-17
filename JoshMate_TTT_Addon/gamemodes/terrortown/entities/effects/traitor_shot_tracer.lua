
function EFFECT:Init(data)
   self.ShotStart = data:GetStart()
   self.ShotEnd   = data:GetOrigin()

   -- ws = worldspace
   self:SetRenderBoundsWS(self.ShotStart, self.ShotEnd)

   self.HitBox    = data:GetMagnitude()

   self.Duration  = data:GetScale() or 0
   self.EndTime   = CurTime() + self.Duration

   self.FadeTime = 3

   self.FadeIn   = CurTime() + self.FadeTime
   self.FadeOut  = self.EndTime - self.FadeTime

   self.Width = 6
   self.WidthMax = 8
end

function EFFECT:Think()
   if self.EndTime < CurTime() then
      return false
   end

   if self.FadeIn > CurTime() then
      self.Width = self.WidthMax * (1 - ((self.FadeIn - CurTime()) / self.FadeTime))
   elseif self.FadeOut < CurTime() then
      self.Width = self.WidthMax * (1 - ((CurTime() - self.FadeOut) / self.FadeTime))
   end


   return true
end

local shot_mat = Material("cable/redlaser")
local clr = Color(255, 0, 0, 255)
function EFFECT:Render()
   render.SetMaterial(shot_mat)
   render.DrawBeam(self.ShotStart, self.ShotEnd, self.Width, 0, 0, clr)
end
