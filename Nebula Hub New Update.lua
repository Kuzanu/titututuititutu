local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()
 
local Window = Library:CreateWindow{
    Title = "Te | Game: Muscle Legends | Version [v.2.6.2]",
    SubTitle = "by 72j",
    TabWidth = 160,
    Size = UDim2.fromOffset(1087, 690.5),
    Resize = true,
    MinSize = Vector2.new(470, 380),
    Acrylic = true,
    
    Theme = "Amethyst Dark",
    MinimizeKey = Enum.KeyCode.RightControl
}

local Tabs = {
  Home = Window:CreateTab{
    	Title = "Home",
    	Icon = "house"
    },
    Main = Window:CreateTab{
        Title = "Main",
        Icon = "align-justify"
    },
  	Rocks = Window:CreateTab{
        Title = "Rocks",
        Icon = "mountain"
    },
	  Rebirth = Window:CreateTab{
        Title = "Auto Rebirths",
        Icon = "biceps-flexed"
    },
  	Killing = Window:CreateTab{
        Title = "Auto Kill",
        Icon = "skull"
    },
	Teleport = Window:CreateTab{
        Title = "Teleport",
        Icon = "arrow-left-right"
    },
	Status = Window:CreateTab{
        Title = "Stats",
        Icon = "circle-plus"
    },
	Crystal = Window:CreateTab{
        Title = "Crystal",
        Icon = "gem"
    },
  Calculator = Window:CreateTab{
        Title = "Calculator",
        Icon = "calculator"
    },
	Misc = Window:CreateTab{
        Title = "Misc",
        Icon = "command"
    },
    Credits = Window:CreateTab{
        Title = "Credits",
        Icon = "credit-card"
    },
    Settings = Window:CreateTab{
        Title = "Settings",
        Icon = "settings"
    }
}
local Options = Library.Options

Library:Notify{
    Title = "Welcome to Nebula Hub",
    Content = "Nebula Hub supports 6 games!",
    SubContent = "This game is muscle legends and currently in beta!", -- Optional
    Duration = 13
}

Tabs.Home:AddSection("Discord Server Link")

Tabs.Home:CreateButton({
    Title = "Click to Copy Link",
    Description = "This allows you to join our Discord server and get update pings and more.",
    Callback = function()
      Library:Notify{
    Title = "Nebula Hub Discord Link Copied",
    Content = "Our discord allows to see sneakpeaks. And everything",
    Duration = 2
}
      wait(0.1)
      setclipboard("https://discord.gg/xbRqESfpD8")
    end
})

Tabs.Home:AddSection("Local Player Configurations")

local speed = 350

local speedInput = Tabs.Home:AddInput("SpeedInput", {
    Title = "Speed Input",
    Default = tostring(speed),
    Placeholder = "Enter Speed",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            speed = num
            print("Speed set to:", speed)
            if speedToggle.Value then
                applySpeed()
            end
        end
    end
})

local speedToggle = Tabs.Home:AddToggle("SpeedToggle", {
    Title = "Enable Speed",
    Default = false
})

local function applySpeed()
    local player = game.Players.LocalPlayer
    if not player then return end

    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid and speedToggle.Value then
        humanoid.WalkSpeed = speed
    elseif humanoid then
        humanoid.WalkSpeed = 16
    end
end

speedToggle:OnChanged(function()
    print("Toggle changed:", speedToggle.Value)
    applySpeed()
end)

local player = game.Players.LocalPlayer
player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    if speedToggle.Value then
        task.wait(0.1)
        applySpeed()
    end
end)

local ToggleInfiniteJump = Tabs.Home:AddToggle("Toggle_InfiniteJump", {Title = "Infinite Jump", Default = false})
ToggleInfiniteJump:OnChanged(function()
    if Options.Toggle_InfiniteJump.Value then
        local UserInputService = game:GetService("UserInputService")
        local Player = game.Players.LocalPlayer
        local Character = Player.Character or Player.CharacterAdded:Wait()
        local Humanoid = Character:WaitForChild("Humanoid")

        _G.InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
            if Options.Toggle_InfiniteJump.Value then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        print("Infinite Jump enabled")
    else
        if _G.InfiniteJumpConnection then
            _G.InfiniteJumpConnection:Disconnect()
            _G.InfiniteJumpConnection = nil
        end
        print("Infinite Jump disabled")
    end
end)

