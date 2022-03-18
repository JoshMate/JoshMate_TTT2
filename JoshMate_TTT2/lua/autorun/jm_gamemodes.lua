-- Give these files out
AddCSLuaFile()

if engine.ActiveGamemode() ~= "terrortown" then return end

if CLIENT then return end

local iRandomChance_Max = 5
local iRandomChance_Current = iRandomChance_Max
local iRandomChance_inc = 1

function JM_GameMode_Function_Main()

    -- Game Modes have a 1 in X Chance of Happening but increaing each round until reset
    local iRandomChance = math.random(1,iRandomChance_Current)
    
    if iRandomChance == 1 then

        local tableOfGamemodes = {}
        table.insert(tableOfGamemodes, "ProtectTheFiles")
        table.insert(tableOfGamemodes, "DefuseTheBombs")
        table.insert(tableOfGamemodes, "DefuseTheBombs")
        table.insert(tableOfGamemodes, "BountyHunter")

        if SERVER then print("[GameModes] Gamemode: Yes! Chance: " .. tostring(iRandomChance_Current)) end

        -- Reset the Chance Counter
        iRandomChance_Current = iRandomChance_Max
    
        -- Randomly select from the table of gamemodes
        selectedGameMode = tableOfGamemodes[math.random( #tableOfGamemodes )]

        -- Protect the Files
        if selectedGameMode == "ProtectTheFiles" then JM_GameMode_ProtectTheFiles_Init() end

        -- Defuse the Bomb
        if selectedGameMode == "DefuseTheBombs" then JM_GameMode_DefuseTheBombs_Init() end

        -- Bounty Hunter
        if selectedGameMode == "BountyHunter" then JM_GameMode_BountyHunter_Init() end

        

    else

        if SERVER then print("[GameModes] Gamemode: No! Chance: " .. tostring(iRandomChance_Current)) end

        -- Increase the odds of a gamemode as it didn't happen this time
        iRandomChance_Current = iRandomChance_Current - iRandomChance_inc
        iRandomChance_Current = math.Clamp(iRandomChance_Current, 1, iRandomChance_Max)
        
    end


end

-- Gamemode Start Functions

function JM_GameMode_ProtectTheFiles_Init()

    -- Debug
    if SERVER then print("[GameModes] Gamemode: Protect The Files") end

    -- Spawn the Gamemode Handler Object
    local GameModeHandlerObject = ents.Create("ent_jm_objective_01_file_base")
    GameModeHandlerObject:Spawn()

end

function JM_GameMode_DefuseTheBombs_Init()

    -- Debug
    if SERVER then print("[GameModes] Gamemode: Defuse the Bombs") end

    -- Spawn the Gamemode Handler Object
    local GameModeHandlerObject = ents.Create("ent_jm_objective_02_bomb_base")
    GameModeHandlerObject:Spawn()

end

function JM_GameMode_BountyHunter_Init()

    -- Debug
    if SERVER then print("[GameModes] Gamemode: Bount Hunter") end

    -- Spawn the Gamemode Handler Object
    local GameModeHandlerObject = ents.Create("ent_jm_objective_03_bounty_base")
    GameModeHandlerObject:Spawn()

end





--- Hook for gamemodes to run on
hook.Add("TTTBeginRound", "JMGameModesMainBeginRound", function()

    if (SERVER) then JM_GameMode_Function_Main() end 

end)