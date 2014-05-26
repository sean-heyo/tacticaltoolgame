//all shared files go here
include( 'shared.lua' )
include( 'ttg_player.lua' )
include( "table_tool.lua" )
include( "table_ent.lua" )
include( "table_shop.lua" )
include( "table_buff.lua" )
include( "meta_ent.lua" )
include( "meta_swep.lua" )
include( "shared_settings.lua" )

--metaplayer
include( 'metaplayer/metaplayer_abilities.lua' )
include( 'metaplayer/metaplayer_aimtarget.lua' )
include( 'metaplayer/metaplayer_currency.lua' )
include( 'metaplayer/metaplayer_freeze.lua' )
include( 'metaplayer/metaplayer_invis.lua' )
include( 'metaplayer/metaplayer_invuln.lua' )
include( 'metaplayer/metaplayer_limbo.lua' )
include( 'metaplayer/metaplayer_buffs.lua' )

//all client files go here
include("cl_teammenu.lua")
include("cl_buymenu.lua")
include("cl_timedisplay.lua")
include("cl_purchasesmenu.lua")
include("cl_inventory.lua")
include("cl_capturedisplay.lua")
include("cl_announcer.lua")
include("cl_hudscore.lua")
include("cl_deathnotice.lua")
include("cl_teammenu_specjoin.lua")
include("cl_turntobuy.lua")
include("cl_purchasesmenu_spec.lua")
include("cl_startscreenlogo.lua")
include("cl_hud_headbars.lua")
include("cl_scoreboard.lua")
include("cl_typecommands.lua")
include("cl_helpmenu.lua")



function ClearOldClientVars()
	for k,v in pairs(player.GetAll()) do
		v.HealthDropping = false
	end
end
usermessage.Hook( "ClearOldClientVars", ClearOldClientVars )



--makes it so it doesnt draw players names and their hp% when you look at them
function GM:HUDDrawTargetID()
     return false
end



local tohide = { -- This is a table where the keys are the HUD items to hide
	["CHudHealth"] = true,
	["CHudBattery"] = false,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true
}

local function HUDShouldDraw(name) -- This is a local function because all functions should be local unless another file needs to run it
	if (tohide[name]) then     -- If the HUD name is a key in the table
		return false;      -- Return false.
	end
end
hook.Add("HUDShouldDraw", "HUD hider", HUDShouldDraw)

 


 
 surface.CreateFont( "TheDefaultSettings", {
	 font = "Arial",
	 size = 120,
	 weight = 500,
	 blursize = 0,
	 scanlines = 0,
	 antialias = true,
	 underline = false,
	 italic = false,
	 strikeout = false,
	 symbol = false,
	 rotary = false,
	 shadow = false,
	 additive = false,
	 outline = false
	} )
	
 surface.CreateFont( "SmallerFont", {
	 font = "Arial",
	 size = 60,
	 weight = 500,
	 blursize = 0,
	 scanlines = 0,
	 antialias = true,
	 underline = false,
	 italic = false,
	 strikeout = false,
	 symbol = false,
	 rotary = false,
	 shadow = false,
	 additive = false,
	 outline = false
	} )
 
  surface.CreateFont( "NewSmallerFont", {
	 font = "Arial",
	 size = 40,
	 weight = 500,
	 blursize = 0,
	 scanlines = 0,
	 antialias = true,
	 underline = false,
	 italic = false,
	 strikeout = false,
	 symbol = false,
	 rotary = false,
	 shadow = false,
	 additive = false,
	 outline = false
	} )
 
 

 
 
 

/*---------------------------------------------------------
	Hud features
---------------------------------------------------------*/
function hud()


	local Ply = LocalPlayer()
	




	
	
	

	
