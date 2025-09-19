--[[                 
     Zenith Library
     Owner: Something478 (Starflow)
     Coder: Something478 (Starflow)
     Inspired by: Rayfield :D
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local ZenithLibrary = {}
ZenithLibrary.__index = ZenithLibrary

local Theme = {
 TextColor = Color3.fromRGB(255,255,255),
 Background = Color3.fromRGB(15,15,15),
 Topbar = Color3.fromRGB(25,25,25),
 Accent = Color3.fromRGB(0,120,255),
 Button = Color3.fromRGB(35,35,35),
 ButtonHover = Color3.fromRGB(45,45,45),
 Outline = Color3.fromRGB(0,0,0)
}

local function createDraggable(frame, dragHandle)
 local dragging, dragStart, startPos
 dragHandle.InputBegan:Connect(function(input)
  if input.UserInputType == Enum.UserInputType.MouseButton1 then
   dragging = true
   dragStart = input.Position
   startPos = frame.Position
   input.Changed:Connect(function()
    if input.UserInputState == Enum.UserInputState.End then
     dragging = false
    end
   end)
  end
 end)
 UserInputService.InputChanged:Connect(function(input)
  if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
   local delta = input.Position - dragStart
   frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
    startPos.Y.Scale, startPos.Y.Offset + delta.Y)
  end
 end)
end

function ZenithLibrary:CreateWindow(config)
 local self = setmetatable({}, ZenithLibrary)
 
 local ScreenGui = Instance.new("ScreenGui")
 ScreenGui.Name = "Zenith"
 ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
 
 local Main = Instance.new("Frame")
 Main.Size = UDim2.new(0, 500, 0, 300)
 Main.Position = UDim2.new(0.5, -250, 0.5, -150)
 Main.BackgroundColor3 = Theme.Background
 Main.BorderColor3 = Theme.Outline
 Main.Parent = ScreenGui
 
 local Topbar = Instance.new("Frame")
 Topbar.Size = UDim2.new(1, 0, 0, 30)
 Topbar.BackgroundColor3 = Theme.Topbar
 Topbar.BorderColor3 = Theme.Outline
 Topbar.Parent = Main
 
 local Title = Instance.new("TextLabel")
 Title.Size = UDim2.new(1, -10, 1, 0)
 Title.Position = UDim2.new(0, 5, 0, 0)
 Title.BackgroundTransparency = 1
 Title.Text = config.Name or "Zenith"
 Title.TextColor3 = Theme.TextColor
 Title.TextXAlignment = Enum.TextXAlignment.Left
 Title.Font = Enum.Font.GothamBold
 Title.TextSize = 14
 Title.Parent = Topbar
 
 createDraggable(Main, Topbar)
 
 local TabHolder = Instance.new("Frame")
 TabHolder.Size = UDim2.new(0, 100, 1, -30)
 TabHolder.Position = UDim2.new(0, 0, 0, 30)
 TabHolder.BackgroundColor3 = Theme.Background
 TabHolder.BorderColor3 = Theme.Outline
 TabHolder.Parent = Main
 
 local ContentHolder = Instance.new("Frame")
 ContentHolder.Size = UDim2.new(1, -100, 1, -30)
 ContentHolder.Position = UDim2.new(0, 100, 0, 30)
 ContentHolder.BackgroundColor3 = Theme.Background
 ContentHolder.BorderColor3 = Theme.Outline
 ContentHolder.Parent = Main
 
 self.Tabs = {}
 self.ContentHolder = ContentHolder
 self.TabHolder = TabHolder
 self.MainFrame = Main
 return self
end

function ZenithLibrary:CreateTab(name)
 local Tab = {}
 Tab.Button = Instance.new("TextButton")
 Tab.Button.Size = UDim2.new(1, -10, 0, 30)
 Tab.Button.Position = UDim2.new(0, 5, 0, (#self.Tabs) * 35 + 5)
 Tab.Button.BackgroundColor3 = Theme.Button
 Tab.Button.BorderColor3 = Theme.Outline
 Tab.Button.Text = name
 Tab.Button.TextColor3 = Theme.TextColor
 Tab.Button.Font = Enum.Font.Gotham
 Tab.Button.TextSize = 13
 Tab.Button.Parent = self.TabHolder
 
 Tab.Content = Instance.new("Frame")
 Tab.Content.Size = UDim2.new(1, 0, 1, 0)
 Tab.Content.BackgroundTransparency = 1
 Tab.Content.Visible = false
 Tab.Content.Parent = self.ContentHolder
 
 Tab.Button.MouseEnter:Connect(function()
  Tab.Button.BackgroundColor3 = Theme.ButtonHover
 end)
 Tab.Button.MouseLeave:Connect(function()
  Tab.Button.BackgroundColor3 = Theme.Button
 end)
 Tab.Button.MouseButton1Click:Connect(function()
  for _, t in pairs(self.Tabs) do
   t.Content.Visible = false
  end
  Tab.Content.Visible = true
 end)
 
 table.insert(self.Tabs, Tab)
 return Tab
end

function ZenithLibrary:CreateButton(tab, text, callback)
 local Btn = Instance.new("TextButton")
 Btn.Size = UDim2.new(1, -10, 0, 30)
 Btn.Position = UDim2.new(0, 5, 0, #tab.Content:GetChildren() * 35)
 Btn.BackgroundColor3 = Theme.Button
 Btn.BorderColor3 = Theme.Outline
 Btn.Text = text
 Btn.TextColor3 = Theme.TextColor
 Btn.Font = Enum.Font.Gotham
 Btn.TextSize = 13
 Btn.Parent = tab.Content
 Btn.MouseButton1Click:Connect(function()
  if callback then callback() end
 end)
 Btn.MouseEnter:Connect(function()
  Btn.BackgroundColor3 = Theme.ButtonHover
 end)
 Btn.MouseLeave:Connect(function()
  Btn.BackgroundColor3 = Theme.Button
 end)
end

function ZenithLibrary:ModifyTheme(newTheme)
 for k,v in pairs(newTheme) do
  if Theme[k] ~= nil then
   Theme[k] = v
  end
 end
 
 if self.MainFrame then
  self.MainFrame.BackgroundColor3 = Theme.Background
  for _, child in pairs(self.MainFrame:GetChildren()) do
   if child:IsA("Frame") then
    if child.Name == "Topbar" then
     child.BackgroundColor3 = Theme.Topbar
     for _, t in pairs(child:GetChildren()) do
      if t:IsA("TextLabel") then
       t.TextColor3 = Theme.TextColor
      end
     end
    elseif child.Name == "TabHolder" then
     child.BackgroundColor3 = Theme.Background
     for _, btn in pairs(child:GetChildren()) do
      if btn:IsA("TextButton") then
       btn.BackgroundColor3 = Theme.Button
       btn.TextColor3 = Theme.TextColor
      end
     end
    elseif child.Name == "ContentHolder" then
     child.BackgroundColor3 = Theme.Background
    end
   end
  end
 end
end

return ZenithLibrary