local ToggleNoClip = Tabs.Home:AddToggle("Toggle_NoClip", {Title = "No Clip", Default = false})
ToggleNoClip:OnChanged(function()
    local RunService = game:GetService("RunService")
    local Player = game.Players.LocalPlayer

    if Options.Toggle_NoClip.Value then
        _G.NoclipConnection = RunService.Stepped:Connect(function()
            local Character = Player.Character
            if Character then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
        print("No Clip enabled")
    else
        if _G.NoclipConnection then
            _G.NoclipConnection:Disconnect()
            _G.NoclipConnection = nil
        end
        print("No Clip disabled")
    end
end)

Tabs.Main:AddSection("Auto Functions")

local Toggle = Tabs.Main:CreateToggle("AutoRep", {Title = "Auto Lift", Default = false})
Toggle:OnChanged(function(State)
    if State then
        task.spawn(function()
            while Toggle.Value do
                game:GetService("Players").LocalPlayer:WaitForChild("muscleEvent"):FireServer("rep")
                task.wait(0.1)
            end
        end)
    end
end)

local attackSpeed = "Normal"

local chooseAttackSpeedDropdown = Tabs.Main:CreateDropdown("Dropdown", {
    Title = "Choose Speed",
    Values = {"Normal", "Medium", "Fast"},
    Multi = false,
    Default = "Normal",
})

chooseAttackSpeedDropdown:SetValue("Normal")

chooseAttackSpeedDropdown:OnChanged(function(Value)
    attackSpeed = Value
end)

local function getAttackTime()
    if attackSpeed == "Fast" then
        return 0
    elseif attackSpeed == "Medium" then
        return 0.15
    else
        return 0.35
    end
end

local Toggle = Tabs.Main:CreateToggle("AutoPunchWithAnim", {
    Title = "Auto Punch",
    Default = false
})

Toggle:OnChanged(function(state)
    while state and Toggle.Value do
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
                attackTime.Value = getAttackTime()
            end

            punchTool:Activate()
        else
            Toggle:SetValue(false)
        end

        task.wait()
    end
end)

Tabs.Main:AddSection("Auto Gym")


local gymToTools = {
    ["Jungle"] = {"Boulder", "Bench", "Squat", "Bar Lift"},
    ["Muscle King"] = {"Boulder", "Bench", "Squat", "Dead Lift"},
}

local machineData = {
    ["Jungle"] = {
        Boulder   = {cf = CFrame.new(-8617,  37, 2677),   rName = "Jungle Boulder"},
        Bench     = {cf = CFrame.new(-8629.88, 64.88, 1855.03), rName = "Jungle Bench"},
        Squat     = {cf = CFrame.new(-8374.26, 34.59, 2932.45), rName = "Jungle Squat"},
        ["Bar Lift"] = {cf = CFrame.new(-8678.06, 14.50, 2089.26), rName = "Jungle Bar Lift"},
    },
    ["Muscle King"] = {
        Boulder    = {cf = CFrame.new(-8940.12, 13.16, -5699.13), rName = "King Boulder"},
        Bench      = {cf = CFrame.new(-8590.06, 46.02, -6043.35), rName = "Muscle King Bench"},
        Squat      = {cf = CFrame.new(-8759,    44,    -6044   ), rName = "Muscle King Squat"},
        ["Dead Lift"] = {cf = CFrame.new(-8773,    50,    -5664   ), rName = "Muscle King Lift"},
    }
}

local SelectGymDropdown = Tabs.Main:CreateDropdown("SelectGym", {
    Title   = "Select Gym",
    Values  = {"Jungle", "Muscle King"},
    Multi   = false,
    Default = 1,
})

local SelectToolDropdown = Tabs.Main:CreateDropdown("SelectTool", {
    Title   = "Select Tool",
    Values  = gymToTools["Jungle"],
    Multi   = false,
    Default = 1,
})

SelectGymDropdown:OnChanged(function(newGym)
    if SelectToolDropdown.SetValues then
        SelectToolDropdown:SetValues(gymToTools[newGym])
        SelectToolDropdown:SetValue(gymToTools[newGym][1])
    end
end)

local StartGymToggle = Tabs.Main:CreateToggle("MyToggle", {
    Title   = "Auto Gym (choose both dropdowns first)",
    Default = false
})

local runService = game:GetService("RunService")
local loopConn

StartGymToggle:OnChanged(function()
    if loopConn then
        loopConn:Disconnect()
        loopConn = nil
    end

    if Options.MyToggle.Value then
        loopConn = runService.Heartbeat:Connect(function()
            local gym  = SelectGymDropdown.Value
            local tool = SelectToolDropdown.Value
            local info = machineData[gym] and machineData[gym][tool]
            if not info then return end

            local char = game.Players.LocalPlayer.Character
            if not (char and char.PrimaryPart) then return end

            char:SetPrimaryPartCFrame(info.cf)
            game:GetService("ReplicatedStorage").rEvents.machineInteractRemote:InvokeServer(
                "useMachine",
                workspace.machinesFolder[info.rName].interactSeat
            )
        end)
    end
end)

SelectGymDropdown:SetValue("Jungle")
SelectToolDropdown:SetValue("Boulder")
Options.MyToggle:SetValue(false)

Tabs.Main:AddSection("Auto Farm")

local repSpeed = "Normal"

local chooseRepSpeedDropdown = Tabs.Main:CreateDropdown("Dropdown", {
    Title = "Choose Rep Speed",
    Values = {"Normal", "Fast"},
    Multi = false,
    Default = "Normal",
})

chooseRepSpeedDropdown:SetValue("Normal")

chooseRepSpeedDropdown:OnChanged(function(Value)
    repSpeed = Value
end)

local function getRepTime()
    return repSpeed == "Fast" and 0 or 1
end

local fastWeightToggle = Tabs.Main:CreateToggle("FastWeight", {Title = "Auto Weight", Default = false})
fastWeightToggle:OnChanged(function(state)
    while state and fastWeightToggle.Value do
        local player = game.Players.LocalPlayer
        local char = player.Character
        local tool = player.Backpack:FindFirstChild("Weight") or (char and char:FindFirstChild("Weight"))

        if tool then
            if tool.Parent ~= char then
                tool.Parent = char
                task.wait(0.1)
            end

            local repTime = tool:FindFirstChild("repTime")
            if repTime then
                repTime.Value = getRepTime()
            end

            tool:Activate()
        end

        task.wait()
    end
end)

local fastPushupToggle = Tabs.Main:CreateToggle("FastPushups", {Title = "Auto Pushups", Default = false})
fastPushupToggle:OnChanged(function(state)
    while state and fastPushupToggle.Value do
        local player = game.Players.LocalPlayer
        local char = player.Character
        local tool = player.Backpack:FindFirstChild("Pushups") or (char and char:FindFirstChild("Pushups"))

        if tool then
            if tool.Parent ~= char then
                tool.Parent = char
                task.wait(0.1)
            end

            local repTime = tool:FindFirstChild("repTime")
            if repTime then
                repTime.Value = getRepTime()
            end

            tool:Activate()
        end

        task.wait()
    end
end)

local fastSitupToggle = Tabs.Main:CreateToggle("FastSitups", {Title = "Auto Situps", Default = false})
fastSitupToggle:OnChanged(function(state)
    while state and fastSitupToggle.Value do
        local player = game.Players.LocalPlayer
        local char = player.Character
        local tool = player.Backpack:FindFirstChild("Situps") or (char and char:FindFirstChild("Situps"))

        if tool then
            if tool.Parent ~= char then
                tool.Parent = char
                task.wait(0.1)
            end

            local repTime = tool:FindFirstChild("repTime")
            if repTime then
                repTime.Value = getRepTime()
            end

            tool:Activate()
        end

        task.wait()
    end
end)

local fastHandstandToggle = Tabs.Main:CreateToggle("FastHandstands", {Title = "Auto Handstands", Default = false})
fastHandstandToggle:OnChanged(function(state)
    while state and fastHandstandToggle.Value do
        local player = game.Players.LocalPlayer
        local char = player.Character
        local tool = player.Backpack:FindFirstChild("Handstands") or (char and char:FindFirstChild("Handstands"))

        if tool then
            if tool.Parent ~= char then
                tool.Parent = char
                task.wait(0.1)
            end

            local repTime = tool:FindFirstChild("repTime")
            if repTime then
                repTime.Value = getRepTime()
            end

            tool:Activate()
        end

        task.wait()
    end
end)

Tabs.Main:AddSection("Auto Equip")

local equipWeightToggle = Tabs.Main:CreateToggle("EquipWeight", {Title = "Auto Equip Weight", Default = false})
equipWeightToggle:OnChanged(function(State)
    if State then
        task.spawn(function()
            while equipWeightToggle.Value do
                local tool = game.Players.LocalPlayer.Backpack:FindFirstChild("Weight")
                if tool then tool.Parent = game.Players.LocalPlayer.Character end
                task.wait(0.1)
            end
        end)
    end
end)

local equipPushupToggle = Tabs.Main:CreateToggle("EquipPushups", {Title = "Auto Equip Pushups", Default = false})
equipPushupToggle:OnChanged(function(State)
    if State then
        task.spawn(function()
            while equipPushupToggle.Value do
                local tool = game.Players.LocalPlayer.Backpack:FindFirstChild("Pushups")
                if tool then tool.Parent = game.Players.LocalPlayer.Character end
                task.wait(0.1)
            end
        end)
    end
end)

local equipSitupToggle = Tabs.Main:CreateToggle("EquipSitups", {Title = "Auto Equip Situps", Default = false})
equipSitupToggle:OnChanged(function(State)
    if State then
        task.spawn(function()
            while equipSitupToggle.Value do
                local tool = game.Players.LocalPlayer.Backpack:FindFirstChild("Situps")
                if tool then tool.Parent = game.Players.LocalPlayer.Character end
                task.wait(0.1)
            end
        end)
    end
end)

local equipHandstandToggle = Tabs.Main:CreateToggle("EquipHandstands", {Title = "Auto Equip Handstands", Default = false})
equipHandstandToggle:OnChanged(function(State)
    if State then
        task.spawn(function()
            while equipHandstandToggle.Value do
                local tool = game.Players.LocalPlayer.Backpack:FindFirstChild("Handstands")
                if tool then tool.Parent = game.Players.LocalPlayer.Character end
                task.wait(0.1)
            end
        end)
    end
end)

Tabs.Main:AddSection("Brawl")

-- God Mode (Brawl) Toggle
local godModeToggle = Tabs.Main:CreateToggle("GodModeBrawl", {
    Title = "God Mode (Brawl)",
    Default = false
})

godModeToggle:OnChanged(function()
    local state = Options.GodModeBrawl.Value
    if state then
        task.spawn(function()
            while Options.GodModeBrawl.Value do
                game:GetService("ReplicatedStorage").rEvents.brawlEvent:FireServer("joinBrawl")
                task.wait(0)
            end
        end)
    end
end)

-- Auto Join Brawl Toggle
local autoJoinToggle = Tabs.Main:CreateToggle("AutoJoinBrawl", {
    Title = "Auto Join Brawl",
    Default = false
})

autoJoinToggle:OnChanged(function()
    local state = Options.AutoJoinBrawl.Value
    if state then
        task.spawn(function()
            while Options.AutoJoinBrawl.Value do
                game:GetService("ReplicatedStorage").rEvents.brawlEvent:FireServer("joinBrawl")
                task.wait(2)
            end
        end)
    end
end)

-- Auto Rebirth (Normal)
local autoRebirthToggle = Tabs.Rebirth:CreateToggle("AutoRebirth", {Title = "Auto Rebirth (Normal)", Default = false})
autoRebirthToggle:OnChanged(function(State)
	if State then
		task.spawn(function()
			while autoRebirthToggle.Value do
				game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("rebirthRemote"):InvokeServer("rebirthRequest")
				task.wait(0.1)
			end
		end)
	end
end)

-- Auto Size 2
local autoSize2Toggle = Tabs.Rebirth:CreateToggle("AutoSize2", {Title = "Auto Size 2", Default = false})
autoSize2Toggle:OnChanged(function(State)
	if State then
		autoSizeLoop = task.spawn(function()
			while autoSize2Toggle.Value do
				game:GetService("ReplicatedStorage").rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", 2)
				task.wait()
			end
		end)
	else
		if autoSizeLoop then
			task.cancel(autoSizeLoop)
			autoSizeLoop = nil
		end
	end
end)

-- Hide All Frames
local hideFramesToggle = Tabs.Rebirth:CreateToggle("HideAllFrames", {Title = "Hide All Frames", Default = false})
hideFramesToggle:OnChanged(function(State)
	local rSto = game:GetService("ReplicatedStorage")
	for _, obj in pairs(rSto:GetChildren()) do
		if obj:IsA("Instance") and obj.Name:match("Frame$") then
			obj.Visible = not State
		end
	end
end)

-- Label
Tabs.Rebirth:AddSection("OP Stuff")

-- Fast Rebirths
local fastRebirthsToggle = Tabs.Rebirth:CreateToggle("FastRebirths", {Title = "Fast Rebirths", Default = false})
fastRebirthsToggle:OnChanged(function(State)
	if State then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ttvkaiser/Nebula-Hub/refs/heads/main/Muscle-Legends/Ddd.txt"))()
	end
end)

-- Speed Grind (No Rebirth)
local speedGrindToggle = Tabs.Rebirth:CreateToggle("SpeedGrind", {Title = "Fast Grind (No Rebirth)", Default = false})
speedGrindToggle:OnChanged(function(State)
	if State then
		for i = 1, 12 do
			task.spawn(function()
				while speedGrindToggle.Value do
					game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
					task.wait(0.083)
				end
			end)
		end
	end
end)

Tabs.Rocks:AddSection("Auto Punch Rocks")

local player = game.Players.LocalPlayer

repeat task.wait() until game:IsLoaded() and player.Character and player.Character:FindFirstChild("Humanoid") and workspace

local ROCK_MODE = "shrink"

local function gettool()
    local tool = player.Backpack:FindFirstChild("Punch") or player.Character:FindFirstChild("Punch")
    if tool and tool.Parent ~= player.Character then
        tool.Parent = player.Character
        task.wait(0.1)
    elseif not tool then
        warn("Punch tool not found in Backpack or Character")
    end
    return tool
end

local function modifyRock(rock)
    if not rock then return end
    if ROCK_MODE == "shrink" then
        rock.Size = rock.Size * 0.1
    elseif ROCK_MODE == "hide" then
        rock.Transparency = 1
        rock.CanCollide = false
    end
end

local function farmRocks(neededDurabilityValue)
    while getgenv().autoFarm do
        task.wait()
        local character = player.Character
        local machinesFolder = workspace:FindFirstChild("machinesFolder")
        if not character or not machinesFolder then return end

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
                    end
                end
            end
        end
    end
end

-- Create the toggle with Fluent Renewed syntax
local JungleToggle = Tabs.Rocks:CreateToggle("JungleRockToggle", {
    Title = "Jungle Rock (10M)",
    Default = false
})

-- Use OnChanged to handle toggle changes
JungleToggle:OnChanged(function()
    local state = Options.JungleRockToggle.Value
    _G.fastHitActive = state
    getgenv().autoFarm = state

    if state then
        coroutine.wrap(function()
            while _G.fastHitActive do
                local character = player.Character
                if character then
                    for _ = 1, 10 do
                        gettool()
                        farmRocks(10000000)
                    end
                end
                task.wait(0.1)
            end
        end)()
    else
        local character = player.Character
        local equipped = character and character:FindFirstChild("Punch")
        if equipped then
            equipped.Parent = player.Backpack
        end
    end
end)

-- You can also set the toggle state programmatically like this:
Options.JungleRockToggle:SetValue(false)

local MuscleKingRockToggle = Tabs.Rocks:CreateToggle("MuscleKingRockToggle", {
    Title = "Muscle King Rock (5M)",
    Default = false
})

-- Use OnChanged to handle toggle changes
MuscleKingRockToggle:OnChanged(function()
    local state = Options.MuscleKingRockToggle.Value
    _G.fastHitActive = state
    getgenv().autoFarm = state

    if state then
        coroutine.wrap(function()
            while _G.fastHitActive do
                local character = player.Character
                if character then
                    for _ = 1, 10 do
                        gettool()
                        farmRocks(5000000)
                    end
                end
                task.wait(0.1)
            end
        end)()
    else
        local character = player.Character
        local equipped = character and character:FindFirstChild("Punch")
        if equipped then
            equipped.Parent = player.Backpack
        end
    end
end)

Options.MuscleKingRockToggle:SetValue(false)

local LegendRockToggle = Tabs.Rocks:CreateToggle("LegendRockToggle", {
    Title = "Legend Rock (1M)",
    Default = false
})

-- Use OnChanged to handle toggle changes
LegendRockToggle:OnChanged(function()
    local state = Options.LegendRockToggle.Value
    _G.fastHitActive = state
    getgenv().autoFarm = state

    if state then
        coroutine.wrap(function()
            while _G.fastHitActive do
                local character = player.Character
                if character then
                    for _ = 1, 10 do
                        gettool()
                        farmRocks(1000000)
                    end
                end
                task.wait(0.1)
            end
        end)()
    else
        local character = player.Character
        local equipped = character and character:FindFirstChild("Punch")
        if equipped then
            equipped.Parent = player.Backpack
        end
    end
end)

Options.LegendRockToggle:SetValue(false)

local InfernoRockToggle = Tabs.Rocks:CreateToggle("InfernoRockToggle", {
    Title = "Inferno Rock (750K)",
    Default = false
})

-- Use OnChanged to handle toggle changes
InfernoRockToggle:OnChanged(function()
    local state = Options.InfernoRockToggle.Value
    _G.fastHitActive = state
    getgenv().autoFarm = state

    if state then
        coroutine.wrap(function()
            while _G.fastHitActive do
                local character = player.Character
                if character then
                    for _ = 1, 10 do
                        gettool()
                        farmRocks(750000)
                    end
                end
                task.wait(0.1)
            end
        end)()
    else
        local character = player.Character
        local equipped = character and character:FindFirstChild("Punch")
        if equipped then
            equipped.Parent = player.Backpack
        end
    end
end)

Options.InfernoRockToggle:SetValue(false)

local MysticRockToggle = Tabs.Rocks:CreateToggle("MysticRockToggle", {
    Title = "Mystic Rock (400K)",
    Default = false
})

-- Use OnChanged to handle toggle changes
MysticRockToggle:OnChanged(function()
    local state = Options.MysticRockToggle.Value
    _G.fastHitActive = state
    getgenv().autoFarm = state

    if state then
        coroutine.wrap(function()
            while _G.fastHitActive do
                local character = player.Character
                if character then
                    for _ = 1, 10 do
                        gettool()
                        farmRocks(400000)
                    end
                end
                task.wait(0.1)
            end
        end)()
    else
        local character = player.Character
        local equipped = character and character:FindFirstChild("Punch")
        if equipped then
            equipped.Parent = player.Backpack
        end
    end
end)

Options.MysticRockToggle:SetValue(false)

local FrozenRockToggle = Tabs.Rocks:CreateToggle("FrozenRockToggle", {
    Title = "Frozen Rock (150K)",
    Default = false
})

-- Use OnChanged to handle toggle changes
FrozenRockToggle:OnChanged(function()
    local state = Options.FrozenRockToggle.Value
    _G.fastHitActive = state
    getgenv().autoFarm = state

    if state then
        coroutine.wrap(function()
            while _G.fastHitActive do
                local character = player.Character
                if character then
                    for _ = 1, 10 do
                        gettool()
                        farmRocks(150000)
                    end
                end
                task.wait(0.1)
            end
        end)()
    else
        local character = player.Character
        local equipped = character and character:FindFirstChild("Punch")
        if equipped then
            equipped.Parent = player.Backpack
        end
    end
end)

Options.FrozenRockToggle:SetValue(false)

local GoldenRockToggle = Tabs.Rocks:CreateToggle("GoldenRockToggle", {
    Title = "Golden Rock (5K)",
    Default = false
})

-- Use OnChanged to handle toggle changes
GoldenRockToggle:OnChanged(function()
    local state = Options.GoldenRockToggle.Value
    _G.fastHitActive = state
    getgenv().autoFarm = state

    if state then
        coroutine.wrap(function()
            while _G.fastHitActive do
                local character = player.Character
                if character then
                    for _ = 1, 10 do
                        gettool()
                        farmRocks(5000)
                    end
                end
                task.wait(0.1)
            end
        end)()
    else
        local character = player.Character
        local equipped = character and character:FindFirstChild("Punch")
        if equipped then
            equipped.Parent = player.Backpack
        end
    end
end)

Options.GoldenRockToggle:SetValue(false)

local LargeRockToggle = Tabs.Rocks:CreateToggle("LargeRockToggle", {
    Title = "Large Rock (100)",
    Default = false
})

-- Use OnChanged to handle toggle changes
LargeRockToggle:OnChanged(function()
    local state = Options.LargeRockToggle.Value
    _G.fastHitActive = state
    getgenv().autoFarm = state

    if state then
        coroutine.wrap(function()
            while _G.fastHitActive do
                local character = player.Character
                if character then
                    for _ = 1, 10 do
                        gettool()
                        farmRocks(100)
                    end
                end
                task.wait(0.1)
            end
        end)()
    else
        local character = player.Character
        local equipped = character and character:FindFirstChild("Punch")
        if equipped then
            equipped.Parent = player.Backpack
        end
    end
end)

Options.LargeRockToggle:SetValue(false)

local PunchingRockToggle = Tabs.Rocks:CreateToggle("PunchingRockToggle", {
    Title = "Punching Rock (10)",
    Default = false
})

-- Use OnChanged to handle toggle changes
PunchingRockToggle:OnChanged(function()
    local state = Options.PunchingRockToggle.Value
    _G.fastHitActive = state
    getgenv().autoFarm = state

    if state then
        coroutine.wrap(function()
            while _G.fastHitActive do
                local character = player.Character
                if character then
                    for _ = 1, 10 do
                        gettool()
                        farmRocks(10)
                    end
                end
                task.wait(0.1)
            end
        end)()
    else
        local character = player.Character
        local equipped = character and character:FindFirstChild("Punch")
        if equipped then
            equipped.Parent = player.Backpack
        end
    end
end)

Options.PunchingRockToggle:SetValue(false)

local TinyRockToggle = Tabs.Rocks:CreateToggle("TinyRockToggle", {
    Title = "Tiny Rock (0)",
    Default = false
})

-- Use OnChanged to handle toggle changes
TinyRockToggle:OnChanged(function()
    local state = Options.LegendRockToggle.Value
    _G.fastHitActive = state
    getgenv().autoFarm = state

    if state then
        coroutine.wrap(function()
            while _G.fastHitActive do
                local character = player.Character
                if character then
                    for _ = 1, 10 do
                        gettool()
                        farmRocks(0)
                    end
                end
                task.wait(0.1)
            end
        end)()
    else
        local character = player.Character
        local equipped = character and character:FindFirstChild("Punch")
        if equipped then
            equipped.Parent = player.Backpack
        end
    end
end)

Options.TinyRockToggle:SetValue(false)

local whitelist = {}

Tabs.Killing:CreateInput("WhitelistBox", {
    Title = "Whitelist Player",
    Default = "",
    Placeholder = "Enter username...",
    Numeric = false,
    Callback = function(text)
        local target = game.Players:FindFirstChild(text)
        if target then
            whitelist[target.Name] = true
        end
    end
})

local Toggle = Tabs.Killing:CreateToggle("AutoKill", {Title = "Auto Kill", Default = false})

Toggle:OnChanged(function(state)
    while state and Toggle.Value do
        local player = game.Players.LocalPlayer
        local char = player.Character or game.Workspace:FindFirstChild(player.Name)

        -- Equip Punch Tool
        local punchTool = player.Backpack:FindFirstChild("Punch") or (char and char:FindFirstChild("Punch"))
        if punchTool then
            if punchTool.Parent ~= char then
                punchTool.Parent = char
                task.wait(0.1)
            end

            local attackTime = punchTool:FindFirstChild("attackTime")
            if attackTime then
                attackTime.Value = 0
            end

            punchTool:Activate()
        else
            warn("Punch tool not found")
            Toggle:SetValue(false)
            break
        end

        -- Damage all non-whitelisted players
        for _, target in ipairs(game.Players:GetPlayers()) do
            if target ~= player and not whitelist[target.Name] then
                local root = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                local rHand = char and char:FindFirstChild("RightHand")
                local lHand = char and char:FindFirstChild("LeftHand")

                if root and rHand and lHand then
                    firetouchinterest(rHand, root, 1)
                    firetouchinterest(lHand, root, 1)
                    firetouchinterest(rHand, root, 0)
                    firetouchinterest(lHand, root, 0)
                end
            end
        end

        task.wait(0.1)
    end
end)

-- Target Kill
local targetPlayerName = nil
Tabs.Killing:CreateInput("TargetPlayerBox", {
    Title = "Player Username",
    Default = "",
    Placeholder = "Enter exact username...",
    Callback = function(text)
        targetPlayerName = text
    end
})

local Toggle = Tabs.Killing:CreateToggle("AutoKillTarget", {Title = "Auto Kill Player", Default = false})
Toggle:OnChanged(function(state)
    while state and Toggle.Value do
        local player = game.Players.LocalPlayer
        local target = game.Players:FindFirstChild(targetPlayerName)

        if target and target ~= player then
            local root = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
            local rHand = player.Character and player.Character:FindFirstChild("RightHand")
            local lHand = player.Character and player.Character:FindFirstChild("LeftHand")

            if root and rHand and lHand then
                firetouchinterest(rHand, root, 1)
                firetouchinterest(lHand, root, 1)
                firetouchinterest(rHand, root, 0)
                firetouchinterest(lHand, root, 0)
            end
        end
        task.wait(0.1)
    end
end)

local SelectAreaDropdown = Tabs.Teleport:CreateDropdown("Dropdown", {
    Title = "Select Area",
    Values = {
        "Tiny Island", "Starter Island", "Beach", "Frost Gym", "Mythical Gym",
        "Inferno Gym", "Legends Gym", "Muscle King", "Jungle Gym", "Lava Brawl",
        "Desert Brawl", "Boxing Brawl", "Secret"
    },
    Multi = false,
    Default = "Starter Island",
})

SelectAreaDropdown:SetValue("Starter Island")

local selectedArea = "Starter Island"

SelectAreaDropdown:OnChanged(function(Value)
    selectedArea = Value
end)

local areaCoordinates = {
    ["Tiny Island"] = Vector3.new(-34.833778381347656, 7.535726547241211, 1882.3487548828125),
    ["Starter Island"] = Vector3.new(-39.778141021728516, 7.382498741149902, 164.24920654296879),
    ["Beach"] = Vector3.new(4.4908833503723145, 7.382500648498535, -370.3563537597656),
    ["Frost Gym"] = Vector3.new(-2631.5400390625, 7.382497787475586, -399.8075256347656),
    ["Mythical Gym"] = Vector3.new(2250.778076171875, 7.382497310638428, 1073.2266845703125),
    ["Inferno Gym"] = Vector3.new(-6758.9638671875, 7.382511615753174, -1284.918701171875)),
    ["Legends Gym"] = Vector3.new(4603.28173828125, 991.560546875, -3897.86572265625),
    ["Muscle King"] = Vector3.new(-8625.9326171875, 17.232524871826172, -5730.47314453125),
    ["Jungle Gym"] = Vector3.new(-8685.62109375, 6.811502933502197, 2392.32666015625),
    ["Lava Brawl"] = Vector3.new(4466.83837890625, 16.832529067993164, -8848.7451171875),
    ["Desert Brawl"] = Vector3.new(985.3681640625, 17.232528686523438, -7457.43310546875),
    ["Boxing Brawl"] = Vector3.new(-1868.568359375, 17.232528686523438, -6315.73486328125),
    ["Secret"] = Vector3.new(1950.8814697265625, 1.8605183362960815, 06184.2705078125),
}

