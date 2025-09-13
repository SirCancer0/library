-- Roblox UI Library
-- Dark Blue Transparent Theme with Animations

local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Animation presets
Library.Animations = {
    EaseOut = Enum.EasingStyle.Quad,
    EaseIn = Enum.EasingStyle.Quad,
    EaseInOut = Enum.EasingStyle.Quad,
    Duration = 0.25
}

-- Theme settings
Library.Theme = {
    Main = Color3.fromRGB(25, 35, 60),
    Secondary = Color3.fromRGB(35, 45, 75),
    Accent = Color3.fromRGB(0, 120, 215),
    Text = Color3.fromRGB(240, 240, 240),
    LightText = Color3.fromRGB(200, 200, 200),
    DarkText = Color3.fromRGB(20, 20, 20),
    Success = Color3.fromRGB(50, 200, 100),
    Error = Color3.fromRGB(220, 80, 80),
    Warning = Color3.fromRGB(220, 180, 60),
    BackgroundTransparency = 0.15,
    ElementTransparency = 0.25
}

-- Config system
Library.Config = {
    Current = {},
    FolderName = "UI_Library_Configs",
    AutoSave = false,
    IgnoreList = {}
}

-- Notification system
Library.Notifications = {
    List = {},
    MaxVisible = 5,
    Duration = 5
}

-- Create main UI container
function Library:CreateUI()
    if self.ScreenGui then self.ScreenGui:Destroy() end
    
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "UILibrary"
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Notification holder
    self.NotificationHolder = Instance.new("Frame")
    self.NotificationHolder.Name = "NotificationHolder"
    self.NotificationHolder.Size = UDim2.new(0, 300, 1, -20)
    self.NotificationHolder.Position = UDim2.new(1, -310, 0, 10)
    self.NotificationHolder.BackgroundTransparency = 1
    self.NotificationHolder.Parent = self.ScreenGui
    
    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Padding = UDim.new(0, 10)
    uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    uiListLayout.Parent = self.NotificationHolder
    
    return self.ScreenGui
end