/*---------------------------------------------------------
	Capture Zone Marker
---------------------------------------------------------*/
	--this global vector is set inside marker_capturezone, when the marker is created
	//local markervec = GetGlobalVector( "MarkerPos" )
	//local PosScr = markervec:ToScreen() 
		//draw.SimpleTextOutlined("[ ]", "default", PosScr.x, PosScr.y, white, 1, 1, 1, Color(0, 0, 0, 255))
	
	local function DrawCapMarker()
		for k,ent in pairs( ents.GetAll() ) do
			if ent:GetClass() == "marker_capturezone" then
				local PosScr = ent:GetPos():ToScreen() 
				draw.SimpleTextOutlined("[ ]", "default", PosScr.x, PosScr.y, white, 1, 1, 1, Color(0, 0, 0, 255))
				//return
			end
		end
	end
	DrawCapMarker()

	
	
	
/*---------------------------------------------------------
	Aim Target setting stuff, the auto aim feature some weapons have
---------------------------------------------------------*/
--Not currently used

	if Ply:GetIfAimTarget() then

		local function GetDistance ( x1, y1, x2, y2 )
			local dx = x1 - x2
			local dy = y1 - y2
			return math.sqrt ( dx * dx + dy * dy )
		end
		
		
		local screen_center = {x = (ScrW()/2), y = (ScrH()/2)}
		
		local lowest_dist = {ply = nil, dist = nil, x = nil, y = nil}
		
		for k,info in pairs( Names_On_Hud ) do
			local distance = GetDistance( info.x , info.y , screen_center.x , screen_center.y )
			
			if IsValid( lowest_dist.ply ) then
				if distance < lowest_dist.dist then
					lowest_dist = {ply = info.ply, dist = distance, x = info.x, y = info.y}
				end
			else
				lowest_dist = {ply = info.ply, dist = distance, x = info.x, y = info.y}
			end
		end
		
		
		local function GetIfTooFar(other_ply)
			local max_dist = Ply:GetAimTargetMaxDist()
			local ply_dist = Ply:GetPos():Distance(other_ply:GetPos())
			if ply_dist < max_dist then
				return false
			else
				return true
			end
		end
		
		--draw special aiming icon on the player you're aiming at
		if lowest_dist.ply != nil then
			local lowestdistply = lowest_dist.ply
		
			--redo this to only run the command when the target changes, not every think
			RunConsoleCommand( "ttg_setaimtarget", lowestdistply:UniqueID( ) )

			
			local alpha = 255
			if GetIfTooFar( lowest_dist.ply ) then
				alpha = 10
			end
			
			draw.SimpleTextOutlined("O", "SmallerFont", lowest_dist.x, lowest_dist.y, Color(255, 255, 255, alpha), 1, 1, 1, Color(0, 0, 0, 255))
		end
		
		--draw smaller icon on other players you could be aiming at if you moved your crosshairs towards them
		for k,info in pairs( Names_On_Hud ) do
			if info.ply != lowest_dist.ply then
				local alpha = 255
				if GetIfTooFar( info.ply ) then
					alpha = 10
				end
			
				draw.SimpleTextOutlined("x", "SmallerFont", info.x, info.y, Color(255, 255, 255, alpha), 1, 1, 1, Color(0, 0, 0, 255))
			end
		end
	end
	
	
	
	
	
	
	
	
	
	
	
	