Tabs.Teleport:CreateButton{
    Title = "Teleport to Area",
    Description = "",
    Callback = function()
        local player = game.Players.LocalPlayer
        local char = player and player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local position = areaCoordinates[selectedArea]
        if hrp and position then
            hrp.CFrame = CFrame.new(position)
        end
    end
}

Tabs.Status:AddSection("Stats Gained")

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

local statsParagraph = Tabs.Status:CreateParagraph("StatsSummary", {
    Title = "Stats Summary",
    Content = "Loading stats...",
    TitleAlignment = "Middle",
    ContentAlignment = Enum.TextXAlignment.Left
})

local function createMyParagraphStats()
    local player = game.Players.LocalPlayer
    if not player then return end

    local leaderstats = player:WaitForChild("leaderstats")
    local strengthStat = leaderstats:WaitForChild("Strength")
    local durabilityStat = player:WaitForChild("Durability")
    local agilityStat = player:WaitForChild("Agility")
    local killsStat = leaderstats:WaitForChild("Kills")
    local evilKarmaStat = player:WaitForChild("evilKarma")
    local goodKarmaStat = player:WaitForChild("goodKarma")

    local initialStrength = strengthStat.Value
    local initialDurability = durabilityStat.Value
    local initialAgility = agilityStat.Value
    local initialKills = killsStat.Value
    local initialEvilKarma = evilKarmaStat.Value
    local initialGoodKarma = goodKarmaStat.Value

    local startTime = tick()

    local function updateStatsContent()
        local strengthGained = abbreviateNumber(strengthStat.Value - initialStrength)
        local durabilityGained = abbreviateNumber(durabilityStat.Value - initialDurability)
        local agilityGained = abbreviateNumber(agilityStat.Value - initialAgility)
        local killsGained = abbreviateNumber(killsStat.Value - initialKills)
        local evilKarmaGained = abbreviateNumber(evilKarmaStat.Value - initialEvilKarma)
        local goodKarmaGained = abbreviateNumber(goodKarmaStat.Value - initialGoodKarma)

        local timeSpent = tick() - startTime
        local minutes = math.floor(timeSpent / 60)
        local seconds = math.floor(timeSpent % 60)
        local timeString = string.format("%02d:%02d", minutes, seconds)

        local content = string.format(
            "Time Spent: %s\nStrength Gained: %s\nDurability Gained: %s\nAgility Gained: %s\nKills Gained: %s\nEvil Karma Gained: %s\nGood Karma Gained: %s",
            timeString, strengthGained, durabilityGained, agilityGained, killsGained, evilKarmaGained, goodKarmaGained
        )

        statsParagraph:SetContent(content)
    end

    strengthStat.Changed:Connect(updateStatsContent)
    durabilityStat.Changed:Connect(updateStatsContent)
    agilityStat.Changed:Connect(updateStatsContent)
    killsStat.Changed:Connect(updateStatsContent)
    evilKarmaStat.Changed:Connect(updateStatsContent)
    goodKarmaStat.Changed:Connect(updateStatsContent)

    game:GetService("RunService").Heartbeat:Connect(updateStatsContent)

    updateStatsContent()
