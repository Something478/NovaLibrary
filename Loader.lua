--[[ 
     NovaLibrary
     Made by Something478 (SuperNova)
     Version: 1.7
]]

local NovaLibrary = {}
NovaLibrary.__index = NovaLibrary

NovaLibrary.Theme = {
    TextColor = Color3.fromRGB(255, 255, 255),
    Background = Color3.fromRGB(20, 20, 30),
    Topbar = Color3.fromRGB(15, 15, 25),
    Shadow = Color3.fromRGB(0, 0, 0),
    TabBackground = Color3.fromRGB(20, 20, 30),
    TabStroke = Color3.fromRGB(50, 50, 180),
    TabBackgroundSelected = Color3.fromRGB(30, 30, 150),
    TabTextColor = Color3.fromRGB(200, 200, 200),
    SelectedTabTextColor = Color3.fromRGB(255, 255, 255),
    ElementBackground = Color3.fromRGB(30, 30, 45),
    ElementBackgroundHover = Color3.fromRGB(40, 40, 60),
    SecondaryElementBackground = Color3.fromRGB(25, 25, 35),
    ElementStroke = Color3.fromRGB(50, 50, 180),
    SecondaryElementStroke = Color3.fromRGB(70, 70, 200),
    SliderBackground = Color3.fromRGB(25, 25, 35),
    SliderProgress = Color3.fromRGB(60, 60, 220),
    SliderStroke = Color3.fromRGB(50, 50, 180),
    ToggleBackground = Color3.fromRGB(30, 30, 150),
    ToggleEnabled = Color3.fromRGB(70, 70, 220),
    ToggleDisabled = Color3.fromRGB(40, 40, 80),
    ToggleEnabledStroke = Color3.fromRGB(50, 50, 180),
    ToggleDisabledStroke = Color3.fromRGB(40, 40, 100),
    InputBackground = Color3.fromRGB(25, 25, 35),
    InputStroke = Color3.fromRGB(50, 50, 180),
    PlaceholderColor = Color3.fromRGB(150, 150, 180),
    ScrollBarColor = Color3.fromRGB(50, 50, 180),
    ScrollBarBackground = Color3.fromRGB(30, 30, 45)
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
    selfInstance.Visible = false
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NovaLibrary"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(0, 650, 0, 380)
    Container.Position = UDim2.new(0.5, -325, 0.5, -190)
    Container.BackgroundTransparency = 1
    Container.Parent = ScreenGui
    
    local Shadow = Instance.new("ImageLabel")
    Shadow.Size = UDim2.new(1, 14, 1, 14)
    Shadow.Position = UDim2.new(0, -7, 0, -7)
    Shadow.Image = "rbxassetid://1316045217"
    Shadow.ImageColor3 = self.Theme.Shadow
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    Shadow.BackgroundTransparency = 1
    Shadow.Parent = Container

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundColor3 = self.Theme.Background
    Frame.Parent = Container
    Frame.ClipsDescendants = true
    
    local UICorner = Instance.new("UICorner", Frame)
    UICorner.CornerRadius = UDim.new(0, 8)

    local Topbar = Instance.new("Frame")
    Topbar.Size = UDim2.new(1, 0, 0, 32)
    Topbar.Position = UDim2.new(0, 0, 0, 0)
    Topbar.BackgroundColor3 = self.Theme.Topbar
    Topbar.Parent = Frame
    local TopCorner = Instance.new("UICorner", Topbar)
    TopCorner.CornerRadius = UDim.new(0, 8)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = self.Theme.TextColor
    Title.Text = config.Name or "NovaLibrary"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Topbar

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(1, -20, 1, -42)
    TabContainer.Position = UDim2.new(0, 10, 0, 42)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 3
    TabContainer.ScrollBarImageColor3 = self.Theme.ScrollBarColor
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabContainer.Parent = Frame

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Padding = UDim.new(0, 5)
    TabListLayout.Parent = TabContainer

    local TabButtons = Instance.new("Frame")
    TabButtons.Size = UDim2.new(1, -20, 0, 28)
    TabButtons.Position = UDim2.new(0, 10, 0, 35)
    TabButtons.BackgroundTransparency = 1
    TabButtons.Parent = Frame

    local TabButtonsList = Instance.new("UIListLayout")
    TabButtonsList.FillDirection = Enum.FillDirection.Horizontal
    TabButtonsList.Padding = UDim.new(0, 5)
    TabButtonsList.Parent = TabButtons

    -- Notification function
    function selfInstance:Notify(title, text, duration)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 5
        })
    end

    function selfInstance:CreateTab(name)
        local tabFrame = Instance.new("Frame")
        tabFrame.Size = UDim2.new(1, 0, 1, 0)
        tabFrame.BackgroundColor3 = self.Theme.TabBackground
        tabFrame.Visible = false
        tabFrame.Parent = TabContainer
        
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(0, 100, 1, 0)
        tabButton.BackgroundColor3 = self.Theme.TabBackground
        tabButton.TextColor3 = self.Theme.TabTextColor
        tabButton.Text = name
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = 12
        tabButton.Parent = TabButtons
        local btnCorner = Instance.new("UICorner", tabButton)
        btnCorner.CornerRadius = UDim.new(0, 4)

        -- Fixed: Use InputBegan instead of MouseButton1Click
        tabButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                for _, t in pairs(selfInstance.Tabs) do
                    t.Frame.Visible = false
                    t.Button.BackgroundColor3 = self.Theme.TabBackground
                    t.Button.TextColor3 = self.Theme.TabTextColor
                end
                tabFrame.Visible = true
                tabButton.BackgroundColor3 = self.Theme.TabBackgroundSelected
                tabButton.TextColor3 = self.Theme.SelectedTabTextColor
                selfInstance.CurrentTab = tabFrame
            end
        end)

        table.insert(selfInstance.Tabs, {Frame = tabFrame, Button = tabButton})
        if #selfInstance.Tabs == 1 then
            tabFrame.Visible = true
            tabButton.BackgroundColor3 = self.Theme.TabBackgroundSelected
            tabButton.TextColor3 = self.Theme.SelectedTabTextColor
            selfInstance.CurrentTab = tabFrame
        end

        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.ScrollBarThickness = 3
        tabContent.ScrollBarImageColor3 = self.Theme.ScrollBarColor
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabContent.Parent = tabFrame

        local tabLayout = Instance.new("UIListLayout")
        tabLayout.Padding = UDim.new(0, 8)
        tabLayout.Parent = tabContent

        function tabFrame:CreateButton(txt, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.BackgroundColor3 = NovaLibrary.Theme.ElementBackground
            btn.TextColor3 = NovaLibrary.Theme.TextColor
            btn.Text = txt
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 12
            btn.Parent = tabContent
            local corner = Instance.new("UICorner", btn)
            corner.CornerRadius = UDim.new(0, 4)
            
            btn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    callback()
                elseif input.UserInputType == Enum.UserInputType.MouseMovement then
                    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = NovaLibrary.Theme.ElementBackgroundHover}):Play()
                end
            end)
            
            btn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = NovaLibrary.Theme.ElementBackground}):Play()
                end
            end)
        end

        function tabFrame:CreateParagraph(title, desc)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 0)
            container.BackgroundTransparency = 1
            container.Parent = tabContent
            container.AutomaticSize = Enum.AutomaticSize.Y
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.TextColor3 = NovaLibrary.Theme.TextColor
            lbl.Text = title.."\n"..desc
            lbl.TextWrapped = true
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextYAlignment = Enum.TextYAlignment.Top
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 12
            lbl.AutomaticSize = Enum.AutomaticSize.Y
            lbl.Parent = container
        end

        function tabFrame:CreateSection(name)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 20)
            lbl.BackgroundTransparency = 1
            lbl.TextColor3 = NovaLibrary.Theme.TextColor
            lbl.Text = name
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 13
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = tabContent
        end

        function tabFrame:CreateDivider()
            local div = Instance.new("Frame")
            div.Size = UDim2.new(1, 0, 0, 1)
            div.BackgroundColor3 = NovaLibrary.Theme.ElementStroke
            div.Parent = tabContent
        end

        function tabFrame:CreateToggle(name, default, callback)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 30)
            container.BackgroundTransparency = 1
            container.Parent = tabContent
            
            local toggle = Instance.new("TextButton")
            toggle.Size = UDim2.new(1, 0, 1, 0)
            toggle.BackgroundColor3 = NovaLibrary.Theme.ToggleBackground
            toggle.TextColor3 = NovaLibrary.Theme.TextColor
            toggle.Text = name.." : "..tostring(default)
            toggle.Font = Enum.Font.Gotham
            toggle.TextSize = 12
            toggle.Parent = container
            local corner = Instance.new("UICorner", toggle)
            corner.CornerRadius = UDim.new(0, 4)
            
            local toggled = default
            
            toggle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    toggled = not toggled
                    toggle.Text = name.." : "..tostring(toggled)
                    callback(toggled)
                end
            end)
        end

        function tabFrame:CreateSlider(name, min, max, step, default, callback)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 50)
            container.BackgroundTransparency = 1
            container.Parent = tabContent
            
            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, 0, 0, 20)
            title.BackgroundTransparency = 1
            title.TextColor3 = NovaLibrary.Theme.TextColor
            title.Text = name
            title.Font = Enum.Font.Gotham
            title.TextSize = 12
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = container
            
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size = UDim2.new(1, 0, 0, 20)
            sliderFrame.Position = UDim2.new(0, 0, 0, 25)
            sliderFrame.BackgroundColor3 = NovaLibrary.Theme.SliderBackground
            sliderFrame.Parent = container
            local corner = Instance.new("UICorner", sliderFrame)
            corner.CornerRadius = UDim.new(0, 4)
            
            local sliderBar = Instance.new("Frame")
            sliderBar.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
            sliderBar.BackgroundColor3 = NovaLibrary.Theme.SliderProgress
            sliderBar.Parent = sliderFrame
            local sliderCorner = Instance.new("UICorner", sliderBar)
            sliderCorner.CornerRadius = UDim.new(0, 4)
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(0, 40, 0, 20)
            valueLabel.Position = UDim2.new(1, -40, 0, 0)
            valueLabel.BackgroundTransparency = 1
            valueLabel.TextColor3 = NovaLibrary.Theme.TextColor
            valueLabel.Text = tostring(default)
            valueLabel.Font = Enum.Font.Gotham
            valueLabel.TextSize = 12
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            valueLabel.Parent = sliderFrame
            
            sliderFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local mouse = game.Players.LocalPlayer:GetMouse()
                    local conn
                    conn = mouse.Move:Connect(function()
                        local relative = math.clamp((mouse.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
                        sliderBar.Size = UDim2.new(relative, 0, 1, 0)
                        local value = math.floor(min + relative * (max-min))
                        valueLabel.Text = tostring(value)
                        callback(value)
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
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 50)
            container.BackgroundTransparency = 1
            container.Parent = tabContent
            
            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, 0, 0, 20)
            title.BackgroundTransparency = 1
            title.TextColor3 = NovaLibrary.Theme.TextColor
            title.Text = name
            title.Font = Enum.Font.Gotham
            title.TextSize = 12
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = container
            
            local inputBox = Instance.new("TextBox")
            inputBox.Size = UDim2.new(1, 0, 0, 25)
            inputBox.Position = UDim2.new(0, 0, 0, 25)
            inputBox.BackgroundColor3 = NovaLibrary.Theme.InputBackground
            inputBox.TextColor3 = NovaLibrary.Theme.TextColor
            inputBox.PlaceholderText = placeholder
            inputBox.PlaceholderColor3 = NovaLibrary.Theme.PlaceholderColor
            inputBox.ClearTextOnFocus = false
            inputBox.Font = Enum.Font.Gotham
            inputBox.TextSize = 12
            inputBox.Parent = container
            local corner = Instance.new("UICorner", inputBox)
            corner.CornerRadius = UDim.new(0, 4)
            
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

    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == selfInstance.ToggleKeybind then
            selfInstance.Visible = not selfInstance.Visible
            Container.Visible = selfInstance.Visible
        end
    end)

    return selfInstance
end

return NovaLibrary