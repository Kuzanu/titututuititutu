if game.PlaceId == 3623096087 then

local FastWaiting = 0.00001

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/nofomo-fr/gigigigigigigigi/refs/heads/main/Library.lua", true))()

local window = library:AddWindow("Midaz Hub | Paid Version | Mobile Version", {
	main_color = Color3.fromRGB(10, 15, 44),
	min_size = Vector2.new(560, 560),
	can_resize = false,
})

local HOME = window:AddTab("Home")
HOME:Show()

local DiscordInviteFolder = HOME:AddFolder("   DISCORD INVITE")
DiscordInviteFolder:AddButton("Copy Discord Invite", function()
	setclipboard("https://discord.gg/7fFgM6KNsf")
end)

local LocalPlayerFolder = HOME:AddFolder("    LOCAL PLAYER")

local WalkSpeedSwitch = false
local walkspeed = 250

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

LocalPlayerFolder:AddTextBox("Enter Walkspeed", function(text)
    local value = tonumber(text)
    if value then
      walkspeed = math.clamp(value, 1, 500)
  end
end)

LocalPlayerFolder:AddSwitch("Set Walkspeed", function(bool)
  WalkSpeedSwitch = bool
  if WalkSpeedSwitch then
    character = player.Character or player.CharacterAdded:Wait()
    character:WaitForChild("Humanoid").WalkSpeed = walkspeed
    else
      character = player.Character or player.CharacterAdded:Wait()
      character:WaitForChild("Humanoid").WalkSpeed = 16
  end
end)

local InfiniteJumpsSwitch = false
local NoClipSwitch = false

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Humanoid
local JumpConnection
local NoClipConnection

LocalPlayer.CharacterAdded:Connect(function(char)
	Humanoid = char:WaitForChild("Humanoid")
end)

LocalPlayerFolder:AddSwitch("Infinite Jumps", function(bool)
	InfiniteJumpsSwitch = bool

	if bool then
		Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		JumpConnection = UserInputService.JumpRequest:Connect(function()
			if InfiniteJumpsSwitch and Humanoid then
				Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end)
	else
		if JumpConnection then
			JumpConnection:Disconnect()
			JumpConnection = nil
		end
	end
end)

LocalPlayerFolder:AddSwitch("No Clip", function(bool)
	NoClipSwitch = bool

	if bool then
		NoClipConnection = RunService.Stepped:Connect(function()
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
				for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
					if part:IsA("BasePart") and part.CanCollide then
						part.CanCollide = false
					end
				end
			end
		end)
	else
		if NoClipConnection then
			NoClipConnection:Disconnect()
			NoClipConnection = nil
		end
		if LocalPlayer.Character then
			for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = true
				end
			end
		end
	end
end)

local MAIN = window:AddTab("Main")

local AutoLiftingSwitch = false

function AutoLift()
  while AutoLiftingSwitch do
  local args = {
    "rep"
}
game:GetService("Players").LocalPlayer:WaitForChild("muscleEvent"):FireServer(unpack(args))
task.wait(FastWaiting)
end
end

MAIN:AddSwitch("Auto Lift | Works With Everything!", function(bool)
  AutoLiftingSwitch = bool
  if bool then
    task.spawn(AutoLift)
  end
end)

local AutoPunchingFolder = MAIN:AddFolder("   AUTO PUNCHING FUNCTIONS")

local SelectedPunchVersion = "Normal"
local AutoPunching = false

local dropdown = AutoPunchingFolder:AddDropdown("Select Punch Speed", function(text)
    SelectedPunchVersion = text
end)

local wow = dropdown:Add("Slow")
local mars = dropdown:Add("Normal")
local hawk = dropdown:Add("Medium")
local earth = dropdown:Add("Fast")

AutoPunchingFolder:AddSwitch("Auto Punch", function(bool)
    AutoPunching = bool

    task.spawn(function()
        while AutoPunching do
            local player = game.Players.LocalPlayer
            local char = game.Workspace:FindFirstChild(player.Name)
            local punchTool = player.Backpack:FindFirstChild("Punch") or (char and char:FindFirstChild("Punch"))

            if punchTool then
                if punchTool.Parent ~= char then
                    punchTool.Parent = char
                    task.wait(0.1)
                end

                local attackTime = punchTool:FindFirstChild("attackTime")
                if attackTime then
                    if SelectedPunchVersion == "Fast" then
                        attackTime.Value = 0
                    elseif SelectedPunchVersion == "Normal" then
                        attackTime.Value = 0.35
                    elseif SelectedPunchVersion == "Medium" then 
                        attackTime.Value = 0.175
                    elseif SelectedPunchVersion == "Slow" then 
                        attackTime.Value = 0.65
                    end
                end

                punchTool:Activate()
            else
                AutoPunching = false
                break
            end

            task.wait()
        end
    end)
end)

AutoPunchingFolder:AddLabel("----------------------------------------------------------------------------------------")

AutoPunchingFolder:AddLabel("The dropdown above is to choose the\nspeed of your punching")

local AutoEquipingFolder = MAIN:AddFolder("   AUTO EQUIP FUNCTIONS")

local AutoEquipPunchSwitch = false
local AutoEquipWeightSwitch = false
local AutoEquipPushupSwitch = false
local AutoEquipSitupSwitch = false
local AutoEquipHandstandsSwitch = false

