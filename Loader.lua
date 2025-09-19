--[[                 
     Zenith Library
     Owner: Something478 (Starflow)
     Coder: Something478 (Starflow)
     Inspired by: Rayfield :D
]]
local Library = {}
Library.__index = Library

function Library:CreateWindow(args)
    local window = {}
    window.Tabs = {}
    window.Theme = args.Theme or {
        TextColor = Color3.fromRGB(255,255,255),
        Background = Color3.fromRGB(0,0,0),
        Topbar = Color3.fromRGB(0,0,0),
        Accent = Color3.fromRGB(0,0,255),
        Button = Color3.fromRGB(35,35,35),
        ButtonHover = Color3.fromRGB(45,45,45),
        Outline = Color3.fromRGB(0,0,0)
    }

    function window:ModifyTheme(theme)
        for k,v in pairs(theme) do
            self.Theme[k] = v
        end
    end

    function window:CreateTab(name)
        local tab = {}
        tab.Name = name
        tab.Elements = {}
        function tab:CreateButton(btnName, callback)
            local btn = {Name = btnName, Callback = callback}
            table.insert(self.Elements, btn)
            return btn
        end
        function tab:CreateToggle(toggleName, default, callback)
            local toggle = {Name = toggleName, State = default, Callback = callback}
            table.insert(self.Elements, toggle)
            return toggle
        end
        function tab:CreateSlider(name, min, max, step, displayName, default, callback)
            local slider = {Name = name, Min = min, Max = max, Step = step, Display = displayName, Value = default, Callback = callback}
            table.insert(self.Elements, slider)
            return slider
        end
        function tab:CreateInput(name, placeholder, numeric, callback)
            local input = {Name = name, Placeholder = placeholder, Numeric = numeric, Callback = callback}
            table.insert(self.Elements, input)
            return input
        end
        function tab:CreateParagraph(args)
            local paragraph = {Title = args.Title, Content = args.Content}
            table.insert(self.Elements, paragraph)
            return paragraph
        end
        function tab:CreateSection(title)
            local section = {SectionTitle = title}
            table.insert(self.Elements, section)
            return section
        end
        function tab:CreateDivider()
            local divider = {Divider = true}
            table.insert(self.Elements, divider)
            return divider
        end

        table.insert(window.Tabs, tab)
        return tab
    end

    return window
end

return Library
