--[[ 
     NovaLibrary
     Made by Something478 (SuperNova)
     Version: 1.5
]]

local NovaLibrary = {}
NovaLibrary.__index = NovaLibrary

NovaLibrary.Theme = {
    TextColor = Color3.fromRGB(255, 255, 255),
    Background = Color3.fromRGB(0, 0, 0),
    Topbar = Color3.fromRGB(0, 0, 0),
    Shadow = Color3.fromRGB(0, 0, 0),
    NotificationBackground = Color3.fromRGB(0, 0, 0),
    NotificationActionsBackground = Color3.fromRGB(0, 0, 125),
    TabBackground = Color3.fromRGB(0, 0, 0),
    TabStroke = Color3.fromRGB(0, 0, 255),
    TabBackgroundSelected = Color3.fromRGB(0, 0, 133),
    TabTextColor = Color3.fromRGB(255, 255, 255),
    SelectedTabTextColor = Color3.fromRGB(255, 255, 255),
    ElementBackground = Color3.fromRGB(15, 15, 15),
    ElementBackgroundHover = Color3.fromRGB(40, 40, 40),
    SecondaryElementBackground = Color3.fromRGB(0, 0, 0),
    ElementStroke = Color3.fromRGB(0, 0, 150),
    SecondaryElementStroke = Color3.fromRGB(0, 0, 255),
    SliderBackground = Color3.fromRGB(0, 0, 0),
    SliderProgress = Color3.fromRGB(0, 0, 255),
    SliderStroke = Color3.fromRGB(0, 0, 255),
    ToggleBackground = Color3.fromRGB(0, 0, 130),
    ToggleEnabled = Color3.fromRGB(0, 0, 255),
    ToggleDisabled = Color3.fromRGB(0, 0, 120),
    ToggleEnabledStroke = Color3.fromRGB(0, 0, 140),
    ToggleDisabledStroke = Color3.fromRGB(0, 0, 120),
    ToggleEnabledOuterStroke = Color3.fromRGB(0, 0, 120),
    ToggleDisabledOuterStroke = Color3.fromRGB(0, 0, 90),
    DropdownSelected = Color3.fromRGB(0, 0, 255),
    DropdownUnselected = Color3.fromRGB(0, 0, 0),
    InputBackground = Color3.fromRGB(0, 0, 0),
    InputStroke = Color3.fromRGB(0, 0, 255),
    PlaceholderColor = Color3.fromRGB(0, 0, 255)
}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