end

createMyParagraphStats()

Tabs.Status:CreateSection("Current Stats")

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

local statsParagraph = Tabs.Status:CreateParagraph("StatsSummary", {
    Title = "Current Stats",
    Content = "Loading...",
    TitleAlignment = "Middle",
    ContentAlignment = Enum.TextXAlignment.Left
})

local function createCurrentStatsParagraph()
    local player = game.Players.LocalPlayer
    if not player then return end

    local leaderstats = player:WaitForChild("leaderstats")
    local strengthStat = leaderstats:WaitForChild("Strength")
    local durabilityStat = player:WaitForChild("Durability")
    local agilityStat = player:WaitForChild("Agility")
    local killsStat = leaderstats:WaitForChild("Kills")
    local evilKarmaStat = player:WaitForChild("evilKarma")
    local goodKarmaStat = player:WaitForChild("goodKarma")

    local function updateStats()
        local content = string.format(
            "Strength: %s\nDurability: %s\nAgility: %s\nKills: %s\nEvil Karma: %s\nGood Karma: %s",
            abbreviateNumber(strengthStat.Value),
            abbreviateNumber(durabilityStat.Value),
            abbreviateNumber(agilityStat.Value),
            abbreviateNumber(killsStat.Value),
            abbreviateNumber(evilKarmaStat.Value),
            abbreviateNumber(goodKarmaStat.Value)
        )

        statsParagraph:SetContent(content)
    end

    strengthStat.Changed:Connect(updateStats)
    durabilityStat.Changed:Connect(updateStats)
    agilityStat.Changed:Connect(updateStats)
    killsStat.Changed:Connect(updateStats)
    evilKarmaStat.Changed:Connect(updateStats)
    goodKarmaStat.Changed:Connect(updateStats)

    game:GetService("RunService").Heartbeat:Connect(updateStats)

    updateStats()
