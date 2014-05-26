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
	
	//if self.Owner.HasBuff_Shield == true then
		//self:CooldownSound()
	//return 
	//end
	
	
	if self.Owner:HowManyOfThisBuff( "Buff_Shield" ) > 0 then
		self:CooldownSound()
	return 
	end
	
	
	//ability code
	//self.Owner:BuffForDuration_Shield( self.Ref.duration )
	
	self.Owner:AddBuff( "Buff_Shield", self.Ref.duration )
	
	
	self:InitiateCooldown()
end