AutoEquipingFolder:AddSwitch("Auto Equip Punch", function(bool)
    AutoEquipPunchSwitch = bool

    task.spawn(function()
        while AutoEquipPunchSwitch do
            local player = game.Players.LocalPlayer
            local char = game.Workspace:FindFirstChild(player.Name)
            local punchTool = player.Backpack:FindFirstChild("Punch")

            if punchTool and char and not char:FindFirstChild("Punch") then
                punchTool.Parent = char
            end

            task.wait(0.001)
        end
    end)
end)

AutoEquipingFolder:AddSwitch("Auto Equip Weight", function(bool)
    AutoEquipWeightSwitch = bool

    task.spawn(function()
        while AutoEquipWeightSwitch do
            local player = game.Players.LocalPlayer
            local char = game.Workspace:FindFirstChild(player.Name)
            local punchTool = player.Backpack:FindFirstChild("Weight")

            if punchTool and char and not char:FindFirstChild("Weight") then
                punchTool.Parent = char
            end

            task.wait(0.001)
        end
    end)
end)

AutoEquipingFolder:AddSwitch("Auto Equip Pushups", function(bool)
    AutoEquipPushupSwitch = bool

    task.spawn(function()
        while AutoEquipPushupSwitch do
            local player = game.Players.LocalPlayer
            local char = game.Workspace:FindFirstChild(player.Name)
            local punchTool = player.Backpack:FindFirstChild("Pushups")

            if punchTool and char and not char:FindFirstChild("Pushups") then
                punchTool.Parent = char
            end

            task.wait(0.001)
        end
    end)
end)

AutoEquipingFolder:AddSwitch("Auto Equip Situps", function(bool)
    AutoEquipSitupSwitch = bool

    task.spawn(function()
        while AutoEquipSitupSwitch do
            local player = game.Players.LocalPlayer
            local char = game.Workspace:FindFirstChild(player.Name)
            local punchTool = player.Backpack:FindFirstChild("Situps")

            if punchTool and char and not char:FindFirstChild("Situps") then
                punchTool.Parent = char
            end

            task.wait(0.001)
        end
    end)
end)

AutoEquipingFolder:AddSwitch("Auto Equip Handstands", function(bool)
    AutoEquipHandstandsSwitch = bool

    task.spawn(function()
        while AutoEquipHandstandsSwitch do
            local player = game.Players.LocalPlayer
            local char = game.Workspace:FindFirstChild(player.Name)
            local punchTool = player.Backpack:FindFirstChild("Handstands")

            if punchTool and char and not char:FindFirstChild("Handstands") then
                punchTool.Parent = char
            end

            task.wait(0.001)
        end
    end)
end)

local AutoBrawlFolder = MAIN:AddFolder("    AUTO BRAWL FUNCTIONS")

local godModeToggle = false
AutoBrawlFolder:AddSwitch("Auto Brawl (You Enter God Mode)", function(State)
    godModeToggle = State
    if State then
        task.spawn(function()
            while godModeToggle do
                game:GetService("ReplicatedStorage").rEvents.brawlEvent:FireServer("joinBrawl")
                task.wait(0)
            end
        end)
    end
end)

local autoJoinToggle = false
AutoBrawlFolder:AddSwitch("Auto Join Brawl", function(State)
    autoJoinToggle = State
    if State then
        task.spawn(function()
            while autoJoinToggle do
                game:GetService("ReplicatedStorage").rEvents.brawlEvent:FireServer("joinBrawl")
                task.wait(2)
            end
        end)
    end
end)

local AutoPunchingRockFolder = MAIN:AddFolder("    AUTO PUNCHING ROCK FUNCTIONS")

local player = game.Players.LocalPlayer

repeat wait() until game:IsLoaded() and player.Character and player.Character:FindFirstChild("Humanoid") and game.Workspace

local ROCK_MODE = "shrink"

local function gettool()
    local tool = player.Backpack:FindFirstChild("Punch") or player.Character:FindFirstChild("Punch")
    if tool and tool.Parent ~= player.Character then
        tool.Parent = player.Character
        wait(0.1)
    elseif not tool then
        warn("Punch tool not found in Backpack or Character")
    end
    return tool
end

local function modifyRock(rock)
    if not rock then return end
    if ROCK_MODE == "shrink" then
        local originalSize = rock.Size
        rock.Size = originalSize * 0.1
    elseif ROCK_MODE == "hide" then
        rock.Transparency = 0
        rock.CanCollide = false
    end
end

local function farmRocks(neededDurabilityValue)
    while getgenv().autoFarm do
        wait(0)
        local character = player.Character
        local machinesFolder = game:GetService("Workspace"):FindFirstChild("machinesFolder")

        if not character then
            warn("Character not loaded")
            return
        end
        if not machinesFolder then
            warn("machinesFolder not found in Workspace")
            return
        end

        if player.Durability.Value >= neededDurabilityValue then
            for _, v in pairs(machinesFolder:GetDescendants()) do
                if v.Name == "neededDurability" and v.Value == neededDurabilityValue then
                    local rock = v.Parent:FindFirstChild("Rock")
                    if rock and character:FindFirstChild("LeftHand") and character:FindFirstChild("RightHand") then
                        local punchTool = gettool()
                        if punchTool then
                            player.muscleEvent:FireServer("punch", "rightHand")
                            player.muscleEvent:FireServer("punch", "leftHand")
                            firetouchinterest(rock, character.RightHand, 0)
                            firetouchinterest(rock, character.RightHand, 1)
                            firetouchinterest(rock, character.LeftHand, 0)
                            firetouchinterest(rock, character.LeftHand, 1)
                            modifyRock(rock)
                        end
                    else
                        warn("Rock or hands not found for durability: " .. neededDurabilityValue)
                    end
                end
            end
        end
    end