end

createCurrentStatsParagraph()

local selectedCrystal = "Galaxy Oracle Crystal"
local autoCrystalRunning = false

-- Crystal names
local crystalNames = {
    "Blue Crystal", "Green Crystal", "Frozen Crystal", "Mythical Crystal",
    "Inferno Crystal", "Legends Crystal", "Muscle Elite Crystal",
    "Galaxy Oracle Crystal", "Sky Eclipse Crystal", "Jungle Crystal"
}

-- Create Dropdown
local CrystalDropdown = Tabs.Crystal:CreateDropdown("CrystalDropdown", {
    Title = "Select Crystal",
    Values = crystalNames,
    Multi = false,
    Default = table.find(crystalNames, selectedCrystal) or 1,
})

CrystalDropdown:OnChanged(function(value)
    selectedCrystal = value
    print("[Nebula Hub] Selected Crystal:", value)
end)

-- Function to auto open crystal
local function autoOpenCrystal()
    while autoCrystalRunning do
        pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("openCrystalRemote"):InvokeServer("openCrystal", selectedCrystal)
        end)
        task.wait(0.1)
    end
end

-- Create Toggle
local CrystalToggle = Tabs.Crystal:CreateToggle("AutoCrystalToggle", {
    Title = "Auto Crystal",
    Default = false,
})

