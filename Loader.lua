--[[
    NovaLibrary
    Made by SuperNova (Something478)
    V: 1.5


]]

local NovaLibrary = {}

local function CreateInstance(class, props)
    local obj = Instance.new(class)
    if props then
        for k,v in pairs(props) do
            pcall(function() obj[k] = v end)
        end
    end
    return obj
end

function NovaLibrary:CreateWindow(opts)
    local Window = {}
    Window.Tabs = {}

    local ScreenGui = CreateInstance("ScreenGui",{Name = opts.Name or "NovaLibraryGui", ResetOnSpawn = false, Parent = game:GetService("CoreGui")})
    local MainFrame = CreateInstance("Frame",{Name = "MainFrame", Size = UDim2.new(0,600,0,400), Position = UDim2.new(0.5,-300,0.5,-200), BackgroundColor3 = Color3.fromRGB(20,20,20), Parent = ScreenGui})
    Window.ScreenGui = ScreenGui
    Window.MainFrame = MainFrame

    function Window:CreateTab(name)
        local Tab = {}
        Tab.Name = name
        Tab.Elements = {}
        Tab.OffsetY = 10 -- initial offset
        Tab.Spacing = 5

        local function AddElement(el, height)
            el.Position = UDim2.new(0,10,0,Tab.OffsetY)
            Tab.OffsetY = Tab.OffsetY + height + Tab.Spacing
            table.insert(Tab.Elements, el)
        end

        function Tab:CreateButton(name, callback)
            local btn = CreateInstance("TextButton",{Text = name, Size = UDim2.new(0,200,0,30), BackgroundColor3 = Color3.fromRGB(50,50,50), TextColor3 = Color3.fromRGB(255,255,255), Parent = MainFrame})
            btn.MouseButton1Click:Connect(callback or function() end)
            AddElement(btn,30)
            return btn
        end

        function Tab:CreateParagraph(title, content)
            local titleLabel = CreateInstance("TextLabel",{Text = title, Size = UDim2.new(0,400,0,20), TextColor3 = Color3.new(1,1,1), BackgroundTransparency = 1, Parent = MainFrame})
            local contentLabel = CreateInstance("TextLabel",{Text = content, Size = UDim2.new(0,400,0,30), TextColor3 = Color3.new(1,1,1), BackgroundTransparency = 1, Parent = MainFrame})
            AddElement(titleLabel,20)
            AddElement(contentLabel,30)
        end

        function Tab:CreateSection(name)
            local section = CreateInstance("TextLabel",{Text = name, Size = UDim2.new(0,400,0,25), TextColor3 = Color3.new(1,1,1), BackgroundColor3 = Color3.fromRGB(40,40,40), Parent = MainFrame})
            AddElement(section,25)
        end

        function Tab:CreateDivider()
            local divider = CreateInstance("Frame",{Size = UDim2.new(0,400,0,2), BackgroundColor3 = Color3.fromRGB(200,200,200), Parent = MainFrame})
            AddElement(divider,2)
        end

        function Tab:CreateToggle(name, default, callback)
            local toggle = CreateInstance("TextButton",{Text = name.." ["..tostring(default).."]", Size = UDim2.new(0,200,0,30), BackgroundColor3 = Color3.fromRGB(50,50,50), TextColor3 = Color3.fromRGB(255,255,255), Parent = MainFrame})
            local value = default
            toggle.MouseButton1Click:Connect(function()
                value = not value
                toggle.Text = name.." ["..tostring(value).."]"
                if callback then pcall(callback,value) end
            end)
            AddElement(toggle,30)
            return toggle
        end

        function Tab:CreateSlider(name, min, max, step, default, callback)
            local sliderLabel = CreateInstance("TextLabel",{Text = name.." ["..tostring(default).."]", Size = UDim2.new(0,200,0,20), TextColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 1, Parent = MainFrame})
            local slider = CreateInstance("TextButton",{Text = "", Size = UDim2.new(0,200,0,20), BackgroundColor3 = Color3.fromRGB(50,50,50), Parent = MainFrame})
            local value = default
            slider.MouseButton1Click:Connect(function()
                value = math.clamp(value + step, min, max)
                sliderLabel.Text = name.." ["..tostring(value).."]"
                if callback then pcall(callback,value) end
            end)
            AddElement(sliderLabel,20)
            AddElement(slider,20)
            return slider
        end

        function Tab:CreateInput(name, placeholder, numeric, callback)
            local inputBox = CreateInstance("TextBox",{Text = placeholder or "", Size = UDim2.new(0,200,0,30), BackgroundColor3 = Color3.fromRGB(50,50,50), TextColor3 = Color3.fromRGB(255,255,255), Parent = MainFrame})
            inputBox.FocusLost:Connect(function()
                local val = inputBox.Text
                if numeric then val = tonumber(val) end
                if callback then pcall(callback,val) end
            end)
            AddElement(inputBox,30)
            return inputBox
        end

        table.insert(Window.Tabs, Tab)
        return Tab
    end

    function Window:Notify(title,text,duration)
        game:GetService("StarterGui"):SetCore("SendNotification",{Title = title, Text = text, Duration = duration or 5})
    end

    return Window
end

return NovaLibrary