end

AutoPunchingRockFolder:AddLabel("ROCKS", function()
    _G.fastHitActive = not _G.fastHitActive
    if _G.fastHitActive then
        getgenv().autoFarm = true
        coroutine.wrap(function()
            while _G.fastHitActive do
                local character = player.Character
                if character then
                    gettool()
                end
                wait(0.1)
            end
        end)()
    else
        getgenv().autoFarm = false
        local character = player.Character
        local equipped = character and character:FindFirstChild("Punch")
        if equipped then
            equipped.Parent = player.Backpack
        end
    end
end)

AutoPunchingRockFolder:AddSwitch("Jungle Rock(10M)", function()
    _G.fastHitActive = not _G.fastHitActive
    if _G.fastHitActive then
        getgenv().autoFarm = true
        coroutine.wrap(function()
            local iterations = 10
            while _G.fastHitActive do
                local character = player.Character
                if character then
                    for _ = 1, iterations do
                        gettool()
                        farmRocks(10000000)
                    end
                end
                wait(.1)
            end
        end)()
    else
        getgenv().autoFarm = false
        local character = player.Character
        local equipped = character and character:FindFirstChild("Punch")
        if equipped then
            equipped.Parent = player.Backpack
        end
    end
end)

AutoPunchingRockFolder:AddSwitch("Muscle Rock (5M)", function()
    _G.fastHitActive = not _G.fastHitActive
    if _G.fastHitActive then
        getgenv().autoFarm = true
        coroutine.wrap(function()
            local iterations = 10
            while _G.fastHitActive do
                local character = player.Character
                if character then
                    for _ = 1, iterations do
                        gettool()
                        farmRocks(5000000)
                    end
                end
                wait(.1)
            end
        end)()
    else
        getgenv().autoFarm = false
        local character = player.Character
        local equipped = character and character:FindFirstChild("Punch")
        if equipped then
            equipped.Parent = player.Backpack
        end
    end
end)

AutoPunchingRockFolder:AddSwitch("Legends Rock(1M)", function()
    _G.fastHitActive = not _G.fastHitActive
    if _G.fastHitActive then
        getgenv().autoFarm = true
        coroutine.wrap(function()
            local iterations = 10
            while _G.fastHitActive do
                local character = player.Character
                if character then
                    for _ = 1, iterations do
                        gettool()
                        farmRocks(1000000)
                    end
                end
                wait(.1)
            end
        end)()
    else
        getgenv().autoFarm = false
        local character = player.Character
        local equipped = character and character:FindFirstChild("Punch")
        if equipped then
            equipped.Parent = player.Backpack
        end
    end
end)

AutoPunchingRockFolder:AddSwitch("Tiny Rock(0)", function()
    _G.fastHitActive = not _G.fastHitActive
    if _G.fastHitActive then
        getgenv().autoFarm = true
        coroutine.wrap(function()
            local iterations = 10
            while _G.fastHitActive do
                local character = player.Character
                if character then
                    for _ = 1, iterations do
                        gettool()
                        farmRocks(0)
                    end
                end
                wait(.1)
            end
        end)()
    else
        getgenv().autoFarm = false
        local character = player.Character
        local equipped = character and character:FindFirstChild("Punch")
        if equipped then
            equipped.Parent = player.Backpack
        end
    end
end)

AutoPunchingRockFolder:AddSwitch("Punching Rock(10)", function()
    _G.fastHitActive = not _G.fastHitActive
    if _G.fastHitActive then
        getgenv().autoFarm = true
        coroutine.wrap(function()
            local iterations = 10
            while _G.fastHitActive do
                local character = player.Character
                if character then
                    for _ = 1, iterations do
                        gettool()
                        farmRocks(10)
                    end
                end
                wait(.1)
            end
        end)()
    else
        getgenv().autoFarm = false
        local character = player.Character
        local equipped = character and character:FindFirstChild("Punch")
        if equipped then
            equipped.Parent = player.Backpack
        end
    end
end)

AutoPunchingRockFolder:AddSwitch("Large Rock(100)", function()
    _G.fastHitActive = not _G.fastHitActive
    if _G.fastHitActive then
        getgenv().autoFarm = true
        coroutine.wrap(function()
            local iterations = 10
            while _G.fastHitActive do
                local character = player.Character
                if character then
                    for _ = 1, iterations do
                        gettool()
                        farmRocks(100)
                    end
                end
                wait(.1)
            end
        end)()
    else
        getgenv().autoFarm = false
        local character = player.Character
        local equipped = character and character:FindFirstChild("Punch")
        if equipped then
            equipped.Parent = player.Backpack
        end
    end
end)

AutoPunchingRockFolder:AddSwitch("Beach Rock(5K)", function()
    _G.fastHitActive = not _G.fastHitActive
    if _G.fastHitActive then
        getgenv().autoFarm = true
        coroutine.wrap(function()
            local iterations = 10
            while _G.fastHitActive do
                local character = player.Character
                if character then
                    for _ = 1, iterations do
                        gettool()
                        farmRocks(5000)
                    end
                end
                wait(.1)
            end
        end)()
    else
        getgenv().autoFarm = false
        local character = player.Character
        local equipped = character and character:FindFirstChild("Punch")
        if equipped then
            equipped.Parent = player.Backpack
        end
    end
end)

