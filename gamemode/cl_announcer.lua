
local function  Announcer_Fight()
	surface.PlaySound( "vo/announcer_am_roundstart03.wav" )
end
usermessage.Hook("Announcer_Fight", Announcer_Fight)


local function  Announcer_Capture()
	surface.PlaySound( "vo/announcer_control_point_warning.wav" )
end
usermessage.Hook("Announcer_Capture", Announcer_Capture)


local function  Announcer_Success()
	surface.PlaySound( "vo/announcer_success.wav" )
end
usermessage.Hook("Announcer_Success", Announcer_Success)


local function  Announcer_Failure()
	surface.PlaySound( "vo/announcer_failure.wav" )
end
usermessage.Hook("Announcer_Failure", Announcer_Failure)


local function  Announcer_Overtime()
	surface.PlaySound( "vo/announcer_overtime.wav" )
end
usermessage.Hook("Announcer_Overtime", Announcer_Overtime)






local function  Buff_Start()
	surface.PlaySound( "weapons/buffed_on.wav" )
end
usermessage.Hook("Buff_Start", Buff_Start)


local function  Buff_End()
	surface.PlaySound( "weapons/buffed_off.wav" )
end
usermessage.Hook("Buff_End", Buff_End)




local function  Buy_Successful()
	surface.PlaySound( "buttons/blip1.wav" )
end
usermessage.Hook("Buy_Successful", Buy_Successful)

local function  Buy_Failed()
	surface.PlaySound( "buttons/button10.wav" )
end
usermessage.Hook("Buy_Failed", Buy_Failed)





local function  Sound_OnCooldown()
	surface.PlaySound( "buttons/button10.wav" )
end
usermessage.Hook("Sound_OnCooldown", Sound_OnCooldown)





local function  Sound_LimboKill()
	surface.PlaySound( "physics/flesh/flesh_squishy_impact_hard3.wav" )
end
usermessage.Hook("Sound_LimboKill", Sound_LimboKill)




local function Sound_TurnToBuy()
	surface.PlaySound( "ambient/alarms/razortrain_horn1.wav" )
end
usermessage.Hook("Sound_TurnToBuy", Sound_TurnToBuy)




local function Sound_BuyingDone()
	surface.PlaySound( "npc/scanner/scanner_alert1.wav" )
end
usermessage.Hook("Sound_BuyingDone", Sound_BuyingDone)





local function Sound_VotingEnd()
	surface.PlaySound( "buttons/button24.wav" )
end
usermessage.Hook("Sound_VotingEnd", Sound_VotingEnd)


