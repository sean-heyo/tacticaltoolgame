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

	
	//ability code
	------------------------------------------------------------------------------------------------
	self.Owner:EmitSound( self.Ref.shoot_sound )
	
	self:ThrowEnt()
	
	------------------------------------------------------------------------------------------------
	//ability code
	
	
	self:InitiateCooldown()
end



function ENT:ThrowEnt()
	if (!SERVER) then return end
	
	local obj = ents.Create(self.Ref.thrown_ent)

		local tr = self.Owner:GetEyeTrace();
		if ( tr.StartPos:Distance( tr.HitPos ) < 64 ) then 
			obj:SetPos(self.Owner:EyePos() + (self.Owner:GetAimVector()))
		else
			obj:SetPos(self.Owner:EyePos() + (self.Owner:GetAimVector() * 32))
		end
		

		obj.TTG_Team = self.Owner:Team()
		obj.Creator = self.Owner
		
		obj:SetOwner(self.Owner)
		obj:SetAngles( self.Owner:EyeAngles() )
		obj:Spawn()
		
		obj.TTG_Angles = (self.Owner:EyeAngles())
	
	//self.Owner:SetAnimation(PLAYER_ATTACK1)
	
	local phys = obj:GetPhysicsObject()
		phys:ApplyForceCenter (self.Owner:GetAimVector():GetNormalized() *  self.Ref.throw_force)
end