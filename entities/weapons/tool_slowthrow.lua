AddCSLuaFile( "tool_slowthrow.lua" )

SWEP.Base = "base_ttgtool"


function SWEP:PrimaryAttack()
	if ( !self:CanPrimaryAttack() ) then return end

	self:TakePrimaryAmmo(1)
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	self:ShootEffects( self )
	
	if (!SERVER) then return end
		self.Owner:EmitSound( self.Ref.shoot_sound )
		self:ThrowEnt()
end


function SWEP:SecondaryAttack()
	return false
end