AutoPunchingRockFolder:AddSwitch("Froz Rock(150K)", function()
    _G.fastHitActive = not _G.fastHitActive
    if _G.fastHitActive then
        getgenv().autoFarm = true
        coroutine.wrap(function()
            local iterations = 10
            while _G.fastHitActive do
                local character = player.Character
                if character then
                    for _ = 1, iterations do
                        gettool()
                        farmRocks(150000)
                    end
                end
                wait(.1)
            end
        end)()
    else
        getgenv().autoFarm = false
        local character = player.Character
        local equipped = character and character:FindFirstChild("Punch")
        if equipped then
            equipped.Parent = player.Backpack
        end
    end
end)

AutoPunchingRockFolder:AddSwitch("Ethernal Rock(750K)", function()
    _G.fastHitActive = not _G.fastHitActive
    if _G.fastHitActive then
        getgenv().autoFarm = true
        coroutine.wrap(function()
            local iterations = 10
            while _G.fastHitActive do
                local character = player.Character
                if character then
                    for _ = 1, iterations do
                        gettool()
                        farmRocks(750000)
                    end
                end
                wait(.1)
            end
        end)()
    else
        getgenv().autoFarm = false
        local character = player.Character
        local equipped = character and character:FindFirstChild("Punch")
        if equipped then
            equipped.Parent = player.Backpack
            end
    end
end)

AutoPunchingRockFolder:AddSwitch("Msytic Rock(400K)", function()
    _G.fastHitActive = not _G.fastHitActive
    if _G.fastHitActive then
        getgenv().autoFarm = true
        coroutine.wrap(function()
            local iterations = 10
            while _G.fastHitActive do
                local character = player.Character
                if character then
                    for _ = 1, iterations do
                        gettool()
                        farmRocks(400000)
                    end
                end
                wait(.1)
            end
        end)()
    else
        getgenv().autoFarm = false
        local character = player.Character
        local equipped = character and character:FindFirstChild("Punch")
        if equipped then
            equipped.Parent = player.Backpack
        end
    end
end)

local AutoGymFarmingFolder = MAIN:AddFolder("    AUTO FARMING GYMS")

local folder = AutoGymFarmingFolder:AddFolder("    AUTO FARM JUNGLE")

folder:AddSwitch("Auto Jungle Boulder", function(State)
    MuscleKingSquatToggle = State
    if State then
        task.spawn(function()
            while MuscleKingSquatToggle do
                game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(-8617, 37, 2677))
                game:GetService("ReplicatedStorage").rEvents.machineInteractRemote:InvokeServer("useMachine", workspace.machinesFolder["Jungle Boulder"].interactSeat)
                task.wait(0.1)
            end
        end)
    end
end)

folder:AddSwitch("Auto Jungle Bench", function(State)
    local jungleBenchToggle = false
    jungleBenchToggle = State
    if State then
        task.spawn(function()
            while jungleBenchToggle do
                game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(-8629.88086, 64.8842468, 1855.03467))
                game:GetService("ReplicatedStorage").rEvents.machineInteractRemote:InvokeServer("useMachine", workspace.machinesFolder["Jungle Bench"].interactSeat)
                task.wait(0.1)
            end
        end)
    end
end)

folder:AddSwitch("Auto Jungle Bar Lift", function(State)
    local jungleBarLiftToggle = false
    jungleBarLiftToggle = State
    if State then
        task.spawn(function()
            while jungleBarLiftToggle do
                game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(-8678.05566, 14.5030098, 2089.25977))
                game:GetService("ReplicatedStorage").rEvents.machineInteractRemote:InvokeServer("useMachine", workspace.machinesFolder["Jungle Bar Lift"].interactSeat)
                task.wait(0.1)
            end
        end)
    end
end)

folder:AddSwitch("Auto Jungle Squat", function(State)
    local jungleSquatToggle = false
    jungleSquatToggle = State
    if State then
        task.spawn(function()
            while jungleSquatToggle do
                game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(-8374.25586, 34.5933418, 2932.44995))
                game:GetService("ReplicatedStorage").rEvents.machineInteractRemote:InvokeServer("useMachine", workspace.machinesFolder["Jungle Squat"].interactSeat)
                task.wait(0.1)
            end
        end)
    end
end)

local folder2 = AutoGymFarmingFolder:AddFolder("     AUTO FARM MUSCLE KING")

local MuscleKingSquatToggle = false
folder2:AddSwitch("Auto Muscle Boulder", function(State)
    MuscleKingSquatToggle = State
    if State then
        task.spawn(function()
            while MuscleKingSquatToggle do
                game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(-8940.12402, 13.1642084, -5699.13477))
                game:GetService("ReplicatedStorage").rEvents.machineInteractRemote:InvokeServer("useMachine", workspace.machinesFolder["King Boulder"].interactSeat)
                task.wait(0.1)
            end
        end)
    end
end)

folder2:AddSwitch("Auto Muscle Bench", function(State)
    MuscleKingSquatToggle = State
    if State then
        task.spawn(function()
            while MuscleKingSquatToggle do
                game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(-8590.06152, 46.0167427, -6043.34717))
                game:GetService("ReplicatedStorage").rEvents.machineInteractRemote:InvokeServer("useMachine", workspace.machinesFolder["Muscle King Bench"].interactSeat)
                task.wait(0.1)
            end
        end)
    end
