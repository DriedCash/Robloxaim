local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local aimbotEnabled = false
local fovRadius = 40
local maxTransparency = 0.1

local FOVring = Drawing.new("Circle")
FOVring.Visible = true
FOVring.Thickness = 2
FOVring.Color = Color3.fromRGB(128, 0, 128)
FOVring.Filled = false
FOVring.Radius = fovRadius
FOVring.Position = Camera.ViewportSize / 2

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AimAssistSystem"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenMenuButton"
OpenButton.Size = UDim2.new(0, 70, 0, 30)
OpenButton.Position = UDim2.new(0.1, 0, 0.2, 0)
OpenButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
OpenButton.Text = "MỞ MENU"
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.TextSize = 12
OpenButton.Font = Enum.Font.SourceSansBold
OpenButton.Visible = false
OpenButton.Active = true
OpenButton.Draggable = true
OpenButton.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 6)
OpenCorner.Parent = OpenButton

local MenuFrame = Instance.new("Frame")
MenuFrame.Name = "ControlMenu"
MenuFrame.Size = UDim2.new(0, 240, 0, 180)
MenuFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MenuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MenuFrame.BorderSizePixel = 0
MenuFrame.Active = true
MenuFrame.Draggable = true 
MenuFrame.Parent = ScreenGui

local MenuCorner = Instance.new("UICorner")
MenuCorner.CornerRadius = UDim.new(0, 8)
MenuCorner.Parent = MenuFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 40)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🎯 AIM ASSIST MENU"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MenuFrame

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Parent = MenuFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0.85, 0, 0, 40)
ToggleButton.Position = UDim2.new(0.075, 0, 0.28, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60) 
ToggleButton.Text = "Aimbot: TẮT"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 15
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Parent = MenuFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 6)
BtnCorner.Parent = ToggleButton

local FOVLabel = Instance.new("TextLabel")
FOVLabel.Size = UDim2.new(0.85, 0, 0, 20)
FOVLabel.Position = UDim2.new(0.075, 0, 0.58, 0)
FOVLabel.BackgroundTransparency = 1
FOVLabel.Text = "Kích thước vòng tròn FOV:"
FOVLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
FOVLabel.TextSize = 13
FOVLabel.TextXAlignment = Enum.TextXAlignment.Left
FOVLabel.Font = Enum.Font.SourceSansItalic
FOVLabel.Parent = MenuFrame

local FOVInput = Instance.new("TextBox")
FOVInput.Size = UDim2.new(0.85, 0, 0, 35)
FOVInput.Position = UDim2.new(0.075, 0, 0.72, 0)
FOVInput.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
FOVInput.Text = tostring(fovRadius)
FOVInput.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVInput.TextSize = 14
FOVInput.Font = Enum.Font.SourceSans
FOVInput.Parent = MenuFrame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 6)
InputCorner.Parent = FOVInput

local function setMenuVisible(visible)
	MenuFrame.Visible = visible
	OpenButton.Visible = not visible
end

ToggleButton.MouseButton1Click:Connect(function()
	aimbotEnabled = not aimbotEnabled
	if aimbotEnabled then
		ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60) 
		ToggleButton.Text = "Aimbot: BẬT"
	else
		ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60) 
		ToggleButton.Text = "Aimbot: TẮT"
	end
end)

FOVInput:GetPropertyChangedSignal("Text"):Connect(function()
	local number = tonumber(FOVInput.Text)
	if number then
		fovRadius = number
		FOVring.Radius = fovRadius
	end
end)

CloseButton.MouseButton1Click:Connect(function()
	setMenuVisible(false)
end)

OpenButton.MouseButton1Click:Connect(function()
	setMenuVisible(true)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.KeyCode == Enum.KeyCode.Insert or input.KeyCode == Enum.KeyCode.RightShift then
		setMenuVisible(not MenuFrame.Visible)
	elseif input.KeyCode == Enum.KeyCode.Delete then
		RunService:UnbindFromRenderStep("FOVUpdate")
		FOVring:Remove()
	end
end)

local function lookAt(target)
	local lookVector = (target - Camera.CFrame.Position).unit
	local newCFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + lookVector)
	Camera.CFrame = newCFrame
end

local function calculateTransparency(distance)
	local maxDistance = fovRadius 
	local transparency = (1 - (distance / maxDistance)) * maxTransparency
	return transparency
end

local function isVisibleByRaycast(targetPart, enemyCharacter)
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, enemyCharacter}
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude

	local rayOrigin = Camera.CFrame.Position
	local rayDirection = targetPart.Position - rayOrigin
	local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)

	if not raycastResult then
		return true
	end
	return false
end

local function getClosestPlayerInFOV(trg_part)
	local nearest = nil
	local last = math.huge
	local playerMousePos = Camera.ViewportSize / 2
	
	local myCharacter = LocalPlayer.Character
	local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local part = player.Character and player.Character:FindFirstChild(trg_part)
			if part then
				local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
				if humanoid and humanoid.Health > 0 then
					local ePos, onScreen = Camera:WorldToViewportPoint(part.Position)
					local screenDistance = (Vector2.new(ePos.X, ePos.Y) - playerMousePos).Magnitude

					-- Kiểm tra mục tiêu nằm trong vòng tròn FOV trước
					if screenDistance < fovRadius and onScreen then
						-- Tính khoảng cách 3D thực tế trong không gian game từ mình tới địch
						local distance3D = myRoot and (part.Position - myRoot.Position).Magnitude or (part.Position - Camera.CFrame.Position).Magnitude

						-- Chọn người có khoảng cách 3D gần nhất thay vì gần tâm chuột nhất
						if distance3D < last then
							if isVisibleByRaycast(part, player.Character) then
								last = distance3D
								nearest = player
							end
						end
					end
				end
			end
		end
	end
	return nearest
end

RunService.RenderStepped:Connect(function()
	FOVring.Position = Camera.ViewportSize / 2
	
	local closest = getClosestPlayerInFOV("Head")
	
	if aimbotEnabled and closest and closest.Character:FindFirstChild("Head") then
		lookAt(closest.Character.Head.Position)
	end
	
	if closest and closest.Character:FindFirstChild("Head") then
		local ePos, _ = Camera:WorldToViewportPoint(closest.Character.Head.Position)
		local distance = (Vector2.new(ePos.X, ePos.Y) - (Camera.ViewportSize / 2)).Magnitude
		FOVring.Transparency = calculateTransparency(distance)
	else
		FOVring.Transparency = 0.1
	end
end)
