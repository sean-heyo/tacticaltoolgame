/*---------------------------------------------------------
	Process for a single round
---------------------------------------------------------*/
--most of this code loops every round, until a team has gotten enough points to win the game.
--goes back to gamesetup after the game has been won by a team




/*---------------------------------------------------------
	Globals and their possible vars ("G_" symbolizes it)
---------------------------------------------------------*/
--G_CurrentPhase:
	--"GameSetup"
	--"DefendersBuy"
	--"AttackersBuy"
	--"Planning"
	--"Setup"
	--"Combat"
	--"Winning"
	--"GameEnd"

	
--G_GameBegun
	-- true or false

--G_CurAttackZone
	--this will be one of the func_bomb_zones of the map, chosen at random each round




/*-------------------------------------------------------------------------------------------------------------------
	Phases in order
--------------------------------------------------------------------------------------------------------------------*/

//called at the start of every new round, resets things, switches team roles
function NextRound()

	ResetVarsBetweenRounds()
	
	--[[
	//join all players who signed up to join last round, if pub mode is on
	if PUB_MODE == true then
		NextRoundJoinAllPlayers()
	end
	]]--
	
	--end the whole game if one team has no players at all
	if DEV_MODE != true then
		local redplys = team.NumPlayers( TEAM_RED )
		local blueplys = team.NumPlayers( TEAM_BLUE )
	
		if redplys == 0 then
			GameRestart()
			ChatPrintToAll( "All of red team's players have left, restarting!" )
			return
		end
		if blueplys == 0 then
			GameRestart()
			ChatPrintToAll( "All of blue team's players have left, restarting!" )
			return
		end
	end
	
	//set all spawns to be availible
	SetupRoundSpawnTables()
	
	--Remove all leftover TTG ents in the world.  (for example: barriers, invis reveal devices, etc) And Abilities as well
	RemoveAllGameEnts()
	
	
	G_CurRound = G_CurRound + 1
	SetRound(G_CurRound)
	
	--if its not the first round, then flip around the teams roles
	if G_CurRound != 1 then
		if GetTeamRole(TEAM_RED) == "Attacking" then
			SetTeamRole(TEAM_RED, "Defending")
			SetTeamRole(TEAM_BLUE, "Attacking")
		elseif GetTeamRole(TEAM_RED) == "Defending" then
			SetTeamRole(TEAM_RED, "Attacking")
			SetTeamRole(TEAM_BLUE, "Defending")
		end
	end

	
	--Checks if this will be a tie breaker round, randomly gives roles out
	if G_CurRound == G_TotalRounds + 1 then
		--Set the roles randomly for the first round
		local rand = math.random(2)
		
		if rand == 1 then
			SetTeamRole(TEAM_RED, "Defending")
			SetTeamRole(TEAM_BLUE, "Attacking")
		elseif rand == 2 then
			SetTeamRole(TEAM_RED, "Attacking")
			SetTeamRole(TEAM_BLUE, "Defending")
		end
	end

	
	//set the zone the teams are vying for control over to be at one of the bomb sites of the de_ map
	ChooseAttackSite()
	
	//makes it constantly make sure atleast one person on each team is alive, otherwise end the round
	Start_TeamsAliveCheck()
	Start_TriggerHurtCheck()
	
	for k,v in pairs(player.GetAll()) do	
		if v:Team() != TEAM_SPEC then
			-- take away all the players tools from the previous round
			v:StripWeapons()
		
			--make sure they arent in specate mode like they are when theyre dead
			v:UnSpectate( )
		
			--spawn all players, except specs
			v:Spawn()
		
			--sets the default stuff for the player, speed, model, default_melee, etc
			SetSpawnStuff( v )
		
			--lock all players so they cant move at all while the buying screen is open
			v:Freeze( true )
			
			--Set everyones tokens to 3, so they can purchase 3 tools in the round
			v:SetToolTokens(ROUND_TOKENS)
			
			--give attackers god mode so they cant be killed in setup phase later
			if GetTeamRole(v:Team()) == "Attacking" then
				v:TTG_Invuln( true )
				//v:TTG_Freeze( true )
			end	
		end
	end
	
	
	DefendersBuyPhase()
	
	CloseAttackersDoors()