CrystalToggle:OnChanged(function()
    autoCrystalRunning = Options.AutoCrystalToggle.Value

    if autoCrystalRunning then
        task.spawn(autoOpenCrystal)
    else
        print("[Nebula Hub] Auto Crystal stopped.")
    end
end)

Tabs.Crystal:CreateSection("Auto Open Pets")

Tabs.Crystal:CreateSection("Gems Duper")

local gemWarnerParagraph = Tabs.Crystal:CreateParagraph("Paragraph", {
    Title = "About Gem Duper",
    Content = "This only works in private servers or low-player count servers.\nThis gem duper is in beta but will be improved soon."
})

-- Permanent Shift Lock Button
Tabs.Misc:CreateButton({
    Title = "Permanent Shift Lock",
    Callback = function()
        loadstring(game:HttpGet('https://pastebin.com/raw/CjNsnSDy'))()
    end
})

local Toggle = Tabs.Misc:CreateToggle("LockPosition", {
    Title = "Lock Position",
    Default = false
})

Toggle:OnChanged(function(Value)
    if Value then
        local currentPos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        getgenv().posLock = game:GetService("RunService").Heartbeat:Connect(function()
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = currentPos
            end
        end)
    else
        if getgenv().posLock then
            getgenv().posLock:Disconnect()
            getgenv().posLock = nil
        end
    end
end)