function NovaLibrary:CreateWindow(config)
    local selfInstance = setmetatable({}, NovaLibrary)
    selfInstance.Tabs = {}
    selfInstance.CurrentTab = nil
    selfInstance.Keybind = config.Keybind or Enum.KeyCode.RightControl
    selfInstance.ToggleKeybind = config.ToggleKeybind or Enum.KeyCode.B
    selfInstance.Config = config.ConfigurationSaving or {}
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ResetOnSpawn = false

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 600, 0, 400)
    Frame.Position = UDim2.new(0.5, -300, 0.5, -200)
    Frame.BackgroundColor3 = self.Theme.Background
    Frame.Parent = ScreenGui
    local UICorner = Instance.new("UICorner", Frame)
    UICorner.CornerRadius = UDim.new(0, 10)

    local Topbar = Instance.new("Frame")
    Topbar.Size = UDim2.new(1, 0, 0, 30)
    Topbar.Position = UDim2.new(0, 0, 0, 0)
    Topbar.BackgroundColor3 = self.Theme.Topbar
    Topbar.Parent = Frame
    local TopCorner = Instance.new("UICorner", Topbar)
    TopCorner.CornerRadius = UDim.new(0, 10)

    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(1, 0, 1, -30)
    TabContainer.Position = UDim2.new(0, 0, 0, 30)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = Frame

    function selfInstance:CreateTab(name)
        local tabFrame = Instance.new("Frame")
        tabFrame.Size = UDim2.new(1, -20, 1, -20)
        tabFrame.Position = UDim2.new(0, 10, 0, 10)
        tabFrame.BackgroundColor3 = self.Theme.TabBackground
        tabFrame.Visible = false
        tabFrame.Parent = TabContainer
        local tabUICorner = Instance.new("UICorner", tabFrame)
        tabUICorner.CornerRadius = UDim.new(0, 6)
        
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(0, 120, 0, 25)
        tabButton.Position = UDim2.new(0, (#selfInstance.Tabs * 125), 0, 0)
        tabButton.BackgroundColor3 = self.Theme.TabBackground
        tabButton.TextColor3 = self.Theme.TabTextColor
        tabButton.Text = name
        tabButton.Parent = Topbar
        local btnCorner = Instance.new("UICorner", tabButton)
        btnCorner.CornerRadius = UDim.new(0, 6)

        tabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(selfInstance.Tabs) do
                t.Frame.Visible = false
            end
            tabFrame.Visible = true
            selfInstance.CurrentTab = tabFrame
            tabButton.TextColor3 = self.Theme.SelectedTabTextColor
        end)

        table.insert(selfInstance.Tabs, {Frame = tabFrame, Button = tabButton})
        if #selfInstance.Tabs == 1 then
            tabButton:MouseButton1Click()
        end

        function tabFrame:CreateButton(txt, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -20, 0, 30)
            btn.Position = UDim2.new(0, 10, 0, (#tabFrame:GetChildren()-1) * 35)
            btn.BackgroundColor3 = NovaLibrary.Theme.ElementBackground
            btn.TextColor3 = NovaLibrary.Theme.TextColor
            btn.Text = txt
            btn.Parent = tabFrame
            local corner = Instance.new("UICorner", btn)
            corner.CornerRadius = UDim.new(0, 6)
            btn.MouseButton1Click:Connect(callback)
        end

        function tabFrame:CreateParagraph(title, desc)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -20, 0, 50)
            lbl.Position = UDim2.new(0, 10, 0, (#tabFrame:GetChildren()-1) * 55)
            lbl.BackgroundTransparency = 1
            lbl.TextColor3 = NovaLibrary.Theme.TextColor
            lbl.Text = title.."\n"..desc
            lbl.TextWrapped = true
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextYAlignment = Enum.TextYAlignment.Top
            lbl.Parent = tabFrame
        end

        function tabFrame:CreateSection(name)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -20, 0, 25)
            lbl.Position = UDim2.new(0, 10, 0, (#tabFrame:GetChildren()-1) * 35)
            lbl.BackgroundTransparency = 1
            lbl.TextColor3 = NovaLibrary.Theme.TextColor
            lbl.Text = name
            lbl.Font = Enum.Font.SourceSansBold
            lbl.TextSize = 16
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = tabFrame
        end

        function tabFrame:CreateDivider()
            local div = Instance.new("Frame")
            div.Size = UDim2.new(1, -20, 0, 2)
            div.Position = UDim2.new(0, 10, 0, (#tabFrame:GetChildren()-1) * 20)
            div.BackgroundColor3 = NovaLibrary.Theme.ElementStroke
            div.Parent = tabFrame
        end

        function tabFrame:CreateToggle(name, default, callback)
            local toggle = Instance.new("TextButton")
            toggle.Size = UDim2.new(1, -20, 0, 30)
            toggle.Position = UDim2.new(0, 10, 0, (#tabFrame:GetChildren()-1) * 35)
            toggle.BackgroundColor3 = NovaLibrary.Theme.ToggleBackground
            toggle.TextColor3 = NovaLibrary.Theme.TextColor
            toggle.Text = name.." : "..tostring(default)
            toggle.Parent = tabFrame
            local corner = Instance.new("UICorner", toggle)
            corner.CornerRadius = UDim.new(0, 6)
            local toggled = default
            toggle.MouseButton1Click:Connect(function()
                toggled = not toggled
                toggle.Text = name.." : "..tostring(toggled)
                callback(toggled)
            end)
        end

        function tabFrame:CreateSlider(name, min, max, step, default, callback)
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size = UDim2.new(1, -20, 0, 30)
            sliderFrame.Position = UDim2.new(0, 10, 0, (#tabFrame:GetChildren()-1) * 35)
            sliderFrame.BackgroundColor3 = NovaLibrary.Theme.SliderBackground
            sliderFrame.Parent = tabFrame
            local corner = Instance.new("UICorner", sliderFrame)
            corner.CornerRadius = UDim.new(0, 6)
            local sliderBar = Instance.new("Frame")
            sliderBar.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
            sliderBar.BackgroundColor3 = NovaLibrary.Theme.SliderProgress
            sliderBar.Parent = sliderFrame
            local sliderCorner = Instance.new("UICorner", sliderBar)
            sliderCorner.CornerRadius = UDim.new(0, 6)
            sliderFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local mouse = game.Players.LocalPlayer:GetMouse()
                    local conn
                    conn = mouse.Move:Connect(function()
                        local relative = math.clamp((mouse.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
                        sliderBar.Size = UDim2.new(relative, 0, 1, 0)
                        callback(math.floor(min + relative * (max-min)))
                    end)
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            conn:Disconnect()
                        end
                    end)
                end
            end)
        end

        function tabFrame:CreateInput(name, placeholder, numeric, callback)
            local inputBox = Instance.new("TextBox")
            inputBox.Size = UDim2.new(1, -20, 0, 30)
            inputBox.Position = UDim2.new(0, 10, 0, (#tabFrame:GetChildren()-1) * 35)
            inputBox.BackgroundColor3 = NovaLibrary.Theme.InputBackground
            inputBox.TextColor3 = NovaLibrary.Theme.TextColor
            inputBox.PlaceholderText = placeholder
            inputBox.ClearTextOnFocus = false
            inputBox.Parent = tabFrame
            local corner = Instance.new("UICorner", inputBox)
            corner.CornerRadius = UDim.new(0, 6)
            inputBox.FocusLost:Connect(function()
                local val = inputBox.Text
                if numeric then
                    val = tonumber(val) or 0
                end
                callback(val)
            end)
        end

        return tabFrame
    end

    return selfInstance
end

return NovaLibrary