end)

folder2:AddSwitch("Auto Muscle Squat", function(State)
    MuscleKingSquatToggle = State
    if State then
        task.spawn(function()
            while MuscleKingSquatToggle do
                game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(-8759, 44, -6044))
                game:GetService("ReplicatedStorage").rEvents.machineInteractRemote:InvokeServer("useMachine", workspace.machinesFolder["Muscle King Squat"].interactSeat)
                task.wait(0.1)
            end
        end)
    end
end)

folder2:AddSwitch("Auto Muscle Dead Lift", function(State)
    MuscleKingSquatToggle = State
    if State then
        task.spawn(function()
            while MuscleKingSquatToggle do
                game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(-8773, 50, -5664))
                game:GetService("ReplicatedStorage").rEvents.machineInteractRemote:InvokeServer("useMachine", workspace.machinesFolder["Muscle King Lift"].interactSeat)
                task.wait(0.1)
            end
        end)
    end
end)

local folder3 = AutoGymFarmingFolder:AddFolder("     AUTO FARM LEGENDS GYM")

local MuscleKingSquatToggle = false
folder3:AddSwitch("Auto Legends Boulder", function(State)
    MuscleKingSquatToggle = State
    if State then
        task.spawn(function()
            while MuscleKingSquatToggle do
                game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(4189, 1010, -3904))
                game:GetService("ReplicatedStorage").rEvents.machineInteractRemote:InvokeServer("useMachine", workspace.machinesFolder["Legends Throw"].interactSeat)
                task.wait(0.1)
            end
        end)
    end
end)

folder3:AddSwitch("Auto Legends Bench", function(State)
    MuscleKingSquatToggle = State
    if State then
        task.spawn(function()
            while MuscleKingSquatToggle do
                game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(4109, 1020, -3803))
                game:GetService("ReplicatedStorage").rEvents.machineInteractRemote:InvokeServer("useMachine", workspace.machinesFolder["Legends Press"].interactSeat)
                task.wait(0.1)
            end
        end)
    end
end)

folder3:AddSwitch("Auto legends Squat", function(State)
    MuscleKingSquatToggle = State
    if State then
        task.spawn(function()
            while MuscleKingSquatToggle do
                game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(4304, 1020, -4123))
                game:GetService("ReplicatedStorage").rEvents.machineInteractRemote:InvokeServer("useMachine", workspace.machinesFolder["Legends Pullup"].interactSeat)
                task.wait(0.1)
            end
        end)
    end
end)

folder3:AddSwitch("Auto Legends Dead Lift", function(State)
    MuscleKingSquatToggle = State
    if State then
        task.spawn(function()
            while MuscleKingSquatToggle do
                game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(4532, 1023, -4003))
                game:GetService("ReplicatedStorage").rEvents.machineInteractRemote:InvokeServer("useMachine", workspace.machinesFolder["Legends Lift"].interactSeat)
                task.wait(0.1)
            end
        end)
    end
end)

local folder4 = AutoGymFarmingFolder:AddFolder("     AUTO FARM ETERNAL GYM")

folder4:AddSwitch("Auto Eternal Bench", function(State)
    MuscleKingSquatToggle = State
    if State then
        task.spawn(function()
            while MuscleKingSquatToggle do
                game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(-7174, 45, -1106))
                game:GetService("ReplicatedStorage").rEvents.machineInteractRemote:InvokeServer("useMachine", workspace.machinesFolder["Eternal Press"].interactSeat)
                task.wait(0.1)
            end
        end)
    end
end)

local folder5 = AutoGymFarmingFolder:AddFolder("     AUTO FARM FROZEN GYM")

folder5:AddSwitch("Auto Froze Bench Lift", function(State)
    MuscleKingSquatToggle = State
    if State then
        task.spawn(function()
            while MuscleKingSquatToggle do
                game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(-3009, 38, -338))
                game:GetService("ReplicatedStorage").rEvents.machineInteractRemote:InvokeServer("useMachine", workspace.machinesFolder["Frost Press"].interactSeat)
                task.wait(0.1)
            end
        end)
    end
end)

folder5:AddSwitch("Auto Dead Lift", function(State)
    MuscleKingSquatToggle = State
    if State then
        task.spawn(function()
            while MuscleKingSquatToggle do
                game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(-2918, 40, -210))
                game:GetService("ReplicatedStorage").rEvents.machineInteractRemote:InvokeServer("useMachine", workspace.machinesFolder["Frost Lift"].interactSeat)
                task.wait(0.1)
            end
        end)
    end
end)

folder5:AddSwitch("Auto Squat Lift", function(State)
    MuscleKingSquatToggle = State
    if State then
        task.spawn(function()
            while MuscleKingSquatToggle do
                game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(-2721, 29, -592))
                game:GetService("ReplicatedStorage").rEvents.machineInteractRemote:InvokeServer("useMachine", workspace.machinesFolder["Frost Squat"].interactSeat)
                task.wait(0.1)
            end
        end)
    end
end)

local folder6 = AutoGymFarmingFolder:AddFolder("     AUTO FARM MYTHICAL GYM")

folder6:AddSwitch("Auto Bench Lift", function(State)
    MuscleKingSquatToggle = State
    if State then
        task.spawn(function()
            while MuscleKingSquatToggle do
                game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(2369, 38, 1243))
                game:GetService("ReplicatedStorage").rEvents.machineInteractRemote:InvokeServer("useMachine", workspace.machinesFolder["Mythical Press"].interactSeat)
                task.wait(0.1)
            end
        end)
    end