Tabs.Misc:CreateToggle("DisableTrade", {Title = "Disable Trade", Default = false}):OnChanged(function(state)
    local tradeEvent = game:GetService("ReplicatedStorage").rEvents.tradingEvent
    if state then
        tradeEvent:FireServer("disableTrading")
    else
        tradeEvent:FireServer("enableTrading")
    end
end)

Tabs.Misc:CreateToggle("HidePets", {Title = "Hide Pets", Default = false}):OnChanged(function(state)
    local petEvent = game:GetService("ReplicatedStorage").rEvents.showPetsEvent
    if state then
        petEvent:FireServer("hidePets")
    else
        petEvent:FireServer("showPets")
    end
end)

Tabs.Misc:CreateSection("Game Enhancers")

Tabs.Misc:CreateButton({
    Title = "Anti AFK [NEBULA]",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Kuzanu/Kaka-67/refs/heads/main/anti_afk.lua", true))()
    end
})

Tabs.Misc:CreateButton({
    Title = "Anti AFK [MOHA]",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Moha-space/SPACE-HUB-/refs/heads/main/MAIN%20AINTI%20AFK%20.txt"))()
    end
})

Tabs.Misc:CreateButton{
    Title = "Instant FPS Boost",
    Description = "Clears effects and boosts performance immediately.",
    Callback = function()
        -- Disable laggy visual effects
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") then
                obj.Enabled = false
            elseif obj:IsA("Explosion") then
                obj:Destroy()
            end
        end

        -- Remove decals/textures
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            end
        end

        -- Lower graphics quality
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

        -- Turn off terrain decorations if available
        if workspace:FindFirstChildOfClass("Terrain") then
            workspace.Terrain.Decorations = false
        end

        -- Force garbage collection
        collectgarbage("collect")

        print("[Nebula Hub] Performance Boost Applied ✔️")
    end
}