-- Create window
function Library:CreateWindow(options)
    local window = {}
    options = options or {}
    
    window.Name = options.Name or "Window"
    window.Size = options.Size or UDim2.new(0, 500, 0, 400)
    window.Position = options.Position or UDim2.new(0.5, -250, 0.5, -200)
    
    -- Main window frame
    window.Main = Instance.new("Frame")
    window.Main.Name = window.Name
    window.Main.Size = window.Size
    window.Main.Position = window.Position
    window.Main.BackgroundColor3 = Library.Theme.Main
    window.Main.BackgroundTransparency = Library.Theme.BackgroundTransparency
    window.Main.BorderSizePixel = 0
    window.Main.ClipsDescendants = true
    window.Main.Parent = self.ScreenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = window.Main
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Library.Theme.Accent
    stroke.Thickness = 1
    stroke.Transparency = 0.7
    stroke.Parent = window.Main
    
    -- Title bar
    window.TitleBar = Instance.new("Frame")
    window.TitleBar.Name = "TitleBar"
    window.TitleBar.Size = UDim2.new(1, 0, 0, 30)
    window.TitleBar.Position = UDim2.new(0, 0, 0, 0)
    window.TitleBar.BackgroundColor3 = Library.Theme.Secondary
    window.TitleBar.BackgroundTransparency = Library.Theme.ElementTransparency
    window.TitleBar.BorderSizePixel = 0
    window.TitleBar.Parent = window.Main
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = window.TitleBar
    
    window.Title = Instance.new("TextLabel")
    window.Title.Name = "Title"
    window.Title.Size = UDim2.new(1, -40, 1, 0)
    window.Title.Position = UDim2.new(0, 10, 0, 0)
    window.Title.BackgroundTransparency = 1
    window.Title.Text = window.Name
    window.Title.TextColor3 = Library.Theme.Text
    window.Title.TextSize = 16
    window.Title.TextXAlignment = Enum.TextXAlignment.Left
    window.Title.Font = Enum.Font.GothamSemibold
    window.Title.Parent = window.TitleBar
    
    -- Close button
    window.CloseButton = Instance.new("TextButton")
    window.CloseButton.Name = "CloseButton"
    window.CloseButton.Size = UDim2.new(0, 30, 0, 30)
    window.CloseButton.Position = UDim2.new(1, -30, 0, 0)
    window.CloseButton.BackgroundTransparency = 1
    window.CloseButton.Text = "X"
    window.CloseButton.TextColor3 = Library.Theme.Text
    window.CloseButton.TextSize = 16
    window.CloseButton.Font = Enum.Font.GothamBold
    window.CloseButton.Parent = window.TitleBar
    
    window.CloseButton.MouseEnter:Connect(function()
        Library:Tween(window.CloseButton, {TextColor3 = Library.Theme.Error}, 0.2)
    end)
    
    window.CloseButton.MouseLeave:Connect(function()
        Library:Tween(window.CloseButton, {TextColor3 = Library.Theme.Text}, 0.2)
    end)
    
    window.CloseButton.MouseButton1Click:Connect(function()
        Library:Tween(window.Main, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        wait(0.3)
        window.Main:Destroy()
    end)
    
    -- Tabs container
    window.Tabs = Instance.new("Frame")
    window.Tabs.Name = "Tabs"
    window.Tabs.Size = UDim2.new(1, -20, 0, 30)
    window.Tabs.Position = UDim2.new(0, 10, 0, 35)
    window.Tabs.BackgroundTransparency = 1
    window.Tabs.Parent = window.Main
    
    local tabsList = Instance.new("UIListLayout")
    tabsList.Padding = UDim.new(0, 5)
    tabsList.FillDirection = Enum.FillDirection.Horizontal
    tabsList.Parent = window.Tabs
    
    -- Content container
    window.Content = Instance.new("Frame")
    window.Content.Name = "Content"
    window.Content.Size = UDim2.new(1, -20, 1, -75)
    window.Content.Position = UDim2.new(0, 10, 0, 70)
    window.Content.BackgroundTransparency = 1
    window.Content.Parent = window.Main
    
    -- Make window draggable
    local dragging = false
    local dragInput, dragStart, startPos
    
    window.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = window.Main.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    window.TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            window.Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Tab creation function
    function window:CreateTab(name)
        local tab = {}
        tab.Name = name
        
        -- Tab button
        tab.Button = Instance.new("TextButton")
        tab.Button.Name = name
        tab.Button.Size = UDim2.new(0, 80, 1, 0)
        tab.Button.BackgroundColor3 = Library.Theme.Secondary
        tab.Button.BackgroundTransparency = Library.Theme.ElementTransparency
        tab.Button.Text = name
        tab.Button.TextColor3 = Library.Theme.LightText
        tab.Button.TextSize = 14
        tab.Button.Font = Enum.Font.Gotham
        tab.Button.Parent = window.Tabs
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 6)
        tabCorner.Parent = tab.Button
        
        -- Tab content
        tab.Content = Instance.new("ScrollingFrame")
        tab.Content.Name = name
        tab.Content.Size = UDim2.new(1, 0, 1, 0)
        tab.Content.Position = UDim2.new(0, 0, 0, 0)
        tab.Content.BackgroundTransparency = 1
        tab.Content.ScrollBarThickness = 4
        tab.Content.ScrollBarImageColor3 = Library.Theme.Accent
        tab.Content.Visible = false
        tab.Content.Parent = window.Content
        
        local contentList = Instance.new("UIListLayout")
        contentList.Padding = UDim.new(0, 10)
        contentList.Parent = tab.Content
        
        contentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tab.Content.CanvasSize = UDim2.new(0, 0, 0, contentList.AbsoluteContentSize.Y)
        end)
        
        -- Tab selection logic
        tab.Button.MouseButton1Click:Connect(function()
            for _, otherTab in pairs(window.Tabs:GetChildren()) do
                if otherTab:IsA("TextButton") then
                    Library:Tween(otherTab, {BackgroundColor3 = Library.Theme.Secondary, TextColor3 = Library.Theme.LightText}, 0.2)
                end
            end
            
            for _, otherContent in pairs(window.Content:GetChildren()) do
                if otherContent:IsA("ScrollingFrame") then
                    otherContent.Visible = false
                end
            end
            
            Library:Tween(tab.Button, {BackgroundColor3 = Library.Theme.Accent, TextColor3 = Library.Theme.Text}, 0.2)
            tab.Content.Visible = true
        end)
        
        -- Select first tab by default
        if #window.Tabs:GetChildren() == 2 then -- UIListLayout + first tab
            tab.Button.BackgroundColor3 = Library.Theme.Accent
            tab.Button.TextColor3 = Library.Theme.Text
            tab.Content.Visible = true
        end
        
        -- Section creation function
        function tab:CreateSection(name)
            local section = {}
            section.Name = name
            
            -- Section frame
            section.Main = Instance.new("Frame")
            section.Main.Name = name
            section.Main.Size = UDim2.new(1, 0, 0, 40)
            section.Main.BackgroundColor3 = Library.Theme.Secondary
            section.Main.BackgroundTransparency = Library.Theme.ElementTransparency
            section.Main.Parent = tab.Content
            
            local sectionCorner = Instance.new("UICorner")
            sectionCorner.CornerRadius = UDim.new(0, 6)
            sectionCorner.Parent = section.Main
            
            local sectionStroke = Instance.new("UIStroke")
            sectionStroke.Color = Library.Theme.Accent
            sectionStroke.Thickness = 1
            sectionStroke.Transparency = 0.7
            sectionStroke.Parent = section.Main
            
            -- Section title
            section.Title = Instance.new("TextLabel")
            section.Title.Name = "Title"
            section.Title.Size = UDim2.new(1, -20, 0, 20)
            section.Title.Position = UDim2.new(0, 10, 0, 10)
            section.Title.BackgroundTransparency = 1
            section.Title.Text = name
            section.Title.TextColor3 = Library.Theme.Text
            section.Title.TextSize = 16
            section.Title.TextXAlignment = Enum.TextXAlignment.Left
            section.Title.Font = Enum.Font.GothamSemibold
            section.Title.Parent = section.Main
            
            -- Section content container
            section.Content = Instance.new("Frame")
            section.Content.Name = "Content"
            section.Content.Size = UDim2.new(1, -20, 1, -40)
            section.Content.Position = UDim2.new(0, 10, 0, 40)
            section.Content.BackgroundTransparency = 1
            section.Content.Parent = section.Main
            
            local contentList = Instance.new("UIListLayout")
            contentList.Padding = UDim.new(0, 8)
            contentList.Parent = section.Content
            
            contentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                section.Main.Size = UDim2.new(1, 0, 0, contentList.AbsoluteContentSize.Y + 50)
            end)
            
            -- Toggle creation function
            function section:CreateToggle(options)
                local toggle = {}
                options = options or {}
                
                toggle.Name = options.Name or "Toggle"
                toggle.Default = options.Default or false
                toggle.Callback = options.Callback or function() end
                
                -- Toggle container
                toggle.Main = Instance.new("Frame")
                toggle.Main.Name = toggle.Name
                toggle.Main.Size = UDim2.new(1, 0, 0, 30)
                toggle.Main.BackgroundTransparency = 1
                toggle.Main.Parent = section.Content
                
                -- Toggle label
                toggle.Label = Instance.new("TextLabel")
                toggle.Label.Name = "Label"
                toggle.Label.Size = UDim2.new(1, -40, 1, 0)
                toggle.Label.Position = UDim2.new(0, 0, 0, 0)
                toggle.Label.BackgroundTransparency = 1
                toggle.Label.Text = toggle.Name
                toggle.Label.TextColor3 = Library.Theme.Text
                toggle.Label.TextSize = 14
                toggle.Label.TextXAlignment = Enum.TextXAlignment.Left
                toggle.Label.Font = Enum.Font.Gotham
                toggle.Label.Parent = toggle.Main
                
                -- Toggle button
                toggle.Button = Instance.new("Frame")
                toggle.Button.Name = "Button"
                toggle.Button.Size = UDim2.new(0, 30, 0, 15)
                toggle.Button.Position = UDim2.new(1, -30, 0.5, -7)
                toggle.Button.BackgroundColor3 = Library.Theme.Secondary
                toggle.Button.BackgroundTransparency = Library.Theme.ElementTransparency
                toggle.Button.Parent = toggle.Main
                
                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = UDim.new(0, 10)
                buttonCorner.Parent = toggle.Button
                
                -- Toggle indicator
                toggle.Indicator = Instance.new("Frame")
                toggle.Indicator.Name = "Indicator"
                toggle.Indicator.Size = UDim2.new(0, 11, 0, 11)
                toggle.Indicator.Position = UDim2.new(0, 2, 0, 2)
                toggle.Indicator.BackgroundColor3 = Library.Theme.Text
                toggle.Indicator.Parent = toggle.Button
                
                local indicatorCorner = Instance.new("UICorner")
                indicatorCorner.CornerRadius = UDim.new(0, 10)
                indicatorCorner.Parent = toggle.Indicator
                
                -- Toggle state
                toggle.Value = toggle.Default
                
                -- Set initial state
                if toggle.Value then
                    Library:Tween(toggle.Indicator, {Position = UDim2.new(0, 17, 0, 2)}, 0.2)
                    Library:Tween(toggle.Button, {BackgroundColor3 = Library.Theme.Accent}, 0.2)
                else
                    Library:Tween(toggle.Indicator, {Position = UDim2.new(0, 2, 0, 2)}, 0.2)
                    Library:Tween(toggle.Button, {BackgroundColor3 = Library.Theme.Secondary}, 0.2)
                end
                
                -- Toggle click event
                toggle.Button.MouseButton1Click:Connect(function()
                    toggle.Value = not toggle.Value
                    
                    if toggle.Value then
                        Library:Tween(toggle.Indicator, {Position = UDim2.new(0, 17, 0, 2)}, 0.2)
                        Library:Tween(toggle.Button, {BackgroundColor3 = Library.Theme.Accent}, 0.2)
                    else
                        Library:Tween(toggle.Indicator, {Position = UDim2.new(0, 2, 0, 2)}, 0.2)
                        Library:Tween(toggle.Button, {BackgroundColor3 = Library.Theme.Secondary}, 0.2)
                    end
                    
                    toggle.Callback(toggle.Value)
                    
                    if Library.Config.AutoSave then
                        Library:SaveConfig()
                    end
                end)
                
                -- Config integration
                Library.Config.Current[toggle.Name] = toggle.Value
                
                -- Get value function
                function toggle:GetValue()
                    return toggle.Value
                end
                
                -- Set value function
                function toggle:SetValue(value)
                    toggle.Value = value
                    
                    if toggle.Value then
                        Library:Tween(toggle.Indicator, {Position = UDim2.new(0, 17, 0, 2)}, 0.2)
                        Library:Tween(toggle.Button, {BackgroundColor3 = Library.Theme.Accent}, 0.2)
                    else
                        Library:Tween(toggle.Indicator, {Position = UDim2.new(0, 2, 0, 2)}, 0.2)
                        Library:Tween(toggle.Button, {BackgroundColor3 = Library.Theme.Secondary}, 0.2)
                    end
                    
                    toggle.Callback(toggle.Value)
                    
                    if Library.Config.AutoSave then
                        Library:SaveConfig()
                    end
                end
                
                return toggle
            end
            
            -- Slider creation function
            function section:CreateSlider(options)
                local slider = {}
                options = options or {}
                
                slider.Name = options.Name or "Slider"
                slider.Min = options.Min or 0
                slider.Max = options.Max or 100
                slider.Default = options.Default or 50
                slider.Callback = options.Callback or function() end
                slider.Precision = options.Precision or 1
                
                -- Slider container
                slider.Main = Instance.new("Frame")
                slider.Main.Name = slider.Name
                slider.Main.Size = UDim2.new(1, 0, 0, 50)
                slider.Main.BackgroundTransparency = 1
                slider.Main.Parent = section.Content
                
                -- Slider label
                slider.Label = Instance.new("TextLabel")
                slider.Label.Name = "Label"
                slider.Label.Size = UDim2.new(1, 0, 0, 20)
                slider.Label.Position = UDim2.new(0, 0, 0, 0)
                slider.Label.BackgroundTransparency = 1
                slider.Label.Text = slider.Name
                slider.Label.TextColor3 = Library.Theme.Text
                slider.Label.TextSize = 14
                slider.Label.TextXAlignment = Enum.TextXAlignment.Left
                slider.Label.Font = Enum.Font.Gotham
                slider.Label.Parent = slider.Main
                
                -- Slider value label
                slider.ValueLabel = Instance.new("TextLabel")
                slider.ValueLabel.Name = "ValueLabel"
                slider.ValueLabel.Size = UDim2.new(0, 60, 0, 20)
                slider.ValueLabel.Position = UDim2.new(1, -60, 0, 0)
                slider.ValueLabel.BackgroundTransparency = 1
                slider.ValueLabel.Text = tostring(slider.Default)
                slider.ValueLabel.TextColor3 = Library.Theme.LightText
                slider.ValueLabel.TextSize = 14
                slider.ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
                slider.ValueLabel.Font = Enum.Font.Gotham
                slider.ValueLabel.Parent = slider.Main
                
                -- Slider track
                slider.Track = Instance.new("Frame")
                slider.Track.Name = "Track"
                slider.Track.Size = UDim2.new(1, 0, 0, 5)
                slider.Track.Position = UDim2.new(0, 0, 0, 30)
                slider.Track.BackgroundColor3 = Library.Theme.Secondary
                slider.Track.BackgroundTransparency = Library.Theme.ElementTransparency
                slider.Track.Parent = slider.Main
                
                local trackCorner = Instance.new("UICorner")
                trackCorner.CornerRadius = UDim.new(0, 3)
                trackCorner.Parent = slider.Track
                
                -- Slider fill
                slider.Fill = Instance.new("Frame")
                slider.Fill.Name = "Fill"
                slider.Fill.Size = UDim2.new(0, 0, 1, 0)
                slider.Fill.BackgroundColor3 = Library.Theme.Accent
                slider.Fill.Parent = slider.Track
                
                local fillCorner = Instance.new("UICorner")
                fillCorner.CornerRadius = UDim.new(0, 3)
                fillCorner.Parent = slider.Fill
                
                -- Slider button
                slider.Button = Instance.new("TextButton")
                slider.Button.Name = "Button"
                slider.Button.Size = UDim2.new(0, 15, 0, 15)
                slider.Button.Position = UDim2.new(0, 0, 0.5, -7)
                slider.Button.BackgroundColor3 = Library.Theme.Text
                slider.Button.Text = ""
                slider.Button.Parent = slider.Track
                
                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = UDim.new(0, 10)
                buttonCorner.Parent = slider.Button
                
                -- Slider state
                slider.Value = slider.Default
                local sliding = false
                
                -- Set initial state
                local percent = (slider.Value - slider.Min) / (slider.Max - slider.Min)
                slider.Fill.Size = UDim2.new(percent, 0, 1, 0)
                slider.Button.Position = UDim2.new(percent, -7, 0.5, -7)
                slider.ValueLabel.Text = tostring(slider.Value)
                
                -- Slider interaction
                local function updateSlider(input)
                    local pos = UDim2.new(
                        math.clamp((input.Position.X - slider.Track.AbsolutePosition.X) / slider.Track.AbsoluteSize.X, 0, 1), 
                        0, 
                        0.5, 
                        -7
                    )
                    
                    local percent = math.clamp((input.Position.X - slider.Track.AbsolutePosition.X) / slider.Track.AbsoluteSize.X, 0, 1)
                    local value = math.floor((slider.Min + (slider.Max - slider.Min) * percent) * (1/slider.Precision)) / (1/slider.Precision)
                    
                    slider.Value = value
                    slider.Fill.Size = UDim2.new(percent, 0, 1, 0)
                    slider.Button.Position = UDim2.new(percent, -7, 0.5, -7)
                    slider.ValueLabel.Text = tostring(slider.Value)
                    
                    slider.Callback(slider.Value)
                    
                    if Library.Config.AutoSave then
                        Library:SaveConfig()
                    end
                end
                
                slider.Button.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliding = true
                        updateSlider(input)
                    end
                end)
                
                slider.Button.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliding = false
                    end
                end)
                
                slider.Track.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliding = true
                        updateSlider(input)
                    end
                end)
                
                slider.Track.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliding = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement and sliding then
                        updateSlider(input)
                    end
                end)
                
                -- Config integration
                Library.Config.Current[slider.Name] = slider.Value
                
                -- Get value function
                function slider:GetValue()
                    return slider.Value
                end
                
                -- Set value function
                function slider:SetValue(value)
                    value = math.clamp(value, slider.Min, slider.Max)
                    slider.Value = value
                    
                    local percent = (slider.Value - slider.Min) / (slider.Max - slider.Min)
                    Library:Tween(slider.Fill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.2)
                    Library:Tween(slider.Button, {Position = UDim2.new(percent, -7, 0.5, -7)}, 0.2)
                    
                    slider.ValueLabel.Text = tostring(slider.Value)
                    slider.Callback(slider.Value)
                    
                    if Library.Config.AutoSave then
                        Library:SaveConfig()
                    end
                end
                
                return slider
            end
            
            -- Dropdown creation function
            function section:CreateDropdown(options)
                local dropdown = {}
                options = options or {}
                
                dropdown.Name = options.Name or "Dropdown"
                dropdown.Options = options.Options or {}
                dropdown.Default = options.Default or dropdown.Options[1]
                dropdown.Callback = options.Callback or function() end
                dropdown.Multi = options.Multi or false
                
                -- Dropdown container
                dropdown.Main = Instance.new("Frame")
                dropdown.Main.Name = dropdown.Name
                dropdown.Main.Size = UDim2.new(1, 0, 0, 30)
                dropdown.Main.BackgroundTransparency = 1
                dropdown.Main.ClipsDescendants = true
                dropdown.Main.Parent = section.Content
                
                -- Dropdown button
                dropdown.Button = Instance.new("TextButton")
                dropdown.Button.Name = "Button"
                dropdown.Button.Size = UDim2.new(1, 0, 0, 30)
                dropdown.Button.Position = UDim2.new(0, 0, 0, 0)
                dropdown.Button.BackgroundColor3 = Library.Theme.Secondary
                dropdown.Button.BackgroundTransparency = Library.Theme.ElementTransparency
                dropdown.Button.Text = ""
                dropdown.Button.Parent = dropdown.Main
                
                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = UDim.new(0, 6)
                buttonCorner.Parent = dropdown.Button
                
                -- Dropdown label
                dropdown.Label = Instance.new("TextLabel")
                dropdown.Label.Name = "Label"
                dropdown.Label.Size = UDim2.new(1, -30, 1, 0)
                dropdown.Label.Position = UDim2.new(0, 10, 0, 0)
                dropdown.Label.BackgroundTransparency = 1
                dropdown.Label.Text = dropdown.Name
                dropdown.Label.TextColor3 = Library.Theme.Text
                dropdown.Label.TextSize = 14
                dropdown.Label.TextXAlignment = Enum.TextXAlignment.Left
                dropdown.Label.Font = Enum.Font.Gotham
                dropdown.Label.Parent = dropdown.Button
                
                -- Dropdown value label
                dropdown.ValueLabel = Instance.new("TextLabel")
                dropdown.ValueLabel.Name = "ValueLabel"
                dropdown.ValueLabel.Size = UDim2.new(0, 20, 0, 20)
                dropdown.ValueLabel.Position = UDim2.new(1, -25, 0.5, -10)
                dropdown.ValueLabel.BackgroundTransparency = 1
                dropdown.ValueLabel.Text = "▼"
                dropdown.ValueLabel.TextColor3 = Library.Theme.LightText
                dropdown.ValueLabel.TextSize = 14
                dropdown.ValueLabel.Font = Enum.Font.Gotham
                dropdown.ValueLabel.Parent = dropdown.Button
                
                -- Dropdown options container
                dropdown.OptionsFrame = Instance.new("Frame")
                dropdown.OptionsFrame.Name = "Options"
                dropdown.OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
                dropdown.OptionsFrame.Position = UDim2.new(0, 0, 0, 35)
                dropdown.OptionsFrame.BackgroundColor3 = Library.Theme.Secondary
                dropdown.OptionsFrame.BackgroundTransparency = Library.Theme.ElementTransparency
                dropdown.OptionsFrame.Visible = false
                dropdown.OptionsFrame.Parent = dropdown.Main
                
                local optionsCorner = Instance.new("UICorner")
                optionsCorner.CornerRadius = UDim.new(0, 6)
                optionsCorner.Parent = dropdown.OptionsFrame
                
                local optionsList = Instance.new("UIListLayout")
                optionsList.Padding = UDim.new(0, 5)
                optionsList.Parent = dropdown.OptionsFrame
                
                -- Dropdown state
                dropdown.Value = dropdown.Multi and {} or dropdown.Default
                dropdown.Open = false
                
                -- Create options
                for i, option in pairs(dropdown.Options) do
                    local optionButton = Instance.new("TextButton")
                    optionButton.Name = option
                    optionButton.Size = UDim2.new(1, -10, 0, 25)
                    optionButton.Position = UDim2.new(0, 5, 0, 5 + (i-1)*30)
                    optionButton.BackgroundColor3 = Library.Theme.Main
                    optionButton.BackgroundTransparency = Library.Theme.ElementTransparency
                    optionButton.Text = option
                    optionButton.TextColor3 = Library.Theme.Text
                    optionButton.TextSize = 14
                    optionButton.Font = Enum.Font.Gotham
                    optionButton.Parent = dropdown.OptionsFrame
                    
                    local optionCorner = Instance.new("UICorner")
                    optionCorner.CornerRadius = UDim.new(0, 4)
                    optionCorner.Parent = optionButton
                    
                    optionButton.MouseButton1Click:Connect(function()
                        if dropdown.Multi then
                            if table.find(dropdown.Value, option) then
                                table.remove(dropdown.Value, table.find(dropdown.Value, option))
                                Library:Tween(optionButton, {BackgroundColor3 = Library.Theme.Main}, 0.2)
                            else
                                table.insert(dropdown.Value, option)
                                Library:Tween(optionButton, {BackgroundColor3 = Library.Theme.Accent}, 0.2)
                            end
                            
                            local displayText = ""
                            for i, v in pairs(dropdown.Value) do
                                displayText = displayText .. v
                                if i < #dropdown.Value then
                                    displayText = displayText .. ", "
                                end
                            end
                            
                            dropdown.Label.Text = displayText ~= "" and displayText or dropdown.Name
                        else
                            dropdown.Value = option
                            dropdown.Label.Text = option
                            dropdown:Toggle()
                            
                            Library:Tween(optionButton, {BackgroundColor3 = Library.Theme.Accent}, 0.2)
                            
                            for _, otherOption in pairs(dropdown.OptionsFrame:GetChildren()) do
                                if otherOption:IsA("TextButton") and otherOption ~= optionButton then
                                    Library:Tween(otherOption, {BackgroundColor3 = Library.Theme.Main}, 0.2)
                                end
                            end
                        end
                        
                        dropdown.Callback(dropdown.Value)
                        
                        if Library.Config.AutoSave then
                            Library:SaveConfig()
                        end
                    end)
                    
                    -- Set initial selected option
                    if (dropdown.Multi and table.find(dropdown.Default, option)) or (not dropdown.Multi and option == dropdown.Default) then
                        if dropdown.Multi then
                            table.insert(dropdown.Value, option)
                        else
                            dropdown.Value = option
                            dropdown.Label.Text = option
                        end
                        
                        Library:Tween(optionButton, {BackgroundColor3 = Library.Theme.Accent}, 0.2)
                    end
                end
                
                -- Update options frame size
                optionsList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    dropdown.OptionsFrame.Size = UDim2.new(1, 0, 0, optionsList.AbsoluteContentSize.Y + 10)
                end)
                
                -- Toggle dropdown function
                function dropdown:Toggle()
                    dropdown.Open = not dropdown.Open
                    
                    if dropdown.Open then
                        dropdown.OptionsFrame.Visible = true
                        Library:Tween(dropdown.Main, {Size = UDim2.new(1, 0, 0, 30 + dropdown.OptionsFrame.Size.Y.Offset)}, 0.2)
                        Library:Tween(dropdown.ValueLabel, {Rotation = 180}, 0.2)
                    else
                        Library:Tween(dropdown.Main, {Size = UDim2.new(1, 0, 0, 30)}, 0.2)
                        Library:Tween(dropdown.ValueLabel, {Rotation = 0}, 0.2)
                        wait(0.2)
                        dropdown.OptionsFrame.Visible = false
                    end
                end
                
                -- Dropdown click event
                dropdown.Button.MouseButton1Click:Connect(function()
                    dropdown:Toggle()
                end)
                
                -- Config integration
                Library.Config.Current[dropdown.Name] = dropdown.Value
                
                -- Get value function
                function dropdown:GetValue()
                    return dropdown.Value
                end
                
                -- Set value function
                function dropdown:SetValue(value)
                    if dropdown.Multi then
                        dropdown.Value = value
                        
                        local displayText = ""
                        for i, v in pairs(dropdown.Value) do
                            displayText = displayText .. v
                            if i < #dropdown.Value then
                                displayText = displayText .. ", "
                            end
                        end
                        
                        dropdown.Label.Text = displayText ~= "" and displayText or dropdown.Name
                        
                        for _, option in pairs(dropdown.OptionsFrame:GetChildren()) do
                            if option:IsA("TextButton") then
                                if table.find(dropdown.Value, option.Name) then
                                    Library:Tween(option, {BackgroundColor3 = Library.Theme.Accent}, 0.2)
                                else
                                    Library:Tween(option, {BackgroundColor3 = Library.Theme.Main}, 0.2)
                                end
                            end
                        end
                    else
                        dropdown.Value = value
                        dropdown.Label.Text = value
                        
                        for _, option in pairs(dropdown.OptionsFrame:GetChildren()) do
                            if option:IsA("TextButton") then
                                if option.Name == value then
                                    Library:Tween(option, {BackgroundColor3 = Library.Theme.Accent}, 0.2)
                                else
                                    Library:Tween(option, {BackgroundColor3 = Library.Theme.Main}, 0.2)
                                end
                            end
                        end
                    end
                    
                    dropdown.Callback(dropdown.Value)
                    
                    if Library.Config.AutoSave then
                        Library:SaveConfig()
                    end
                end
                
                return dropdown
            end
            
            -- Label creation function
            function section:CreateLabel(text)
                local label = {}
                
                -- Label container
                label.Main = Instance.new("Frame")
                label.Main.Name = "Label"
                label.Main.Size = UDim2.new(1, 0, 0, 20)
                label.Main.BackgroundTransparency = 1
                label.Main.Parent = section.Content
                
                -- Label text
                label.TextLabel = Instance.new("TextLabel")
                label.TextLabel.Name = "Text"
                label.TextLabel.Size = UDim2.new(1, 0, 1, 0)
                label.TextLabel.BackgroundTransparency = 1
                label.TextLabel.Text = text
                label.TextLabel.TextColor3 = Library.Theme.Text
                label.TextLabel.TextSize = 14
                label.TextLabel.TextXAlignment = Enum.TextXAlignment.Left
                label.TextLabel.Font = Enum.Font.Gotham
                label.TextLabel.Parent = label.Main
                
                -- Set text function
                function label:SetText(newText)
                    label.TextLabel.Text = newText
                end
                
                return label
            end
            
            -- Button creation function
            function section:CreateButton(options)
                local button = {}
                options = options or {}
                
                button.Name = options.Name or "Button"
                button.Callback = options.Callback or function() end
                
                -- Button container
                button.Main = Instance.new("TextButton")
                button.Main.Name = button.Name
                button.Main.Size = UDim2.new(1, 0, 0, 30)
                button.Main.BackgroundColor3 = Library.Theme.Secondary
                button.Main.BackgroundTransparency = Library.Theme.ElementTransparency
                button.Main.Text = button.Name
                button.Main.TextColor3 = Library.Theme.Text
                button.Main.TextSize = 14
                button.Main.Font = Enum.Font.Gotham
                button.Main.Parent = section.Content
                
                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = UDim.new(0, 6)
                buttonCorner.Parent = button.Main
                
                -- Button animation
                button.Main.MouseEnter:Connect(function()
                    Library:Tween(button.Main, {BackgroundColor3 = Library.Theme.Accent}, 0.2)
                end)
                
                button.Main.MouseLeave:Connect(function()
                    Library:Tween(button.Main, {BackgroundColor3 = Library.Theme.Secondary}, 0.2)
                end)
                
                button.Main.MouseButton1Click:Connect(function()
                    Library:Tween(button.Main, {Size = UDim2.new(0.95, 0, 0, 28)}, 0.1)
                    Library:Tween(button.Main, {Size = UDim2.new(1, 0, 0, 30)}, 0.1)
                    button.Callback()
                end)
                
                return button
            end
            
            -- Textbox creation function
            function section:CreateTextbox(options)
                local textbox = {}
                options = options or {}
                
                textbox.Name = options.Name or "Textbox"
                textbox.Placeholder = options.Placeholder or "Enter text..."
                textbox.Default = options.Default or ""
                textbox.Callback = options.Callback or function() end
                
                -- Textbox container
                textbox.Main = Instance.new("Frame")
                textbox.Main.Name = textbox.Name
                textbox.Main.Size = UDim2.new(1, 0, 0, 30)
                textbox.Main.BackgroundTransparency = 1
                textbox.Main.Parent = section.Content
                
                -- Textbox label
                textbox.Label = Instance.new("TextLabel")
                textbox.Label.Name = "Label"
                textbox.Label.Size = UDim2.new(1, 0, 0, 15)
                textbox.Label.Position = UDim2.new(0, 0, 0, 0)
                textbox.Label.BackgroundTransparency = 1
                textbox.Label.Text = textbox.Name
                textbox.Label.TextColor3 = Library.Theme.Text
                textbox.Label.TextSize = 14
                textbox.Label.TextXAlignment = Enum.TextXAlignment.Left
                textbox.Label.Font = Enum.Font.Gotham
                textbox.Label.Parent = textbox.Main
                
                -- Textbox input
                textbox.Input = Instance.new("TextBox")
                textbox.Input.Name = "Input"
                textbox.Input.Size = UDim2.new(1, 0, 0, 30)
                textbox.Input.Position = UDim2.new(0, 0, 0, 20)
                textbox.Input.BackgroundColor3 = Library.Theme.Secondary
                textbox.Input.BackgroundTransparency = Library.Theme.ElementTransparency
                textbox.Input.Text = textbox.Default
                textbox.Input.PlaceholderText = textbox.Placeholder
                textbox.Input.TextColor3 = Library.Theme.Text
                textbox.Input.PlaceholderColor3 = Library.Theme.LightText
                textbox.Input.TextSize = 14
                textbox.Input.Font = Enum.Font.Gotham
                textbox.Input.Parent = textbox.Main
                
                local inputCorner = Instance.new("UICorner")
                inputCorner.CornerRadius = UDim.new(0, 6)
                inputCorner.Parent = textbox.Input
                
                -- Textbox state
                textbox.Value = textbox.Default
                
                -- Textbox focus events
                textbox.Input.Focused:Connect(function()
                    Library:Tween(textbox.Input, {BackgroundColor3 = Library.Theme.Accent}, 0.2)
                end)
                
                textbox.Input.FocusLost:Connect(function()
                    Library:Tween(textbox.Input, {BackgroundColor3 = Library.Theme.Secondary}, 0.2)
                    textbox.Value = textbox.Input.Text
                    textbox.Callback(textbox.Value)
                    
                    if Library.Config.AutoSave then
                        Library:SaveConfig()
                    end
                end)
                
                -- Config integration
                Library.Config.Current[textbox.Name] = textbox.Value
                
                -- Get value function
                function textbox:GetValue()
                    return textbox.Value
                end
                
                -- Set value function
                function textbox:SetValue(value)
                    textbox.Value = value
                    textbox.Input.Text = value
                    textbox.Callback(value)
                    
                    if Library.Config.AutoSave then
                        Library:SaveConfig()
                    end
                end
                
                return textbox
            end
            
            -- Keybind creation function
            function section:CreateKeybind(options)
                local keybind = {}
                options = options or {}
                
                keybind.Name = options.Name or "Keybind"
                keybind.Default = options.Default or Enum.KeyCode.Unknown
                keybind.Callback = options.Callback or function() end
                keybind.Block = options.Block or false
                
                -- Keybind container
                keybind.Main = Instance.new("Frame")
                keybind.Main.Name = keybind.Name
                keybind.Main.Size = UDim2.new(1, 0, 0, 30)
                keybind.Main.BackgroundTransparency = 1
                keybind.Main.Parent = section.Content
                
                -- Keybind label
                keybind.Label = Instance.new("TextLabel")
                keybind.Label.Name = "Label"
                keybind.Label.Size = UDim2.new(1, -80, 1, 0)
                keybind.Label.Position = UDim2.new(0, 0, 0, 0)
                keybind.Label.BackgroundTransparency = 1
                keybind.Label.Text = keybind.Name
                keybind.Label.TextColor3 = Library.Theme.Text
                keybind.Label.TextSize = 14
                keybind.Label.TextXAlignment = Enum.TextXAlignment.Left
                keybind.Label.Font = Enum.Font.Gotham
                keybind.Label.Parent = keybind.Main
                
                -- Keybind button
                keybind.Button = Instance.new("TextButton")
                keybind.Button.Name = "Button"
                keybind.Button.Size = UDim2.new(0, 70, 0, 25)
                keybind.Button.Position = UDim2.new(1, -70, 0.5, -12)
                keybind.Button.BackgroundColor3 = Library.Theme.Secondary
                keybind.Button.BackgroundTransparency = Library.Theme.ElementTransparency
                keybind.Button.Text = keybind.Default.Name or "None"
                keybind.Button.TextColor3 = Library.Theme.Text
                keybind.Button.TextSize = 14
                keybind.Button.Font = Enum.Font.Gotham
                keybind.Button.Parent = keybind.Main
                
                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = UDim.new(0, 6)
                buttonCorner.Parent = keybind.Button
                
                -- Keybind state
                keybind.Value = keybind.Default
                keybind.Listening = false
                keybind.Connection = nil
                
                -- Keybind click event
                keybind.Button.MouseButton1Click:Connect(function()
                    keybind.Listening = true
                    keybind.Button.Text = "..."
                    keybind.Button.BackgroundColor3 = Library.Theme.Accent
                    
                    local connection
                    connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                        if gameProcessed then return end
                        
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            keybind.Value = input.KeyCode
                            keybind.Button.Text = input.KeyCode.Name
                            keybind.Listening = false
                            Library:Tween(keybind.Button, {BackgroundColor3 = Library.Theme.Secondary}, 0.2)
                            connection:Disconnect()
                        end
                    end)
                end)
                
                -- Keybind connection
                keybind.Connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if gameProcessed and keybind.Block then return end
                    
                    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == keybind.Value then
                        keybind.Callback()
                    end
                end)
                
                -- Config integration
                Library.Config.Current[keybind.Name] = keybind.Value
                
                -- Get value function
                function keybind:GetValue()
                    return keybind.Value
                end
                
                -- Set value function
                function keybind:SetValue(value)
                    keybind.Value = value
                    keybind.Button.Text = value.Name
                    keybind.Callback()
                    
                    if Library.Config.AutoSave then
                        Library:SaveConfig()
                    end
                end
                
                return keybind
            end
            
            -- Color picker creation function
            function section:CreateColorPicker(options)
                local colorPicker = {}
                options = options or {}
                
                colorPicker.Name = options.Name or "ColorPicker"
                colorPicker.Default = options.Default or Library.Theme.Accent
                colorPicker.Callback = options.Callback or function() end
                
                -- Color picker container
                colorPicker.Main = Instance.new("Frame")
                colorPicker.Main.Name = colorPicker.Name
                colorPicker.Main.Size = UDim2.new(1, 0, 0, 30)
                colorPicker.Main.BackgroundTransparency = 1
                colorPicker.Main.Parent = section.Content
                
                -- Color picker label
                colorPicker.Label = Instance.new("TextLabel")
                colorPicker.Label.Name = "Label"
                colorPicker.Label.Size = UDim2.new(1, -50, 1, 0)
                colorPicker.Label.Position = UDim2.new(0, 0, 0, 0)
                colorPicker.Label.BackgroundTransparency = 1
                colorPicker.Label.Text = colorPicker.Name
                colorPicker.Label.TextColor3 = Library.Theme.Text
                colorPicker.Label.TextSize = 14
                colorPicker.Label.TextXAlignment = Enum.TextXAlignment.Left
                colorPicker.Label.Font = Enum.Font.Gotham
                colorPicker.Label.Parent = colorPicker.Main
                
                -- Color picker button
                colorPicker.Button = Instance.new("TextButton")
                colorPicker.Button.Name = "Button"
                colorPicker.Button.Size = UDim2.new(0, 40, 0, 25)
                colorPicker.Button.Position = UDim2.new(1, -40, 0.5, -12)
                colorPicker.Button.BackgroundColor3 = colorPicker.Default
                colorPicker.Button.Text = ""
                colorPicker.Button.Parent = colorPicker.Main
                
                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = UDim.new(0, 6)
                buttonCorner.Parent = colorPicker.Button
                
                -- Color picker popup
                colorPicker.Popup = Instance.new("Frame")
                colorPicker.Popup.Name = "Popup"
                colorPicker.Popup.Size = UDim2.new(0, 200, 0, 180)
                colorPicker.Popup.Position = UDim2.new(1, 10, 0, 0)
                colorPicker.Popup.BackgroundColor3 = Library.Theme.Main
                colorPicker.Popup.BackgroundTransparency = Library.Theme.BackgroundTransparency
                colorPicker.Popup.Visible = false
                colorPicker.Popup.Parent = colorPicker.Main
                
                local popupCorner = Instance.new("UICorner")
                popupCorner.CornerRadius = UDim.new(0, 8)
                popupCorner.Parent = colorPicker.Popup
                
                local popupStroke = Instance.new("UIStroke")
                popupStroke.Color = Library.Theme.Accent
                popupStroke.Thickness = 1
                popupStroke.Transparency = 0.7
                popupStroke.Parent = colorPicker.Popup
                
                -- Color spectrum
                colorPicker.Spectrum = Instance.new("ImageButton")
                colorPicker.Spectrum.Name = "Spectrum"
                colorPicker.Spectrum.Size = UDim2.new(0, 150, 0, 150)
                colorPicker.Spectrum.Position = UDim2.new(0, 10, 0, 10)
                colorPicker.Spectrum.Image = "rbxassetid://2615689005"
                colorPicker.Spectrum.Parent = colorPicker.Popup
                
                -- Color spectrum cursor
                colorPicker.Cursor = Instance.new("Frame")
                colorPicker.Cursor.Name = "Cursor"
                colorPicker.Cursor.Size = UDim2.new(0, 5, 0, 5)
                colorPicker.Cursor.BackgroundColor3 = Color3.new(1, 1, 1)
                colorPicker.Cursor.BorderSizePixel = 2
                colorPicker.Cursor.BorderColor3 = Color3.new(0, 0, 0)
                colorPicker.Cursor.Parent = colorPicker.Spectrum
                
                -- Hue slider
                colorPicker.Hue = Instance.new("ImageButton")
                colorPicker.Hue.Name = "Hue"
                colorPicker.Hue.Size = UDim2.new(0, 20, 0, 150)
                colorPicker.Hue.Position = UDim2.new(0, 170, 0, 10)
                colorPicker.Hue.Image = "rbxassetid://2615692420"
                colorPicker.Hue.Parent = colorPicker.Popup
                
                -- Hue slider cursor
                colorPicker.HueCursor = Instance.new("Frame")
                colorPicker.HueCursor.Name = "HueCursor"
                colorPicker.HueCursor.Size = UDim2.new(1, 0, 0, 2)
                colorPicker.HueCursor.BackgroundColor3 = Color3.new(1, 1, 1)
                colorPicker.HueCursor.BorderSizePixel = 1
                colorPicker.HueCursor.BorderColor3 = Color3.new(0, 0, 0)
                colorPicker.HueCursor.Parent = colorPicker.Hue
                
                -- Current color display
                colorPicker.Current = Instance.new("Frame")
                colorPicker.Current.Name = "Current"
                colorPicker.Current.Size = UDim2.new(0, 40, 0, 20)
                colorPicker.Current.Position = UDim2.new(0, 10, 0, 170)
                colorPicker.Current.BackgroundColor3 = colorPicker.Default
                colorPicker.Current.Parent = colorPicker.Popup
                
                local currentCorner = Instance.new("UICorner")
                currentCorner.CornerRadius = UDim.new(0, 4)
                currentCorner.Parent = colorPicker.Current
                
                -- Hex input
                colorPicker.Hex = Instance.new("TextBox")
                colorPicker.Hex.Name = "Hex"
                colorPicker.Hex.Size = UDim2.new(0, 80, 0, 20)
                colorPicker.Hex.Position = UDim2.new(0, 60, 0, 170)
                colorPicker.Hex.BackgroundColor3 = Library.Theme.Secondary
                colorPicker.Hex.BackgroundTransparency = Library.Theme.ElementTransparency
                colorPicker.Hex.Text = "#" .. self:ToHex(colorPicker.Default)
                colorPicker.Hex.TextColor3 = Library.Theme.Text
                colorPicker.Hex.TextSize = 14
                colorPicker.Hex.Font = Enum.Font.Gotham
                colorPicker.Hex.Parent = colorPicker.Popup
                
                local hexCorner = Instance.new("UICorner")
                hexCorner.CornerRadius = UDim.new(0, 4)
                hexCorner.Parent = colorPicker.Hex
                
                -- RGB inputs
                colorPicker.R = self:CreateRGBInput("R", 0, 10, 140, colorPicker.Popup)
                colorPicker.G = self:CreateRGBInput("G", 1, 60, 140, colorPicker.Popup)
                colorPicker.B = self:CreateRGBInput("B", 2, 110, 140, colorPicker.Popup)
                
                -- Color picker state
                colorPicker.Value = colorPicker.Default
                colorPicker.HueValue = 0
                colorPicker.SatValue = 0
                colorPicker.VibValue = 0
                
                -- Set initial color
                self:SetColorFromRGB(colorPicker.Default)
                
                -- Color picker click event
                colorPicker.Button.MouseButton1Click:Connect(function()
                    colorPicker.Popup.Visible = not colorPicker.Popup.Visible
                end)
                
                -- Spectrum interaction
                colorPicker.Spectrum.MouseButton1Down:Connect(function(x, y)
                    local moving = true
                    
                    local function update(x, y)
                        local relX = math.clamp(x - colorPicker.Spectrum.AbsolutePosition.X, 0, colorPicker.Spectrum.AbsoluteSize.X) / colorPicker.Spectrum.AbsoluteSize.X
                        local relY = math.clamp(y - colorPicker.Spectrum.AbsolutePosition.Y, 0, colorPicker.Spectrum.AbsoluteSize.Y) / colorPicker.Spectrum.AbsoluteSize.Y
                        
                        colorPicker.SatValue = relX
                        colorPicker.VibValue = 1 - relY
                        
                        colorPicker.Cursor.Position = UDim2.new(relX, -2, relY, -2)
                        
                        self:UpdateColorFromHSV()
                    end
                    
                    update(x, y)
                    
                    local connection
                    connection = UserInputService.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement and moving then
                            update(input.Position.X, input.Position.Y)
                        end
                    end)
                    
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            moving = false
                            connection:Disconnect()
                        end
                    end)
                end)
                
                -- Hue slider interaction
                colorPicker.Hue.MouseButton1Down:Connect(function(x, y)
                    local moving = true
                    
                    local function update(y)
                        local relY = math.clamp(y - colorPicker.Hue.AbsolutePosition.Y, 0, colorPicker.Hue.AbsoluteSize.Y) / colorPicker.Hue.AbsoluteSize.Y
                        
                        colorPicker.HueValue = 1 - relY
                        
                        colorPicker.HueCursor.Position = UDim2.new(0, 0, relY, -1)
                        
                        self:UpdateColorFromHSV()
                    end
                    
                    update(y)
                    
                    local connection
                    connection = UserInputService.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement and moving then
                            update(input.Position.Y)
                        end
                    end)
                    
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            moving = false
                            connection:Disconnect()
                        end
                    end)
                end)
                
                -- Hex input event
                colorPicker.Hex.FocusLost:Connect(function()
                    local hex = colorPicker.Hex.Text:gsub("#", "")
                    if hex:match("^[0-9A-Fa-f]+$") and #hex == 6 then
                        local r = tonumber(hex:sub(1, 2), 16) / 255
                        local g = tonumber(hex:sub(3, 4), 16) / 255
                        local b = tonumber(hex:sub(5, 6), 16) / 255
                        
                        self:SetColorFromRGB(Color3.new(r, g, b))
                    else
                        colorPicker.Hex.Text = "#" .. self:ToHex(colorPicker.Value)
                    end
                end)
                
                -- RGB input events
                for i, component in pairs({"R", "G", "B"}) do
                    colorPicker[component].FocusLost:Connect(function()
                        local value = tonumber(colorPicker[component].Text) or 0
                        value = math.clamp(value, 0, 255)
                        colorPicker[component].Text = tostring(value)
                        
                        local r = tonumber(colorPicker.R.Text) or 0
                        local g = tonumber(colorPicker.G.Text) or 0
                        local b = tonumber(colorPicker.B.Text) or 0
                        
                        self:SetColorFromRGB(Color3.fromRGB(r, g, b))
                    end)
                end
                
                -- Config integration
                Library.Config.Current[colorPicker.Name] = colorPicker.Value
                
                -- Get value function
                function colorPicker:GetValue()
                    return colorPicker.Value
                end
                
                -- Set value function
                function colorPicker:SetValue(value)
                    self:SetColorFromRGB(value)
                    colorPicker.Callback(colorPicker.Value)
                    
                    if Library.Config.AutoSave then
                        Library:SaveConfig()
                    end
                end
                
                -- Helper functions
                function colorPicker:ToHex(color)
                    return string.format("%02X%02X%02X", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))
                end
                
                function colorPicker:CreateRGBInput(name, index, x, y, parent)
                    local input = Instance.new("TextBox")
                    input.Name = name
                    input.Size = UDim2.new(0, 40, 0, 20)
                    input.Position = UDim2.new(0, x, 0, y)
                    input.BackgroundColor3 = Library.Theme.Secondary
                    input.BackgroundTransparency = Library.Theme.ElementTransparency
                    input.Text = "0"
                    input.TextColor3 = Library.Theme.Text
                    input.TextSize = 14
                    input.Font = Enum.Font.Gotham
                    input.Parent = parent
                    
                    local label = Instance.new("TextLabel")
                    label.Name = name .. "Label"
                    label.Size = UDim2.new(0, 10, 0, 20)
                    label.Position = UDim2.new(0, x + 45, 0, y)
                    label.BackgroundTransparency = 1
                    label.Text = name
                    label.TextColor3 = Library.Theme.Text
                    label.TextSize = 14
                    label.Font = Enum.Font.Gotham
                    label.Parent = parent
                    
                    local corner = Instance.new("UICorner")
                    corner.CornerRadius = UDim.new(0, 4)
                    corner.Parent = input
                    
                    return input
                end
                
                function colorPicker:UpdateColorFromHSV()
                    colorPicker.Value = Color3.fromHSV(colorPicker.HueValue, colorPicker.SatValue, colorPicker.VibValue)
                    
                    colorPicker.Button.BackgroundColor3 = colorPicker.Value
                    colorPicker.Current.BackgroundColor3 = colorPicker.Value
                    colorPicker.Hex.Text = "#" .. self:ToHex(colorPicker.Value)
                    
                    colorPicker.R.Text = tostring(math.floor(colorPicker.Value.R * 255))
                    colorPicker.G.Text = tostring(math.floor(colorPicker.Value.G * 255))
                    colorPicker.B.Text = tostring(math.floor(colorPicker.Value.B * 255))
                    
                    colorPicker.Callback(colorPicker.Value)
                    
                    if Library.Config.AutoSave then
                        Library:SaveConfig()
                    end
                end
                
                function colorPicker:SetColorFromRGB(color)
                    colorPicker.Value = color
                    
                    local h, s, v = color:ToHSV()
                    colorPicker.HueValue = h
                    colorPicker.SatValue = s
                    colorPicker.VibValue = v
                    
                    colorPicker.Button.BackgroundColor3 = color
                    colorPicker.Current.BackgroundColor3 = color
                    colorPicker.Hex.Text = "#" .. self:ToHex(color)
                    
                    colorPicker.R.Text = tostring(math.floor(color.R * 255))
                    colorPicker.G.Text = tostring(math.floor(color.G * 255))
                    colorPicker.B.Text = tostring(math.floor(color.B * 255))
                    
                    colorPicker.Cursor.Position = UDim2.new(s, -2, 1 - v, -2)
                    colorPicker.HueCursor.Position = UDim2.new(0, 0, 1 - h, -1)
                end
                
                return colorPicker
            end
            
            return section
        end
        
        return tab
    end
    
    return window
