--[[ 
   NovaLibrary
   Made by SuperNova
   Version: 1.4
--]]

local NovaLibrary = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

NovaLibrary.Theme = {
    TextColor = Color3.fromRGB(255, 255, 255),
    Background = Color3.fromRGB(15, 15, 30),
    Topbar = Color3.fromRGB(0, 0, 0),
    TabBackground = Color3.fromRGB(0, 0, 0),
    TabBackgroundSelected = Color3.fromRGB(0, 0, 133),
    TabTextColor = Color3.fromRGB(255, 255, 255),
    ElementBackground = Color3.fromRGB(15, 15, 15),
    ElementBackgroundHover = Color3.fromRGB(40, 40, 40),
    ToggleBackground = Color3.fromRGB(0, 0, 130),
    ToggleEnabled = Color3.fromRGB(0, 0, 255),
    ToggleDisabled = Color3.fromRGB(0, 0, 120),
    SliderProgress = Color3.fromRGB(0, 0, 255),
    Accent = Color3.fromRGB(0, 170, 255)
}

local function Tween(obj, props, time, easingStyle, easingDirection)
    local tween = TweenService:Create(obj, TweenInfo.new(time or 0.2, easingStyle or Enum.EasingStyle.Quad, easingDirection or Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

local function RippleEffect(button)
    local ripple = Instance.new("Frame")
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.8
    ripple.ZIndex = button.ZIndex + 1
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.BorderSizePixel = 0
    ripple.Parent = button
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    Tween(ripple, {Size = UDim2.new(2, 0, 2, 0), BackgroundTransparency = 1}, 0.5)
    spawn(function() wait(0.5) ripple:Destroy() end)
end

function NovaLibrary:CreateWindow(options)
    local Window = {}
    Window.Name = options.Name or "NovaLibrary"
    Window.Theme = options.Theme or NovaLibrary.Theme
    Window.Tabs = {}
    Window.ToggleKeybind = options.ToggleKeybind or Enum.KeyCode.B

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = Window.Name
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui
    Window.Frame = ScreenGui

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 550, 0, 400) -- smaller vertical height
    Main.Position = UDim2.new(0.5, -275, 0.5, -200)
    Main.BackgroundColor3 = Window.Theme.Background
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui
    Window.Main = Main

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = Main

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 36)
    TopBar.BackgroundColor3 = Window.Theme.Topbar
    TopBar.BorderSizePixel = 0
    TopBar.Parent = Main
    Window.TopBar = TopBar

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
    CloseButton.Size = UDim2.new(0, 36, 1, 0)
    CloseButton.Position = UDim2.new(1, -36, 0, 0)
    CloseButton.BackgroundTransparency = 1
    CloseButton.TextColor3 = Window.Theme.TextColor
    CloseButton.Text = "X"
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 18
    CloseButton.Parent = TopBar
    CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    -- Dragging
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
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    TopBar.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)

    -- Tab container and pages
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(0, 140, 1, -36)
    TabContainer.Position = UDim2.new(0, 0, 0, 36)
    TabContainer.BackgroundColor3 = Window.Theme.TabBackground
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = Main

    local PagesContainer = Instance.new("Frame")
    PagesContainer.Size = UDim2.new(1, -140, 1, -36)
    PagesContainer.Position = UDim2.new(0, 140, 0, 36)
    PagesContainer.BackgroundColor3 = Window.Theme.Background
    PagesContainer.BorderSizePixel = 0
    PagesContainer.ClipsDescendants = true
    PagesContainer.Parent = Main

    local function AutoLayout(container)
        local layout = Instance.new("UIListLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 6)
        layout.Parent = container
        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, 6)
        padding.PaddingBottom = UDim.new(0, 6)
        padding.PaddingLeft = UDim.new(0, 6)
        padding.PaddingRight = UDim.new(0, 6)
        padding.Parent = container
        return layout
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
        Tab.Buttons = {}
        Tab.Toggles = {}
        Tab.Sliders = {}

        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, -12, 0, 34)
        Button.BackgroundColor3 = Window.Theme.TabBackground
        Button.BorderSizePixel = 0
        Button.TextColor3 = Window.Theme.TabTextColor
        Button.Text = Name
        Button.Font = Enum.Font.GothamBold
        Button.TextSize = 14
        Button.LayoutOrder = #self.Tabs + 1
        Button.Parent = TabContainer
        Tab.Button = Button

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
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
                t.Button.BackgroundColor3 = Window.Theme.TabBackground
            end
            Page.Visible = true
            Button.BackgroundColor3 = Window.Theme.TabBackgroundSelected
        end)

        function Tab:CreateButton(Name, Callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -12, 0, 34)
            Btn.BackgroundColor3 = Window.Theme.ElementBackground
            Btn.BorderSizePixel = 0
            Btn.Text = Name
            Btn.TextColor3 = Window.Theme.TextColor
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 14
            Btn.LayoutOrder = #Page:GetChildren() + 1
            Btn.Parent = Page
            Btn.AutoButtonColor = false
            Btn.MouseButton1Click:Connect(function() RippleEffect(Btn); Callback() end)
            table.insert(self.Buttons, Btn)
            return Btn
        end

        function Tab:CreateToggle(Name, Default, Callback)
            Default = Default or false
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, -12, 0, 34)
            ToggleFrame.BackgroundTransparency = 1
            ToggleFrame.LayoutOrder = #Page:GetChildren() + 1
            ToggleFrame.Parent = Page

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
            Toggle.BackgroundColor3 = Default and Window.Theme.ToggleEnabled or Window.Theme.ToggleDisabled
            Toggle.BorderSizePixel = 0
            Toggle.Parent = ToggleFrame
            local dot = Instance.new("Frame")
            dot.Size = UDim2.new(0, 18, 0, 18)
            dot.Position = UDim2.new(0, Default and 28 or 4, 0.5, -9)
            dot.AnchorPoint = Vector2.new(0, 0.5)
            dot.BackgroundColor3 = Window.Theme.TextColor
            dot.BorderSizePixel = 0
            dot.Parent = Toggle
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(1, 0)
            toggleCorner.Parent = Toggle
            local dotCorner = Instance.new("UICorner")
            dotCorner.CornerRadius = UDim.new(1, 0)
            dotCorner.Parent = dot

            local Toggled = Default
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 1, 0)
            Btn.BackgroundTransparency = 1
            Btn.Text = ""
            Btn.Parent = ToggleFrame
            Btn.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                Toggle.BackgroundColor3 = Toggled and Window.Theme.ToggleEnabled or Window.Theme.ToggleDisabled
                dot.Position = UDim2.new(0, Toggled and 28 or 4, 0.5, -9)
                Callback(Toggled)
            end)

            table.insert(self.Toggles, {Frame = ToggleFrame, Value = Toggled})
            return ToggleFrame
        end

        self.Tabs[#self.Tabs+1] = Tab
        if #self.Tabs == 1 then Button:MouseButton1Click() end
        return Tab
    end

    return Window
end

return NovaLibrary
