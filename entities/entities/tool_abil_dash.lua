ENT.Type 	= "point"
ENT.Base 	= "base_ttgabil"


if !SERVER then return end
------------------------------------------------------------------------------------------------
--all server from now on
------------------------------------------------------------------------------------------------


function ENT:DoAbility()
	if self.Cooldown == true then
		self:CooldownSound()
	return 
	end

	
	
	if self.Owner:OnGround() then
		self.Owner:EmitSound( self.Ref.shoot_sound )
		local aim = self.Owner:GetForward() 
			self.Owner:SetVelocity( Vector(aim[1], aim[2], 0) * self.Ref.force + Vector(0, 0, 300))
			
		self:InitiateCooldown()
	else
		self.Owner:EmitSound( self.Ref.shoot_sound )
		local aim = self.Owner:GetForward() 
			self.Owner:SetVelocity( Vector(aim[1], aim[2], 0) * self.Ref.force )
		
		self:InitiateCooldown()
		
	end

	
	
	
end