end



function DefendersBuyPhase()
	G_CurrentPhase = "DefendersBuy"
	Open_BuyingMenus()
	
	//runs on tick, checking if all of the currently buying team has bought 
	Start_CheckIfPlayersBought()

	//plays buying bell sound for defending players
	for k,v in pairs(player.GetAll()) do	
		if v:Team() != TEAM_SPEC then
			if GetTeamRole(v:Team()) == "Defending" then
				umsg.Start("Sound_TurnToBuy", v)
				umsg.End()
			end	
		end
	end
	
	SetGlobalString("CL_CurBuyingRole", "Defending")
	
	SetGlobalString("CL_CurPhase", "DefendersBuy")
	
	SetGlobalBool("CL_PlayTimerCountSounds", false)
	InitializeGCTime(DEFENDERSBUYPHASE_TIME, AttackersBuyPhase)
end



function AttackersBuyPhase()
	G_CurrentPhase = "AttackersBuy"
	//Update_EnemyPurchasesVgui()

	//plays buying bell sound for attacking players
	for k,v in pairs(player.GetAll()) do	
		if v:Team() != TEAM_SPEC then
			if GetTeamRole(v:Team()) == "Attacking" then
				umsg.Start("Sound_TurnToBuy", v)
				umsg.End()
			end	
		end
	end
	
	SetGlobalString("CL_CurBuyingRole", "Attacking")
	
	SetGlobalString("CL_CurPhase", "AttackersBuy")
	
	InitializeGCTime(ATTACKERSBUYPHASE_TIME, PlanningPhase)
end



function PlanningPhase()
	G_CurrentPhase = "Planning"
	//Update_EnemyPurchasesVgui()
	
	End_CheckIfPlayersBought()
	
	//plays the buying done sound
	umsg.Start("Sound_BuyingDone")
	umsg.End()
	
	SetGlobalString("CL_CurBuyingRole", "None")
	
	SetGlobalString("CL_CurPhase", "Planning")

	InitializeGCTime(PLANNINGPHASE_TIME, SetupPhase)
end




function SetupPhase()
	G_CurrentPhase = "Setup"
	
	--close out of all the buying phase menus
	Close_BuyingMenus()
	
	

	for k,v in pairs(player.GetAll()) do
		
		--unlock all players, attacking team will still be frozen and invulnerable
		v:Freeze( false )
		
		//print("this is his default crouch speed multiplier",v:GetCrouchedWalkSpeed())
		
		if GetTeamRole(v:Team()) == "Defending" then
			v:SetBaseSpeed( PLAYER_BASE_SPEED_SETUP )
			v:SetCrouchedWalkSpeed( PLAYER_BASE_CROUCHMULTIPLIER_SETUP )
		end
	end
	
	SetGlobalString("CL_CurPhase", "Setup")
	
	SetGlobalBool("CL_PlayTimerCountSounds", true)
	
	InitializeGCTime(SETUPPHASE_TIME, CombatPhase)
end


function CombatPhase()
	G_CurrentPhase = "Combat"
	
	Start_CaptureCheck()
	
	OpenAttackersDoors()
	
	End_TriggerHurtCheck()

	//plays the sound of the announcer saying "fight!"
	umsg.Start("Announcer_Fight")
	umsg.End()
	
	for k,v in pairs(player.GetAll()) do
	
		--set the defending players movement speed back to default
		if GetTeamRole(v:Team()) == "Defending" then
			v:SetBaseSpeed( v.BaseSpeed )
			v:SetCrouchedWalkSpeed( PLAYER_BASE_CROUCHMULTIPLIER )
		end
	
		

		--unfreeze attackers and take away god mode after a few seconds
		if GetTeamRole(v:Team()) == "Attacking" then
			//v:TTG_Freeze( false )
			
			timer.Simple(BEGINNING_INVULN_TIME, function()
				v:TTG_Invuln( false )
			end)
		end

	end
	
	SetGlobalString("CL_CurPhase", "Combat")
	
	InitializeGCTime(COMBATPHASE_TIME, WinningPhase)
end