end)

folder6:AddSwitch("Auto Boulder", function(State)
    MuscleKingSquatToggle = State
    if State then
        task.spawn(function()
            while MuscleKingSquatToggle do
                game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(2667, 46, 1203))
                game:GetService("ReplicatedStorage").rEvents.machineInteractRemote:InvokeServer("useMachine", workspace.machinesFolder["Mytical Throw"].interactSeat)
                task.wait(0.1)
            end
        end)
    end
end)

folder6:AddSwitch("Auto Mythical Pull up", function(State)
    MuscleKingSquatToggle = State
    if State then
        task.spawn(function()
            while MuscleKingSquatToggle do
                game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(2487, 30, 848))
                game:GetService("ReplicatedStorage").rEvents.machineInteractRemote:InvokeServer("useMachine", workspace.machinesFolder["Mytical Pullup"].interactSeat)
                task.wait(0.1)
            end
        end)
    end
end)

local KILLING = window:AddTab("Killing")

KILLING:AddLabel("Note:")
KILLING:AddLabel("This punching system is an old version.")
KILLING:AddLabel("If you want better punching mechanics,")
KILLING:AddLabel("please consider buying the premium version.")
KILLING:AddLabel("Don't get mad — upgrade instead!")

KILLING:AddLabel("----------------------------------------------------------------------------------------")

