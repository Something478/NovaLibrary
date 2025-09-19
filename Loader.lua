--[[
   NovaLibrary
   Made by SuperNova
   Version: 1.3
]]--

local NovaLibrary = {}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

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
    PlaceholderColor = Color3.fromRGB(0, 0, 255),
    
    Base = Color3.fromRGB(15, 15, 30),
    Accent = Color3.fromRGB(0, 170, 255),
    Hover = Color3.fromRGB(35, 35, 55),
    Dark = Color3.fromRGB(10, 10, 20),
    Light = Color3.fromRGB(25, 25, 45)
}

local function Tween(obj, props, time, easingStyle, easingDirection)
    local tween = TweenService:Create(obj, TweenInfo.new(time or 0.2, easingStyle or Enum.EasingStyle.Quad, easingDirection or Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

local function CreateShadow(frame, size)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Image = "rbxassetid://5554236805"
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    shadow.ImageTransparency = 0.5
    shadow.Size = UDim2.new(1, size or 14, 1, size or 14)
    shadow.Position = UDim2.new(0, -(size or 14)/2, 0, -(size or 14)/2)
    shadow.BackgroundTransparency = 1
    shadow.ZIndex = frame.ZIndex - 1
    shadow.Parent = frame
    return shadow
end

local function RippleEffect(button)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.8
    ripple.ZIndex = button.ZIndex + 1
    ripple.Parent = button
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    local mouse = button:FindFirstChildWhichIsA("GuiObject")
    if mouse then
        ripple.Position = UDim2.new(0, mouse.AbsolutePosition.X - button.AbsolutePosition.X, 0, mouse.AbsolutePosition.Y - button.AbsolutePosition.Y)
    end
    
    Tween(ripple, {Size = UDim2.new(2, 0, 2, 0), BackgroundTransparency = 1}, 0.5)
    
    spawn(function()
        wait(0.5)
        ripple:Destroy()
    end)
end

function NovaLibrary:CreateWindow(options)
    local Window = {}
    Window.Name = options.Name or "NovaLibrary"
    Window.Keybind = options.Keybind or Enum.KeyCode.RightControl
    Window.Tabs = {}
    Window.Theme = options.Theme or NovaLibrary.Theme
    Window.ToggleKeybind = options.ToggleKeybind or Enum.KeyCode.B
    Window.ConfigurationSaving = options.ConfigurationSaving or {Enabled = false}
    
    if Window.ConfigurationSaving.Enabled then
        local success, data = pcall(function()
            return game:GetService("HttpService"):JSONDecode(readfile(Window.ConfigurationSaving.FolderName .. "/" .. Window.ConfigurationSaving.FileName .. ".json"))
        end)
        Window.Config = success and data or {}
    else
        Window.Config = {}
    end
    
    function Window:SaveConfig()
        if not Window.ConfigurationSaving.Enabled then return end
        local json
        pcall(function()
            json = game:GetService("HttpService"):JSONEncode(Window.Config)
        end)
        if json then
            writefile(Window.ConfigurationSaving.FolderName .. "/" .. Window.ConfigurationSaving.FileName .. ".json", json)
        end
    end

    -- Theme modification function
    function Window:ModifyTheme(newTheme)
        for property, value in pairs(newTheme) do
            Window.Theme[property] = value
        end
        Window:ApplyTheme()
    end

    function Window:ApplyTheme()
        if Window.Main then
            Window.Main.BackgroundColor3 = Window.Theme.Background
        end
        
        if Window.TopBar then
            Window.TopBar.BackgroundColor3 = Window.Theme.Topbar
        end
        
        if Window.Title then
            Window.Title.TextColor3 = Window.Theme.TextColor
        end
        
        for _, tab in pairs(Window.Tabs) do
            if tab.Button then
                tab.Button.BackgroundColor3 = Window.Theme.TabBackground
                tab.Button.TextColor3 = Window.Theme.TabTextColor
            end
            
            if tab.Page then
                for _, child in pairs(tab.Page:GetChildren()) do
                    if child:IsA("TextButton") then
                        child.BackgroundColor3 = Window.Theme.ElementBackground
                        child.TextColor3 = Window.Theme.TextColor
                    elseif child:IsA("TextLabel") then
                        child.TextColor3 = Window.Theme.TextColor
                    elseif child:IsA("Frame") and child.Name == "ToggleFrame" then
                        local toggle = child:FindFirstChild("Toggle")
                        if toggle then
                            toggle.BackgroundColor3 = Window.Theme.ToggleBackground
                        end
                    end
                end
            end
        end
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = Window.Name
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = CoreGui
    Window.Frame = ScreenGui

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 600, 0, 450)
    Main.Position = UDim2.new(0.5, -300, 0.5, -225)
    Main.BackgroundColor3 = Window.Theme.Background
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui
    Main.Name = "Main"
    Main.ClipsDescendants = true
    Window.Main = Main
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = Main
    
    CreateShadow(Main, 20)

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Window.Theme.Topbar
    TopBar.BorderSizePixel = 0
    TopBar.Parent = Main
    TopBar.Name = "TopBar"
    Window.TopBar = TopBar
    
    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 8)
    topCorner.Parent = TopBar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -10, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Window.Theme.TextColor
    Title.Text = Window.Name
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    Window.Title = Title

    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 40, 1, 0)
    CloseButton.Position = UDim2.new(1, -40, 0, 0)
    CloseButton.BackgroundTransparency = 1
    CloseButton.TextColor3 = Window.Theme.TextColor
    CloseButton.Text = "X"
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 18
    CloseButton.Parent = TopBar
    
    CloseButton.MouseEnter:Connect(function()
        Tween(CloseButton, {TextColor3 = Color3.fromRGB(255, 50, 50)}, 0.2)
    end)
    
    CloseButton.MouseLeave:Connect(function()
        Tween(CloseButton, {TextColor3 = Window.Theme.TextColor}, 0.2)
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                  startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(0, 150, 1, -40)
    TabContainer.Position = UDim2.new(0, 0, 0, 40)
    TabContainer.BackgroundColor3 = Window.Theme.TabBackground
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = Main

    local PagesContainer = Instance.new("Frame")
    PagesContainer.Size = UDim2.new(1, -150, 1, -40)
    PagesContainer.Position = UDim2.new(0, 150, 0, 40)
    PagesContainer.BackgroundColor3 = Window.Theme.Background
    PagesContainer.BorderSizePixel = 0
    PagesContainer.Parent = Main
    PagesContainer.ClipsDescendants = true

    local NotifContainer = Instance.new("Frame")
    NotifContainer.Size = UDim2.new(0, 300, 0, 100)
    NotifContainer.Position = UDim2.new(0.5, -150, 0, 20)
    NotifContainer.BackgroundTransparency = 1
    NotifContainer.Parent = ScreenGui

    local function AutoLayout(container)
        local UIList = Instance.new("UIListLayout")
        UIList.Padding = UDim.new(0, 8)
        UIList.SortOrder = Enum.SortOrder.LayoutOrder
        UIList.Parent = container
        
        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, 8)
        padding.PaddingLeft = UDim.new(0, 8)
        padding.PaddingRight = UDim.new(0, 8)
        padding.PaddingBottom = UDim.new(0, 8)
        padding.Parent = container
        
        return UIList
    end
    
    AutoLayout(TabContainer)
    AutoLayout(PagesContainer)

    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Window.ToggleKeybind then
            Main.Visible = not Main.Visible
        end
    end)

    function Window:CreateTab(Name)
        local Tab = {}
        Tab.Name = Name
        Tab.Buttons = {}
        Tab.Toggles = {}
        Tab.Sliders = {}

        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, -16, 0, 40)
        Button.BackgroundColor3 = Window.Theme.TabBackground
        Button.BorderSizePixel = 0
        Button.TextColor3 = Window.Theme.TabTextColor
        Button.Text = Name
        Button.Font = Enum.Font.GothamBold
        Button.TextSize = 16
        Button.LayoutOrder = #self.Tabs
        Button.Parent = TabContainer
        Tab.Button = Button
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = Button
        
        Button.MouseEnter:Connect(function()
            if not Tab.Active then
                Tween(Button, {BackgroundColor3 = Window.Theme.TabBackgroundSelected}, 0.2)
            end
        end)
        
        Button.MouseLeave:Connect(function()
            if not Tab.Active then
                Tween(Button, {BackgroundColor3 = Window.Theme.TabBackground}, 0.2)
            end
        end)

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollingDirection = Enum.ScrollingDirection.Y
        Page.ScrollBarThickness = 4
        Page.ScrollBarImageColor3 = Window.Theme.Accent
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.Parent = PagesContainer
        Tab.Page = Page
        
        AutoLayout(Page)

        Button.MouseButton1Click:Connect(function()
            for _, t in pairs(self.Tabs) do
                t.Page.Visible = false
                t.Active = false
                Tween(t.Button, {BackgroundColor3 = Window.Theme.TabBackground}, 0.2)
            end
            Page.Visible = true
            Tab.Active = true
            Tween(Button, {BackgroundColor3 = Window.Theme.TabBackgroundSelected}, 0.2)
        end)
        
        function Tab:CreateSection(Title)
            local Section = Instance.new("Frame")
            Section.Size = UDim2.new(1, -16, 0, 30)
            Section.BackgroundTransparency = 1
            Section.LayoutOrder = #Page:GetChildren()
            Section.Parent = Page

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, 0, 1, 0)
            Label.BackgroundTransparency = 1
            Label.Text = Title
            Label.TextColor3 = Window.Theme.TextColor
            Label.Font = Enum.Font.GothamBold
            Label.TextSize = 16
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Section

            return Section
        end

        function Tab:CreateButton(Name, Callback)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, -16, 0, 40)
            Button.BackgroundColor3 = Window.Theme.ElementBackground
            Button.BorderSizePixel = 0
            Button.Text = Name
            Button.TextColor3 = Window.Theme.TextColor
            Button.Font = Enum.Font.Gotham
            Button.TextSize = 14
            Button.LayoutOrder = #Page:GetChildren()
            Button.Parent = Page
            Button.AutoButtonColor = false
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 6)
            buttonCorner.Parent = Button
            
            Button.MouseEnter:Connect(function()
                Tween(Button, {BackgroundColor3 = Window.Theme.ElementBackgroundHover}, 0.2)
            end)
            
            Button.MouseLeave:Connect(function()
                Tween(Button, {BackgroundColor3 = Window.Theme.ElementBackground}, 0.2)
            end)
            
            Button.MouseButton1Click:Connect(function()
                RippleEffect(Button)
                Callback()
            end)
            
            table.insert(self.Buttons, Button)
            return Button
        end

        function Tab:CreateToggle(Name, Default, Callback)
            local configName = Name .. "_Toggle"
            local Toggled = Window.Config[configName] or Default or false
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = "ToggleFrame"
            ToggleFrame.Size = UDim2.new(1, -16, 0, 40)
            ToggleFrame.BackgroundTransparency = 1
            ToggleFrame.LayoutOrder = #Page:GetChildren()
            ToggleFrame.Parent = Page
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(1, 0, 1, 0)
            ToggleButton.BackgroundTransparency = 1
            ToggleButton.Text = ""
            ToggleButton.Parent = ToggleFrame
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0.7, 0, 1, 0)
            Label.BackgroundTransparency = 1
            Label.Text = Name
            Label.TextColor3 = Window.Theme.TextColor
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = ToggleFrame
            
            local Toggle = Instance.new("Frame")
            Toggle.Size = UDim2.new(0, 50, 0, 24)
            Toggle.Position = UDim2.new(1, -50, 0.5, -12)
            Toggle.AnchorPoint = Vector2.new(1, 0.5)
            Toggle.BackgroundColor3 = Toggled and Window.Theme.ToggleEnabled or Window.Theme.ToggleDisabled
            Toggle.BorderSizePixel = 0
            Toggle.Parent = ToggleFrame
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(1, 0)
            toggleCorner.Parent = Toggle
            
            local ToggleDot = Instance.new("Frame")
            ToggleDot.Size = UDim2.new(0, 18, 0, 18)
            ToggleDot.Position = UDim2.new(0, Toggled and 28 or 4, 0.5, -9)
            ToggleDot.AnchorPoint = Vector2.new(0, 0.5)
            ToggleDot.BackgroundColor3 = Window.Theme.TextColor
            ToggleDot.BorderSizePixel = 0
            ToggleDot.Parent = Toggle
            
            local dotCorner = Instance.new("UICorner")
            dotCorner.CornerRadius = UDim.new(1, 0)
            dotCorner.Parent = ToggleDot
            
            ToggleButton.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                Window.Config[configName] = Toggled
                Window:SaveConfig()
                
                Tween(Toggle, {BackgroundColor3 = Toggled and Window.Theme.ToggleEnabled or Window.Theme.ToggleDisabled}, 0.2)
                Tween(ToggleDot, {Position = UDim2.new(0, Toggled and 28 or 4, 0.5, -9)}, 0.2)
                Callback(Toggled)
            end)
            
            table.insert(self.Toggles, {Frame = ToggleFrame, Value = Toggled})
            return ToggleFrame
        end

        function Tab:CreateSlider(Name, Min, Max, Increment, Default, Callback)
            local configName = Name .. "_Slider"
            local Value = Window.Config[configName] or Default or Min
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, -16, 0, 60)
            SliderFrame.BackgroundTransparency = 1
            SliderFrame.LayoutOrder = #Page:GetChildren()
            SliderFrame.Parent = Page

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, 0, 0, 20)
            Label.BackgroundTransparency = 1
            Label.Text = Name..": "..Value
            Label.TextColor3 = Window.Theme.TextColor
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = SliderFrame

            local Track = Instance.new("Frame")
            Track.Size = UDim2.new(1, 0, 0, 6)
            Track.Position = UDim2.new(0, 0, 0, 30)
            Track.BackgroundColor3 = Window.Theme.SliderBackground
            Track.BorderSizePixel = 0
            Track.Parent = SliderFrame
            
            local trackCorner = Instance.new("UICorner")
            trackCorner.CornerRadius = UDim.new(1, 0)
            trackCorner.Parent = Track

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
            Fill.BackgroundColor3 = Window.Theme.SliderProgress
            Fill.BorderSizePixel = 0
            Fill.Parent = Track
            
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(1, 0)
            fillCorner.Parent = Fill

            local SliderButton = Instance.new("TextButton")
            SliderButton.Size = UDim2.new(0, 20, 0, 20)
            SliderButton.Position = UDim2.new((Value - Min) / (Max - Min), -10, 0.5, -10)
            SliderButton.Text = ""
            SliderButton.BackgroundColor3 = Window.Theme.TextColor
            SliderButton.BorderSizePixel = 0
            SliderButton.Parent = Track
            SliderButton.ZIndex = 2
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(1, 0)
            buttonCorner.Parent = SliderButton

            local dragging = false
            SliderButton.MouseButton1Down:Connect(function()
                dragging = true
                RippleEffect(SliderButton)
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            local function updateSlider(input)
                if dragging then
                    local relX = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                    local value = math.floor(relX * (Max - Min) / Increment + 0.5) * Increment + Min
                    
                    Value = value
                    Label.Text = Name..": "..Value
                    Fill.Size = UDim2.new(relX, 0, 1, 0)
                    SliderButton.Position = UDim2.new(relX, -10, 0.5, -10)
                    
                    Window.Config[configName] = Value
                    Window:SaveConfig()
                    Callback(Value)
                end
            end
            
            UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)
            
            Track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    updateSlider(input)
                end
            end)
            
            table.insert(self.Sliders, {Frame = SliderFrame, Value = Value})
            return SliderFrame
        end

        function Tab:CreateParagraph(TitleText, ContentText)
            local ParagraphFrame = Instance.new("Frame")
            ParagraphFrame.Size = UDim2.new(1, -16, 0, 80)
            ParagraphFrame.BackgroundColor3 = Window.Theme.SecondaryElementBackground
            ParagraphFrame.LayoutOrder = #Page:GetChildren()
            ParagraphFrame.Parent = Page
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = ParagraphFrame
            
            local padding = Instance.new("UIPadding")
            padding.PaddingTop = UDim.new(0, 8)
            padding.PaddingLeft = UDim.new(0, 8)
            padding.PaddingRight = UDim.new(0, 8)
            padding.PaddingBottom = UDim.new(0, 8)
            padding.Parent = ParagraphFrame

            local ParagraphTitle = Instance.new("TextLabel")
            ParagraphTitle.Size = UDim2.new(1, 0, 0, 20)
            ParagraphTitle.BackgroundTransparency = 1
            ParagraphTitle.Text = TitleText
            ParagraphTitle.TextColor3 = Window.Theme.TextColor
            ParagraphTitle.Font = Enum.Font.GothamBold
            ParagraphTitle.TextSize = 14
            ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
            ParagraphTitle.Parent = ParagraphFrame

            local ParagraphContent = Instance.new("TextLabel")
            ParagraphContent.Size = UDim2.new(1, 0, 1, -20)
            ParagraphContent.Position = UDim2.new(0, 0, 0, 20)
            ParagraphContent.BackgroundTransparency = 1
            ParagraphContent.Text = ContentText
            ParagraphContent.TextColor3 = Window.Theme.TextColor
            ParagraphContent.Font = Enum.Font.Gotham
            ParagraphContent.TextSize = 12
            ParagraphContent.TextWrapped = true
            ParagraphContent.TextXAlignment = Enum.TextXAlignment.Left
            ParagraphContent.TextYAlignment = Enum.TextYAlignment.Top
            ParagraphContent.Parent = ParagraphFrame
            
            return ParagraphFrame
        end

        function Tab:CreateDivider()
            local Divider = Instance.new("Frame")
            Divider.Size = UDim2.new(1, -16, 0, 1)
            Divider.BackgroundColor3 = Window.Theme.ElementStroke
            Divider.BorderSizePixel = 0
            Divider.LayoutOrder = #Page:GetChildren()
            Divider.Parent = Page
            
            return Divider
        end

        self.Tabs[#self.Tabs+1] = Tab
        
        -- Activate first tab by default
        if #self.Tabs == 1 then
            Button.MouseButton1Click:Fire()
        end
        
        return Tab
    end

    function Window:Notify(Title, Text, Duration)
        local Notif = Instance.new("Frame")
        Notif.Size = UDim2.new(0, 300, 0, 80)
        Notif.Position = UDim2.new(0.5, -150, 0, -100)
        Notif.BackgroundColor3 = Window.Theme.NotificationBackground
        Notif.BorderSizePixel = 0
        Notif.Parent = NotifContainer
        Notif.ZIndex = 100
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = Notif
        
        CreateShadow(Notif, 20)
        
        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, 8)
        padding.PaddingLeft = UDim.new(0, 8)
        padding.PaddingRight = UDim.new(0, 8)
        padding.PaddingBottom = UDim.new(0, 8)
        padding.Parent = Notif

        local LabelTitle = Instance.new("TextLabel")
        LabelTitle.Size = UDim2.new(1, 0, 0, 20)
        LabelTitle.BackgroundTransparency = 1
        LabelTitle.Text = Title
        LabelTitle.TextColor3 = Window.Theme.TextColor
        LabelTitle.Font = Enum.Font.GothamBold
        LabelTitle.TextSize = 16
        LabelTitle.TextXAlignment = Enum.TextXAlignment.Left
        LabelTitle.Parent = Notif

        local LabelText = Instance.new("TextLabel")
        LabelText.Size = UDim2.new(1, 0, 1, -20)
        LabelText.Position = UDim2.new(0, 0, 0, 20)
        LabelText.BackgroundTransparency = 1
        LabelText.Text = Text
        LabelText.TextColor3 = Window.Theme.TextColor
        LabelText.Font = Enum.Font.Gotham
        LabelText.TextSize = 14
        LabelText.TextXAlignment = Enum.TextXAlignment.Left
        LabelText.TextWrapped = true
        LabelText.TextYAlignment = Enum.TextYAlignment.Top
        LabelText.Parent = Notif

        Tween(Notif, {Position = UDim2.new(0.5, -150, 0, 20)}, 0.3)
        
        local duration = Duration or 3
        task.delay(duration, function()
            Tween(Notif, {Position = UDim2.new(0.5, -150, 0, -100)}, 0.3)
            task.wait(0.3)
            Notif:Destroy()
        end)
        
        return Notif
    end

    return Window
end

return NovaLibrary