function WinningPhase(winners)
	//this makes sure the win isnt triggered twice
	if G_WinAlreadyTriggered == true then return end
	G_WinAlreadyTriggered = true

	//checks if it was buying phase when one of the teams won for some weird reason, and if so, closes the menus
	if G_CurrentPhase == "AttackersBuy" or G_CurrentPhase == "DefendersBuy" or G_CurrentPhase == "Planning" then
		Close_BuyingMenus()
	end
	
	//sets the phase to winning
	G_CurrentPhase = "Winning"
	
	
	End_CaptureCheck()
	End_TeamsAliveCheck()

	
	--if the win was triggered by time running out, then make it so defenders won the round
	if winners == nil then
		if GetTeamRole(TEAM_RED) == "Defending" then
			winners = TEAM_RED
		elseif GetTeamRole(TEAM_BLUE) == "Defending" then
			winners = TEAM_BLUE
		end
	end
	
	--give the winners of the round a point
	team.AddScore (winners, 1)
	
	
	--if a team has enough points to straight up win the game, then end the game with that team being the winner
	if team.GetScore(TEAM_RED) >= G_MaxScore then
		GameEnd(TEAM_RED)
		return
	elseif team.GetScore(TEAM_BLUE) >= G_MaxScore then
		GameEnd(TEAM_BLUE)
		return
	end
	
	
	
	--if this was the last round and both teams have the same score then go to a tiebreaker round
	if G_CurRound == G_TotalRounds then
		if team.GetScore(TEAM_RED) == team.GetScore(TEAM_BLUE) then
			for k,v in pairs(player.GetAll()) do
				v:PrintMessage( HUD_PRINTCENTER, "There's gonna have to be a tie breaker round...")
			end
			
			--makes it so it wont play the announcer counting down sounds
			SetGlobalBool("CL_PlayTimerCountSounds", false)
			
			InitializeGCTime(WINNINGPHASE_TIME, NextRound)
			return
		end
	end
	
	
	
	--if it was a tiebreaker round then have the winners of the round win the whole game
	if G_CurRound == G_TotalRounds + 1 then
		GameEnd(winners)
		return
	end
	
	
	--prints to all players telling them who won
	for k,v in pairs(player.GetAll()) do
		v:PrintMessage( HUD_PRINTCENTER, ConvertToTeamName(winners) .. " won the round")
		//print( "this is the winning teams number to debug:", winners )
		if GetTeamRole(winners) == "Defending" then
			if GetTeamRole(v:Team()) == "Defending" then
				umsg.Start("Announcer_Success", v); umsg.End()
			elseif GetTeamRole(v:Team()) == "Attacking" then
				umsg.Start("Announcer_Failure", v); umsg.End()
			end
			
		elseif GetTeamRole(winners) == "Attacking" then
			if GetTeamRole(v:Team()) == "Defending" then
				umsg.Start("Announcer_Failure", v); umsg.End()
			elseif GetTeamRole(v:Team()) == "Attacking" then
				umsg.Start("Announcer_Success", v); umsg.End()
			end
		end
	end
	

	--makes it so it wont play the announcer counting down sounds
	SetGlobalBool("CL_PlayTimerCountSounds", false)

	
	--disables stuff like the sentry gun, proximity mines, etc
	DisableAllEnts()
	
	SetGlobalString("CL_CurPhase", "Winning")
	
	InitializeGCTime(WINNINGPHASE_TIME, NextRound)
end






/*-------------------------------------------------------------------------------------------------------------------
	Game End
--------------------------------------------------------------------------------------------------------------------*/

function GameEnd(winners)
	local winners_name = ConvertToTeamName(winners)
	
	
	for k,v in pairs(player.GetAll()) do
		v:PrintMessage( HUD_PRINTCENTER, winners_name .. " won the whole game! Restarting in " .. WINNINGPHASE_TIME .. " seconds.")
	end
	
	--makes it so it wont play the announcer counting down sounds
	SetGlobalBool("CL_PlayTimerCountSounds", false)
	
	SetGlobalString("CL_CurPhase", "GameEnd")
	
	InitializeGCTime(WINNINGPHASE_TIME, GameRestart)
end