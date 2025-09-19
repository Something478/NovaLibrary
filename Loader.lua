--[[ 
       NovaLibrary   
       Made by SuperNova
       Version: 1.4
]]
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

    function Window:ModifyTheme(newTheme)
        for property, value in pairs(newTheme) do
            Window.Theme[property] = value
        end
        Window:ApplyTheme()
    end

    function Window:ApplyTheme()
        if Window.Main then Window.Main.BackgroundColor3 = Window.Theme.Background end
        if Window.TopBar then Window.TopBar.BackgroundColor3 = Window.Theme.Topbar end
        if Window.Title then Window.Title.TextColor3 = Window.Theme.TextColor end
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
    Main.Size = UDim2.new(0, 600, 0, 350) -- <--- Reduced vertical height
    Main.Position = UDim2.new(0.5, -300, 0.5, -175)
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
    TopBar.Size = UDim2.new(1, 0, 0, 32) -- <--- slightly smaller TopBar
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
    CloseButton.Size = UDim2.new(0, 32, 1, 0)
    CloseButton.Position = UDim2.new(1, -32, 0, 0)
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
    TabContainer.Size = UDim2.new(0, 150, 1, -32)
    TabContainer.Position = UDim2.new(0, 0, 0, 32)
    TabContainer.BackgroundColor3 = Window.Theme.TabBackground
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = Main

    local PagesContainer = Instance.new("Frame")
    PagesContainer.Size = UDim2.new(1, -150, 1, -32)
    PagesContainer.Position = UDim2.new(0, 150, 0, 32)
    PagesContainer.BackgroundColor3 = Window.Theme.Background
    PagesContainer.BorderSizePixel = 0
    PagesContainer.Parent = Main
    PagesContainer.ClipsDescendants = true

    local NotifContainer = Instance.new("Frame")
    NotifContainer.Size = UDim2.new(0, 300, 0, 80) -- <--- smaller notifications
    NotifContainer.Position = UDim2.new(0.5, -150, 0, 20)
    NotifContainer.BackgroundTransparency = 1
    NotifContainer.Parent = ScreenGui

    local function AutoLayout(container)
        local UIList = Instance.new("UIListLayout")
        UIList.Padding = UDim.new(0, 6) -- <--- smaller padding
        UIList.SortOrder = Enum.SortOrder.LayoutOrder
        UIList.Parent = container

        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, 6)
        padding.PaddingLeft = UDim.new(0, 6)
        padding.PaddingRight = UDim.new(0, 6)
        padding.PaddingBottom = UDim.new(0, 6)
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

    -- Fixed CreateTab
    function Window:CreateTab(Name)
        local Tab = {}
        Tab.Name = Name
        Tab.Buttons = {}
        Tab.Toggles = {}
        Tab.Sliders = {}

        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, -12, 0, 32) -- <--- smaller button
        Button.BackgroundColor3 = Window.Theme.TabBackground
        Button.BorderSizePixel = 0
        Button.TextColor3 = Window.Theme.TabTextColor
        Button.Text = Name
        Button.Font = Enum.Font.GothamBold
        Button.TextSize = 14
        Button.LayoutOrder = #self.Tabs
        Button.Parent = TabContainer
        Tab.Button = Button

        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = Button

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

        self.Tabs[#self.Tabs+1] = Tab

        if #self.Tabs == 1 then
            Button:MouseButton1Click()
        end

        return Tab
    end

    return Window
end

return NovaLibrary
