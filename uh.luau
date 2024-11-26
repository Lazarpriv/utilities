print("Divine Hub V2: Executed.")

-- \ To check if the script was already loaded \ -
if getgenv().Loaded then
    print("Divine Hub V2: Script was already ran once! Try clicking the Unload button in the Configs tab, if the UI isn't visible, run getgenv().Loaded = false")
    return;
end

getgenv().Loaded = true

-- \ Loading Wait \ --
repeat task.wait() until game:IsLoaded() and cloneref(game:GetService("Players")).LocalPlayer:FindFirstChild("LoadingUI", true).Enabled == false

-- \ Library \ --
local repo = "https://raw.githubusercontent.com/deividcomsono/LinoriaLib/refs/heads/main/"

local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/mstudio45/MSESP/refs/heads/main/source.luau"))()


getgenv().ForceUnload = function()
    Library:Unload()
end

-- \ Variables, tables... \ --
local Players: Players = cloneref(game:GetService("Players"))
local PlayerVariables = {
    Player = Players.LocalPlayer,
    Character = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait(),
    HumanoidRootPart = Players.LocalPlayer.Character.PrimaryPart,
    Humanoid = Players.LocalPlayer.Character.Humanoid,
    Collision = Players.LocalPlayer.Character:WaitForChild("Collision"),
    CollisionClone = Players.LocalPlayer.Character:FindFirstChild("CollisionNew") or Players.LocalPlayer.Character:FindFirstChild("Collision"):Clone(),
    Weld = Players.LocalPlayer.Character.Collision:FindFirstChildWhichIsA("ManualWeld"),
    DefaultC0 = Players.LocalPlayer.Character.Collision:FindFirstChildWhichIsA("ManualWeld").C0,
    CollisionProperties = Players.LocalPlayer.Character.Collision.CustomPhysicalProperties,
    RootProperties = Players.LocalPlayer.Character.PrimaryPart.CustomPhysicalProperties
}


PlayerVariables.CollisionClone.Parent = PlayerVariables.Collision.Parent
PlayerVariables.CollisionClone.Name = "CollisionNew"


local ReplicatedStorage: ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local EntityModules = ReplicatedStorage.ClientModules.EntityModules
local Glitch = EntityModules.Glitch
local Void = EntityModules.Void
local Random: Random =  Random.new()
local charactertable = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'}
local Shade = EntityModules.Shade
local gameData = ReplicatedStorage.GameData
local Floor = gameData.Floor.Value
local Disposal = {}
local StoredValues = {}
local Parts = {}
local Groupboxes = {}
local Supported = {}
local UNCPrintMessages = {}
local Bridges = {}
local ToExclude = {
    "FigureHotelChase",
    "Elevator1",
    "MinesFinale"
}
local IsFloor = {
    HardMode = Floor == "Fools",
    Hotel = Floor == "Hotel",
    Mines = Floor == "Mines",
    Retro = Floor == "Retro",
    Backdoor = Floor == "Backdoor",
    Rooms = Floor == "Rooms"
}
local CurrentRoom = tostring(PlayerVariables.Player:GetAttribute("CurrentRoom"))

-- \ Self-explanatory \ --
if workspace.CurrentRooms[CurrentRoom] == nil then
    CurrentRoom = tostring(gameData.LatestRoom.Value)
end
local CurrentRooms: Folder = workspace.CurrentRooms
local CurrentRoomModel: Model = CurrentRooms[CurrentRoom]
local NextRoom = tostring(PlayerVariables.Player:GetAttribute("CurrentRoom") + 1)
local NextRoomModel: Model = CurrentRooms:FindFirstChild(NextRoom)
local Objectives = {
    ["LiveHintBook"] = {ESPName = "Book"},
    ["LiveBreakerPolePickup"] = {ESPName = "Breaker"},
    ["FuseObtain"] = {ESPName = "Fuse"},
    ["MinesAnchor"] = {ESPName = "Anchor"},
    ["WaterPump"] = {ESPName = "Valve"},
    ["MinesGateButton"] = {ESPName = "Gate Button"},
    ["MinesGenerator"] = {ESPName = "Generator"},
    ["KeyObtain"] = {ESPName = "Key"},
    ["TimerLever"] = {ESPName = "Time Lever"},
    ["LeverForGate"] = {ESPName = "Gate Lever"},
    ["ElectricalKeyObtain"] = {ESPName = "Electrical Key"},
    ["Candy"] = {ESPName = "Candy"}
}
local Fly = {
    BodyGyro = nil,
    BodyVelocity = nil,
    Enabled = false
}
local BodyProperties = {"HeadColor3", "LeftLegColor3", "LeftArmColor3", "RightLegColor3", "RightArmColor3", "TorsoColor3"}
local uis: UserInputService = cloneref(game:GetService("UserInputService"))
local RemotesFolder = ReplicatedStorage:FindFirstChild("RemotesFolder") or ReplicatedStorage:FindFirstChild("EntityInfo");
local PxPromptService: ProximityPromptService = cloneref(game:GetService("ProximityPromptService"))
local Entity = game.ReplicatedStorage.Entities
local Hooks = {}
local Connections = {}
local screechModel = Entity:WaitForChild("Screech")
local timothyModel = Entity:WaitForChild("Spider")
local modules = Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game.RemoteListener.Modules
local A90 = modules.A90
local Dread = modules.Dread
local moduleScripts = {
    MainGame = PlayerVariables.Player.PlayerGui.MainUI.Initiator.Main_Game
}
local screechModule = moduleScripts.MainGame.RemoteListener.Modules.Screech
local RunService: RunService = cloneref(game:GetService("RunService"))
local TweenService: TweenService = cloneref(game:GetService("TweenService"))
local IsBypass = false
local NotifyTable = {
    ["Rush"] = {Notification = "Rush has spawned."},
    ["Ambush"] = {Notification = "Ambush has spawned."},
    ["Jeff The Killer"] = {Notification = "Jeff The Killer has spawned."},
    ["Eyes"] = {Notification = "Eyes has spawned."},
    ["A-60"] = {Notification = "A-60 has spawned."},
    ["A-120"] = { Notification = "A-120 has spawned."},
    ["Blitz"] = {Notification = "Blitz has spawned"},
    ["Lookman"] = {Notification = "Lookman has spawned."},
    ["Gloombat Swarm"] = {Notification = "Gloombats have spawned."}
}
local camera = workspace.Camera 
local currentcam = workspace.CurrentCamera
local worldToViewportPoint = camera.worldToViewportPoint
local BodyColors = PlayerVariables.Character["Body Colors"]

local ESPTable = {
    Entity = {},
    SideEntity = {},
    Door = {},
    Item = {},
    DroppedItem = {},
    Player = {},
    Gold = {},
    Chest = {},
    HidingSpot = {},
    Objective = {}
}

local Functions = {}
local executorname = getexecutorname()


local IsEntity = {
    ["RushMoving"] = {Type = "Entity"},
    ["AmbushMoving"] = {Type = "Entity"},
    ["FigureRagdoll"] = {Type = "SideEntity"},
    ["FigureRig"] = {Type = "SideEntity"},
    ["Eyes"] = {Type = "Entity"},
    ["JeffTheKiller"] = {Type = "Entity"},
    ["GiggleCeiling"] = {Type = "SideEntity"},
    ["BackdoorLookman"] = {Type = "Entity"},
    ["BackdoorRush"] = {Type = "Entity"},
    ["GrumbleRig"] = {Type = "SideEntity"}
}
local ShortNameTable = {
    "Moving",
    "Obtain",
    "Rig",
    "Ragdoll",
    "Ceiling",
    "Setup",
    "Live",
    "Hint",
    "Pole",
    "New",
    "ForGate",
    "Backdoor",
    "Peel",
    "Clone",
    "Wall",
    "Pickup"
}
local ShortNameExclusions = {
    ["JeffTheKiller"] = {Shortened = "Jeff"},
    ["GloomPile"] = {Shortened = "Gloom Eggs"},
    ["PickupItem"] = {Shortened = "Library Paper"}
}
local FloorHidingSpot = {
    ["Hotel"] = "Wardrobe",
    ["Retro"] = "Wardrobe",
    ["Fools"] = "Wardrobe",
    ["Rooms"] = "Locker",
    ["Mines"] = "Locker"
}
local AutoInteractPrompts = {
    ["ModulePrompt"] = 7,
    ["ActivateEventPrompt"] = 6,
    ["FusesPrompt"] = 5,
    ["LeverPrompt"] = 4,
    ["LootPrompt"] = 3,
    ["HerbPrompt"] = 2,
    ["UnlockPrompt"] = 1
}
local GamePrompts = {}

local notificationSound = Instance.new("Sound")

notificationSound.SoundId = "rbxassetid://4590657391"
notificationSound.Parent = cloneref(game:GetService("SoundService"))
notificationSound.Looped = false
notificationSound.Volume = 2
notificationSound.Name = "Notify"

Disposal.Light = Instance.new("SpotLight", PlayerVariables.Character.Head) do
    Disposal.Light.Range = 60
    Disposal.Light.Angle = 180
    Disposal.Light.Enabled = false
    Disposal.Light.Name = "DVHub"
    Disposal.Light.Brightness = 0
end
-- \ Functions \ --
function Functions.PadlockCode(Paper: Tool, Usage: string, Player: Player)
    assert(Paper:IsA("Tool"), "Library Paper was not a tool.")
    assert(typeof(Usage) == "string", "Usage for PadlockCode() was not a string.")

    if Player == nil then
        Player = PlayerVariables.Player
    end

    if not Paper.Name:find("LibraryHint") then
        return
    end

    if not Toggles.autopl.Value or not Toggles.plcode.Value then
        return
    end

    local Code = {}

    for _, v in pairs(Player.PlayerGui.PermUI.Hints:GetChildren()) do
        if v.Name == "Icon" then
            for _, x in pairs(Paper.UI:GetChildren()) do
                if tonumber(x.Name) then
                    local ins = {tonumber(x.Name), "_"}
                    table.insert(Code, tonumber(x.Name), ins)
                end
            end
        end
    end


    for i, v in ipairs(Code) do
        if typeof(v) == "table" then
            for _, x in pairs(Player.PlayerGui.PermUI.Hints:GetChildren()) do
                if x.Name == "Icon" then
                    if x.ImageRectOffset == Paper.UI[v[1]].ImageRectOffset then
                        Code[i] = x:FindFirstChild("TextLabel").Text
                    end
                end
            end
        end
    end

    for i, v in ipairs(Code) do
        if typeof(v) == "table" then
            Code[i] = "_"
        end
    end

    local Concatenated = table.concat(Code)
    local Needed = Paper.Name == "LibraryHintPaperHard" and 10 or 5
    local Count = Concatenated:len()

    if Count > Needed then
        Concatenated = Concatenated:sub(1, Needed)
        Count = Concatenated:len()
    end

    if Usage == "ToNotify" and Concatenated ~= "" and not Functions.ConsecutiveDigits(Concatenated) then
        Library:Notification("The code is " .. Concatenated .. ".")
    elseif Usage == "FireServer" then
        if Count == Needed then
            RemotesFolder.PL:FireServer(Concatenated)
        end
    end

    return Concatenated
end

function Functions.SetupPadlockCodeConnection(plr: Player)
    for _, v in pairs(plr:WaitForChild("Backpack"):GetChildren()) do
        task.spawn(Functions.PadlockCode, v, plr)
    end

    local char = plr.Character or plr.CharacterAdded:Wait()

    for _, v in pairs(char:GetChildren()) do
        task.spawn(Functions.PadlockCode, v, plr)
    end

    Connections["Items" .. char.Name] = char.ChildAdded:Connect(function(child)
        task.spawn(Functions.PadlockCode, child, plr)
    end)
