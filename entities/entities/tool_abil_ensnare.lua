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
	

	local orgin_ents = ents.FindInSphere( self.Owner:GetPos(), self.Ref.radius )
	
	--explodes when any enemy players are within the radius
	for k, ent in pairs( orgin_ents ) do
		if ent:IsValidGamePlayer() and ent:Team() != self.Owner:Team() then
		
			//ent:BuffForDuration_Ensnare( self.Ref.duration )
			ent:AddBuff( "Buff_Snare", self.Ref.duration )
			
		end
	end
	
	self.Owner:EmitSound( self.Ref.sound_ensnare )

	self:InitiateCooldown()
end