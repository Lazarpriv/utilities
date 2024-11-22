
    -- \\ DIVINE HUB V1 (or V2 idk first one was ass) \\ --

-- \ To check if the script was already loaded \ -
if getgenv().Loaded then
    return;
end

getgenv().Loaded = true

-- \ Loading Wait \ --
repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

-- \ Library \ --
local repo = "https://raw.githubusercontent.com/deividcomsono/LinoriaLib/refs/heads/main/"

local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/mstudio45/MSESP/refs/heads/main/source.lua"))()



getgenv().ForceUnload = function()
    getgenv().Loaded = false
end

-- \ Variables \ --
local PlayerVariables = {
    Player = game.Players.LocalPlayer,
    Character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait(),
    HumanoidRootPart = game.Players.LocalPlayer.Character.PrimaryPart,
    Humanoid = game.Players.LocalPlayer.Character.Humanoid,
    Collision = game.Players.LocalPlayer.Character:WaitForChild("Collision"),
    Weld = game.Players.LocalPlayer.Character.Collision:FindFirstChildWhichIsA("ManualWeld"),
    DefaultC0 = game.Players.LocalPlayer.Character.Collision:FindFirstChildWhichIsA("ManualWeld").C0,
    CollisionClone = game.Players.LocalPlayer.Character:FindFirstChild("CollisionFake") or game.Players.LocalPlayer.Character.Collision:Clone(),
    CollisionProperties = game.Players.LocalPlayer.Character.Collision.CustomPhysicalProperties,
    RootProperties = game.Players.LocalPlayer.Character.PrimaryPart.CustomPhysicalProperties
}


PlayerVariables.CollisionClone.Parent = PlayerVariables.Collision.Parent
PlayerVariables.CollisionClone.Name = "CollisionFake"


local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local EntityModules: Folder = ReplicatedStorage.ClientModules.EntityModules
local Glitch: ModuleScript = EntityModules.Glitch
local Void: ModuleScript = EntityModules.Void
local Random: Random =  Random.new()
local charactertable = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'}
local Shade: ModuleScript = EntityModules.Shade
local gameData: Folder = ReplicatedStorage.GameData
local Floor: StringValue = gameData.Floor.Value
local Disposal = {}
local StoredValues = {}
local Parts = {}
local Groupboxes = {}
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
local CurrentRoomModel: Model = workspace.CurrentRooms[CurrentRoom]
local NextRoom = tostring(PlayerVariables.Player:GetAttribute("CurrentRoom") + 1)
local NextRoomModel: Model = workspace.CurrentRooms:FindFirstChild(NextRoom)
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
local RemotesFolder: Folder = ReplicatedStorage:FindFirstChild("RemotesFolder") or ReplicatedStorage:FindFirstChild("EntityInfo");
local PxPromptService = cloneref(game:GetService("ProximityPromptService"))
local Entity: Folder = game.ReplicatedStorage.Entities
local hooks = {}
local Connections = {}
local screechModel: Model = Entity:WaitForChild("Screech")
local timothyModel: Model = Entity:WaitForChild("Spider")
local modules: Folder = game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game.RemoteListener.Modules
local A90: ModuleScript = modules.A90
local Dread: ModuleScript = modules.Dread
local moduleScripts = {
    MainGame = PlayerVariables.Player.PlayerGui.MainUI.Initiator.Main_Game
}
local screechModule: ModuleScript = moduleScripts.MainGame.RemoteListener.Modules.Screech
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
local camera: Camera = workspace.Camera 
local currentcam: Camera = workspace.CurrentCamera
local worldToViewportPoint = camera.worldToViewportPoint
local BodyColors: BodyColors = PlayerVariables.Character["Body Colors"]

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

local ESPFunctions = {}
local executorname = identifyexecutor()
local SupportTable = {
     [executorname] = {Require = false, FirePP = executorname ~= "Solara"}
}