end

function Functions.ConsecutiveDigits(str: string)
    return string.match(str, "%d%d%d+") ~= nil
end

function Functions.DistanceFromCharacter(point: Instance)
    return (PlayerVariables.Character:GetPivot().Position - point:GetPivot().Position).Magnitude
end

-- \ Testing support \ --
function TestFeature(name: string, toTest: () -> (), succMessage: string)
    local succ, err = false, nil

    succ, err = pcall(toTest)

    Supported[name] = succ
    UNCPrintMessages[name] = string.format("%s [%s]%s", (if succ then "✅" else "⛔"), name, (if err then (": " .. tostring(err)) else (": " .. succMessage)))
    return succ
end

TestFeature("require", function()
    require(PlayerVariables.Player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"))
end, "Succesfully required module.")

local CanFirePP = TestFeature("fireproximityprompt", function()
    local prox = Instance.new("ProximityPrompt", Instance.new("Part", workspace))
    local trig = false

    prox.Triggered:Once(function()
        trig = true
    end)
    fireproximityprompt(prox)
    task.wait(0.1)

    prox.Parent:Destroy()

    assert(trig, "Wasn't able to fire prompt")
end, "Successfully fired proximity prompt.")

TestFeature("hookfunction", function()
    local function test()
        return true
    end

    local ref = hookfunction(test, function()
        return false
    end)

    assert(test() == false, "Hooked function should return false")
    assert(ref() == true, "Old function should return true")
    assert(test ~= ref, "Original function should not be the same as the reference to the old one")
end, "Succesfully hooked function.")

TestFeature("firesignal", function()
    local bindable = Instance.new("BindableEvent", workspace)
    local trig = false

    bindable.Event:Once(function(val)
        trig = val
    end)

    firesignal(bindable.Event, true)
    task.wait(0.1)
    bindable:Destroy()

    assert(trig, "Failed to fire signal")
end, "Successfully fired a BindableEvent with firesignal.")

TestFeature("hookmetamethod", function()
    local object = setmetatable({}, { __index = newcclosure(function() return false end), __metatable = "Locked!" })
	local ref = hookmetamethod(object, "__index", function() return true end)
	assert(object.test == true, "Failed to hook a metamethod and change the return value")
	assert(ref() == false, "Did not return the original function")
end, "Hookmetamethod successful.")

TestFeature("getnamecallmethod", function()
	local method
    local ref 

    ref = hookmetamethod(game, "__namecall", function(...)
		if not method then
			method = getnamecallmethod()
		end
        return ref(...)
	end)
    game:GetService("HttpService")
    task.wait(0.2)
    assert(method == "GetService", "getnamecallmethod was not capable of returning the correct method.")
end, "Succesfully received correct namecall method (GetService).")

TestFeature("firetouchinterest", function()
        
    local part = Instance.new("Part", workspace)
    local touched 

    part.Touched:Once(function()
        touched = true
    end)

    firetouchinterest(part, PlayerVariables.HumanoidRootPart, 1)
    task.wait()
    firetouchinterest(part, PlayerVariables.HumanoidRootPart, 0)
    task.wait()

    assert(touched, "Was not able to firetouchinterest.")
end, "Succesfully simulated a .Touched event with firetouchinterest.")

for name, result in pairs(Supported) do
    if UNCPrintMessages[name] then
        print(UNCPrintMessages[name])
    end
end

print(string.format("Executor Name: %s", getexecutorname()))

getgenv().SupportTable = Supported
-- \ Fixing \ --
if not CanFirePP then
    print("🛠️ Making a fireproximityprompt()...")
    getgenv().fireproximityprompt = function(prompt: ProximityPrompt, skip: boolean)
        assert(typeof(prompt) == "Instance" and prompt:IsA("ProximityPrompt"), "Argument #1 of fireproximityprompt was not a prompt.")

        local HoldDur = prompt.HoldDuration
        local RequiresLineOfSight = prompt.RequiresLineOfSight

        if skip then
            prompt.HoldDuration = 0
        end

        prompt.RequiresLineOfSight = false

        prompt:InputHoldBegin()
        task.wait(prompt.HoldDuration + 0.05)
        prompt:InputHoldEnd()

        prompt.HoldDuration = HoldDur
        prompt.RequiresLineOfSight = RequiresLineOfSight
    end
end

if not Supported["firetouchinterest"] then
    print("🛠️ Making a working firetouchinterest...")
    getgenv().firetouchinterest = firetouchtransmitter or function(inst1: BasePart, inst2: BasePart, amount: number)
        for i = 1, amount do
            inst2.CFrame = inst1.CFrame
        end
    end
end

if not isnetworkowner then
    print("🛠️ Making a isnetworkowner() function...")
    getgenv().isnetworkowner = function(part)
        return part.ReceiveAge == 0
    end
end

print("Divine Hub V2: All support checks and replacements have been finished.")
type ESPArg = {
    Type: string,
    Object: Instance,
    Text: string,
    Color: Color3,
    IsEntity: boolean | nil,
    TextModel: Instance | nil,
    OnDestroyFunc: () -> ()
}

function Functions.ESP(Properties: ESPArg)

    local Args = {
        Object = Properties.Object,
        Text = Properties.Text,
        TextModel = Properties.TextModel or nil,
        Color = Properties.Color,
        Type = Properties.Type,
        OnDestroyFunc = Properties.OnDestroyFunc or function()
            if Properties.IsEntity then
                if Properties.Object and Properties.Object.PrimaryPart then
                    Properties.Object.PrimaryPart.Transparency = 1
                end
            end
        end,
        IsEntity = Properties.IsEntity or false
    }

    local ESP = ESPLibrary:Add({
        Name = Args.Text,
        Model = Args.Object,
        TextModel = Args.TextModel,
        Color = Args.Color,
        FillColor = Args.Color,
        OutlineColor = Args.Color,
        ESPType = "Highlight",
        TextSize = Options.TextSize.Value,

        OnDestroyFunc = Args.OnDestroyFunc,

        Tracer = {
            Enabled = true,
            Color = Args.Color,
            From = Options.TracerStart.Value
        }
    })

    if Args.IsEntity then
        if Args.Object and Args.Object.PrimaryPart then
            Args.Object.PrimaryPart.Transparency = 0
        end
    end

    table.insert(ESPTable[Args.Type], ESP)


    return ESP
end

function Functions.EntityESP(entity)
    if not entity:IsA("Model") or not Toggles.EntityESP.Value then
        return
    end

    if IsEntity[entity.Name] and IsEntity[entity.Name].Type == "Entity" then
        Functions.ESP({
            Object = entity,
            Text = Functions.ShortName(entity),
            Color = Options.EntityESPColor.Value,
            Type = "Entity",
            IsEntity = entity.Name ~= "JeffTheKiller"
        })
    end
end

function Functions.SideEntityESP(entity)
    if not entity:IsA("Model") or not Toggles.EntityESP.Value then
        return
    end

    if IsEntity[entity.Name] then
        if IsEntity[entity.Name].Type == "SideEntity" then
            Functions.ESP({
                Object = entity,
                Text = Functions.ShortName(entity),
                TextModel = if entity.Name == "GiggleCeiling" then entity.Root else nil,
                Color = Options.EntityESPColor.Value,
                Type = "SideEntity"
            })
        end
    end
end

function Functions.GetDoorText(door: Model)
    local shortnum = nil
    local longnum = nil
    local stinker = door:FindFirstChild("Sign"):FindFirstChild("SignText") or door:FindFirstChild("Sign"):FindFirstChild("Stinker")

    shortnum = if Options.DoorESPTextMethod.Value == "Normal (1)" then tonumber(door.Parent.Name) + 1 else nil
    longnum = if Options.DoorESPTextMethod.Value == "Four Digits (0001)" then stinker.Text else nil

    if IsFloor.Mines and shortnum then
        shortnum += 100
    end

    if shortnum then
        return shortnum
    else
        return longnum
    end
end

function Functions.DoorESP(room)
    if not room:IsA("Model") or not Toggles.DoorESP.Value then
        return
    end

    local Door = room:WaitForChild("Door", 5)

    if Door then
        local RealDoor: BasePart = Door:WaitForChild("Door", 5)

        if RealDoor then
            local Locked = room:GetAttribute("RequiresKey")
            local Opened = Door:GetAttribute("Opened")
            local State = if Locked and not Opened then "[Locked]" elseif Opened then "[Opened]" else ""
            local RoomNum = Functions.GetDoorText(room:FindFirstChild("Door"))
            local String = string.format("Door %s %s", RoomNum, State)

            local DoorESP = Functions.ESP({
                Object = RealDoor,
                Text = String,
                Color = Options.DoorESPColor.Value,
                Type = "Door",

                OnDestroy = function()
                    if Connections["Door " .. RoomNum] then
                        Connections["Door " .. RoomNum]:Disconnect()
                    end
                end
            })

            Connections["Door " .. RoomNum] = Door:GetAttributeChangedSignal("Opened"):Connect(function()
                if DoorESP and Door and RealDoor then
                    DoorESP.CurrentSettings.Name = string.format("Door %s %s", RoomNum, "[Opened]")
                end
            end)
        end
    end
end

function Functions.ObjectiveESP(objective)
    if not objective:IsA("Model") or not Toggles.ObjectiveESP.Value then
        return
    end

    if not Objectives[objective.Name] then
        return
    end

    if objective.Name == "TimerLever" then
        Functions.ESP({
            Object = objective,
            Text = string.format("Time Lever [+%s]", objective.TakeTimer.TextLabel.Text),
            Color = Options.ObjectiveESPColor.Value,
            Type = "Objective"
        })
    elseif objective.Name == "WaterPump" then
        local wheel = objective:WaitForChild("Wheel", 5)
        local OnFrame = objective:FindFirstChild("OnFrame", true)

        if wheel and (OnFrame and OnFrame.Visible) then
            local Random = Functions.RandomString()

            local ESPInstance = Functions.ESP({
                Object = wheel,
                Text = "Valve",
                Color = Options.ObjectiveESP.Value,
                Type = "Objective"
            })
        end
    elseif objective.Name == "MinesAnchor" then
        local sign = objective:WaitForChild("Sign", 5)

        if sign and sign:FindFirstChild("TextLabel") then
            Functions.ESP({
                Object = objective,
                Text = string.format("Anchor %s", sign.TextLabel.Text),
                Color = Options.ObjectiveESPColor.Value,
                Type = "Objective"
            })
        end
    end

    if Objectives[objective.Name] and (objective.Name ~= "TimerLever" and objective.Name ~= "WaterPump" and objective.Name ~= "MinesAnchor") then
        Functions.ESP({
            Object = objective,
            Text = Objectives[objective.Name].ESPName,
            Color = Options.ObjectiveESPColor.Value,
            Type = "Objective"
        })
    end
end

function Functions.ItemESP(item, dropped: boolean)
    if not Functions.IsItem(item) or not Toggles.ItemESP.Value or Objectives[item.Name] then
        return
    end

    Functions.ESP({
        Object = item,
        Text = Functions.ShortName(item),
        Color = Options.ItemESPColor.Value,
        Type = if dropped then "DroppedItem" else "Item"
    })
end

function Functions.GoldESP(gold)
    if not gold:IsA("Model") or not Toggles.GoldESP.Value then
        return
    end

    if gold.Name == "GoldPile" then
        Functions.ESP({
            Object = gold,
            Text = string.format("Gold [%s]", gold:GetAttribute("GoldValue")),
            Color = Options.GoldESPColor.Value,
            Type = "Gold"
        })
    end
end

function Functions.ChestESP(storage)
    if not storage:IsA("Model") or not Toggles.ChestESP.Value then
        return
    end

    if storage.Name:find("Chest") or storage.Name == "Toolshed_Small" or storage:GetAttribute("Storage") == "ChestBox" then
        local State = if storage:GetAttribute("Locked") then "[Locked]" else ""
        local CleanerName = storage.Name:gsub("_Small", ""):gsub("Box", ""):gsub("Locked", ""):gsub("_Vine", "") .. " %s"
        local String = string.format(CleanerName, State)

        Functions.ESP({
            Object = storage,
            Text = String,
            Color = Options.ChestESPColor.Value,
            Type = "Chest"
        })
    end
end

function Functions.HidingSpotESP(spot)
    if not spot:IsA("Model") or not Toggles.HidingSpotsESP.Value then
        return
    end

    if spot.Name == "Rooms_Locker" or spot.Name == "Retro_Wardrobe" or spot:GetAttribute("LoadModule") == "Bed" or spot:GetAttribute("LoadModule") == "Wardrobe" then
        local IsBed = spot.Name == "Bed"
        local String = if IsBed then "Bed" else FloorHidingSpot[Floor]

        Functions.ESP({
            Object = spot,
            Text = String,
            Color = Options.HidingSpotESPColor.Value,
            Type = "HidingSpot"
        })
    end
end

function Functions.PlayerESP(player: Player)
    if not player:IsA("Player") or player == PlayerVariables.Player or not Toggles.PlayerESP.Value then
        return
    end

    local char = player.Character or player.CharacterAdded:Wait()

    Functions.ESP({
        Object = char,
        Text = player.DisplayName,
        Color = Options.PlayerESPColor.Value,
        Type = "Player"
    })
end

function Functions.AssetCheck(asset: Instance)
    if asset and asset.Parent then

        if asset.Name == "Collision" and asset.Parent.Name == "TriggerEventCollision" and Toggles.NoSeekFE.Value then
            task.spawn(Functions.SetupDeleteSeek, asset)
        end

        if asset.Name == "Snare" then
            asset:WaitForChild("Hitbox", 5).CanTouch = not Toggles.RemoveSnareHitbox.Value
        end

        if asset.Name == "GiggleCeiling" then
            asset:WaitForChild("Hitbox", 5).CanTouch = not Toggles.GiggleHitboxRemoval.Value
        end

        if (asset.Name == "Seek_Arm" or asset.Name == "ChandelierObstruction") then
            for _, v in pairs(asset:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanTouch = not Toggles.noObstaclesToggle.Value
                end
            end
        end


        if asset.Name == "GloomPile" then
            for _, v in pairs(asset:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanTouch = not Toggles.AntiGloomEgg.Value
                end
            end
        end


        if asset.Name == "DoorFake" then
            for _, v in pairs(asset:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanTouch = not Toggles.NoDupeTouch.Value
                end


                if v:IsA("ProximityPrompt") then
                    v.Enabled = not Toggles.NoDupeTouch.Value
                end
            end
        end

        if asset:IsA("ProximityPrompt") then
            table.insert(GamePrompts, asset)

            if not asset:GetAttribute("OGDistance") then
                asset:SetAttribute("OGDistance", asset.MaxActivationDistance)
            end

            if not asset:GetAttribute("RequiresSight") then
                asset:SetAttribute("RequiresSight", asset.RequiresLineOfSight)
            end

            asset.RequiresLineOfSight = not Toggles.PromptClip.Value

            asset.MaxActivationDistance = asset:GetAttribute("OGDistance") * Options.PromptReach.Value
        end
    end
end

function Functions.SetupRoom(room: Model)

    if room:GetAttribute("RawName"):find("Halt") then
        Library:Notification("Halt will be in the next room.")
    end

    for _, v in pairs(room:GetDescendants()) do
        task.spawn(Functions.AssetCheck, v)
    end

    Connections[tonumber(room.Name)] = room.DescendantAdded:Connect(function(descendant)
        if room == CurrentRoomModel then
            if Toggles.ItemESP.Value then
                task.spawn(Functions.ItemESP, descendant)
            end
    
            if Toggles.ObjectiveESP.Value then
                task.spawn(Functions.ObjectiveESP, descendant)
            end
    
            if Toggles.GoldESP.Value then
                task.spawn(Functions.GoldESP, descendant)
            end
        end

        task.delay(0.1, Functions.AssetCheck, descendant)
    end)
end

function Functions.SetupCurrentRoomESP(room: Model)
    for _, v in pairs(room:GetDescendants()) do
        task.spawn(Functions.ItemESP, v)

        task.spawn(Functions.ChestESP, v)

        task.spawn(Functions.SideEntityESP, v)

        task.spawn(Functions.GoldESP, v)

        task.spawn(Functions.HidingSpotESP, v)

        task.spawn(Functions.ObjectiveESP, v)
    end
end

function Functions.ClearRoomESP()
    if Toggles.ObjectiveESP.Value then
        for _, v in pairs(ESPTable.Objective) do
            v:Destroy()
        end
    end

    if Toggles.ItemESP.Value then
        for _, v in pairs(ESPTable.Item) do
            v:Destroy()
        end
    end

    if Toggles.HidingSpotsESP.Value then
        for _, v in pairs(ESPTable.HidingSpot) do
            v:Destroy()
        end
    end

    if Toggles.GoldESP.Value then
        for _, v in pairs(ESPTable.Gold) do
            v:Destroy()
        end
    end

    if Toggles.EntityESP.Value then
        for _, v in pairs(ESPTable.SideEntity) do
            v:Destroy()
        end
    end

    if Toggles.ChestESP.Value then
        for _, v in pairs(ESPTable.Chest) do
            v:Destroy()
        end
    end
end

function Functions.NonRequireViewmodelOffset(tool: Tool)
    if Supported["require"] or not Toggles.ViewmodelOffset.Value or not tool or not tool.Parent or not tool:IsA("Tool") then
        return
    end
    local v3 = Vector3.new(Options.XOffset.Value, Options.YOffset.Value, Options.ZOffset.Value)
    local originalvector = tool:GetAttribute("OGOffset") or Vector3.new(0, 0.25, 0)

    if not tool:GetAttribute("OGOffset") then
        tool:SetAttribute("OGOffset", originalvector)
    end

    tool:SetAttribute("ToolOffset", v3)
end

function Functions.ClearViewmodelOffset(tool: Tool)
    if Supported["require"] or not tool or not tool.Parent or not tool:IsA("Tool") or not tool:GetAttribute("OGOffset") then
        return
    end

    tool:SetAttribute("ToolOffset", tool:GetAttribute("OGOffset"))
end

function Functions.BridgePlatform(bridge)
    if not bridge:IsA("Model") or not bridge or not bridge.Parent or not bridge.Name == "Bridge" or not Toggles.BridgeWalk.Value then
        return
    end

    local barrier = nil
    local clone = nil

    for _, v: BasePart in pairs(bridge:GetChildren()) do
        if v.Name == "PlayerBarrier" and v.Size.Y == 2.75 then
            barrier = v
            break
        end
    end
    
    if barrier then
        clone = barrier:Clone()
        clone.Name = "NoFall"
        clone.Parent = barrier.Parent
        clone.CFrame = barrier.CFrame
        clone.Size = Vector3.new(barrier.Size.X, barrier.Size.Y, 40)
        clone.Color = Color3.new(1, 1, 1)
        clone.Transparency = 1

        table.insert(Bridges, clone)
    end
end

function Functions.IsMultiplayer()
    return #Players:GetPlayers() > 1
end


function Functions.MakeRandomString()
    return charactertable[Random:NextInteger(1, #charactertable)]
end

function Functions.RandomString()
    local ret = ""

    for i = 1, 8 do
        local randomletter = Functions.MakeRandomString()

        if Random:NextNumber() > 0.5 then
            randomletter = randomletter:upper(randomletter)
        end
        ret = ret .. randomletter
    end
    return ret
end

function Functions.IsItem(inst)
    if inst:IsA("Model") and (inst:GetAttribute("Pickup") or inst:GetAttribute("PropType")) then 
        return true
    else
        return false
    end
end

getgenv().isnetworkowner = isnetworkowner or function(Part)
   return Part.ReceiveAge == 0
end

function Functions.SetSpeedBypass(set: boolean)
    IsBypass = set

    if not PlayerVariables.CollisionClone then
        return
    end

    if IsBypass then
        Options.SpeedBoost:SetMax(50)
        Options.FlySpeed:SetMax(75)
    end

    task.spawn(function()
        while IsBypass and PlayerVariables.Player:GetAttribute("Alive") and PlayerVariables.Collision and PlayerVariables.CollisionClone and Loaded do
            if PlayerVariables.HumanoidRootPart.Anchored then
                PlayerVariables.CollisionClone.Massless = false
                repeat
                    task.wait()
                until not PlayerVariables.HumanoidRootPart.Anchored
            else
                PlayerVariables.CollisionClone.Massless = not PlayerVariables.CollisionClone.Massless
            end

            task.wait(Options.SpeedBypassDelay.Value)
        end

        Options.SpeedBoost:SetMax(7)
        Options.FlySpeed:SetMax(18)

        PlayerVariables.CollisionClone.Massless = false
    end)
end

function Library:Notification(string: string)
    Library:Notify(string)

    if Toggles.NotificationSound.Value then
        notificationSound:Play()
    end
end



function Functions.SetTouch(obj: Instance, CanTouch: boolean)

    if obj:IsA("BasePart") then
        obj.CanTouch = CanTouch;
    end

    for _, v in pairs(obj:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanTouch = CanTouch;
        end

        if obj.Name == "DoorFake" and v:IsA("ProximityPrompt") then
            v.Enabled = CanTouch
        end
    end
end

function Functions.SetupDeleteSeek(trigger: BasePart)
    if Toggles.NoSeekFE.Value then
        Library:Notification("Attempting to delete Seek...")

        task.delay(3, function()
            if trigger:IsDescendantOf(workspace) then
                Library:Notification("Script was unable to delete Seek on the server. Please check the console.")
            end
        end)

        task.delay(1.5, function()
            PlayerVariables.HumanoidRootPart.Anchored = false
        end)

        PlayerVariables.HumanoidRootPart.Anchored = true

        task.spawn(function()
            repeat
                firetouchinterest(trigger, PlayerVariables.HumanoidRootPart, 1)
                task.wait()
                firetouchinterest(trigger, PlayerVariables.HumanoidRootPart, 0)
            until not trigger:IsDescendantOf(workspace) or not Toggles.NoSeekFE.Value

            if not trigger:IsDescendantOf(workspace) then
                Library:Notification("Successfully deleted Seek.")
            end
        end)
    end
end


function Functions.ShortName(v: Instance)
    local Ret = v.Name

    for _, element in pairs(ShortNameTable) do
       Ret = Ret:gsub(element, "")
    end

    if table.find(ShortNameExclusions, v.Name) then
        Ret = ShortNameExclusions[v.Name].Shortened
    end

    if v.Name == "PickupItem" and v.Parent.Name == "50" then
        Ret = "Library Paper"
    end

    if v.Name:find("(%l)(%u)") then
        Ret = Ret:gsub("(%l)(%u)", "%1 %2")
    end

    if v.Name == "RushMoving" and v.PrimaryPart.Name ~= "RushNew" and IsFloor.HardMode then
        Ret = v.PrimaryPart.Name
    end

    if v.Name == "GloombatSwarm" then
        Ret = "Gloombat Swarm"
    end

    return Ret
end

function Functions.AvailablePrompt(prompt: ProximityPrompt)
    if not prompt or not prompt.Parent then
        return false
    end

    if not prompt:IsA("ProximityPrompt") then
        return false
    end

    if prompt.Parent:GetAttribute("JeffShop") then
        return false
    end

    if prompt.Parent:GetAttribute("PropType") then
        if prompt.Parent:GetAttribute("PropType") == "Heal" and PlayerVariables.Humanoid.Health == 100 then
            return false
        end
    end

    if prompt.KeyboardKeyCode ~= Enum.KeyCode.E then
        return false
    end

    if not prompt.Enabled then
        return false
    end

    if prompt.Parent.Name == "Retro_Wardrobe" or prompt.Parent.Name == "MinesAnchor" then
        return false
    end

    if Functions.DistanceFromCharacter(prompt.Parent) > prompt.MaxActivationDistance then
        return false
    end

    if prompt:GetAttribute("Interactions" .. PlayerVariables.Character.Name) and prompt.Parent.Name ~= "Lock" and not prompt:FindFirstAncestor("MinesGenerator") and prompt.Parent.Parent.Name ~= "MinesGateButton" and not prompt.Parent:GetAttribute("Locked") then
        return false
    end

    if prompt:FindFirstAncestor("KeyObtainFake") or prompt:FindFirstAncestor("Padlock") then
        return false
    end

    return AutoInteractPrompts[prompt.Name] ~= nil
end



function Fly:Start()
    Fly.Enabled = true
    
    Fly.BodyGyro = Instance.new("BodyGyro", PlayerVariables.HumanoidRootPart)
    Fly.BodyVelocity = Instance.new("BodyVelocity", PlayerVariables.HumanoidRootPart)
    Fly.BodyGyro.P = 9e4
    Fly.BodyGyro.MaxTorque = Vector3.one * 9e9
    Fly.BodyGyro.CFrame = workspace.CurrentCamera.CFrame
    Fly.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    Fly.BodyVelocity.MaxForce = Vector3.one * 9e9

    Connections["FlyConnection"] = RunService.RenderStepped:Connect(function()
        if Fly.Enabled then
            local direction = Vector3.new(0, 0, 0)

            if uis:IsKeyDown(Enum.KeyCode.W) and not uis:GetFocusedTextBox() then
                direction += (workspace.CurrentCamera.CFrame.LookVector * Options.FlySpeed.Value)
            end
            if uis:IsKeyDown(Enum.KeyCode.S) and not uis:GetFocusedTextBox() then
                direction -= (workspace.CurrentCamera.CFrame.LookVector * Options.FlySpeed.Value)
            end
            if uis:IsKeyDown(Enum.KeyCode.A) and not uis:GetFocusedTextBox() then
                direction -= (workspace.CurrentCamera.CFrame.RightVector * Options.FlySpeed.Value)
            end
            if uis:IsKeyDown(Enum.KeyCode.D) and not uis:GetFocusedTextBox() then
                direction += (workspace.CurrentCamera.CFrame.RightVector * Options.FlySpeed.Value)
            end
            if uis:IsKeyDown(Enum.KeyCode.Space) and not uis:GetFocusedTextBox() then
                direction += (workspace.CurrentCamera.CFrame.UpVector * Options.FlySpeed.Value)
            end
            if uis:IsKeyDown(Enum.KeyCode.LeftShift) and not uis:GetFocusedTextBox() then
                direction -= (workspace.CurrentCamera.CFrame.UpVector * Options.FlySpeed.Value)
            end
            if uis:IsKeyDown(Enum.KeyCode.E) and not uis:GetFocusedTextBox() then
                direction += (workspace.CurrentCamera.CFrame.UpVector * Options.FlySpeed.Value)
            end
            if uis:IsKeyDown(Enum.KeyCode.Q) and not uis:GetFocusedTextBox() then
                direction -= (workspace.CurrentCamera.CFrame.UpVector * Options.FlySpeed.Value)
            end
            
            Fly.BodyVelocity.Velocity = direction
            Fly.BodyGyro.CFrame = workspace.CurrentCamera.CFrame
        end
    end)
end

function Fly:Stop()
    Fly.Enabled = false

    if Connections["FlyConnection"] then
        Connections["FlyConnection"]:Disconnect()
    end

    if Fly.BodyGyro then
        Fly.BodyGyro:Destroy()
        Fly.BodyGyro = nil
    end
    
    if Fly.BodyVelocity then
        Fly.BodyVelocity:Destroy()
        Fly.BodyVelocity = nil
    end
end

-- \ UI Code \ --
local Window = Library:CreateWindow({
    Title = "Divine Hub | " .. PlayerVariables.Player.DisplayName .. " | " .. executorname,
    Center = true,
    AutoShow = true,
    TabPadding = 2,
    MenuFadeTime = 0.09,
    ShowCustomCursor = true
})


-- \ custom functions rel (may need them and whoever is seeing this may feel free to use this) \ --

if Supported["hookmetamethod"] then
	Hooks.FindFirstChildWithCondition = hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...}
        local met = getnamecallmethod()
        local child = nil

        if met == "FindFirstChildWithCondition" then
            if args[3] and args[3] == true then
                for _, v in ipairs(self:GetDescendants()) do
					if args[2](v) == true and args[1] == v.Name then
                        child = v
                        break
                    end
				end
            else
				for _, v in ipairs(self:GetChildren()) do
					if args[2](v) == true and args[1] == v.Name then
                        child = v
                        break
                    end
				end
			end

            return child
        end

        return Hooks.FindFirstChildWithCondition(self, ...)
    end)

    Hooks.WaitForChildWithCondition = hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...}
        local met = getnamecallmethod()
        local child = nil

        if met == "WaitForChildWithCondition" then
            local t = tick()
            
            if args[3] == nil then
                args[3] = math.huge
            end

            repeat
				task.wait()
                for _, v in ipairs(self:GetChildren()) do
					if args[1] == v.Name and args[2](v) == true then
                        child = v
                    end
				end
			until tick() - t >= args[3] or child or not self

            if child and child.Parent and self then
                return child
            end
        end

        return Hooks.WaitForChildWithCondition(self, ...)
    end)

    Hooks.WaitForChildWhichIsA = hookmetamethod(game, "__namecall", function(self, ...)
        local met = getnamecallmethod()
        local args = {...}
        local class = args[1]
        local timeout = args[2] or math.huge

        if met == "WaitForChildWhichIsA" then
			local t = tick()
            repeat
				task.wait()
			until self:FindFirstChildWhichIsA(class) or tick() - t >= timeout

            if self and self:FindFirstChildWhichIsA(class) then
                return self:FindFirstChildWhichIsA(class)
            end
        end

        return Hooks.WaitForChildWhichIsA(self, ...)
    end)
else
    function Functions.FindFirstChildWithCondition(self: Instance, childName: string, condition: () -> (), recursive: boolean)
        local child = nil

        if recursive then
            for _, v in ipairs(self:GetDescendants()) do
                if condition(v) and childName == v.Name then
                    child = v
                    break
                end
            end
        else
            for _, v in ipairs(self:GetChildren()) do
                if condition(v) and childName == v.Name then
                    child = v
                    break
                end
            end
        end

        if child and child.Parent then
            
        end
    end

    function Functions.WaitForChildWithCondition(self: Instance, childName: string, condition: () -> (), timeout: number | nil)
        local child = nil
        local t = tick()

        if timeout == nil then
            timeout = math.huge
        end

        repeat
            task.wait()
            for _, v in ipairs(self:GetChildren()) do
                if condition(v) and childName == v.Name then
                    child = v
                end
            end
        until child or not self or tick() - t >= timeout

        if child and self and child.Parent then
            return child
        end
    end
end


local Tabs = {
   
    Main = Window:AddTab("Main"),
    Cheats = Window:AddTab("Cheats"),
    Fun = Window:AddTab("Fun (WIP!)"),
    Visuals = Window:AddTab("Visual"),
    Configs = Window:AddTab("Configs"),
}


Groupboxes.Automation = Tabs.Main:AddRightGroupbox("Automation")
Groupboxes.Player = Tabs.Main:AddLeftGroupbox("Player")

CurrentRooms.DescendantAdded:Connect(function(d)
    task.wait(.101)
    if d and (d:IsA("Model") or d:IsA("Folder")) and d.Name == "AnimSaves" then d:Destroy(); end
end)

Groupboxes.Automation:AddToggle("noewait", {
    Text = "Instant Interact",
    Default = false,
    Tooltip = "Skips wait-time for interacting.",
})
if IsFloor.Hotel or IsFloor.HardMode then
    Groupboxes.Automation:AddDivider()
end
Groupboxes.Automation:AddToggle("autopl", {
    Text = "Auto Padlock Code",
    Default = false,
    Visible = IsFloor.Hotel or IsFloor.HardMode
})
Groupboxes.Automation:AddToggle("AutoBreakerBox", {
    Text = "Auto Breaker Box",
    Default = false,
    Visible = IsFloor.Hotel or IsFloor.HardMode
})
Groupboxes.Automation:AddToggle("AutoAnchor", {
    Text = "Auto Anchor",
    Default = false,
    Visible = IsFloor.Mines
})
if IsFloor.Hotel or IsFloor.Mines or IsFloor.HardMode then
    Groupboxes.Automation:AddDivider()
end
Groupboxes.Automation:AddToggle("AutoInteract", {
    Text = "Auto Interact",
    Default = false
}):AddKeyPicker("AutoInteractKey", {
    Default = "R",
    SyncToggleState = false,
    NoUI = false,
    Mode = "Toggle",
    Text = "Auto Interact"
})
Groupboxes.Player:AddSlider("SpeedBoost", {
    Text = "Speed Boost",
    Default = 0,
    Min = 0,
    Max = 7,
    Rounding = 0, 
    Compact = true
})


Groupboxes.Player:AddToggle("noslide", {
    Text = "No Acceleration",
    Default = false,
})
Groupboxes.Player:AddToggle("nclip", {
    Text = "Noclip",
    Default = false,
}):AddKeyPicker("noclipKey", {
    Text = "Noclip",
    Default = "N",
    SyncToggleState = true,
    Mode = "Toggle",
    NoUI = false
})
Groupboxes.Player:AddDivider()
Groupboxes.Player:AddToggle("sbypass", {
    Text = "Speed Bypass",
    Default = false,
})
Groupboxes.Player:AddSlider("SpeedBypassDelay", {
    Text = "Speed Bypass Delay",
    Default = 0.23,
    Min = 0.21,
    Max = 0.25,
    Rounding = 3,
    Compact = true
})

Groupboxes.Player:AddDivider()

Groupboxes.Player:AddToggle("hidingExiting", {
    Text = "Hiding Exiting Fix",
    Default = false
})


Groupboxes.Player:AddToggle("Fly", {
    Text = "Fly",
    Default = false
}):AddKeyPicker("FlyKey", {
    Text = "Fly",
    Default = "F",
    SyncToggleState = true,
    Mode = "Toggle",
    NoUI = false
})

Groupboxes.Player:AddSlider("FlySpeed", {
    Text = "Fly Speed",
    Default = 16,
    Max = 18,
    Min = 16,
    Rounding = 0,
    Compact = true
})

Groupboxes.Player:AddDivider()

Groupboxes.Player:AddToggle("jump", {
    Text = "Jump",
    Default = false,
})

Groupboxes.Player:AddSlider("JumpHeight", {
    Text = "Jump Boost",
    Default = 5,
    Min = 0,
    Max = 50,
    Rounding = 0,
    Compact = true
})

Groupboxes.Reach = Tabs.Main:AddLeftGroupbox("Reach")

Groupboxes.Reach:AddToggle("PromptClip", {
    Text = "Prompt Clip", 
    Default = false
})

Groupboxes.Reach:AddSlider("PromptReach", {
    Text = "Prompt Reach Multiplier",
    Default = 1,
    Min = 1,
    Max = 2,
    Rounding = 1,
    Compact = true
})

Groupboxes.Reach:AddDivider()

Groupboxes.Reach:AddToggle("DoorReach", {
    Text = "Door Reach",
    Default = false
})


Groupboxes.Notifying = Tabs.Main:AddRightGroupbox("Notifying")
Groupboxes.Notifying:AddDropdown("EntityNotifier", {
    AllowNull = true,
    Values = {"Rush", "Ambush", "Eyes", "Jeff The Killer", "A-60", "A-120", "Blitz", "Lookman", "Halt", "Gloombat Swarm"},
    Multi = true,
    Text = "Entity Notifier"
})
Groupboxes.Notifying:AddToggle("NotificationSound", {
    Text = "Notification Sound",
    Default = false
})
Groupboxes.Notifying:AddToggle("plcode", {
    Text = "Padlock Code",
    Default = false,
    Visible = IsFloor.Hotel or IsFloor.HardMode
})
Groupboxes.Notifying:AddToggle("plrleave", {
    Text = "Player Leaving",
    Default = false,
})


Groupboxes.Miscellaneous = Tabs.Main:AddRightGroupbox("Miscellaneous")
local reviveButton = Groupboxes.Miscellaneous:AddButton({
    Text = "Revive",
    Func = function()
        RemotesFolder:WaitForChild("Revive"):FireServer()
    end,  
    DoubleClick = false,
})
local restartButton = Groupboxes.Miscellaneous:AddButton({
    Text = "Play Again",
    Func = function()
        RemotesFolder:WaitForChild("PlayAgain"):FireServer()
    end,
    DoubleClick = false,
})
local lobbyButton = Groupboxes.Miscellaneous:AddButton({
    Text = "Lobby",
    Func = function()
        RemotesFolder:WaitForChild("Lobby"):FireServer()
    end,
    DoubleClick = false,
})



Groupboxes.AntiEntity = Tabs.Cheats:AddLeftGroupbox("Anti-Entity")
Groupboxes.AntiEntity:AddToggle("RemoveSnareHitbox", {
    Text = "Anti-Snare",
    Default = false,
    Visible = IsFloor.Mines or IsFloor.Hotel or IsFloor.HardMode
})
Groupboxes.AntiEntity:AddToggle("NoDupeTouch", {
    Text = "Anti-Dupe",
    Default = false,
    Visible = IsFloor.Mines or IsFloor.Hotel or IsFloor.HardMode
})
Groupboxes.AntiEntity:AddToggle("nobanana", {
    Text = "Anti-Bananas",
    Default = false,
    Visible = IsFloor.HardMode
})
Groupboxes.AntiEntity:AddToggle("noeyes", {
    Text = if IsFloor.Backdoor then "Anti-Lookman" else "Anti-Eyes",
    Default = false,
})
Groupboxes.AntiEntity:AddToggle("GiggleHitboxRemoval", {
    Text = "Anti-Giggle",
    Default = false,
    Visible = IsFloor.Mines
})
Groupboxes.AntiEntity:AddToggle("AntiGloomEgg", {
    Text = "Anti-Gloom Egg",
    Default = false,
    Visible = IsFloor.Mines
})
Groupboxes.AntiEntity:AddToggle("AntiDread", {
    Text = "Anti-Dread",
    Default = false,
})
Groupboxes.AntiEntity:AddToggle("nohalt", {
    Text = "Anti-Halt",
    Default = false,
})
Groupboxes.AntiEntity:AddToggle("AntiJeffClient", {
    Text = "Anti-Jeff (Client-Side)",
    Default = false,
    Visible = IsFloor.HardMode
})
Groupboxes.Removal = Tabs.Cheats:AddRightGroupbox("Removal")
Groupboxes.Removal:AddToggle("RemoveScreech", {
    Text = "No Screech",
    Default = false,
})

Groupboxes.Removal:AddToggle("A90Disabled", {
    Text = "No A90",
    Default = false,
})

Groupboxes.Removal:AddDivider()

Groupboxes.Removal:AddToggle("serverSideKillJeff", {
    Text = "No Jeff FE",
    Default = false,
    Visible = IsFloor.HardMode
})

Groupboxes.Removal:AddToggle("NoSeekFE", {
    Text = "FE No Seek Trigger",
    Default = false,
    Visible = IsFloor.Hotel or IsFloor.HardMode or IsFloor.Mines
})

Groupboxes.SelfCheats = Tabs.Cheats:AddRightGroupbox("Self")

Groupboxes.SelfCheats:AddToggle("FigureHearing", {
    Text = "No Figure Hearing",
    Default = false,
    Visible = IsFloor.Mines or IsFloor.HardMode or IsFloor.Hotel
})
Groupboxes.SelfCheats:AddToggle("noObstaclesToggle", {
    Text = "Anti-Obstacles",
    Default = false,
    Visible = IsFloor.Hotel or IsFloor.HardMode
})
Groupboxes.SelfCheats:AddToggle("BridgeWalk", {
    Text = "Anti-Bridge Fall",
    Default = false,
    Visible = IsFloor.Mines
})

Groupboxes.SelfCheats:AddDivider()

Groupboxes.SelfCheats:AddToggle("InfUniversalKey", {
    Text = "Infinite Items",
    Default = false,
    Visible = not IsFloor.HardMode
})


Groupboxes.FE = Tabs.Fun:AddLeftGroupbox("FE")

Groupboxes.FE:AddToggle("StunToggle", {
    Text = "Roll Over",
    Default = false
}):AddKeyPicker("StunKeybind", {
    Text = "Roll Over",
    Default = "P",
    NoUI = false,
    SyncToggleState = true
})

Groupboxes.FE:AddToggle("SpamOtherTools", {
    Text = "Spam Others' Tools",
    Default = false
}):AddKeyPicker("SpamOtherToolsKeybind", {
    Text = "Spam Others' Tools",
    Default = "V",
    NoUI = false,
    SyncToggleState = false
})

local breakDoors = Groupboxes.FE:AddButton({
    Text = "Teleport Unanchored",
    Func = function()
        for i, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Attachment") and not v:FindFirstAncestor("RushMoving") and not v:FindFirstAncestor("AmbushMoving") and not v:FindFirstAncestor("Dread") then
                v.WorldCFrame = PlayerVariables.HumanoidRootPart.CFrame
        end
    end

        CurrentRooms.DescendantAdded:Connect(function(v)
            if v:IsA("Attachment") and not v:FindFirstAncestor("RushMoving") and not v:FindFirstAncestor("AmbushMoving") and not v:FindFirstAncestor("Dread") then
                v.WorldCFrame = PlayerVariables.HumanoidRootPart.CFrame
            end
        end)
    end,
    DoubleClick = false,
})




local TabBox = Tabs.Visuals:AddLeftTabbox()

Groupboxes.ESP = TabBox:AddTab("ESP")

Groupboxes.ESP:AddToggle("EntityESP", {
    Text = "Entity",
    Default = false,
}):AddColorPicker("EntityESPColor", {
    Default = Color3.fromRGB(255, 0, 0),
    Title = "Entity ESP Color"
})


Groupboxes.ESP:AddToggle("DoorESP", {
    Text = "Door ESP",
    Default = false,
}):AddColorPicker("DoorESPColor", {
    Default = Color3.fromRGB(0, 255, 255),
    Title = "Door ESP Color",
})

Groupboxes.ESP:AddToggle("ObjectiveESP", {
    Text = "Objective",
    Default = false
}):AddColorPicker("ObjectiveESPColor", {
    Default = Color3.fromRGB(0, 150, 0),
    Title = "Objective ESP Color"
})

Groupboxes.ESP:AddToggle("PlayerESP", {
    Text = "Player",
    Default = false
}):AddColorPicker("PlayerESPColor", {
    Default = Color3.fromRGB(255, 255, 255)
})

Groupboxes.ESP:AddToggle("ItemESP", {
    Text = "Item",
    Default = false,
}):AddColorPicker("ItemESPColor", {
    Default = Color3.fromRGB(1, 50, 32),
    Title = "Item ESP Color",
})

Groupboxes.ESP:AddToggle("GoldESP", {
    Text = "Gold",
    Default = false
}):AddColorPicker("GoldESPColor", {
    Default = Color3.fromRGB(229, 184, 11),
    Title = "Gold ESP Color",
})

Groupboxes.ESP:AddToggle("ChestESP", {
    Text = "Chest/Toolshed",
    Default = false
}):AddColorPicker("ChestESPColor", {
    Default = Color3.fromRGB(120, 42, 42),
    Title = "Chest ESP Color",
})

Groupboxes.ESP:AddToggle("HidingSpotsESP", {
    Text = "Hiding Spot",
    Default = false
}):AddColorPicker("HidingSpotESPColor", {
    Default = Color3.fromRGB(165, 42, 42),
    Title = "Hiding Spot ESP Color",
})

Groupboxes.Settings = TabBox:AddTab("ESP Settings")

Groupboxes.Settings:AddToggle("DistanceESP", {
    Text = "Show Distance",
    Default = false
})

Groupboxes.Settings:AddToggle("RainbowESP", {
    Text = "Rainbow",
    Default = false
})

Groupboxes.Settings:AddToggle("Tracers", {
    Text = "Enable Tracers",
    Default = false
})

Groupboxes.Settings:AddDropdown("TracerStart", {
    Values = {"Bottom", "Center", "Top", "Mouse"},
    Default = "Bottom",
    Multi = false,
    Text = "Tracer Start"
})

Groupboxes.Settings:AddDivider()

Groupboxes.Settings:AddSlider("TextSize", {
    Text = "Text Size",
    Min = 16,
    Default = 22,
    Max = 32,
    Compact = false,
    Rounding = 0
})
Groupboxes.Settings:AddDivider()

Groupboxes.Settings:AddDropdown("DoorESPTextMethod", {
    Text = "Door ESP Text",
    Multi = false,
    Values = {"Normal (1)", "Four Digits (0001)"},
    Default = "Normal (1)"
})

Groupboxes.Lighting = Tabs.Visuals:AddRightGroupbox("Lighting")

Groupboxes.Lighting:AddToggle("ambienceToggle", {
    Text = "Ambient",
    Default = false
}):AddColorPicker("ambiencecol", {
    Default = Color3.fromRGB(255, 255, 255),
    Transparency = 0
})
Groupboxes.Lighting:AddToggle("NoFog", {
    Text = "No Fog",
    Default = false
})

Groupboxes.Lighting:AddDivider()

Groupboxes.Lighting:AddToggle("lightToggle", {
    Text = "Headlight",
    Default = false
})

Groupboxes.Lighting:AddSlider("lightSlider", {
    Text = "Brightness",
    Default = 0,
    Min = 0,
    Rounding = 1,
    Max = 3,
    Compact = true
})

local VisualTabBox = Tabs.Visuals:AddRightTabbox()

Groupboxes.View = VisualTabBox:AddTab("Self")

Groupboxes.View:AddToggle("NoCutscenes", {
    Text = "No Cutscenes",
    Default = false
})

Groupboxes.View:AddToggle("DisableCameraShake", {
    Text = "Disable Camera Shake",
    Default = false
})

Groupboxes.View:AddSlider("fovSlider", {
    Text = "Field Of View",
    Default = 70,
    Min = 30,
    Max = 120,
    Rounding = 0,
    Compact = true
})

Groupboxes.View:AddDivider()

Groupboxes.View:AddToggle("TranslucentCloset", {
    Text = "Transparent " .. FloorHidingSpot[Floor],
    Default = false
})

Groupboxes.View:AddSlider("TransparencySlider", {
    Text = "Transparency",
    Default = 0.5,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = true 
})

Groupboxes.View:AddDivider()

Groupboxes.View:AddToggle("ViewmodelOffset", {
    Text = "Viewmodel Offset",
    Default = false
})

Groupboxes.View:AddSlider("XOffset", {
    Text = "X",
    Default = 0,
    Min = -5,
    Max = 5,
    Rounding = 1,
    Compact = true
})

Groupboxes.View:AddSlider("YOffset", {
    Text = "Y",
    Default = 0,
    Min = -5,
    Max = 5,
    Rounding = 1,
    Compact = true
})

Groupboxes.View:AddSlider("ZOffset", {
    Text = "Z",
    Default = 0, 
    Min = -5,
    Max = 5,
    Rounding = 1,
    Compact = true
})

Groupboxes.Jumpscares = VisualTabBox:AddTab("Jumpscares")


Groupboxes.Jumpscares:AddToggle("NoVoidJumpscare", {
    Text = "No Void Effect",
    Default = false
})

Groupboxes.Jumpscares:AddToggle("NoGlitchFX", {
    Text = "No Glitch Jumpscare",
    Default = false
})

Groupboxes.Jumpscares:AddToggle("NoTimothyJumpscare", {
    Text = "No Timothy Jumpscare",
    Default = false
})

-- \ Logical Code \ --


Toggles.sbypass:OnChanged(function(value)
    Functions.SetSpeedBypass(value)
end)

Toggles.noslide:OnChanged(function(value)
    if value then
        PlayerVariables.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(100, 0, 0, 0, 0)
    else
        PlayerVariables.HumanoidRootPart.CustomPhysicalProperties = PlayerVariables.RootProperties
    end
end)


Toggles.Fly:OnChanged(function(value)
    if value then
        Fly:Start()
    else
        if Fly.Enabled then
            Fly:Stop()
        end
    end
end)

Toggles.autopl:OnChanged(function(value)
    if PlayerVariables.Character:FindFirstChild("LibraryHintPaper") or PlayerVariables.Character:FindFirstChild("LibraryHintPaperHard") then
        local paper = PlayerVariables.Character:FindFirstChild("LibraryHintPaper") or PlayerVariables.Character:FindFirstChild("LibraryHintPaperHard")
        local code = Functions.PadlockCode(paper, "FireServer")
    end
end)

Toggles.plcode:OnChanged(function(value)
    if value then
        if PlayerVariables.Character:FindFirstChild("LibraryHintPaper") or PlayerVariables.Character:FindFirstChild("LibraryHintPaperHard") then
            local paper = PlayerVariables.Character:FindFirstChild("LibraryHintPaper") or PlayerVariables.Character:FindFirstChild("LibraryHintPaperHard")
            local code = Functions.PadlockCode(paper, "ToNotify")
        end
    end
end)

Toggles.lightToggle:OnChanged(function(value)
    Disposal.Light.Enabled = value
    Disposal.Light.Brightness = Options.lightSlider.Value
end)

Options.lightSlider:OnChanged(function(value)
    Disposal.Light.Brightness = value
end)



Toggles.RemoveScreech:OnChanged(function(value)
    local Name = if value then "Real" else "Screech"

    screechModule.Name = Name
end)

Toggles.GiggleHitboxRemoval:OnChanged(function(value)
    for _, v in pairs(CurrentRoomModel:GetChildren()) do
        for i, giggle in pairs(v:GetChildren()) do
            if giggle.Name == "GiggleCeiling" then
                local Hitbox = giggle:WaitForChild("Hitbox", 5)

                if Hitbox then
                    Hitbox.CanTouch = not value
                end
            end
        end
    end
end)

Toggles.AntiGloomEgg:OnChanged(function(value)
    for _, v in pairs(CurrentRoomModel:GetChildren()) do
        if v.Name == "GloomPile" then
            for index, egg in pairs(v:GetDescendants()) do
                if egg.Name == "Egg" then
                    egg.CanTouch = not value
                end
            end
        end
    end
end)

Toggles.AntiDread:OnChanged(function(value)
    Dread.Name = if value then "Draddy" else "Dread"
end)
Toggles.NoTimothyJumpscare:OnChanged(function(value)
    timothyModel.Parent = if value then nil else Entity
end)

Toggles.A90Disabled:OnChanged(function(value)
    local Name = if value then "Cooked" else "A90"

    A90.Name = Name
end)

Toggles.NoCutscenes:OnChanged(function(value)
    if moduleScripts.MainGame:FindFirstChild("Cutscenes", true) then
        local Cutscenes = moduleScripts.MainGame:FindFirstChild("Cutscenes", true)

        for _, v in pairs(Cutscenes:GetChildren()) do
            if not table.find(ToExclude, v.Name) then
                local name = v.Name:gsub("Script", "")

                v.Name = if value then name .. "Script" else name
            end
        end
    end
end)

Toggles.NoSeekFE:OnChanged(function(value)
    if CurrentRooms:FindFirstChild(tostring(gameData.LatestRoom.Value + 1)) then
        local trigcollision = CurrentRooms[tostring(gameData.LatestRoom.Value + 1)]:FindFirstChild("TriggerEventCollision")
        local collision = if trigcollision then trigcollision:FindFirstChild("Collision") else nil

        if trigcollision and collision then
            Functions.SetupDeleteSeek(collision)
        end
    end
end)
Toggles.NoGlitchFX:OnChanged(function(value)
    local Name = if value then "_Script_Glitch" else "Glitch"

    Glitch.Name = Name
end)

Toggles.NoVoidJumpscare:OnChanged(function(value)
    local Name = if value then "DivineHub" else "Void"

    Void.Name = Name
end)



Toggles.RemoveSnareHitbox:OnChanged(function(value)
    for _, v in pairs(CurrentRoomModel.Assets:GetChildren()) do
        if v.Name == "Snare" then
            task.spawn(Functions.SetTouch, v, not value)
        end
    end
end)

Toggles.NoDupeTouch:OnChanged(function(value)
    for _, v in pairs(CurrentRoomModel:GetChildren()) do
        if v.Name == "SideroomDupe" then
            local DoorFake = v:WaitForChild("DoorFake", 5)

            if DoorFake then
                task.spawn(Functions.SetTouch, DoorFake, not value)
            end
        end
    end
end)

Toggles.nobanana:OnChanged(function(value)
    for _, v in pairs(workspace:GetChildren()) do
        if v.Name == "BananaPeel" then
            v.CanTouch = not value
        end
    end
end)

Toggles.nohalt:OnChanged(function(value)
    local Name = if value then "Halt" else "Shade"

    Shade.Name = Name
end)

Toggles.noObstaclesToggle:OnChanged(function(value)
    for _, v in pairs(CurrentRoomModel.Assets:GetChildren()) do
        for i, obstr in pairs(v:GetDescendants()) do
            if obstr.Name == "Seek_Arm" or obstr.Name == "ChandelierObstruction" then
                task.spawn(Functions.SetTouch, obstr, not value)
            end
        end
    end
end)

Toggles.BridgeWalk:OnChanged(function(value)
    if value then
        if CurrentRoomModel:FindFirstChild("Parts") then
            for _, v in pairs(CurrentRoomModel:FindFirstChild("Parts"):GetChildren()) do
                task.spawn(Functions.BridgePlatform, v)
            end
        end
    else
        for _, v in pairs(Bridges) do
            v:Destroy()
        end
    end
end)

Toggles.PromptClip:OnChanged(function(value)
    for _, v: ProximityPrompt in pairs(CurrentRooms:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            if not v:GetAttribute("RequiresSight") then
                v:SetAttribute("RequiresSight", v.RequiresLineOfSight)
            end

            v.RequiresLineOfSight = not value
        end
    end
end)

Options.PromptReach:OnChanged(function(value)
    for _, v: ProximityPrompt in pairs(CurrentRooms:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            if not v:GetAttribute("OGDistance") then
                v:SetAttribute("OGDistance", v.MaxActivationDistance)
            end

            v.MaxActivationDistance = v:GetAttribute("OGDistance") * value
        end
    end
end)



Toggles.serverSideKillJeff:OnChanged(function(value)
    if value then
        for _, v in pairs(workspace:GetChildren()) do
            if v.Name == "JeffTheKiller" then
                task.spawn(function()
                    repeat
                        task.wait()
                    until isnetworkowner(v.PrimaryPart) or not v or not v:IsDescendantOf(workspace) or not Toggles.serverSideKillJeff.Value

                    if v and Toggles.serverSideKillJeff.Value then
                        v.Torso.Name = math.random(1, 100)
                    end
                end)
            end
        end
    end
end)

Toggles.EntityESP:OnChanged(function(value)
    if value then
        for _, v in pairs(workspace:GetChildren()) do
            task.spawn(Functions.EntityESP, v)
        end

        for _, v in pairs(CurrentRoomModel:GetDescendants()) do
            task.spawn(Functions.SideEntityESP, v)
        end

    else
        for _, v in pairs(ESPTable.Entity) do
            v:Destroy()
        end

        for _, v in pairs(ESPTable.SideEntity) do
            v:Destroy()
        end
    end
end)

Toggles.DoorESP:OnChanged(function(value)
    if value then
        task.spawn(Functions.DoorESP, CurrentRoomModel)

        task.spawn(Functions.DoorESP, NextRoomModel)
    else
        for _, v in pairs(ESPTable.Door) do
            v:Destroy()
        end
    end
end)

Toggles.ObjectiveESP:OnChanged(function(value)
    if value then
        for _, v in pairs(CurrentRoomModel:GetDescendants()) do
            task.spawn(Functions.ObjectiveESP, v)
        end
    else
        for _, esp in pairs(ESPTable.Objective) do
            esp:Destroy()
        end
    end
end)

Toggles.ItemESP:OnChanged(function(value)
    if value then
        for _, v in pairs(CurrentRoomModel:GetDescendants()) do
            task.spawn(Functions.ItemESP, v)
        end

        for _, v in pairs(workspace.Drops:GetChildren()) do
            task.spawn(Functions.ItemESP, v, true)
        end
    else
        for _, v in pairs(ESPTable.Item) do
            v:Destroy()
        end

        for _, v in pairs(ESPTable.DroppedItem) do
            v:Destroy()
        end
    end
end)

Toggles.GoldESP:OnChanged(function(value)
    if value then
        for _, v in pairs(CurrentRoomModel.Assets:GetDescendants()) do
            task.spawn(Functions.GoldESP, v)
        end
    else
        for _, v in pairs(ESPTable.Gold) do
            v:Destroy()
        end
    end
end)

Toggles.ChestESP:OnChanged(function(value)
    if value then
        for _, v in pairs(CurrentRoomModel:GetDescendants()) do
            task.spawn(Functions.ChestESP, v)
        end
    else
        for _, v in pairs(ESPTable.Chest) do
            v:Destroy()
        end
    end
end)

Toggles.HidingSpotsESP:OnChanged(function(value)
    if value then
        for _, v in pairs(CurrentRoomModel.Assets:GetChildren()) do
            task.spawn(Functions.HidingSpotESP, v)
        end
    else
        for _, v in pairs(ESPTable.HidingSpot) do
            v:Destroy()
        end
    end
end)

Toggles.PlayerESP:OnChanged(function(value)
    if value then
        for _, player in pairs(Players:GetPlayers()) do
            task.spawn(Functions.PlayerESP, player)
        end
    else
        for _, v in pairs(ESPTable.Player) do
            v:Destroy()
        end
    end
end)

Options.EntityESPColor:OnChanged(function(value)
    for _, v in pairs(ESPTable.Entity) do
        v.CurrentSettings.Color = value        
        v.CurrentSettings.FillColor = value
        v.CurrentSettings.OutlineColor = value
    end
end)

Options.DoorESPColor:OnChanged(function(value)
    for _, v in pairs(ESPTable.Door) do
        v.CurrentSettings.Color = value        
        v.CurrentSettings.FillColor = value
        v.CurrentSettings.OutlineColor = value
    end
end)

Options.ObjectiveESPColor:OnChanged(function(value)
    for _, v in pairs(ESPTable.Objective) do
        v.CurrentSettings.Color = value        
        v.CurrentSettings.FillColor = value
        v.CurrentSettings.OutlineColor = value
    end
end)

Options.ItemESPColor:OnChanged(function(value)
    for _, v in pairs(ESPTable.Item) do
        v.CurrentSettings.Color = value        
        v.CurrentSettings.FillColor = value
        v.CurrentSettings.OutlineColor = value
    end
end)

Options.GoldESPColor:OnChanged(function(value)
    for _, v in pairs(ESPTable.Gold) do
        v.CurrentSettings.Color = value        
        v.CurrentSettings.FillColor = value
        v.CurrentSettings.OutlineColor = value
    end
end)

Options.ChestESPColor:OnChanged(function(value)
    for _, v in pairs(ESPTable.Chest) do
        v.CurrentSettings.Color = value        
        v.CurrentSettings.FillColor = value
        v.CurrentSettings.OutlineColor = value
    end
end)

Options.PlayerESPColor:OnChanged(function(value)
    for _, v in pairs(ESPTable.Player) do
        v.CurrentSettings.Color = value        
        v.CurrentSettings.FillColor = value
        v.CurrentSettings.OutlineColor = value
    end
end)

Options.HidingSpotESPColor:OnChanged(function(value)
    for _, v in pairs(ESPTable.HidingSpot) do
        v.CurrentSettings.Color = value        
        v.CurrentSettings.FillColor = value
        v.CurrentSettings.OutlineColor = value
    end
end)

Toggles.RainbowESP:OnChanged(function(value)
    ESPLibrary.GlobalConfig.Rainbow = value
end)

Toggles.DistanceESP:OnChanged(function(value)
    ESPLibrary.GlobalConfig.Distance = value
end)

Toggles.Tracers:OnChanged(function(value)
    ESPLibrary.GlobalConfig.Tracers = value
end)

Options.TracerStart:OnChanged(function(value)
    for _, v in pairs(ESPTable) do
        for _, x in pairs(v) do
            x.CurrentSettings.Tracer = {
                Enabled = true,
                Color = x.CurrentSettings.Color,
                From = value
            }
        end
    end
end)

Options.TextSize:OnChanged(function(value)
    for _, v in pairs(ESPTable) do
        for _, x in pairs(v) do
            x.CurrentSettings.TextSize = value
        end   
    end
end)

Options.DoorESPTextMethod:OnChanged(function(value)
    for _, v in pairs(ESPTable.Door) do
        v.CurrentSettings.Name = string.format("Door %s %s", Functions.GetDoorText(v.CurrentSettings.Model.Parent), (if v.CurrentSettings.Model.Parent:GetAttribute("Opened") then "[Opened]" elseif v.CurrentSettings.Model.Parent.Parent:GetAttribute("RequiresKey") then "[Locked]" else ""))
    end
end)


Toggles.TranslucentCloset:OnChanged(function(value)
    if value then
        if PlayerVariables.Character:GetAttribute("Hiding") then
            for _, v in pairs(CurrentRoomModel:GetDescendants()) do
                if v.Name == "HiddenPlayer" then
                    if v.Value == PlayerVariables.Player or v.Value == PlayerVariables.Character then
                        for _, x in pairs(v.Parent:GetDescendants()) do
                            if x:IsA("BasePart") then
                                if x.Transparency ~= 1 then
                                    table.insert(Parts, x)
                                end
                            end
                        end
                    end
                end
            end

            task.spawn(function()
                repeat
                    task.wait()
                    for _, v in pairs(Parts) do
                        v.Transparency = Options.TransparencySlider.Value
                    end
                until not PlayerVariables.Character:GetAttribute("Hiding") or not Toggles.TranslucentCloset.Value

                for _, v in pairs(Parts) do
                    v.Transparency = 0
                end

                Parts = {}
            end)
        end
    end
end)

Toggles.ViewmodelOffset:OnChanged(function(value)
    if value then
        for _, v in pairs(PlayerVariables.Player.Backpack:GetChildren()) do
            if v:IsA("Tool") then
                if not v:GetAttribute("OGOffset") then
                    v:SetAttribute("OGOffset", v:GetAttribute("ToolOffset"))
                end

                v:SetAttribute("ToolOffset", Vector3.new(Options.XOffset.Value, Options.YOffset.Value, Options.ZOffset.Value))
            end
        end

        for _, v in pairs(PlayerVariables.Character:GetChildren()) do
            if v:IsA("Tool") then
                if not v:GetAttribute("OGOffset") then
                    v:SetAttribute("OGOffset", v:GetAttribute("ToolOffset"))
                end

                v:SetAttribute("ToolOffset", Vector3.new(Options.XOffset.Value, Options.YOffset.Value, Options.ZOffset.Value))
            end
        end

        task.spawn(function()
            repeat
                task.wait()
            until not Toggles.ViewmodelOffset.Value

            for _, v in pairs(PlayerVariables.Character:GetChildren()) do
                if v:IsA("Tool") then
                    if v:GetAttribute("OGOffset") then
                        v:SetAttribute("ToolOffset", v:GetAttribute("OGOffset"))
                    end
                end
            end

            for _, v in pairs(PlayerVariables.Player.Backpack:GetChildren()) do
                if v:IsA("Tool") then
                    if v:GetAttribute("OGOffset") then
                        v:SetAttribute("ToolOffset", v:GetAttribute("OGOffset"))
                    end
                end
            end
        end)
    end
end)

Options.XOffset:OnChanged(function(value)
    if Toggles.ViewmodelOffset.Value then
        for _, v in pairs(PlayerVariables.Player.Backpack:GetChildren()) do
            if v:IsA("Tool") then
                if not v:GetAttribute("OGOffset") then
                    v:SetAttribute("OGOffset", v:GetAttribute("ToolOffset"))
                end

                v:SetAttribute("ToolOffset", Vector3.new(Options.XOffset.Value, Options.YOffset.Value, Options.ZOffset.Value))
            end
        end

        for _, v in pairs(PlayerVariables.Character:GetChildren()) do
            if v:IsA("Tool") then
                if not v:GetAttribute("OGOffset") then
                    v:SetAttribute("OGOffset", v:GetAttribute("ToolOffset"))
                end

                v:SetAttribute("ToolOffset", Vector3.new(Options.XOffset.Value, Options.YOffset.Value, Options.ZOffset.Value))
            end
        end
    end
end)

Options.YOffset:OnChanged(function(value)
    if Toggles.ViewmodelOffset.Value then
        for _, v in pairs(PlayerVariables.Player.Backpack:GetChildren()) do
            if v:IsA("Tool") then
                if not v:GetAttribute("OGOffset") then
                    v:SetAttribute("OGOffset", v:GetAttribute("ToolOffset"))
                end

                v:SetAttribute("ToolOffset", Vector3.new(Options.XOffset.Value, Options.YOffset.Value, Options.ZOffset.Value))
            end
        end

        for _, v in pairs(PlayerVariables.Character:GetChildren()) do
            if v:IsA("Tool") then
                if not v:GetAttribute("OGOffset") then
                    v:SetAttribute("OGOffset", v:GetAttribute("ToolOffset"))
                end

                v:SetAttribute("ToolOffset", Vector3.new(Options.XOffset.Value, Options.YOffset.Value, Options.ZOffset.Value))
            end
        end
    end
end)

Options.ZOffset:OnChanged(function(value)
    if Toggles.ViewmodelOffset.Value then
        for _, v in pairs(PlayerVariables.Player.Backpack:GetChildren()) do
            if v:IsA("Tool") then
                if not v:GetAttribute("OGOffset") then
                    v:SetAttribute("OGOffset", v:GetAttribute("ToolOffset"))
                end

                v:SetAttribute("ToolOffset", Vector3.new(Options.XOffset.Value, Options.YOffset.Value, Options.ZOffset.Value))
            end
        end

        for _, v in pairs(PlayerVariables.Character:GetChildren()) do
            if v:IsA("Tool") then
                if not v:GetAttribute("OGOffset") then
                    v:SetAttribute("OGOffset", v:GetAttribute("ToolOffset"))
                end

                v:SetAttribute("ToolOffset", Vector3.new(Options.XOffset.Value, Options.YOffset.Value, Options.ZOffset.Value))
            end
        end
    end
end)


if CurrentRoomModel:GetAttribute("RawName"):find("Halt") and Options.EntityNotifier.Value["Halt"] then
    Library:Notification("Halt will be in the next room.")
end

for _, v in pairs(CurrentRooms:GetChildren()) do
    task.spawn(Functions.SetupRoom, v)
end

-- \ Main connections \ --
Library:GiveSignal(RunService.RenderStepped:Connect(function()

    if Toggles.ambienceToggle.Value then
        game.Lighting.Ambient = Options.ambiencecol.Value
    else
        game.Lighting.Ambient = CurrentRoomModel:GetAttribute("Ambient")
    end

    if CurrentRoomModel:FindFirstChild("Door") and CurrentRoomModel:FindFirstChild("Door"):FindFirstChild("ClientOpen") and Toggles.DoorReach.Value then
        CurrentRoomModel:FindFirstChild("Door"):FindFirstChild("ClientOpen"):FireServer()
    end

    if Toggles.NoFog.Value then
        game.Lighting.FogStart = 9e9
        game.Lighting.FogEnd = 9e9
    else
        game.Lighting.FogStart = 150
        game.Lighting.FogEnd = 350
    end

    if Supported["require"] and Toggles.ViewmodelOffset.Value then
        require(moduleScripts.MainGame).tooloffset = Vector3.new(Options.XOffset.Value, Options.YOffset.Value, Options.ZOffset.Value)
    end

    if Toggles.jump.Value and PlayerVariables.Humanoid then
        PlayerVariables.Humanoid.JumpHeight = Options.JumpHeight.Value
    end

    if Toggles.SpamOtherTools.Value and Options.SpamOtherToolsKeybind:GetState() then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= PlayerVariables.Player then
                for index, item in pairs(player.Backpack:GetChildren()) do
                    item:FindFirstChildWhichIsA("RemoteEvent"):FireServer()
                end
    
                for index, item in pairs(player.Character:GetChildren()) do
                    if item:IsA("Tool") then
                        item:FindFirstChildWhichIsA("RemoteEvent"):FireServer()
                    end
                end
            end
        end
    end



    if Toggles.FigureHearing.Value then
        RemotesFolder.Crouch:FireServer(true)
        PlayerVariables.Character:SetAttribute("Crouching", true)
    end

    if Toggles.noeyes.Value and (workspace:FindFirstChild("Eyes") or workspace:FindFirstChild("BackdoorLookman")) then
        RemotesFolder.MotorReplication:FireServer(-649)
    end

    PlayerVariables.Character:SetAttribute("Stunned", Toggles.StunToggle.Value)
    PlayerVariables.Character:SetAttribute("SpeedBoost", Options.SpeedBoost.Value)
    PlayerVariables.Character:SetAttribute("CanJump", Toggles.jump.Value)

    if Toggles.DisableCameraShake.Value then
        require(moduleScripts.MainGame).csgo = CFrame.new(0, 0, 0)
    end

    workspace.CurrentCamera.FieldOfView = Options.fovSlider.Value

    if Supported["require"] then
        require(moduleScripts.MainGame).fovtarget = Options.fovSlider.Value
    end

    if Toggles.AutoBreakerBox.Value then
        if RemotesFolder:FindFirstChild("EBF") then
            RemotesFolder.EBF:FireServer()
        end
    end

    if CurrentRoomModel == nil then
        CurrentRoom = tostring(gameData.LatestRoom.Value)
    end

    for _, v in pairs(PlayerVariables.Character:GetChildren()) do
        if v:IsA("BasePart") then
            if Toggles.nclip.Value then
                v.CanCollide = not Toggles.nclip.Value
            end
        end
    end

    if not Toggles.nclip.Value then
        PlayerVariables.Collision.CanCollide = Supported["require"] and not require(moduleScripts.MainGame).crouching or not PlayerVariables.Character:GetAttribute("Crouching")
        PlayerVariables.CollisionClone.CanCollide = Supported["require"] and not require(moduleScripts.MainGame).crouching or not PlayerVariables.Character:GetAttribute("Crouching")
    end

    PlayerVariables.CollisionClone.CollisionCrouch.CanCollide = Supported["require"] and require(moduleScripts.MainGame).crouching or PlayerVariables.Character:GetAttribute("Crouching")
    PlayerVariables.Collision.CollisionCrouch.CanCollide = Supported["require"] and require(moduleScripts.MainGame).crouching or PlayerVariables.Character:GetAttribute("Crouching") 

    if PlayerVariables.CollisionClone and PlayerVariables.Collision then
        PlayerVariables.CollisionClone.CollisionGroup = PlayerVariables.Collision.CollisionGroup
        PlayerVariables.CollisionClone.CollisionCrouch.CollisionGroup = PlayerVariables.Collision.CollisionCrouch.CollisionGroup
        PlayerVariables.CollisionClone.Position = PlayerVariables.Collision.Position
    end

    if Toggles.AutoInteract.Value and Options.AutoInteractKey:GetState() then
        for _, v in pairs(GamePrompts) do
            if Functions.AvailablePrompt(v) then
                fireproximityprompt(v, true)
            end
        end
    end
end))


Library:GiveSignal(workspace.ChildAdded:Connect(function(child)
    if not child:IsA("Model") then
        return;
    end

    task.spawn(Functions.EntityESP, child)

    if NotifyTable[Functions.ShortName(child)] and child:GetPivot().Position.Y > -10000 and Options.EntityNotifier.Value[Functions.ShortName(child)] then
        Library:Notification(NotifyTable[Functions.ShortName(child)].Notification)
    end

    if child.Name == "BananaPeel" then
        child.CanTouch = not Toggles.nobanana.Value
    end

    if Toggles.serverSideKillJeff.Value then
        if child.Name == "JeffTheKiller" then
            task.spawn(function()
                repeat
                    task.wait()
                until isnetworkowner(child) or not child or not child:IsDescendantOf(workspace) or not Toggles.serverSideKillJeff.Value

                if Toggles.serverSideKillJeff.Value and child then
                    child.Torso.Name = math.random(1, 50)
                end
            end)
        end
    end
end))


Library:GiveSignal(PxPromptService.PromptButtonHoldBegan:Connect(function(prompt, playerWhoTriggered)
    if Toggles.noewait.Value then
        if playerWhoTriggered == PlayerVariables.Player then
            fireproximityprompt(prompt, true)
        end
    end
end))

for _, plr in pairs(Players:GetPlayers()) do
    Connections[string.format("Items: %s", plr.DisplayName)] = plr.Character.ChildAdded:Connect(function(tool: Tool)
        if tool.Name:find("LibraryHintPaper") then

            if Toggles.plcode.Value then
                Functions.PadlockCode(tool, "ToNotify", plr)
            end

            if Toggles.autopl.Value then
                Functions.PadlockCode(tool, "FireServer", plr)
            end
        end

        if tool.Parent == PlayerVariables.Character then
            if Toggles.ViewmodelOffset.Value then
                task.spawn(Functions.NonRequireViewmodelOffset, tool)
            else
                task.spawn(Functions.ClearViewmodelOffset, tool)
            end
        end
    end)
end

Library:GiveSignal(PlayerVariables.Humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(function()
    if PlayerVariables.Character:GetAttribute("Hiding") and PlayerVariables.Humanoid.MoveDirection.Magnitude > 0 then
        RemotesFolder.CamLock:FireServer()
    end
end))

Library:GiveSignal(CurrentRooms.ChildAdded:Connect(function(child)
    task.spawn(Functions.SetupRoom, child)
end))

Library:GiveSignal(workspace.Drops.ChildAdded:Connect(function(child: Instance)
    task.spawn(Functions.ItemESP, child, true)
end))

Library:GiveSignal(PlayerVariables.Player:GetAttributeChangedSignal("CurrentRoom"):Connect(function()
    
        CurrentRoom = if CurrentRooms:FindFirstChild(tostring(PlayerVariables.Player:GetAttribute("CurrentRoom"))) then tostring(PlayerVariables.Player:GetAttribute("CurrentRoom")) else tostring(gameData.LatestRoom.Value)
        NextRoom = tostring(PlayerVariables.Player:GetAttribute("CurrentRoom") + 1)
        CurrentRoomModel = CurrentRooms:FindFirstChild(CurrentRoom)
        NextRoomModel = CurrentRooms:FindFirstChild(NextRoom)

        

        if PlayerVariables.Player:GetAttribute("CurrentRoom") ~= 100 then repeat task.wait() until CurrentRooms:FindFirstChild(NextRoom) end

        if Toggles.DoorESP.Value then
            for _, v in pairs(ESPTable.Door) do
                v:Destroy()
            end

            task.spawn(Functions.DoorESP, CurrentRoomModel)

            task.spawn(Functions.DoorESP, NextRoomModel)
        end

        task.spawn(Functions.ClearRoomESP)

        task.spawn(Functions.SetupCurrentRoomESP, CurrentRoomModel)

        if Toggles.BridgeWalk.Value and IsFloor.Mines and CurrentRoomModel:GetAttribute("Chase") then
            for _, v in pairs(CurrentRoomModel:FindFirstChild("Parts"):GetChildren()) do
                if v.Name == "Bridge" then
                    task.spawn(Functions.BridgePlatform, v)
                end
            end
        end
end))

Library:GiveSignal(PlayerVariables.Character:GetAttributeChangedSignal("Hiding"):Connect(function(value)
    if Toggles.TranslucentCloset.Value then
        for _, v in pairs(CurrentRoomModel:GetDescendants()) do
            if v.Name == "HiddenPlayer" then
                if v.Value == PlayerVariables.Player or v.Value == PlayerVariables.Character then
                    for _, x in pairs(v.Parent:GetDescendants()) do
                        if x:IsA("BasePart") then
                            if x.Transparency ~= 1 then
                                table.insert(Parts, x)
                            end
                        end
                    end
                end
            end
        end

        task.spawn(function()
            repeat
                task.wait()

                for _, v in pairs(Parts) do
                    v.Transparency = Options.TransparencySlider.Value
                end
            until not PlayerVariables.Character:GetAttribute("Hiding") or not Toggles.TranslucentCloset.Value

            for _, v in pairs(Parts) do
                v.Transparency = 0
            end

            Parts = {}
        end)
    end
end))

Library:GiveSignal(PxPromptService.PromptTriggered:Connect(function(v, playerWhoTriggered)
    if not Toggles.InfUniversalKey.Value or not playerWhoTriggered == PlayerVariables.Player or IsFloor.HardMode then
        return;
    end
    
    local DoorLock = v.Name == "UnlockPrompt" and v.Parent.Name == "Lock" and not v.Parent.Parent:GetAttribute("Opened")
    local Skull = v.Name == "SkullPrompt" and v.Parent.Name == "SkullLock"
    local ChestLock = v.Parent:GetAttribute("Category") and v.Parent:GetAttribute("Category") == "ChestLocked"
    local RoomsLock = v.Parent.Parent.Parent.Name == "RoomsDoor_Entrance" and v.Enabled

    if DoorLock or ChestLock or RoomsLock or Skull then
        if PlayerVariables.Character:FindFirstChildWhichIsA("Tool") then
            local tool = PlayerVariables.Character:FindFirstChildWhichIsA("Tool")

            if (tool and tool:GetAttribute("UniversalKey")) then
                if not ChestLock then
                    task.wait()
                end

                RemotesFolder.DropItem:FireServer(tool)

                workspace.Drops.ChildAdded:Once(function(v)
                    task.wait(.1)
                    fireproximityprompt(v:WaitForChild("ModulePrompt"), true)
                end)
            end
        end
    end
end))

Library:GiveSignal(Players.PlayerRemoving:Connect(function(plr)
    if Toggles.plrleave.Value then
        Library:Notification(plr.DisplayName .. " has left the game.")
    end
end))

Library:GiveSignal(Players.PlayerAdded:Connect(function(plr)
    task.spawn(Functions.SetupPadlockCodeConnection, plr)
end))

Library:GiveSignal(PlayerVariables.Humanoid.Died:Connect(function()
    if PlayerVariables.CollisionClone then
        PlayerVariables.CollisionClone:Destroy()
    end
end))

Library:GiveSignal(PlayerVariables.Player.Backpack.ChildAdded:Connect(function(tool: Tool)
    if tool:IsA("Tool") then
        if Toggles.ViewmodelOffset.Value then
            task.spawn(Functions.NonRequireViewmodelOffset, tool)
        else
            task.spawn(Functions.ClearViewmodelOffset, tool)
        end
    end
end))

Library:GiveSignal(PlayerVariables.Humanoid:GetPropertyChangedSignal("JumpHeight"):Connect(function()
    if PlayerVariables.Humanoid.JumpHeight ~= Options.JumpHeight.Value and Toggles.jump.Value then
        PlayerVariables.Humanoid.JumpHeight = Options.JumpHeight.Value
    end
end))

local MenuGroup = Tabs.Configs:AddLeftGroupbox("Menu")

MenuGroup:AddButton("Unload", function() Library:Unload() end)
MenuGroup:AddToggle("showKeybinds", {
    Text = "Show Keybinds",
    Default = false,
    Callback = function(Value)
        Library.KeybindFrame.Visible = Value
    end
})
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu Keybind" })
MenuGroup:AddToggle("KeepScript", {
    Text = "Execute On Teleport",
    Default = false
})
MenuGroup:AddToggle("CustomCursor", {
    Text = "Show Custom Cursor",
    Default = true,
    Callback = function(Value)
        Library.ShowCustomCursor = Value
    end
})

Library:OnUnload(function()
    getgenv().Loaded = false


    PlayerVariables.CollisionClone:Destroy()

    Options.SpeedBoost:SetValue(0)
    PlayerVariables.Character:SetAttribute("SpeedBoost", 0)
    PlayerVariables.Character:SetAttribute("CanJump", false)
    workspace.CurrentCamera.FieldOfView = 70

    if Supported["require"] then
        require(moduleScripts.MainGame).fovtarget = 70
    end

    ESPLibrary:Clear()

    Library.Unloaded = true

end)

Library.ToggleKeybind = Options.MenuKeybind


ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)


SaveManager:IgnoreThemeSettings()


SaveManager:SetIgnoreIndexes({ "MenuKeybind" })


ThemeManager:SetFolder("Divine Hub")
SaveManager:SetFolder("Divine Hub/DOORS")



SaveManager:BuildConfigSection(Tabs.Configs)


ThemeManager:ApplyToTab(Tabs.Configs)

SaveManager:LoadAutoloadConfig()

PlayerVariables.Player.OnTeleport:Connect(function(teleportState)
    if Toggles.KeepScript.Value and not getgenv().queueing_on_teleport then
        getgenv().queueing_on_teleport = true
        queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/Lazarpriv/utilities/refs/heads/main/uh.luau'))()")
    end
end)