KILLING:AddTextBox("Whitelist Player", function(text)
    local targetPlayer = game.Players:FindFirstChild(text)
    if targetPlayer then
        whitelist[targetPlayer.Name] = true
    end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local whitelist = {}
local killMethod = "Teleport"

local function equipTool(toolName)
    local character = LocalPlayer.Character
    local backpack = LocalPlayer.Backpack
    if not (character and backpack) then return end
    local tool = backpack:FindFirstChild(toolName)
    if tool then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:EquipTool(tool)
        end
    end
end

local function autoKill(toggleState)
    _G.autoKillActive = toggleState
    if toggleState then
        equipTool("Punch")
        task.spawn(function()
            while _G.autoKillActive do
                local character = LocalPlayer.Character
                local leftHand = character and character:FindFirstChild("LeftHand")
                if not leftHand then
                    task.wait(0.3)
                    continue
                end
                local muscleEvent = LocalPlayer:FindFirstChild("muscleEvent")
                if muscleEvent then
                    muscleEvent:FireServer("punch", "rightHand")
                    muscleEvent:FireServer("punch", "leftHand")
                end
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and not table.find(whitelist, player.Name) then
                        local targetChar = player.Character
                        local head = targetChar and targetChar:FindFirstChild("Head")
                        if head then
                            if killMethod == "Teleport" then
                                head.CFrame = leftHand.CFrame
                                for _, part in pairs(targetChar:GetDescendants()) do
                                    if part:IsA("BasePart") and part.Name == "Handle" then
                                        part.CFrame = leftHand.CFrame
                                    end
                                end
                                local sweatPart = targetChar:FindFirstChild("sweatPart")
                                if sweatPart then
                                    sweatPart.CFrame = leftHand.CFrame
                                end
                            end
                        end
                    end
                end
                task.wait(0.3)
            end
        end)
    end
end

KILLING:AddSwitch("Enable Auto Kill", function(state)
    autoKill(state)
end)

KILLING:AddSwitch("Fastest Kill", function(state)
    _G.fasterAutoKill = state
    local punch = LocalPlayer.Backpack:FindFirstChild("Punch")
    local punchEquipped = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Punch")
    if punch and punch:FindFirstChild("attackTime") then
        punch.attackTime.Value = state and 0 or 0.5
    elseif punchEquipped and punchEquipped:FindFirstChild("attackTime") then
        punchEquipped.attackTime.Value = state and 0 or 0.5
    end
end)

local targetPlayerName = nil

KILLING:AddTextBox("Player Username", function(text)
    targetPlayerName = text
end)

local killTarget = false
KILLING:AddSwitch("Auto Kill Player", function(bool)
    killTarget = bool
    while killTarget do
        local player = game.Players.LocalPlayer
        local target = game.Players:FindFirstChild(targetPlayerName)

        if target and target ~= player then
            local targetChar = target.Character
            local rootPart = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

            if rootPart then
                local rightHand = player.Character and player.Character:FindFirstChild("RightHand")
                local leftHand = player.Character and player.Character:FindFirstChild("LeftHand")

                if rightHand and leftHand then
                    firetouchinterest(rightHand, rootPart, 1)
                    firetouchinterest(leftHand, rootPart, 1)
                    firetouchinterest(rightHand, rootPart, 0)
                    firetouchinterest(leftHand, rootPart, 0)
                end
            end
        end

        wait(0.1)
    end
end)

local ohYeahswitch = KILLING:AddSwitch("Spectace Player", function(Value)
end)

local Rebirth = window:AddTab("Rebirth")

local RB = {}
RB.__index = RB

function RB.new(tab)
    local self = setmetatable({}, RB)
    self.on = false
    self.target = 1
    self.tab = tab
    self:ui()
    return self
end

function RB:ui()
    self.input = self.tab:AddTextBox("Target", function(v)
        local n = tonumber(v)
        if n and n >= 1 then
            self.target = n
        else
            self.input:Set("")
        end
    end, { placeholder = "Enter target rebirths" })

    self.tab:AddSwitch("Auto Rebirth(Target)", function(s)
        self.on = s
        if s then
            self:run()
        end
    end)
end

function RB:run()
    task.spawn(function()
        local leaderstats = LocalPlayer:WaitForChild("leaderstats")
        local rebirths = leaderstats and leaderstats:WaitForChild("Rebirths")
        local events = ReplicatedStorage:WaitForChild("rEvents")
        local remote = events and events:WaitForChild("rebirthRemote")

        if not (rebirths and remote) then
            self.on = false
            return
        end

        while self.on do
            if rebirths.Value >= self.target then
                self.on = false
                print("Target rebirths reached! Stopping auto rebirth.")
                break
            end

            local success, errorMessage = pcall(function()
                remote:InvokeServer("rebirthRequest")
            end)

            if not success then
                warn("Failed to send rebirth request: " .. tostring(errorMessage))
            end

            task.wait(1)
        end
    end)
end

local myRebirth = RB.new(Rebirth)

local autoRebirth = false
local switch = Rebirth:AddSwitch("Auto Rebirth (infinite)", function(state)
    autoRebirth = state
    while autoRebirth do
        game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("rebirthRemote"):InvokeServer("rebirthRequest")
        task.wait(0.1)
    end
end)

local autoSizeLoop = nil
local switch = Rebirth:AddSwitch("Auto Size 2", function(state)
    if state then
        autoSizeLoop = task.spawn(function()
            while task.wait(0) do
                game:GetService("ReplicatedStorage").rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", 2)
            end
        end)
    else
        if autoSizeLoop then
            task.cancel(autoSizeLoop)
            autoSizeLoop = nil
        end
    end
end)

Rebirth:AddLabel("Pack Farms | 7 Packs are needed")

local activeTasks = {}
local switch = Rebirth:AddSwitch("Speed Grind (No Rebirth)", function(Value)
    local player = game:GetService("Players").LocalPlayer
    local muscleEvent = player:WaitForChild("muscleEvent")

    if Value then
        for i = 1, 12 do
            local taskFunc = task.spawn(function()
                while task.wait() do
                    muscleEvent:FireServer("rep")
                end
            end)
            table.insert(activeTasks, taskFunc)
        end
    else
        for _, taskFunc in pairs(activeTasks) do
            task.cancel(taskFunc)
        end
        activeTasks = {}
    end
end)

local fastRebirthSwitch = Rebirth:AddSwitch("Fast Rebirths", function(enabled)
    if enabled then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ttvkaiser/Nebula-Hub/refs/heads/main/Muscle-Legends/Ddd.txt"))()
    end
end)

fastRebirthSwitch:Set(false)

Rebirth:AddLabel("----------------------------------------------------------------------------------------")

local postionlockswitch = Rebirth:AddSwitch("Lock Position", function(Value)
    if Value then
        local currentPos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        getgenv().posLock = game:GetService("RunService").Heartbeat:Connect(function()
            if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = currentPos
            end
        end)
    else
        if getgenv().posLock then
            getgenv().posLock:Disconnect()
            getgenv().posLock = nil
        end
    end
end)

local Stats = window:AddTab("Stats")

local function abbreviateNumber(value)
    if value >= 1e15 then
        return string.format("%.1fQa", value / 1e15)
    elseif value >= 1e12 then
        return string.format("%.1fT", value / 1e12)
    elseif value >= 1e9 then
        return string.format("%.1fB", value / 1e9)
    elseif value >= 1e6 then
        return string.format("%.1fM", value / 1e6)
    elseif value >= 1e3 then
        return string.format("%.1fK", value / 1e3)
    else
        return tostring(value)
    end
end

local labels = {
    TimeSpentLabel = Stats:AddLabel("Time spent in this server: 00:00"),
    StrengthGainedLabel = Stats:AddLabel("Amount of strength gained in this server: 0"),
    DurabilityGainedLabel = Stats:AddLabel("Amount of durability gained in this server: 0"),
    AgilityGainedLabel = Stats:AddLabel("Amount of agility gained in this server: 0"),
    KillsGainedLabel = Stats:AddLabel("Amount of kills gained in this server: 0"),
    EvilKarmaGainedLabel = Stats:AddLabel("Amount of Evil Karma gained in this server: 0"),
    GoodKarmaGainedLabel = Stats:AddLabel("Amount of Good Karma gained in this server: 0"),
    RebirthsGainedLabel = Stats:AddLabel("Amount of rebirths gained in this server: 0")
}

local function createMyLabels()
    local player = game.Players.LocalPlayer
    if not player then
        warn("Player not found!")
        return
    end

    local leaderstats = player:WaitForChild("leaderstats", 10)
    if not leaderstats then
        warn("leaderstats not found!")
        return
    end

    local strengthStat = leaderstats:WaitForChild("Strength", 5)
    local durabilityStat = player:WaitForChild("Durability", 5)
    local agilityStat = player:WaitForChild("Agility", 5)
    local killsStat = leaderstats:WaitForChild("Kills", 5)
    local evilKarmaStat = player:WaitForChild("evilKarma", 5)
    local goodKarmaStat = player:WaitForChild("goodKarma", 5)
    local rebirthStat = leaderstats:WaitForChild("Rebirths", 5)

    if not (strengthStat and durabilityStat and agilityStat and killsStat and evilKarmaStat and goodKarmaStat and rebirthStat) then
        warn("One or more stats not found! Check stat names.")
        return
    end

    local initialStrength = strengthStat.Value or 0
    local initialDurability = durabilityStat.Value or 0
    local initialAgility = agilityStat.Value or 0
    local initialKills = killsStat.Value or 0
    local initialEvilKarma = evilKarmaStat.Value or 0
    local initialGoodKarma = goodKarmaStat.Value or 0
    local initialRebirths = rebirthStat.Value or 0

    local startTime = tick()

    local function updateLabels()
        local strengthGained = strengthStat.Value - initialStrength
        local durabilityGained = durabilityStat.Value - initialDurability
        local agilityGained = agilityStat.Value - initialAgility
        local killsGained = killsStat.Value - initialKills
        local evilKarmaGained = evilKarmaStat.Value - initialEvilKarma
        local goodKarmaGained = goodKarmaStat.Value - initialGoodKarma
        local rebirthsGained = rebirthStat.Value - initialRebirths

        labels.StrengthGainedLabel.Text = "Amount of strength gained in this server: " .. abbreviateNumber(strengthGained)
        labels.DurabilityGainedLabel.Text = "Amount of durability gained in this server: " .. abbreviateNumber(durabilityGained)
        labels.AgilityGainedLabel.Text = "Amount of agility gained in this server: " .. abbreviateNumber(agilityGained)
        labels.KillsGainedLabel.Text = "Amount of kills gained in this server: " .. abbreviateNumber(killsGained)
        labels.EvilKarmaGainedLabel.Text = "Amount of Evil Karma gained in this server: " .. abbreviateNumber(evilKarmaGained)
        labels.GoodKarmaGainedLabel.Text = "Amount of Good Karma gained in this server: " .. abbreviateNumber(goodKarmaGained)
        labels.RebirthsGainedLabel.Text = "Amount of rebirths gained in this server: " .. abbreviateNumber(rebirthsGained)
    end

    local function updateTimeSpent()
        local timeSpent = tick() - startTime
        local minutes = math.floor(timeSpent / 60)
        local seconds = math.floor(timeSpent % 60)
        labels.TimeSpentLabel.Text = string.format("Time spent in this server: %02d:%02d", minutes, seconds)
    end

    strengthStat.Changed:Connect(updateLabels)
    durabilityStat.Changed:Connect(updateLabels)
    agilityStat.Changed:Connect(updateLabels)
    killsStat.Changed:Connect(updateLabels)
    evilKarmaStat.Changed:Connect(updateLabels)
    goodKarmaStat.Changed:Connect(updateLabels)
    rebirthStat.Changed:Connect(updateLabels)

    game:GetService("RunService").Heartbeat:Connect(updateTimeSpent)

    updateLabels()
end

createMyLabels()

local MISC = window:AddTab("Misc")

local ConfigFolder = MISC:AddFolder("   CONFIG")

ConfigFolder:AddButton("Destroy Ad Teleport", function()
    local part = workspace:FindFirstChild("RobloxForwardPortals")
    if part then
        part:Destroy()
    end
end)

ConfigFolder:AddButton("Walk On Water", function()
    loadstring(game:HttpGet('https://pastebin.com/raw/xNUMcmvW'))()
end)

ConfigFolder:AddButton("Permanent Shift Lock", function()
    loadstring(game:HttpGet('https://pastebin.com/raw/CjNsnSDy'))()
end)

ConfigFolder:AddButton("Free AutoLift Gamepass", function()
    local gamepassFolder = game:GetService("ReplicatedStorage").gamepassIds
    local player = game:GetService("Players").LocalPlayer
    for _, gamepass in pairs(gamepassFolder:GetChildren()) do
        local value = Instance.new("IntValue")
        value.Name = gamepass.Name
        value.Value = gamepass.Value
        value.Parent = player.ownedGamepasses
    end
end)

ConfigFolder:AddSwitch("Disable Trade", function(State)
    if State then
        game:GetService("ReplicatedStorage").rEvents.tradingEvent:FireServer("disableTrading")
    else
        game:GetService("ReplicatedStorage").rEvents.tradingEvent:FireServer("enableTrading")
    end
end)

ConfigFolder:AddSwitch("Hide Pets", function(State)
    if State then
        game:GetService("ReplicatedStorage").rEvents.showPetsEvent:FireServer("hidePets")
    else
        game:GetService("ReplicatedStorage").rEvents.showPetsEvent:FireServer("showPets")
    end
end)

local PerformnaceHelperFolder = MISC:AddFolder("    PERFORMANCE HELPER")

PerformnaceHelperFolder:AddButton("Anti AFK", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/evxncodes/mainroblox/main/anti-afk", true))()
end)

local thkswitch = PerformnaceHelperFolder:AddSwitch("Hide All Frames", function(state)
    local rSto = game:GetService("ReplicatedStorage")
    for _, obj in pairs(rSto:GetChildren()) do
        if obj.Name:match("Frame$") then
            obj.Visible = not state
        end
    end
end)

local CREDITS = window:AddTab("Credits")

CREDITS:AddLabel("Credits:")
CREDITS:AddLabel("Script by nofomo_56")
CREDITS:AddLabel("Inspired by my big bro ttvkaiser")
CREDITS:AddLabel("Creator of Nebula Hub")
CREDITS:AddLabel("I got super jealous")
CREDITS:AddLabel("So I'm making a script even better!")

else
  print("Wrong Game!!!")
end