/*---------------------------------------------------------
	Revealer Marker
---------------------------------------------------------*/
	local function DrawMark( ent, mark, color )
		local PosScr = ent:GetPos():ToScreen()
		draw.SimpleTextOutlined( mark, "SmallerFont", PosScr.x, PosScr.y, color, 1, 1, 1, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
	end
	

	--[[
	--mark players
	for k,ent in pairs( ents.GetAll() ) do
		if ent:Get_RevealerMarkerNum() >= 1 then
		
			if ent:IsValidGamePlayer() then
				if ent:Team() == TEAM_RED then
					DrawMark( ent, "x", Color(255, 0, 0, 255) )
				elseif ent:Team() == TEAM_BLUE then 
					DrawMark( ent, "x", Color(0, 0, 255, 255) )
				end

			else
				if ent:GetEntTeamForClient() == TEAM_RED then
					DrawMark( ent, "x", Color(255, 0, 0, 255) )
				elseif ent:GetEntTeamForClient() == TEAM_BLUE then
					DrawMark( ent, "x", Color(0, 0, 255, 255) )
				else
					DrawMark( ent, "x", Color(255, 255, 255, 255) )
				end

			end
			
			
		end
	end
	]]--
	
	
	
	--mark enemy players
	if LocalPlayer():Team() != TEAM_SPEC then
		for k,ent in pairs( ents.GetAll() ) do
			if ent:GetClass() == "ent_revealer" and ent:GetEntTeamForClient() == LocalPlayer():Team() then
				local ref = EntReference( ent:GetClass() )
				local orgin_ents = ents.FindInSphere( ent:GetPos(), ref.radius )
			
				--mark all enemy players in the origin of the radar, (except if theyre invisible)
				for k, in_ent in pairs( orgin_ents ) do
					if in_ent:IsValidGamePlayer() and not in_ent:GetIfInvisible() and in_ent:HowManyOfThisBuff( "Buff_BarrelDisguise" ) == 0 and in_ent:Team() != LocalPlayer():Team() then
						local color = Color(255, 255, 255, 255)
						if in_ent:Team() == TEAM_BLUE then
							color = Color(0, 0, 255, 255)
						elseif in_ent:Team() == TEAM_RED then
							color = Color(255, 0, 0, 255)
						end
						
						DrawMark( in_ent, "x", color )
					end
				end
			end
		end
	
	--mark playets for spectators so they know who sees who on radar
	elseif LocalPlayer():Team() == TEAM_SPEC then
		for k,ent in pairs( ents.GetAll() ) do
			if ent:GetClass() == "ent_revealer" then
				local ref = EntReference( ent:GetClass() )
				local orgin_ents = ents.FindInSphere( ent:GetPos(), ref.radius )
			
				--mark all enemy players in the origin of the radar, (except if theyre invisible)
				for k, in_ent in pairs( orgin_ents ) do
					if in_ent:IsValidGamePlayer() and not in_ent:GetIfInvisible() and in_ent:HowManyOfThisBuff( "Buff_BarrelDisguise" ) == 0 and in_ent:Team() != ent:GetEntTeamForClient() then
						local color = Color(255, 255, 255, 255)
						if in_ent:Team() == TEAM_BLUE then
							color = Color(0, 0, 255, 255)
						elseif in_ent:Team() == TEAM_RED then
							color = Color(255, 0, 0, 255)
						end
						
						DrawMark( in_ent, "x", color )
					end
				end
			end
		end
	end
	
	
	

	
	
	--mark players
	//for k,ent in pairs( player.GetAll() ) do
		//if ent:GetIfMarked() then
			//local PosScr = ent:GetPos():ToScreen()
			
			//draw.SimpleTextOutlined("x", "SmallerFont", PosScr.x, PosScr.y, Color(0, 255, 0, 255), 1, 1, 1, Color(0, 0, 0, 255))
		//end
	//end
	
	
	
	
	
	
	
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	----Player must be alive for the rest of this stuff.....
	if !(Ply && Ply:Alive()) then
		return
	end
	
	
	
	

	
	
/*---------------------------------------------------------
	Bad Crosshair
---------------------------------------------------------*/
	draw.RoundedBox(20, (ScrW()/2)-5, (ScrH() / 2)-5, 10, 10, Color(0,0,0,75))
	
	
	
	
/*---------------------------------------------------------
	Buff Hud display stuff
---------------------------------------------------------*/
--[[
	
	local function AddBuffDisplay( display, y, isnerf )
		local color = Color(50,70,50,220)
		if isnerf == true then
			color = Color(100,50,50,220)
		end
		
		draw.RoundedBox(0, ((ScrW()/2) - 200), (y - 15) , 400, 60, color)
		draw.SimpleText( display, "DermaLarge", ScrW()/2, y, Color(255,255,255,255), TEXT_ALIGN_CENTER)
	end
	
	
	local t_buffs = Ply:GetBuffInfo()
	local height = (ScrH() - 50)
	
	for _, buff in pairs( t_buffs ) do
		if buff.on == true then
			AddBuffDisplay( buff.display, height, buff.isnerf )
			height = height - 70
		end
	end
	
	--little box that displays if the player is invulnerable at the time
	//if (Ply:GetInvulnInfo()) then
		//draw.RoundedBox(0, 240, ScrH()-65, 45, 65, Color(50,50,50,220))		
	//end
]]--	

	local function AddBuffDisplay( buffname, y, timeleft, showtime )
		local ref = Buff_Reference( buffname )
		
		//local color = Color(50,70,50,220)
		//if ref.is_nerf == true then
			//color = Color(100,50,50,220)
		//end
		local color = Color( ref.color.r, ref.color.g, ref.color.b, 180 )
		
		draw.RoundedBox(0, ((ScrW()/2) - 200), (y - 15) , 400, 60, color)
		
		if showtime == true then
			if timeleft > 0 then
				draw.SimpleText( ref.display .. " - " .. timeleft, "DermaLarge", ScrW()/2, y, Color(255,255,255,255), TEXT_ALIGN_CENTER)
			else
				draw.SimpleText( ref.display, "DermaLarge", ScrW()/2, y, Color(255,255,255,255), TEXT_ALIGN_CENTER)
			end
		else
			draw.SimpleText( ref.display, "DermaLarge", ScrW()/2, y, Color(255,255,255,255), TEXT_ALIGN_CENTER)
		end
		--[[
		if timeleft > 0 and showtime == true then
			draw.SimpleText( ref.display .. " - " .. timeleft, "DermaLarge", ScrW()/2, y, Color(255,255,255,255), TEXT_ALIGN_CENTER)
		elseif showtime == false or timeleft == 0 then
			draw.SimpleText( ref.display, "DermaLarge", ScrW()/2, y, Color(255,255,255,255), TEXT_ALIGN_CENTER)
		end
		]]--
	end
	
	
	
	local t_buffs = Ply:GetBuffInfoTable(  )
	local height = (ScrH() - 50)
	
	for _, buff in pairs( t_buffs ) do
		if buff.name != "none" then
			AddBuffDisplay( buff.name, height, buff.timeleft, buff.showtime )
			height = height - 70
		end
	end

	
	
	
	
/*---------------------------------------------------------
	Ability HUD info
---------------------------------------------------------*/	
	local Ability_A = Ply:GetAbilityInfo("a")
	
	if Ability_A.name != "none" then

		draw.RoundedBox(0, 0, ScrH()-185, 85, 45, Color(50,50,50,255))			--background box
		
		draw.RoundedBox(0, 85, ScrH()-180, 190, 35, Color(50,50,50,180))			--2nd background box
		
		draw.SimpleText("'IN_SPEED'", "Trebuchet18", 40, ScrH() - 178, Color(255,255,255,255), TEXT_ALIGN_CENTER) 
		if (Ability_A.cooldown) == true then
			draw.SimpleText( ConvertToPrintName(Ability_A.name), "DermaLarge", 100, ScrH() - 178, Color(255,100,100,255)) 
			draw.SimpleText( Ability_A.time, "DermaLarge", 250, ScrH() - 178, Color(255,100,100,255), TEXT_ALIGN_CENTER) 
		else
			draw.SimpleText( ConvertToPrintName(Ability_A.name), "DermaLarge", 100, ScrH() - 178, Color(200,200,200,255)) 
		end
	end
	
	
	
	local Ability_B = Ply:GetAbilityInfo("b")
	
	if Ability_B.name != "none" then

		draw.RoundedBox(0, 0, ScrH()-235, 85, 45, Color(50,50,50,255))			--background box
		
		draw.RoundedBox(0, 85, ScrH()-230, 190, 35, Color(50,50,50,180))			--2nd background box
		
		draw.SimpleText("'IN_USE'", "Trebuchet18", 40, ScrH() - 228, Color(255,255,255,255), TEXT_ALIGN_CENTER) 
		if (Ability_B.cooldown) == true then
			draw.SimpleText( ConvertToPrintName(Ability_B.name), "DermaLarge", 100, ScrH() - 228, Color(255,100,100,255)) 
			draw.SimpleText( Ability_B.time, "DermaLarge", 250, ScrH() - 228, Color(255,100,100,255), TEXT_ALIGN_CENTER) 
		else
			draw.SimpleText( ConvertToPrintName(Ability_B.name), "DermaLarge", 100, ScrH() - 228, Color(200,200,200,255)) 
		end
	end
	
	
	local Ability_C = Ply:GetAbilityInfo("c")
	
	if Ability_C.name != "none" then

		draw.RoundedBox(0, 0, ScrH()-285, 85, 45, Color(50,50,50,255))			--background box
		
		draw.RoundedBox(0, 85, ScrH()-280, 190, 35, Color(50,50,50,180))			--2nd background box
		
		draw.SimpleText("'IN_WALK'", "Trebuchet18", 40, ScrH() - 278, Color(255,255,255,255), TEXT_ALIGN_CENTER) 
		if (Ability_C.cooldown) == true then
			draw.SimpleText( ConvertToPrintName(Ability_C.name), "DermaLarge", 100, ScrH() - 278, Color(255,100,100,255)) 
			draw.SimpleText( Ability_C.time, "DermaLarge", 250, ScrH() - 278, Color(255,100,100,255), TEXT_ALIGN_CENTER) 
		else
			draw.SimpleText( ConvertToPrintName(Ability_C.name), "DermaLarge", 100, ScrH() - 278, Color(200,200,200,255)) 
		end
	end
	
	
	
	
	
	
/*---------------------------------------------------------
	Swep Name and Ammo
---------------------------------------------------------*/	
	if Ply:GetActiveWeapon( ) != NULL then
		local SwepName = Ply:GetActiveWeapon( ):GetPrintName()
		local NumGuns = Ply:GetActiveWeapon( ):GetNumGuns()
		local Amount = ""
		if NumGuns == 1 then
			Amount = ""
		elseif NumGuns == 2 then
			Amount = "Double "
		elseif NumGuns == 3 then
			Amount = "Triple "
		end
		
		draw.RoundedBox(2, ScrW()-350, ScrH() - 140, 350, 55, Color(50,50,50,255))	
		draw.RoundedBox(2, ScrW()-220, ScrH() - 85, 350, 85, Color(100,100,100,150))	
		draw.SimpleText(Amount .. SwepName,"NewSmallerFont",ScrW()-343, ScrH() - 140,Color(255,255,255,255))
		
		local Ammo = Ply:GetActiveWeapon( ):Clip1() 
		
		
		if Ammo != -1 then
			if Ammo < 100 then
				if Ammo < 10 then
					if Ammo == 0 then
						draw.SimpleText("000", "TheDefaultSettings", ScrW()-200, ScrH() - 100, Color(255,150,150,255))
					else
						draw.SimpleText("00" .. Ammo, "TheDefaultSettings", ScrW()-200, ScrH() - 100, Color(255,255,255,255))
					end
				else
					draw.SimpleText("0" .. Ammo, "TheDefaultSettings", ScrW()-200, ScrH() - 100, Color(255,255,255,255))
				end
			else
				draw.SimpleText( Ammo, "TheDefaultSettings", ScrW()-200, ScrH() - 100, Color(255,255,255,255))
			end
		end
		
		
		
		//if Ply:GetActiveWeapon( ):GetClass() != "default_melee" then
	
			local toolref = ToolReference(Ply:GetActiveWeapon( ):GetClass())
			local ShouldReload = false
			
			if toolref.class == "gun" and Ammo == 0 then
				ShouldReload = true
			end
			
			if ShouldReload then
				draw.SimpleText("RELOAD", "SmallerFont", ScrW()-250, ScrH() - 75, Color(200,200,255,255))
			end
		//end
		
		
		--descriptions of binds
		local shopref = Shop_ToolReference( Ply:GetActiveWeapon( ):GetClass() )
		if shopref != nil then
			draw.SimpleTextOutlined( "Primary:", "TargetID", ScrW()-8, ScrH() - 300, Color(180, 180, 180, 255), TEXT_ALIGN_RIGHT, 1, 1, Color(0, 0, 0, 255) )
			draw.SimpleTextOutlined( "Secondary:", "TargetID", ScrW()-8, ScrH() - 250, Color(180, 180, 180, 255), TEXT_ALIGN_RIGHT, 1, 1, Color(0, 0, 0, 255) )
			draw.SimpleTextOutlined( "Reload:", "TargetID", ScrW()-8, ScrH() - 200, Color(180, 180, 180, 255), TEXT_ALIGN_RIGHT, 1, 1, Color(0, 0, 0, 255) )
			
			if shopref.bind_primary != nil then
				draw.SimpleTextOutlined( shopref.bind_primary, "default", ScrW()-10, ScrH() - 285, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, 1, 1, Color(0, 0, 0, 255),TEXT_ALIGN_RIGHT )
			else
				draw.SimpleTextOutlined( "---------------------", "default", ScrW()-10, ScrH() - 285, Color(180, 180, 180, 255), TEXT_ALIGN_RIGHT, 1, 1, Color(0, 0, 0, 255),TEXT_ALIGN_RIGHT )
			end
			
			if shopref.bind_alt != nil then
				draw.SimpleTextOutlined( shopref.bind_alt, "default", ScrW()-10, ScrH() - 235, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, 1, 1, Color(0, 0, 0, 255),TEXT_ALIGN_RIGHT )
			else
				draw.SimpleTextOutlined( "---------------------", "default", ScrW()-10, ScrH() - 235, Color(180, 180, 180, 255), TEXT_ALIGN_RIGHT, 1, 1, Color(0, 0, 0, 255),TEXT_ALIGN_RIGHT )
			end
		
			if shopref.bind_r != nil then
				draw.SimpleTextOutlined( shopref.bind_r, "default", ScrW()-10, ScrH() - 185, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, 1, 1, Color(0, 0, 0, 255),TEXT_ALIGN_RIGHT )
			else
				draw.SimpleTextOutlined( "---------------------", "default", ScrW()-10, ScrH() - 185, Color(180, 180, 180, 255), TEXT_ALIGN_RIGHT, 1, 1, Color(0, 0, 0, 255),TEXT_ALIGN_RIGHT )
			end
		end
		
	end
	

	

/*---------------------------------------------------------
	Healthbar
---------------------------------------------------------*/
	if LocalPlayer():GetObserverMode() != OBS_MODE_NONE then return end
	
	local health = LocalPlayer():Health()
	if health <= 0 then
		health = 0
	end
	
	local health_color = Color(255,255,255,255)
	local health_color_bg = Color(100,100,100,255)
	
	if LocalPlayer():Team() == TEAM_RED then
		health_color = Color(255,0,0,255)
		health_color_bg = Color(100,0,0,255)
	elseif LocalPlayer():Team() == TEAM_BLUE then
		health_color = Color(0,0,255,255)
		health_color_bg = Color(0,0,100,255)
	end
	
	draw.RoundedBox(0, 0, ScrH()-45, 220, 45, Color(50,50,50,255))			--background box
	draw.RoundedBox(0, 10, ScrH() - 15 - 20, 200, 25, health_color_bg) --background health bar
	draw.RoundedBox(0, 10, ScrH() - 15 - 20, health*2, 25, health_color) --changing health bar
	draw.SimpleText(health, "DermaLarge", 10, ScrH() - 50, Color(255,255,255,255)) --health number text
	
	
	
	--little box that displays if the player is invulnerable at the time
	if (Ply:GetInvulnInfo()) then
		draw.RoundedBox(0, 0, ScrH()-110, 285, 45, Color(50,50,50,220))	
		draw.RoundedBox(0, 240, ScrH()-65, 45, 65, Color(50,50,50,220))			
		draw.SimpleText("INVULNERABLE", "DermaLarge", 10, ScrH() - 100, Color(255,255,255,255))
	end
	
	
	
	--text that displays what role the players team currently is
	local plyteam = Ply:Team()
	local role = GetTeamRole(plyteam)

	//draw.RoundedBox(20, 0, 0, 270, 70, health_color_bg) 
	//draw.SimpleTextOutlined( role, "SmallerFont", 25, 0, Color(255,255,255,255))
	draw.SimpleTextOutlined(role, "SmallerFont", 25, 0, white, 3, 3, 3, Color(0, 0, 0, 255))
	
	
	
end 

hook.Add("HUDPaint", "HealthHud", hud)