local IsEntity = {
    ["RushMoving"] = {"Entity"},
    ["AmbushMoving"] = {"Entity"},
    ["FigureRagdoll"] = {"SideEntity"},
    ["FigureRig"] = {"SideEntity"},
    ["Eyes"] = {"Entity"},
    ["JeffTheKiller"] = {"Entity"},
    ["GloomPile"] = {"SideEntity"},
    ["GiggleCeiling"] = {"Entity"},
    ["BackdoorLookman"] = {"Entity"},
    ["BackdoorRush"] = {"Entity"},
    ["GrumbleRig"] = {"SideEntity"}
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
-- \ Add current game prompts into the table \ --
for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
    if v:IsA("ProximityPrompt") then
        table.insert(GamePrompts, v)
    end
end
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
function PadlockCode(Paper: Tool, Usage: string, Player: Player)
    assert(Paper:IsA("Tool"), "Library Paper was not a tool.")
    assert(typeof(Usage) == "string", "Usage for PadlockCode() was not a string.")

    if Player == nil then
        Player = PlayerVariables.Player
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

    if Usage == "ToNotify" and Concatenated ~= "" and not ConsecutiveDigits(Concatenated) then
        Library:Notification("The code is " .. Concatenated .. ".")
    elseif Usage == "FireServer" then
        if Count == Needed then
            RemotesFolder.PL:FireServer(Concatenated)
        end
    end

    return Concatenated
end

function ConsecutiveDigits(str: string)
    return string.match(str, "(%d)%1%1+") ~= nil
end

function DistanceFromCharacter(point: Instance)
    return (PlayerVariables.Character:GetPivot().Position - point:GetPivot().Position).Magnitude
end


type ESPArg = {
    Type: string,
    Object: Instance,
    Text: string,
    Color: Color3,
    IsEntity: boolean | nil,
    TextModel: Instance | nil
}

function ESPFunctions.ESP(Properties: ESPArg)

    local Args = {
        Object = Properties.Object,
        Text = Properties.Text,
        TextModel = Properties.TextModel or nil,
        Color = Properties.Color,
        Type = Properties.Type,
        OnDestroy = Properties.OnDestroy or nil,
        IsEntity = Properties.IsEntity or false
    }

    local ESPSave = ESPLibrary.ESP.Highlight({
        Model = Args.Object,
        TextModel = Args.TextModel,
        Name = Args.Text,
        FillColor = Args.Color,
        OutlineColor = Args.Color,
        TextColor = Args.Color,
        TextSize = Options.TextSize.Value or 22,
        
        OnDestroy = Args.OnDestroy or function()
            if Args.IsEntity and Args.Object.PrimaryPart then
                Args.Object.PrimaryPart.Transparency = 1
            end
        end,

        Tracer = {
            Enabled = true,
            From = Options.TracerStart.Value,
            Color = Args.Color
        }
    })

    if Args.IsEntity then
        Args.Object.PrimaryPart.Transparency = 0.99
    end

    table.insert(ESPTable[Properties.Type], ESPSave)

    return ESPSave
end

function ESPFunctions.EntityESP(entity: Model)
    if not entity:IsA("Model") or not Toggles.EntityESP.Value then
        return
    end

    if IsEntity[entity.Name] then
        if IsEntity[entity.Name][1] == "Entity" then
            ESPFunctions.ESP({
                Object = entity,
                Text = ShortName(entity),
                Color = Options.EntityESPColor.Value,
                IsEntity = entity.Name ~= "JeffTheKiller",
                Type = "Entity"
            })
        end
    end
end

function ESPFunctions.SideEntityESP(entity: Model)
    if not entity:IsA("Model") or not Toggles.EntityESP.Value then
        return
    end

    if IsEntity[entity.Name] then
        if IsEntity[entity.Name][1] == "SideEntity" then
            ESPFunctions.ESP({
                Object = entity,
                Text = ShortName(entity),
                TextModel = if entity.Name == "GiggleCeiling" then entity.Root elseif (entity.Name == "FigureRig" or entity.Name == "FigureRagdoll") then entity.Torso else nil,
                Color = Options.EntityESPColor.Value,
                Type = "SideEntity"
            })
        end
    end
end

function ESPFunctions.DoorESP(room: Model)
    if not door:IsA("Model") or not Toggles.DoorESP.Value then
        return
    end

    local Door: Model = room:WaitForChild("Door", 5)

    if Door then
        local RealDoor: BasePart = Door:WaitForChild("Door", 5)

        if RealDoor then
            local Locked = room:GetAttribute("RequiresKey")
            local Opened = Door:GetAttribute("Opened")
            local State = if Locked and not Opened then "[Locked]" elseif Opened then "[Opened]" else ""
            local Stinker = Door:WaitForChild("Sign"):FindFirstChild("SignText") or Door:WaitForChild("Sign"):FindFirstChild("Stinker")
            local RoomNum = Stinker.Text
            local String = string.format("Door %s %s", RoomNum, State)

            local DoorESP = ESPFunctions.ESP({
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
                    DoorESP.SetText(string.format("Door %s %s", RoomNum, "[Opened]"))
                end
            end)
        end
    end
end

function ESPFunctions.ObjectiveESP(objective: Model)
    if not objective:IsA("Model") or not Toggles.ObjectiveESP.Value then
        return
    end

    if not Objectives[objective.Name] then
        return
    end

    if objective.Name == "TimerLever" then
        ESPFunctions.ESP({
            Object = objective,
            Text = string.format("Time Lever [+%s]", objective.TakeTimer.TextLabel.Text),
            Color = Options.ObjectiveESPColor.Value,
            Type = "Objective"
        })
    elseif objective.Name == "WaterPump" then
        local wheel = objective:WaitForChild("Wheel", 5)
        local OnFrame = objective:FindFirstChild("OnFrame", true)

        if wheel and (OnFrame and OnFrame.Visible) then
            local Random = RandomString()

            local ESPInstance = ESPFunctions.ESP({
                Object = wheel,
                Text = "Valve",
                Color = Options.ObjectiveESP.Value,
                Type = "Objective"
            })
        end
    elseif objective.Name == "MinesAnchor" then
        local sign = objective:WaitForChild("Sign", 5)

        if sign and sign:FindFirstChild("TextLabel") then
            ESPFunctions.ESP({
                Object = objective,
                Text = string.format("Anchor %s", sign.TextLabel.Text),
                Color = Options.ObjectiveESPColor.Value,
                Type = "Objective"
            })
        end
    end

    if Objectives[objective.Name] and (objective.Name ~= "TimerLever" and objective.Name ~= "WaterPump" and objective.Name ~= "MinesAnchor") then
        ESPFunctions.ESP({
            Object = objective,
            Text = Objectives[objective.Name].ESPName,
            Color = Options.ObjectiveESPColor.Value,
            Type = "Objective"
        })
    end
end

function ESPFunctions.ItemESP(item: Model, dropped: boolean)
    if not isItem(item) or not Toggles.ItemESP.Value then
        return
    end

    ESPFunctions.ESP({
        Object = item,
        Text = ShortName(item),
        Color = Options.ItemESPColor.Value,
        Type = if dropped then "DroppedItem" else "Item"
    })
end

function ESPFunctions.GoldESP(gold: Model)
    if not gold:IsA("Model") or not Toggles.GoldESP.Value then
        return
    end

    if gold.Name == "GoldPile" then
        ESPFunctions.ESP({
            Object = gold,
            Text = string.format("Gold [%s]", gold:GetAttribute("GoldValue")),
            Color = Options.GoldESPColor.Value,
            Type = "Gold"
        })
    end
end

function ESPFunctions.ChestESP(storage: Model)
    if not storage:IsA("Model") or not Toggles.ChestESP.Value then
        return
    end

    if storage.Name:find("Chest") or storage.Name == "Toolshed_Small" or storage:GetAttribute("Storage") == "ChestBox" then
        local State = if storage:GetAttribute("Locked") then "[Locked]" else ""
        local CleanerName = storage.Name:gsub("_Small", ""):gsub("Box", ""):gsub("Locked", ""):gsub("_Vine", "") .. " %s"
        local String = string.format(CleanerName, State)

        ESPFunctions.ESP({
            Object = storage,
            Text = String,
            Color = Options.ChestESPColor.Value,
            Type = "Chest"
        })
    end
end

function ESPFunctions.HidingSpotESP(spot: Model)
    if not spot:IsA("Model") or not Toggles.HidingSpotsESP.Value then
        return
    end

    if spot.Name == "Rooms_Locker" or spot.Name == "Retro_Wardrobe" or spot:GetAttribute("LoadModule") == "Bed" or spot:GetAttribute("LoadModule") == "Wardrobe" then
        local IsBed = spot.Name == "Bed"
        local String = if IsBed then "Bed" else FloorHidingSpot[Floor]

        ESPFunctions.ESP({
            Object = spot,
            Text = String,
            Color = Options.HidingSpotESPColor.Value,
            Type = "HidingSpot"
        })
    end
end

function ESPFunctions.PlayerESP(player: Player)
    if not player:IsA("Player") or player == PlayerVariables.Player or not Toggles.PlayerESP.Value then
        return
    end

    local char = player.Character or player.CharacterAdded:Wait()

    ESPFunctions.ESP({
        Object = char,
        Text = player.DisplayName,
        Color = Options.PlayerESPColor.Value,
        Type = "Player"
    })
end
function IsMultiplayer()
    return #game.Players:GetPlayers() > 1
end

-- \ Checking support for the main features the script needs \ --

local hasrequire = false

local succ, err = pcall(function()
    require(moduleScripts.MainGame)
end)

local hasrequire = if succ then true else false

SupportTable[executorname].Require = hasrequire

getgenv().fireproximityprompt = if SupportTable[executorname].FirePP then fireproximityprompt else function(ProximityPrompt, Amount, Skip)
    assert(ProximityPrompt, "Argument #1 Missing or nil")
    assert(typeof(ProximityPrompt) == "Instance" and ProximityPrompt:IsA("ProximityPrompt"), "Attempted to fire a Value that is not a ProximityPrompt")

    local HoldDuration = ProximityPrompt.HoldDuration
    local RequiresSight = ProximityPrompt.RequiresLineOfSight
    if Skip then
        ProximityPrompt.HoldDuration = 0
    end

    ProximityPrompt.RequiresLineOfSight = false

    for i = 1, Amount or 1 do
        ProximityPrompt:InputHoldBegin()
        task.wait(ProximityPrompt.HoldDuration + 0.05)
        ProximityPrompt:InputHoldEnd()
    end
    ProximityPrompt.HoldDuration = HoldDuration
    ProximityPrompt.RequiresLineOfSight = RequiresSight
end


function MakeRandomString()
    return charactertable[Random:NextInteger(1, #charactertable)]
end

function RandomString()
    local ret = ""

    for i = 1, 8 do
        local randomletter = MakeRandomString()

        if Random:NextNumber() > 0.5 then
            randomletter = randomletter:upper(randomletter)
        end
        ret = ret .. randomletter
    end
    return ret
end

function isItem(inst)
    if inst:IsA("Model") and (inst:GetAttribute("Pickup") or inst:GetAttribute("PropType")) then 
        return true
    else
        return false
    end
end

getgenv().isnetworkowner = isnetworkowner or function(Part)
   return Part.ReceiveAge == 0
end

function SpeedBypass()
    if IsBypass or not PlayerVariables.CollisionClone then
        return;
    end

    IsBypass = true

    task.spawn(function()
        while Toggles.sbypass.Value and PlayerVariables.CollisionClone and not Library.Unloaded do
            if PlayerVariables.HumanoidRootPart.Anchored then
                PlayerVariables.CollisionClone.Massless = true
                repeat task.wait() until not PlayerVariables.HumanoidRootPart.Anchored
                task.wait(0.15)
            else
                PlayerVariables.CollisionClone.Massless = not PlayerVariables.CollisionClone.Massless
            end
            task.wait(0.24)
        end

        IsBypass = false
        if PlayerVariables.CollisionClone then
            PlayerVariables.CollisionClone.Massless = true
        end
    end)
end

function Library:Notification(string: string)
    Library:Notify(string)

    if Toggles.NotificationSound.Value then
        notificationSound:Play()
    end
end



function SetTouch(obj: Instance, CanTouch: boolean)
    if typeof(obj) ~= "Instance" or obj == nil or typeof(CanTouch) ~= "boolean" or CanTouch == nil then
        return;
    end

    if obj:IsA("BasePart") then
        obj.CanTouch = CanTouch;
        return
    end

    for _, v in pairs(obj:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanTouch = CanTouch;
        end
    end
end

function SetupDeleteSeek(trigger: BasePart)
    if Toggles.NoSeekFE.Value then
        Library:Notification("Attempting to delete Seek...")

        task.delay(1, function()
            PlayerVariables.HumanoidRootPart.Anchored = false
        end)

        task.delay(2, function()
            if trigger:IsDescendantOf(workspace) then
                Library:Notification("Script was unable to delete Seek on the server. Please check the console.")
            end
        end)

        PlayerVariables.HumanoidRootPart.Anchored = true

        task.spawn(function()
            if firetouchinterest then
                    repeat
                        firetouchinterest(trigger, PlayerVariables.HumanoidRootPart, 1)
                        task.wait()
                        firetouchinterest(trigger, PlayerVariables.HumanoidRootPart, 0)
                    until not trigger:IsDescendantOf(workspace) or not Toggles.NoSeekFE.Value

                    if not trigger:IsDescendantOf(workspace) then
                        Library:Notification("Successfully deleted Seek.")
                    end
            else
                repeat
                    task.wait()
                    trigger.Position = PlayerVariables.HumanoidRootPart.Position
                until not trigger:IsDescendantOf(workspace) or not Toggles.NoSeekFE.Value

                if not trigger:IsDescendantOf(workspace) then
                    Library:Notification("Successfully deleted Seek.")
                end
            end
        end)
    end
end


function ShortName(v: Instance)
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

function AvailablePrompt(prompt: ProximityPrompt)
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

    if DistanceFromCharacter(prompt.Parent) > prompt.MaxActivationDistance then
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

function GetRoomName(room)
    local OriginalName = room:GetAttribute("RawName")
    local FirstPattern = "(%l)(%u)"
    local SecondPattern = "(%l)_(%u)"
    local ThirdPattern = "MT"
    local PrettifiedName = OriginalName

    if string.find(PrettifiedName, FirstPattern) then
        PrettifiedName = PrettifiedName:gsub(FirstPattern, "%1 %2")
    end

    if string.find(PrettifiedName, SecondPattern) then
        PrettifiedName = PrettifiedName:gsub("_", " ")
    end

    if string.find(PrettifiedName, ThirdPattern) then
        PrettifiedName = PrettifiedName:gsub(ThirdPattern, "")
    end

    if string.find(PrettifiedName, "%d") then
        PrettifiedName = PrettifiedName:gsub("%d", "")
    end

    return PrettifiedName
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
    TabPadding = 8,
    MenuFadeTime = 0.5,
    ShowCustomCursor = true
})





local Tabs = {
   
    Main = Window:AddTab("Local Player"),
    Cheats = Window:AddTab("Cheats"),
    Fun = Window:AddTab("Fun"),
    Visuals = Window:AddTab("Visual"),
    Configs = Window:AddTab("Configs"),
}


Groupboxes.Automation = Tabs.Main:AddLeftGroupbox("Automation")
Groupboxes.Movement = Tabs.Main:AddLeftGroupbox("Movement")

workspace.CurrentRooms.DescendantAdded:Connect(function(d)
    task.wait(.101)
    if d and (d:IsA("Model") or d:IsA("Folder")) and d.Name == "AnimSaves" then d:Destroy(); end
end)

Groupboxes.Automation:AddToggle("noewait", {
    Text = "Instant Interact",
    Default = false,
    Tooltip = "Skips wait-time for interacting.",
})
Groupboxes.Automation:AddDivider()
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
Groupboxes.Automation:AddDivider()
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
Groupboxes.Movement:AddSlider("SpeedBoost", {
    Text = "Speed Boost",
    Default = 0,
    Min = 0,
    Max = 7,
    Rounding = 0, 
    Compact = true
})
Groupboxes.Movement:AddToggle("sbypass", {
    Text = "Speed Bypass",
    Default = false,
})
Groupboxes.Movement:AddToggle("noslide", {
    Text = "No Sliding",
    Default = false,
})
Groupboxes.Movement:AddToggle("nclip", {
    Text = "Noclip",
    Default = false,
}):AddKeyPicker("noclipKey", {
    Text = "Noclip",
    Default = "N",
    SyncToggleState = true,
    Mode = "Toggle",
    NoUI = false
})

Groupboxes.Movement:AddToggle("Fly", {
    Text = "Fly",
    Default = false
}):AddKeyPicker("FlyKey", {
    Text = "Fly",
    Default = "F",
    SyncToggleState = true,
    Mode = "Toggle",
    NoUI = false
})

Groupboxes.Movement:AddSlider("FlySpeed", {
    Text = "Fly Speed",
    Default = 16,
    Max = 75,
    Min = 16,
    Rounding = 0,
    Compact = true
})

Groupboxes.Movement:AddToggle("jump", {
    Text = "Jump",
    Default = false,
})

Groupboxes.Movement:AddSlider("JumpHeight", {
    Text = "Jump Boost",
    Default = 5,
    Min = 0,
    Max = 50,
    Rounding = 0,
    Compact = true
})

Groupboxes.Miscellaneous = Tabs.Main:AddLeftGroupbox("Miscellaneous")
local reviveButton = Groupboxes.Miscellaneous:AddButton({
    Text = "Revive",
    Func = function()
        RemotesFolder:WaitForChild("Revive"):FireServer()
    end,  
    DoubleClick = false,
    Tooltip = "Uses a revive or pops up the prompt to buy one.",

})
local restartButton = Groupboxes.Miscellaneous:AddButton({
    Text = "Restart",
    Func = function()
        RemotesFolder:WaitForChild("PlayAgain"):FireServer()
    end,
    DoubleClick = false,
    Tooltip = "Goes into a new game.",
})
local lobbyButton = Groupboxes.Miscellaneous:AddButton({
    Text = "Lobby",
    Func = function()
        RemotesFolder:WaitForChild("Lobby"):FireServer()
    end,
    DoubleClick = false,
    Tooltip = "Teleports you to the lobby",
})

Groupboxes.Notifying = Tabs.Main:AddRightGroupbox("Notifying")
Groupboxes.Notifying:AddDropdown("EntityNotifier", {
    AllowNull = true,
    Values = {"Rush", "Ambush", "Eyes", "Jeff The Killer", "A-60", "A-120", "Blitz", "Lookman", "Halt", "Gloombat Swarm"},
    Default = {},
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



Groupboxes.SelfMain = Tabs.Main:AddRightGroupbox("Self")
Groupboxes.SelfMain:AddToggle("lightToggle", {
    Text = "Light",
    Default = false,
})
Groupboxes.SelfMain:AddSlider("lightSlider", {
    Text = "Light Brightness",
    Default = 0,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = true
})
Groupboxes.SelfMain:AddDivider()
Groupboxes.SelfMain:AddToggle("hidingExiting", {
    Text = "Hiding Exiting Fix",
    Default = false,
})






Groupboxes.Removal = Tabs.Cheats:AddLeftGroupbox("Removal")
Groupboxes.Removal:AddToggle("RemoveScreech", {
    Text = "No Screech",
    Default = false,
})
Groupboxes.Removal:AddToggle("DisableCameraShake", {
    Text = "No Camera Shake",
    Default = false,
    Visible = SupportTable[executorname].Require
})
Groupboxes.Removal:AddToggle("NoTimothyJumpscare", {
    Text = "No Timothy Jumpscare",
    Default = false,
    Visible = IsFloor.Mines or IsFloor.Hotel or IsFloor.HardMode
})
Groupboxes.Removal:AddToggle("A90Disabled", {
    Text = "No A90",
    Default = false,
})

Groupboxes.Removal:AddDivider()

Groupboxes.Removal:AddToggle("NoCutscenes", {
    Text = "No Cutscenes",
    Default = false,
})

Groupboxes.Removal:AddDivider()

Groupboxes.Removal:AddToggle("NoSeekFE", {
    Text = "FE No Seek Trigger",
    Default = false,
    Visible = IsFloor.Hotel or IsFloor.HardMode or IsFloor.Mines
})

Groupboxes.Removal:AddDivider();

Groupboxes.Removal:AddToggle("NoGlitchFX", {
    Text = "No Glitch Jumpscare",
    Default = false
})

Groupboxes.Removal:AddToggle("NoVoidJumpscare", {
    Text = "No Void Effect",
    Default = false
})


Groupboxes.Trolling = Tabs.Cheats:AddRightGroupbox("Trolling")
Groupboxes.Trolling:AddToggle("SpamOtherTools", {
    Text = "Spam Others Tools",
    Default = false,
}):AddKeyPicker("SpamOtherToolsKeybind", {
    Default = "V",

    Mode = "Hold",

    Text = "Spam Others Tools",
    NoUI = false
})

Groupboxes.Trolling:AddToggle("StunToggle", {
    Text = "Stun",
    Default = false
}):AddKeyPicker("StunKeybind", {
    Default = "L",
    SyncToggleState = true,

    Mode = "Toggle",

    Text = "Stun",
    NoUI = false,
})
Groupboxes.Trolling:AddDivider()


local breakFigure = Groupboxes.Trolling:AddButton({
    Text = "Break/Delete Figure",
    Func = function()
        if workspace.CurrentRooms:FindFirstChild("50") then        
            for i, v in pairs(workspace.CurrentRooms["50"]:GetChildren()) do
                if v.Name == "FigureSetup" then
                    local fig = v:FindFirstChild("FigureRig") or v:FindFirstChild("FigureRagdoll")

                    if fig then
                        for j, t in pairs(fig:GetDescendants()) do
                            if t:IsA("BasePart") then
                                t.CanTouch = false
                                t.CanCollide = false
                            end

                            if t:IsA("Attachment") then
                                t.WorldCFrame = PlayerVariables.HumanoidRootPart.CFrame
                            end
                        end

                        fig.PrimaryPart.CFrame = CFrame.new(0, 10000, 0)
                    end
                end
            end
        end
    end,
    DoubleClick = false,
})

Groupboxes.Trolling:AddDivider()

Groupboxes.Trolling:AddDropdown("BodyRotationDropdown", {
    Values = { "Normal", "Upside Down", "Left", "Right", "Up"},
    Default = 1,

    Text = "Body Position",
})
Groupboxes.SelfCheats = Tabs.Cheats:AddRightGroupbox("Self")
Groupboxes.SelfCheats:AddToggle("RemoveSnareHitbox", {
    Text = "Anti-Snare",
    Default = false,
    Visible = IsFloor.Mines or IsFloor.Hotel or IsFloor.HardMode
})
Groupboxes.SelfCheats:AddToggle("NoDupeTouch", {
    Text = "Anti-Dupe",
    Default = false,
    Visible = IsFloor.Mines or IsFloor.Hotel or IsFloor.HardMode
})
Groupboxes.SelfCheats:AddToggle("nobanana", {
    Text = "Anti-Bananas",
    Default = false,
    Visible = IsFloor.HardMode
})
Groupboxes.SelfCheats:AddToggle("noeyes", {
    Text = if IsFloor.Backdoor then "Anti-Lookman" else "Anti-Eyes",
    Default = false,
})
Groupboxes.SelfCheats:AddToggle("GiggleHitboxRemoval", {
    Text = "Anti-Giggle",
    Default = false,
    Visible = IsFloor.Mines
})
Groupboxes.SelfCheats:AddToggle("AntiGloomEgg", {
    Text = "Anti Gloom Egg",
    Default = false,
    Visible = IsFloor.Mines
})
Groupboxes.SelfCheats:AddToggle("AntiDread", {
    Text = "Anti-Dread",
    Default = false,
})
Groupboxes.SelfCheats:AddToggle("nohalt", {
    Text = "Anti-Halt",
    Default = false,
})
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
    Text = "Anti Bridge Fall",
    Default = false,
    Visible = IsFloor.Mines
})
Groupboxes.SelfCheats:AddDivider()

Groupboxes.SelfCheats:AddSlider("doorReach", {
    Text = "Door Reach",
    Default = 12,
    Min = 12,
    Max = 28,
    Rounding = 0,
    Compact = true
})

Groupboxes.SelfCheats:AddDivider()

Groupboxes.SelfCheats:AddToggle("PromptClip", {
    Text = "Prompt Clip", 
    Default = false
})

Groupboxes.SelfCheats:AddSlider("PromptReach", {
    Text = "Prompt Reach Multiplier",
    Default = 1,
    Min = 1,
    Max = 2,
    Rounding = 1,
    Compact = true
})

Groupboxes.SelfCheats:AddDivider()

Groupboxes.SelfCheats:AddToggle("InfUniversalKey", {
    Text = "Infinite Items",
    Default = false,
    Visible = not IsFloor.HardMode
})


Groupboxes.FE = Tabs.Fun:AddLeftGroupbox("FE")
Groupboxes.FE:AddToggle("serverSideKillJeff", {
    Text = "FE kill Jeff the Killer",
    Default = false,
    Visible = IsFloor.HardMode
})

Groupboxes.FE:AddDivider()

local breakDoors = Groupboxes.FE:AddButton({
    Text = "Teleport Unanchored",
    Func = function()
        for i, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Attachment") and not v:FindFirstAncestor("RushMoving") and not v:FindFirstAncestor("AmbushMoving") and not v:FindFirstAncestor("Dread") then
                v.WorldCFrame = PlayerVariables.HumanoidRootPart.CFrame
        end
    end

        workspace.CurrentRooms.DescendantAdded:Connect(function(v)
            if v:IsA("Attachment") and not v:FindFirstAncestor("RushMoving") and not v:FindFirstAncestor("AmbushMoving") and not v:FindFirstAncestor("Dread") then
                v.WorldCFrame = PlayerVariables.HumanoidRootPart.CFrame
            end
        end)
    end,
    DoubleClick = false,
})
Groupboxes.FE:AddDivider()

Groupboxes.FE:AddToggle("lagSwitch", {
    Text = "Lag Switch",
    Default = false,
}):AddKeyPicker("keyPicklag", {
    Default = "X",
    SyncToggleState = true,

    Mode = "Toggle",

    Text = "Lag Switch",
    NoUI = false,
})


Groupboxes.FE:AddDivider()

local TenLockpicks =  Groupboxes.FE:AddButton({
    Text = "Get 10 lockpicks",
    Func = function()
                local args = {
                    [1] = {
                        [1] = "Lockpick",
                        [2] = "Lockpick",
                        [3] = "Lockpick",
                        [4] = "Lockpick",
                        [5] = "Lockpick",
                        [6] = "Lockpick",
                        [7] = "Lockpick",
                        [8] = "Lockpick",
                        [9] = "Lockpick",
                        [10] = "Lockpick",
                    }
                }
                RemotesFolder.PreRunShop:FireServer(unpack(args))
            end,
    DoubleClick = false,
    Tooltip = "Need to be in the Item-Shop.",

})

local TenVitamins =  Groupboxes.FE:AddButton({
    Text = "Get 10 vitamins",
    Func = function()
                local args = {
                    [1] = {
                        [1] = "Vitamins",
                        [2] = "Vitamins",
                        [3] = "Vitamins",
                        [4] = "Vitamins",
                        [5] = "Vitamins",
                        [6] = "Vitamins",
                        [7] = "Vitamins",
                        [8] = "Vitamins",
                        [9] = "Vitamins",
                        [10] = "Vitamins",
                    }
                }
                RemotesFolder.PreRunShop:FireServer(unpack(args))
        end,
    DoubleClick = false,
    Tooltip = "Need to be in the Item-Shop.",

})
local TenLighters =  Groupboxes.FE:AddButton({
    Text = "Get 10 lighters",
    Func = function()
                local args = {
                    [1] = {
                        [1] = "Lighter",
                        [2] = "Lighter",
                        [3] = "Lighter",
                        [4] = "Lighter",
                        [5] = "Lighter",
                        [6] = "Lighter",
                        [7] = "Lighter",
                        [8] = "Lighter",
                        [9] = "Lighter",
                        [10] = "Lighter"
                    }
                }
                RemotesFolder.PreRunShop:FireServer(unpack(args))
        end,
    DoubleClick = false,
    Tooltip = "Need to be in the Item-Shop.",

})
local TenFlashlights =  Groupboxes.FE:AddButton({
    Text = "Get 10 flashlights",
    Func = function()
                local args = {
                    [1] = {
                        [1] = "Flashlight",
                        [2] = "Flashlight",
                        [3] = "Flashlight",
                        [4] = "Flashlight",
                        [5] = "Flashlight",
                        [6] = "Flashlight",
                        [7] = "Flashlight",
                        [8] = "Flashlight",
                        [9] = "Flashlight",
                        [10] = "Flashlight",
                    }
                }

                RemotesFolder.PreRunShop:FireServer(unpack(args))
        end,
    DoubleClick = false,
    Tooltip = "Need to be in the Item-Shop.",

})


local TabBox = Tabs.Visuals:AddLeftTabbox()

Groupboxes.ESP = TabBox:AddTab("ESP")

Groupboxes.ESP:AddToggle("EntityESP", {
    Text = "Entity ESP",
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
    Text = "Objective ESP",
    Default = false
}):AddColorPicker("ObjectiveESPColor", {
    Default = Color3.fromRGB(0, 150, 0),
    Title = "Objective ESP Color"
})

Groupboxes.ESP:AddToggle("ItemESP", {
    Text = "Item ESP",
    Default = false,
}):AddColorPicker("ItemESPColor", {
    Default = Color3.fromRGB(1, 50, 32),
    Title = "Item ESP Color",
})

Groupboxes.ESP:AddToggle("GoldESP", {
    Text = "Gold ESP",
    Default = false
}):AddColorPicker("GoldESPColor", {
    Default = Color3.fromRGB(229, 184, 11),
    Title = "Gold ESP Color",
})

Groupboxes.ESP:AddToggle("ChestESP", {
    Text = "Chest ESP",
    Default = false
}):AddColorPicker("ChestESPColor", {
    Default = Color3.fromRGB(120, 42, 42),
    Title = "Chest ESP Color",
})

Groupboxes.ESP:AddToggle("HidingSpotsESP", {
    Text = "Hiding Spots ESP",
    Default = false
}):AddColorPicker("HidingSpotESPColor", {
    Default = Color3.fromRGB(165, 42, 42),
    Title = "Hiding Spot ESP Color",
})

Groupboxes.Settings = TabBox:AddTab("ESP Settings")

Groupboxes.Settings:AddToggle("DistanceESP", {
    Text = "Distance",
    Default = false
})

Groupboxes.Settings:AddToggle("RainbowESP", {
    Text = "Rainbow ESP",
    Default = false
})

Groupboxes.Settings:AddToggle("Tracers", {
    Text = "Tracers",
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

Groupboxes.PlayerESP = Tabs.Visuals:AddRightGroupbox("Player ESP")

Groupboxes.PlayerESP:AddToggle("PlayerESP", {
    Text = "Enable",
    Default = false,
}):AddColorPicker("PlayerESPColor", {
    Default = Color3.fromRGB(178, 235, 242),
    Title = "Player ESP Color",
})

Groupboxes.View = Tabs.Visuals:AddRightGroupbox("View")



Groupboxes.View:AddToggle("ambienceToggle", {
    Text = "Ambient",
    Default = false,
}):AddColorPicker("ambiencecol", {
    Default = Color3.fromRGB(255, 255, 255),
    Transparency = 0,
})

Groupboxes.View:AddToggle("NoFog", {
    Text = "No Fog",
    Default = false
})
Groupboxes.View:AddSlider("fovSlider", {
    Text = "Field of View",
    Default = 70,
    Min = 0,
    Max = 120,
    Rounding = 0,
    Compact = true,
})

Groupboxes.View:AddDivider()

Groupboxes.View:AddToggle("TranslucentCloset", {
   Text = "Translucent Closet",
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
-- \ Logical Code \ --




Toggles.sbypass:OnChanged(function(value)
    if value then
        SpeedBypass();
        Options.SpeedBoost:SetMax(75)

        task.spawn(function()
            repeat task.wait() until not Toggles.sbypass.Value

            PlayerVariables.CollisionClone.Massless = false


            Options.SpeedBoost:SetMax(7)
        end)
    end
end)

Toggles.noslide:OnChanged(function(value)
    if value then
        PlayerVariables.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(100, 0, 0, 0, 0)
    else
        PlayerVariables.HumanoidRootPart.CustomPhysicalProperties = PlayerVariables.RootProperties
    end
end)

Options.JumpHeight:OnChanged(function(value)
    if not Toggles.jump.Value or IsFloor.HardMode then
        return;
    end
    PlayerVariables.Humanoid.JumpHeight = value
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
        local code = PadlockCode(paper, "FireServer")
    end
end)

Toggles.plcode:OnChanged(function(value)
    if value then
        if PlayerVariables.Character:FindFirstChild("LibraryHintPaper") or PlayerVariables.Character:FindFirstChild("LibraryHintPaperHard") then
            local paper = PlayerVariables.Character:FindFirstChild("LibraryHintPaper") or PlayerVariables.Character:FindFirstChild("LibraryHintPaperHard")
            local code = PadlockCode(paper, "ToNotify")
        end
    end
end)

Toggles.plrleave:OnChanged(function(value)
    if value then
        Connections.PlayerLeaving = game.Players.PlayerRemoving:Connect(function(player)
            Library:Notification(player.DisplayName .. " has left the game.")
        end)

        task.spawn(function()
            repeat
                task.wait()
            until not Toggles.plrleave.Value
            Connections.PlayerLeaving:Disconnect();
        end)
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
    if workspace.CurrentRooms:FindFirstChild(tostring(gameData.LatestRoom.Value + 1)) then
        local trigcollision = workspace.CurrentRooms[tostring(gameData.LatestRoom.Value + 1)]:FindFirstChild("TriggerEventCollision")
        local collision = if trigcollision then trigcollision:FindFirstChild("Collision") else nil

        if trigcollision and collision then
            SetupDeleteSeek(collision)
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

Options.BodyRotationDropdown:OnChanged(function(mode)
    local OldPos = PlayerVariables.Collision:GetPivot()

    if mode ~= "Normal" then
        PlayerVariables.Collision.CanCollide = false
        PlayerVariables.Collision.CustomPhysicalProperties = nil
    elseif mode == "Normal" then
        PlayerVariables.Collision.CanCollide = true
        PlayerVariables.Collision.CustomPhysicalProperties = PlayerVariables.CollisionProperties
    end

    if mode == "Normal" then
        PlayerVariables.Weld.C0 = PlayerVariables.DefaultC0
    elseif mode == "Upside Down" then
        PlayerVariables.Weld.C0 = CFrame.new(0, -0.335, 0.3) * CFrame.Angles(math.rad(180), math.rad(180), 0)
    elseif mode == "Up" then
        PlayerVariables.Weld.C0 = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(-90), 0, 0)
    elseif mode == "Left" then
        PlayerVariables.Weld.C0 = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(-90))
    elseif mode == "Right" then
        PlayerVariables.Weld.C0 = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(90))
    end
    task.wait()
    PlayerVariables.Collision:PivotTo(OldPos)
end)

Toggles.RemoveSnareHitbox:OnChanged(function(value)
    for _, v in pairs(CurrentRoomModel.Assets:GetChildren()) do
        if v.Name == "Snare" then
            SetTouch(v, not value)
        end
    end
end)

Toggles.NoDupeTouch:OnChanged(function(value)
    for _, v in pairs(CurrentRoomModel:GetChildren()) do
        if v.Name == "SideroomDupe" then
            local DoorFake = v:WaitForChild("DoorFake", 5)

            if DoorFake then
                for _, l in pairs(DoorFake:GetDescendants()) do
                    if l:IsA("BasePart") then
                        l.CanTouch = not value
                    end
                end
            end

            for _, l in pairs(DoorFake:GetDescendants()) do
                if l:IsA("ProximityPrompt") then
                    l.Enabled = not value
                end
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
                SetTouch(obstr, not value)
            end
        end
    end
end)

Toggles.BridgeWalk:OnChanged(function(value)
    if value then
        for _, v in pairs(CurrentRoomModel.Parts:GetChildren()) do
            if v.Name == "Bridge" then
                for _, x: BasePart in pairs(v:GetChildren()) do
                    if (x.Name == "PlayerBarrier" and x.Size == Vector3.new(15.125, 2.75, 5.375)) then
                        local clone = x:Clone()
                        clone.Name = "NoFall"
                        clone.Size = Vector3.new(15.125, 2.75, 40)
                        clone.Color = Color3.new(255, 255, 255)
                        clone.Transparency = 0
                    end
                end
            end
        end
    else
        for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
            if v.Name == "Bridge" then
                for _, x: BasePart in pairs(v:GetChildren()) do
                    if x.Name == "NoFall" then
                        x:Destroy()
                    end
                end
            end
        end
    end
end)


Options.PromptReach:OnChanged(function(value)
    for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            if v.GamepadKeyCode ~= Enum.KeyCode.E then return; end
            if not v:GetAttribute("OGDistance") then v:SetAttribute("OGDistance", v.MaxActivationDistance) end
            v.MaxActivationDistance = v:GetAttribute("OGDistance") * value
        end
    end
end)

Toggles.PromptClip:OnChanged(function(value)
    for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            if v.GamepadKeyCode ~= Enum.KeyCode.E then return; end
            if not v:GetAttribute("RequiresSight") then v:SetAttribute("RequiresSight", v.RequiresLineOfSight) end
            v.RequiresLineOfSight = not value
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
                    until isnetworkowner(v) or not v or not v:IsDescendantOf(workspace) or not Toggles.serverSideKillJeff.Value

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
            task.spawn(ESPFunctions.EntityESP, v)
        end

        for _, v in pairs(CurrentRoomModel:GetChildren()) do
            task.spawn(ESPFunctions.SideEntityESP, v)
        end
    else
        for _, v in pairs(ESPTable.Entity) do
            v.Destroy()
        end

        for _, v in pairs(ESPTable.SideEntity) do
            v.Destroy()
        end
    end
end)

Toggles.DoorESP:OnChanged(function(value)
    if value then
        task.spawn(ESPFunctions.DoorESP, CurrentRoomModel)

        task.spawn(ESPFunctions.DoorESP, NextRoomModel)
    else
        for _, v in pairs(ESPTable.Door) do
            v.Destroy()
        end
    end
end)

Toggles.ObjectiveESP:OnChanged(function(value)
    if value then
        for _, v in pairs(CurrentRoomModel:GetDescendants()) do
            task.spawn(ESPFunctions.ObjectiveESP, v)
        end
    else
        for _, esp in pairs(ESPTable.Objective) do
            esp.Destroy()
        end
    end
end)

Toggles.ItemESP:OnChanged(function(value)
    if value then
        for _, v in pairs(CurrentRoomModel:GetDescendants()) do
            task.spawn(ESPFunctions.ItemESP, v)
        end

        for _, v in pairs(workspace.Drops:GetChildren()) do
            task.spawn(ESPFunctions.ItemESP, v, true)
        end
    else
        for _, v in pairs(ESPTable.Item) do
            v.Destroy()
        end

        for _, v in pairs(ESPTable.DroppedItem) do
            v.Destroy()
        end
    end
end)

Toggles.GoldESP:OnChanged(function(value)
    if value then
        for _, v in pairs(CurrentRoomModel.Assets:GetDescendants()) do
            task.spawn(ESPFunctions.GoldESP, v)
        end
    else
        for _, v in pairs(ESPTable.Gold) do
            v.Destroy()
        end
    end
end)

Toggles.ChestESP:OnChanged(function(value)
    if value then
        for _, v in pairs(CurrentRoomModel:GetDescendants()) do
            task.spawn(ESPFunctions.ChestESP, v)
        end
    else
        for _, v in pairs(ESPTable.Chest) do
            v.Destroy()
        end
    end
end)

Toggles.HidingSpotsESP:OnChanged(function(value)
    if value then
        for _, v in pairs(CurrentRoomModel.Assets:GetChildren()) do
            task.spawn(ESPFunctions.HidingSpotESP, v)
        end
    else
        for _, v in pairs(ESPTable.HidingSpot) do
            v.Destroy()
        end
    end
end)

Toggles.PlayerESP:OnChanged(function(value)
    if value then
        for _, player in pairs(game.Players:GetPlayers()) do
            task.spawn(ESPFunctions.PlayerESP, player)
        end
    else
        for _, v in pairs(ESPTable.Player) do
            v.Destroy()
        end
    end
end)

Options.EntityESPColor:OnChanged(function(value)
    for _, v in pairs(ESPTable.Entity) do
        v.Update({
            FillColor = value,
            OutlineColor = value,
            TextColor = value,

            Tracer = {
                Color = value
            }
        })
    end
end)

Options.DoorESPColor:OnChanged(function(value)
    for _, v in pairs(ESPTable.Door) do
        v.Update({
            FillColor = value,
            OutlineColor = value,
            TextColor = value,
        })
    end
end)

Options.ObjectiveESPColor:OnChanged(function(value)
    for _, v in pairs(ESPTable.Objective) do
        v.Update({
            FillColor = value,
            OutlineColor = value,
            TextColor = value,
        })
    end
end)

Options.ItemESPColor:OnChanged(function(value)
    for _, v in pairs(ESPTable.Item) do
        v.Update({
            FillColor = value,
            OutlineColor = value,
            TextColor = value,
        })
    end
end)

Options.GoldESPColor:OnChanged(function(value)
    for _, v in pairs(ESPTable.Gold) do
        v.Update({
            FillColor = value,
            OutlineColor = value,
            TextColor = value,
        })
    end
end)

Options.ChestESPColor:OnChanged(function(value)
    for _, v in pairs(ESPTable.Chest) do
        v.Update({
            FillColor = value,
            OutlineColor = value,
            TextColor = value,
        })
    end
end)

Options.PlayerESPColor:OnChanged(function(value)
    for _, v in pairs(ESPTable.Player) do
        v.Update({
            FillColor = value,
            OutlineColor = value,
            TextColor = value,
        })
    end
end)

Options.HidingSpotESPColor:OnChanged(function(value)
    for _, v in pairs(ESPTable.HidingSpot) do
        v.Update({
            FillColor = value,
            OutlineColor = value,
            TextColor = value,
        })
    end
end)

Toggles.RainbowESP:OnChanged(function(value)
    ESPLibrary.Rainbow.Set(value)
end)

Toggles.DistanceESP:OnChanged(function(value)
    ESPLibrary.Distance.Set(value)
end)

Toggles.Tracers:OnChanged(function(value)
    ESPLibrary.Tracers.Set(value)
end)

Options.TracerStart:OnChanged(function(value)
    for _, v in pairs(ESPTable) do
        for _, type in pairs(v) do
            type.Update({
                Tracer = {
                    From = value
                }
            })
        end
    end
end)

Options.TextSize:OnChanged(function(value)
    for _, v in pairs(ESPTable) do
        for _,  type in pairs(v) do
            type.Update({
                TextSize = value
            })
        end   
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

Connections[tonumber(CurrentRoom)] = CurrentRoomModel.DescendantAdded:Connect(function(v)

    task.spawn(ESPFunctions.ItemESP, v)

    task.spawn(ESPFunctions.GoldESP, v)

    task.spawn(ESPFunctions.ObjectiveESP, v)

    if v:IsA("ProximityPrompt") then
        if not v:GetAttribute("RequiresSight") then v:SetAttribute("RequiresSight", v.RequiresLineOfSight) end
        v.RequiresLineOfSight = not Toggles.PromptClip.Value
        if not v:GetAttribute("OGDistance") then v:SetAttribute("OGDistance", v.MaxActivationDistance) end
        v.MaxActivationDistance = v:GetAttribute("OGDistance") * Options.PromptReach.Value
        table.insert(GamePrompts, v)
    end
end)


-- \ Main connections \ --
Connections.MainRenderStepped = RunService.RenderStepped:Connect(function()

    if not getgenv().Loaded then
        Library:Unload()
    end

    if Toggles.ambienceToggle.Value then
        game.Lighting.Ambient = Options.ambiencecol.Value
    else
        game.Lighting.Ambient = CurrentRoomModel:GetAttribute("Ambient")
    end

    if Toggles.NoFog.Value then
        game.Lighting.FogStart = 9e9
        game.Lighting.FogEnd = 9e9
    else
        game.Lighting.FogStart = 150
        game.Lighting.FogEnd = 350
    end

    StoredValues.Distance = (CurrentRoomModel:FindFirstChild("Door"):FindFirstChild("Door"):GetPivot().Position - PlayerVariables.Character:GetPivot().Position).Magnitude

    if StoredValues.Distance <= Options.doorReach.Value then
        CurrentRoomModel:WaitForChild("Door"):WaitForChild("ClientOpen"):FireServer()
    end



    if Toggles.SpamOtherTools.Value and Options.SpamOtherToolsKeybind:GetState() then
        for _, player in pairs(game.Players:GetPlayers()) do
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

    if SupportTable[executorname].Require then
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
            v.CanCollide = not Toggles.nclip.Value
        end
    end

    if Toggles.lagSwitch.Value and Options.keyPicklag:GetState() then
        settings():GetService("NetworkSettings").IncomingReplicationLag = math.huge
    else
        settings():GetService("NetworkSettings").IncomingReplicationLag = 0
    end

    if PlayerVariables.CollisionClone and PlayerVariables.Collision then
        PlayerVariables.CollisionClone.CollisionGroup = PlayerVariables.Collision.CollisionGroup;
        PlayerVariables.CollisionClone.Position = PlayerVariables.Collision.Position
    end

    if Library.Unloaded then
        Connections.MainRenderStepped:Disconnect()
    end

    if Toggles.AutoInteract.Value and Options.AutoInteractKey:GetState() then
        for _, v in pairs(GamePrompts) do
            if AvailablePrompt(v) then
                fireproximityprompt(v, 1, true)
            end
        end
    end

end)


Connections.EntityHandler = workspace.ChildAdded:Connect(function(child: Model)
    if not child:IsA("Model") then
        return;
    end

    task.spawn(ESPFunctions.EntityESP, child)

    if NotifyTable[ShortName(child)] and child:GetPivot().Position.Y > -10000 and Options.EntityNotifier.Value[ShortName(child)] then
        Library:Notification(NotifyTable[ShortName(child)].Notification)
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
end)


Connections.PromptBegan = PxPromptService.PromptButtonHoldBegan:Connect(function(prompt, playerWhoTriggered)
    if Toggles.noewait.Value then
        if playerWhoTriggered == PlayerVariables.Player then
            fireproximityprompt(prompt, 1, true)
        end
    end
end)

for _, plr in pairs(game.Players:GetPlayers()) do
    Connections[string.format("Items: %s", plr.DisplayName)] = plr.Character.ChildAdded:Connect(function(tool: Tool)
        if tool.Name:find("LibraryHintPaper") then

            if Toggles.plcode.Value then
                PadlockCode(tool, "ToNotify", plr)
            end

            if Toggles.autopl.Value then
                PadlockCode(tool, "FireServer", plr)
            end
        end

        if tool.Parent == PlayerVariables.Character then
            if Toggles.ViewmodelOffset.Value then
                if tool:IsA("Tool") then
                    if not tool:GetAttribute("OGOffset") then
                        tool:SetAttribute("OGOffset", tool:GetAttribute("ToolOffset"))
                    end
        
                    tool:SetAttribute("ToolOffset", Vector3.new(Options.XOffset.Value, Options.YOffset.Value, Options.ZOffset.Value))
                end
            end
        end
    end)

    Connections[string.format("BackpackItems: %s", plr.DisplayName)] = plr.Backpack.ChildAdded:Connect(function(tool: Tool)
        if tool.Name:find("LibraryHintPaper") then
            
            if Toggles.plcode.Value then
                PadlockCode(tool, "ToNotify", plr)
            end

            if Toggles.autopl.Value then
                PadlockCode(tool, "FireServer", plr)
            end
        end

        if tool.Parent == PlayerVariables.Player.Backpack then
            if Toggles.ViewmodelOffset.Value then
                if tool:IsA("Tool") then
                    if not tool:GetAttribute("OGOffset") then
                        tool:SetAttribute("OGOffset", tool:GetAttribute("ToolOffset"))
                    end
        
                    tool:SetAttribute("ToolOffset", Vector3.new(Options.XOffset.Value, Options.YOffset.Value, Options.ZOffset.Value))
                end
            end
        end
    end)
end

Connections.MoveDirection = PlayerVariables.Humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(function()
    if PlayerVariables.Character:GetAttribute("Hiding") and PlayerVariables.Humanoid.MoveDirection.Magnitude > 0 then
        RemotesFolder.CamLock:FireServer()
    end
end)

Connections.RoomHandler = workspace.CurrentRooms.ChildAdded:Connect(function(child: Model)
    if child:GetAttribute("RawName"):find("Halt") then
        Library:Notification("Halt will be in the next room.")
    end
    if child:GetAttribute("RawName"):find("SeekIntro") or child:GetAttribute("RawName"):find("SeekStart") then
        task.spawn(function()
            repeat
                task.wait()
            until child:FindFirstChild("TriggerEventCollision")

            local collision = child:FindFirstChild("TriggerEventCollision"):FindFirstChild("Collision")

            if collision and collision:IsA("BasePart") then
                SetupDeleteSeek(collision)
            end
        end)
    end
end)

Connections.Dropped = workspace.Drops.ChildAdded:Connect(function(child: Instance)
    task.spawn(ESPFunctions.ItemESP, child, true)
end)

Connections.RoomChanged = PlayerVariables.Player:GetAttributeChangedSignal("CurrentRoom"):Connect(function()
    
        CurrentRoom = if workspace.CurrentRooms:FindFirstChild(tostring(PlayerVariables.Player:GetAttribute("CurrentRoom"))) then tostring(PlayerVariables.Player:GetAttribute("CurrentRoom")) else tostring(gameData.LatestRoom.Value)
        NextRoom = tostring(PlayerVariables.Player:GetAttribute("CurrentRoom") + 1)
        CurrentRoomModel = workspace.CurrentRooms:FindFirstChild(CurrentRoom)
        NextRoomModel = workspace.CurrentRooms:FindFirstChild(NextRoom)

        

        if PlayerVariables.Player:GetAttribute("CurrentRoom") ~= 100 then repeat task.wait() until workspace.CurrentRooms:FindFirstChild(NextRoom) end

        if Toggles.DoorESP.Value then
            for _, v in pairs(ESPTable.Door) do
                v.Destroy()
            end

            task.spawn(ESPFunctions.DoorESP, CurrentRoomModel)

            task.spawn(ESPFunctions.DoorESP, NextRoomModel)
        end

        for i, v in pairs(Connections) do
            if type(i) == "number" then
                if i ~= tonumber(CurrentRoom) then
                    v:Disconnect()
                end
            end
        end
    
        if Connections[tonumber(CurrentRoom)] then
            Connections[tonumber(CurrentRoom)]:Disconnect()
        end

        
        if Toggles.ObjectiveESP.Value then
            for _, v in pairs(ESPTable.Objective) do
                v.Destroy()
            end
        end

        if Toggles.ItemESP.Value then
            for _, v in pairs(ESPTable.Item) do
                v.Destroy()
            end
        end

        if Toggles.HidingSpotsESP.Value then
            for _, v in pairs(ESPTable.HidingSpot) do
                v.Destroy()
            end
        end

        if Toggles.GoldESP.Value then
            for _, v in pairs(ESPTable.Gold) do
                v.Destroy()
            end
        end

        if Toggles.EntityESP.Value then
            for _, v in pairs(ESPTable.SideEntity) do
                v.Destroy()
            end
        end

        if Toggles.ChestESP.Value then
            for _, v in pairs(ESPTable.Chest) do
                v.Destroy()
            end
        end

        for _, v: Instance in pairs(CurrentRoomModel:GetDescendants()) do
            -- iterating through parts during floor 2 seek chases gets laggy
            if IsFloor.Mines and CurrentRoomModel:GetAttribute("Chase") then
                if v.Name == "Parts" or v:FindFirstAncestor("Parts") then
                    continue
                end
            end

            task.spawn(ESPFunctions.ItemESP, v)

            task.spawn(ESPFunctions.ChestESP, v)

            task.spawn(ESPFunctions.SideEntityESP, v)

            task.spawn(ESPFunctions.GoldESP, v)

            task.spawn(ESPFunctions.HidingSpotESP, v)

            task.spawn(ESPFunctions.ObjectiveESP, v)
        end
    

        if Toggles.BridgeWalk.Value then
            for _, v in pairs(CurrentRoomModel.Parts:GetChildren()) do
                if v.Name == "Bridge" then
                    for _, x: BasePart in pairs(v:GetChildren()) do
                        if (x.Name == "PlayerBarrier" and  x.Size == Vector3.new(15.125, 2.75, 5.375))then
                            local clone = x:Clone()
                            clone.Name = "NoFall"
                            clone.Size = Vector3.new(15.125, 2.75, 40)
                            clone.Color = Color3.new(255, 255, 255)
                            clone.Transparency = 0
                        end
                    end
                end
            end
        end

    Connections[tonumber(CurrentRoom)] = CurrentRoomModel.DescendantAdded:Connect(function(v)

        
        task.spawn(ESPFunctions.ItemESP, v)

        task.spawn(ESPFunctions.GoldESP, v)

        task.spawn(ESPFunctions.ObjectiveESP, v)

    
        if v:IsA("ProximityPrompt") then
            if not v:GetAttribute("RequiresSight") then v:SetAttribute("RequiresSight", v.RequiresLineOfSight) end
            v.RequiresLineOfSight = not Toggles.PromptClip.Value
            if not v:GetAttribute("OGDistance") then v:SetAttribute("OGDistance", v.MaxActivationDistance) end
            v.MaxActivationDistance = v:GetAttribute("OGDistance") * Options.PromptReach.Value
            table.insert(GamePrompts, v)
        end
    end)
end)

Connections.Hidden = PlayerVariables.Character:GetAttributeChangedSignal("Hiding"):Connect(function(value)
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
end)

Connections.PromptTriggered = PxPromptService.PromptTriggered:Connect(function(v, playerWhoTriggered)
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
                    fireproximityprompt(v:WaitForChild("ModulePrompt"), false, false)
                end)
            end
        end
    end
end)
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

    for _, toggle in pairs(Toggles) do
        toggle:SetValue(false)
    end

    for _, conn in pairs(Connections) do
        conn:Disconnect()
    end

    Options.SpeedBoost:SetValue(0)

    Library.Unloaded = true

    PlayerVariables.CollisionClone:Destroy()
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

PlayerVariables.Player.OnTeleport:Connect(function()
    if Toggles.KeepScript.Value and not getgenv().teleporting then
        getgenv().teleporting = true
        queue_on_teleport([[ loadstring(game:HttpGet("https://raw.githubusercontent.com/Lazarpriv/utilities/refs/heads/main/uh.lua"))() ]])
    end
end)
