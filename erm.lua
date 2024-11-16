-- \ Aimbot \ --

-- \ Methods: Smooth or Static \ --

local Aimbot = {}
local Camera = workspace.CurrentCamera

function Aimbot:Set(value: boolean)
    Aimbot.SetValue = value

    if value then

    else

    end
end

function Aimbot:LockOntoPlayer(method: string, player: Player, smoothDelay: number | nil)

    if not Aimbot.LockedPlayer or not Aimbot.LockedPlayer.Character.Humanoid.Health > 0 then
        Aimbot.LockedPlayer = player
    end


    local char = Aimbot.LockedPlayer.Character
    local Head = char:WaitForChild("Head")  

    if method == "Static" then
        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, Head.Position)
    else
        game:GetService("TweenService"):Create(Camera, TweenInfo.new(smoothDelay, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, Head.Position)}):Play()

    end
end

Connections.Aimbot = game:GetService("RunService").RenderStepped:Connect(function()
    if Aimbot.SetValue == true then
        Aimbot:LockOntoPlayer(Options.AimbotMethod.Value, Closest)
    end
end)

return Aimbot
