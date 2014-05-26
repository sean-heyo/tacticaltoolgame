--G_CurrentPhase:
	--"GameSetup"
	--"DefendersBuy"
	--"AttackersBuy"
	--"Planning"
	--"Setup"
	--"Combat"
	--"Winning"
	--"GameEnd


/*---------------------------------------------------------
	Client Score Displays
---------------------------------------------------------*/

local function ScoreHud()
		
	local redscore = team.GetScore(TEAM_RED)
	draw.SimpleTextOutlined(redscore .. "/" .. GetMaxScore() .. "    -", "TargetID", ScrW()/2 - 80, 25, Color(255, 190, 190, 255), 1, 1, 1, Color(0, 0, 0, 255))
	
	local bluescore = team.GetScore(TEAM_BLUE)
	draw.SimpleTextOutlined( "-    " .. bluescore ..  "/" .. GetMaxScore(), "TargetID", ScrW()/2 + 80, 25, Color(190, 190, 255, 255), 1, 1, 1, Color(0, 0, 0, 255))
	
	
	
	local phase = GetGlobalString("CL_CurPhase")
	if phase == "GameSetup" then
		draw.SimpleTextOutlined("GAME SETUP", "TargetID", ScrW()/2, 55, Color(255, 255, 255, 255), 1, 1, 1, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
	elseif phase == "DefendersBuy" then
		draw.SimpleTextOutlined("DEFENDERS TURN TO BUY", "TargetID", ScrW()/2, 55, Color(255, 255, 255, 255), 1, 1, 1, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
	elseif phase == "AttackersBuy" then
		draw.SimpleTextOutlined("ATTACKERS TURN TO BUY", "TargetID", ScrW()/2, 55, Color(255, 255, 255, 255), 1, 1, 1, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
	elseif phase == "Planning" then
		draw.SimpleTextOutlined("GET READY!", "TargetID", ScrW()/2, 55, Color(255, 255, 255, 255), 1, 1, 1, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
	elseif phase == "Setup" then
		draw.SimpleTextOutlined("DEFENDERS SETUP", "TargetID", ScrW()/2, 55, Color(255, 255, 255, 255), 1, 1, 1, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
	elseif phase == "Combat" then
		draw.SimpleTextOutlined("COMBAT", "TargetID", ScrW()/2, 55, Color(255, 255, 255, 255), 1, 1, 1, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
	elseif phase == "Winning" then
		draw.SimpleTextOutlined("A TEAM WON", "TargetID", ScrW()/2, 55, Color(255, 255, 255, 255), 1, 1, 1, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
	elseif phase == "GameEnd" then
		draw.SimpleTextOutlined("GAME OVER", "TargetID", ScrW()/2, 55, Color(255, 255, 255, 255), 1, 1, 1, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
	end
	
	
	
	
	local round = GetRound()
	local total_rounds = GetTotalRounds() + 1
	if total_rounds <= 1 then
		total_rounds = 0
	end
	draw.SimpleTextOutlined("ROUND: " .. round .. " / " .. total_rounds, "TargetID", ScrW()/2, 70, Color(255, 255, 255, 255), 1, 1, 1, Color(0, 0, 0, 255))
	
	if round > GetTotalRounds() then
		draw.SimpleTextOutlined("TIE BREAKER", "TargetID", ScrW()/2, 90, Color(255, 255, 255, 255), 1, 1, 1, Color(0, 0, 0, 255))
	end
	


	
	--help info
	draw.SimpleTextOutlined("Press F1 to open the tool library", "TargetID", ScrW()-150, 15, Color(255, 255, 255, 255), 1, 1, 1, Color(0, 0, 0, 255))
end
hook.Add("HUDPaint", "ScoreHud", ScoreHud)