Tabs.Misc:CreateButton{
    Title = "No Lag",
    Description = "Instantly removes lag by cleaning visuals, effects, and more.",
    Callback = function()
        -- Disable visual effects
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                obj.Enabled = false
            elseif obj:IsA("Explosion") then
                obj:Destroy()
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj:Destroy()
            elseif obj:IsA("Lighting") then
                obj:Destroy()
            end
        end

        -- Lower graphics quality
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

        -- Disable terrain decoration
        if workspace:FindFirstChildOfClass("Terrain") then
            workspace.Terrain.Decorations = false
        end

        -- Remove sounds
        for _, s in pairs(workspace:GetDescendants()) do
            if s:IsA("Sound") then
                s:Destroy()
            end
        end

        -- Remove accessories and clothing
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        for _, item in pairs(character:GetDescendants()) do
            if item:IsA("Accessory") or item:IsA("Clothing") or item:IsA("ShirtGraphic") then
                item:Destroy()
            end
        end

        -- Disable global shadows and blur
        local lighting = game:GetService("Lighting")
        lighting.GlobalShadows = false
        lighting.FogEnd = 100000
        lighting.Blur = nil

        -- Garbage collect memory
        collectgarbage("collect")

        print("[Nebula Hub] 🧹 No Lag Mode Activated")
    end
}

local Paragraph = Tabs.Credits:CreateParagraph("Credits", {
    Title = "Script Credits",
    Content = "This script was made by ttvkaiser (Emperor).\nHe is the creator and owner of this script. All rights reserved."
})

SaveManager:SetLibrary(Library)
InterfaceManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes{}

InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

Library:Notify{
    Title = "Nebula Hub",
    Content = "The script has been loaded.",
    Duration = 1
}

SaveManager:LoadAutoloadConfig()