end

-- Notification function
function Library:Notify(options)
    local notification = {}
    options = options or {}
    
    notification.Title = options.Title or "Notification"
    notification.Text = options.Text or "This is a notification"
    notification.Duration = options.Duration or Library.Notifications.Duration
    notification.Type = options.Type or "Default" -- Default, Success, Error, Warning
    
    -- Create notification
    notification.Main = Instance.new("Frame")
    notification.Main.Name = "Notification"
    notification.Main.Size = UDim2.new(0, 280, 0, 80)
    notification.Main.Position = UDim2.new(1, 0, 0, (#Library.Notifications.List * 90))
    notification.Main.BackgroundColor3 = Library.Theme.Main
    notification.Main.BackgroundTransparency = Library.Theme.BackgroundTransparency
    notification.Main.Parent = self.NotificationHolder
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notification.Main
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Library.Theme.Accent
    stroke.Thickness = 1
    stroke.Transparency = 0.7
    stroke.Parent = notification.Main
    
    -- Notification icon based on type
    notification.Icon = Instance.new("TextLabel")
    notification.Icon.Name = "Icon"
    notification.Icon.Size = UDim2.new(0, 30, 0, 30)
    notification.Icon.Position = UDim2.new(0, 10, 0, 10)
    notification.Icon.BackgroundTransparency = 1
    notification.Icon.Text = "💡"
    notification.Icon.TextColor3 = Library.Theme.Text
    notification.Icon.TextSize = 20
    notification.Icon.Font = Enum.Font.Gotham
    notification.Icon.Parent = notification.Main
    
    if notification.Type == "Success" then
        notification.Icon.Text = "✅"
        stroke.Color = Library.Theme.Success
    elseif notification.Type == "Error" then
        notification.Icon.Text = "❌"
        stroke.Color = Library.Theme.Error
    elseif notification.Type == "Warning" then
        notification.Icon.Text = "⚠️"
        stroke.Color = Library.Theme.Warning
    end
    
    -- Notification title
    notification.TitleLabel = Instance.new("TextLabel")
    notification.TitleLabel.Name = "Title"
    notification.TitleLabel.Size = UDim2.new(1, -50, 0, 20)
    notification.TitleLabel.Position = UDim2.new(0, 50, 0, 10)
    notification.TitleLabel.BackgroundTransparency = 1
    notification.TitleLabel.Text = notification.Title
    notification.TitleLabel.TextColor3 = Library.Theme.Text
    notification.TitleLabel.TextSize = 16
    notification.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    notification.TitleLabel.Font = Enum.Font.GothamSemibold
    notification.TitleLabel.Parent = notification.Main
    
    -- Notification text
    notification.TextLabel = Instance.new("TextLabel")
    notification.TextLabel.Name = "Text"
    notification.TextLabel.Size = UDim2.new(1, -20, 0, 40)
    notification.TextLabel.Position = UDim2.new(0, 10, 0, 40)
    notification.TextLabel.BackgroundTransparency = 1
    notification.TextLabel.Text = notification.Text
    notification.TextLabel.TextColor3 = Library.Theme.LightText
    notification.TextLabel.TextSize = 14
    notification.TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    notification.TextLabel.TextYAlignment = Enum.TextYAlignment.Top
    notification.TextLabel.Font = Enum.Font.Gotham
    notification.TextLabel.Parent = notification.Main
    
    -- Close button
    notification.CloseButton = Instance.new("TextButton")
    notification.CloseButton.Name = "CloseButton"
    notification.CloseButton.Size = UDim2.new(0, 20, 0, 20)
    notification.CloseButton.Position = UDim2.new(1, -25, 0, 10)
    notification.CloseButton.BackgroundTransparency = 1
    notification.CloseButton.Text = "X"
    notification.CloseButton.TextColor3 = Library.Theme.Text
    notification.CloseButton.TextSize = 14
    notification.CloseButton.Font = Enum.Font.GothamBold
    notification.CloseButton.Parent = notification.Main
    
    notification.CloseButton.MouseEnter:Connect(function()
        Library:Tween(notification.CloseButton, {TextColor3 = Library.Theme.Error}, 0.2)
    end)
    
    notification.CloseButton.MouseLeave:Connect(function()
        Library:Tween(notification.CloseButton, {TextColor3 = Library.Theme.Text}, 0.2)
    end)
    
    -- Add to notifications list
    table.insert(Library.Notifications.List, notification)
    
    -- Animate in
    Library:Tween(notification.Main, {Position = UDim2.new(1, -290, 0, (#Library.Notifications.List * 90))}, 0.3)
    
    -- Close function
    local function close()
        Library:Tween(notification.Main, {Position = UDim2.new(1, 0, 0, notification.Main.Position.Y.Offset)}, 0.3)
        wait(0.3)
        notification.Main:Destroy()
        
        for i, notif in pairs(Library.Notifications.List) do
            if notif == notification then
                table.remove(Library.Notifications.List, i)
                break
            end
        end
        
        -- Update positions of remaining notifications
        for i, notif in pairs(Library.Notifications.List) do
            Library:Tween(notif.Main, {Position = UDim2.new(1, -290, 0, (i * 90))}, 0.3)
        end
    end
    
    notification.CloseButton.MouseButton1Click:Connect(close)
    
    -- Auto close after duration
    if notification.Duration > 0 then
        delay(notification.Duration, close)
    end
    
    return notification
end

-- Config management functions
function Library:SaveConfig(name)
    name = name or "default"
    
    if not isfolder(Library.Config.FolderName) then
        makefolder(Library.Config.FolderName)
    end
    
    local config = {}
    
    for key, value in pairs(Library.Config.Current) do
        if not table.find(Library.Config.IgnoreList, key) then
            if typeof(value) == "Color3" then
                config[key] = {value.R, value.G, value.B}
            else
                config[key] = value
            end
        end
    end
    
    writefile(Library.Config.FolderName .. "/" .. name .. ".json", game:GetService("HttpService"):JSONEncode(config))
    
    self:Notify({
        Title = "Config Saved",
        Text = "Configuration '" .. name .. "' has been saved successfully.",
        Type = "Success",
        Duration = 3
    })
end

function Library:LoadConfig(name)
    name = name or "default"
    
    if not isfolder(Library.Config.FolderName) then
        self:Notify({
            Title = "Config Error",
            Text = "No configurations found.",
            Type = "Error",
            Duration = 3
        })
        return false
    end
    
    if not isfile(Library.Config.FolderName .. "/" .. name .. ".json") then
        self:Notify({
            Title = "Config Error",
            Text = "Configuration '" .. name .. "' not found.",
            Type = "Error",
            Duration = 3
        })
        return false
    end
    
    local success, config = pcall(function()
        return game:GetService("HttpService"):JSONDecode(readfile(Library.Config.FolderName .. "/" .. name .. ".json"))
    end)
    
    if not success then
        self:Notify({
            Title = "Config Error",
            Text = "Failed to load configuration '" .. name .. "'.",
            Type = "Error",
            Duration = 3
        })
        return false
    end
    
    for key, value in pairs(config) do
        if Library.Config.Current[key] ~= nil then
            if typeof(Library.Config.Current[key]) == "Color3" then
                Library.Config.Current[key] = Color3.new(value[1], value[2], value[3])
            else
                Library.Config.Current[key] = value
            end
        end
    end
    
    self:Notify({
        Title = "Config Loaded",
        Text = "Configuration '" .. name .. "' has been loaded successfully.",
        Type = "Success",
        Duration = 3
    })
    
    return true
end

function Library:DeleteConfig(name)
    name = name or "default"
    
    if not isfolder(Library.Config.FolderName) then
        self:Notify({
            Title = "Config Error",
            Text = "No configurations found.",
            Type = "Error",
            Duration = 3
        })
        return false
    end
    
    if not isfile(Library.Config.FolderName .. "/" .. name .. ".json") then
        self:Notify({
            Title = "Config Error",
            Text = "Configuration '" .. name .. "' not found.",
            Type = "Error",
            Duration = 3
        })
        return false
    end
    
    delfile(Library.Config.FolderName .. "/" .. name .. ".json")
    
    self:Notify({
        Title = "Config Deleted",
        Text = "Configuration '" .. name .. "' has been deleted successfully.",
        Type = "Success",
        Duration = 3
    })
    
    return true
end

function Library:GetConfigs()
    if not isfolder(Library.Config.FolderName) then
        return {}
    end
    
    local configs = {}
    
    for _, file in pairs(listfiles(Library.Config.FolderName)) do
        if file:sub(-5) == ".json" then
            local name = file:match("^.+/(.+)%..+$")
            table.insert(configs, name)
        end
    end
    
    return configs
end

-- Tween helper function
function Library:Tween(object, properties, duration)
    local tweenInfo = TweenInfo.new(
        duration or Library.Animations.Duration,
        Library.Animations.EaseOut
    )
    
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    
    return tween
end

-- Initialize library
Library:CreateUI()

return Library
