-- Образовательный скрипт для Xeno - Расширенная версия
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Ожидание загрузки персонажа
repeat wait() until player.Character and player.Character:FindFirstChild("HumanoidRootPart")

-- Создание GUI меню
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local FollowBtn = Instance.new("TextButton")
local InvisibleBtn = Instance.new("TextButton")
local GodModeBtn = Instance.new("TextButton")
local AutoShootBtn = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "XenoEduMenu"
ScreenGui.ResetOnSpawn = false

-- Основное окно
MainFrame.Size = UDim2.new(0, 220, 0, 250)
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(80, 80, 100)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Заголовок
Title.Size = UDim2.new(0, 200, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 10)
Title.Text = "🎮 Xeno Учебное Меню"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = MainFrame

-- Переменные для функций
local isFollowing = false
local isInvisible = false
local isGodMode = false
local isAutoShoot = false
local followConnection
local godModeConnection
local autoShootConnection

-- Функция поиска ближайшего игрока
local function findClosestPlayer()
    local closestPlayer = nil
    local closestDistance = math.huge
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (plr.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestPlayer = plr
            end
        end
    end
    
    return closestPlayer
end

-- Кнопка Следование (СЛ)
FollowBtn.Size = UDim2.new(0, 200, 0, 35)
FollowBtn.Position = UDim2.new(0, 10, 0, 50)
FollowBtn.Text = "👥 СЛ (Следование)"
FollowBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
FollowBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FollowBtn.BorderSizePixel = 1
FollowBtn.BorderColor3 = Color3.fromRGB(100, 100, 120)
FollowBtn.Font = Enum.Font.Gotham
FollowBtn.TextSize = 12
FollowBtn.Parent = MainFrame
FollowBtn.MouseButton1Click:Connect(function()
    isFollowing = not isFollowing
    
    if isFollowing then
        FollowBtn.BackgroundColor3 = Color3.fromRGB(80, 120, 80)
        FollowBtn.Text = "👥 СЛ [ВКЛ]"
        
        -- Запуск следования
        followConnection = RunService.Heartbeat:Connect(function()
            if not isFollowing or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                return
            end
            
            local targetPlayer = findClosestPlayer()
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local targetPos = targetPlayer.Character.HumanoidRootPart.Position
                local targetCFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                
                -- Позиция за спиной игрока (сзади на расстоянии 3 studs)
                local behindPosition = targetCFrame:ToWorldSpace(CFrame.new(0, 0, -3)).Position
                
                -- Плавное перемещение к позиции за спиной
                player.Character.HumanoidRootPart.CFrame = CFrame.new(behindPosition, targetPos)
                
                -- Автоматическое движение к цели
                player.Character.Humanoid:MoveTo(behindPosition)
            end
        end)
        
        print("Режим следования: ВКЛ - Следуем за ближайшим игроком")
        
    else
        FollowBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        FollowBtn.Text = "👥 СЛ (Следование)"
        
        -- Остановка следования
        if followConnection then
            followConnection:Disconnect()
        end
        
        print("Режим следования: ВЫКЛ")
    end
end)

-- Кнопка Невидимка
InvisibleBtn.Size = UDim2.new(0, 200, 0, 35)
InvisibleBtn.Position = UDim2.new(0, 10, 0, 95)
InvisibleBtn.Text = "👻 Невидимка"
InvisibleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
InvisibleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
InvisibleBtn.BorderSizePixel = 1
InvisibleBtn.BorderColor3 = Color3.fromRGB(100, 100, 120)
InvisibleBtn.Font = Enum.Font.Gotham
InvisibleBtn.TextSize = 12
InvisibleBtn.Parent = MainFrame
InvisibleBtn.MouseButton1Click:Connect(function()
    isInvisible = not isInvisible
    
    if isInvisible then
        InvisibleBtn.BackgroundColor3 = Color3.fromRGB(80, 120, 80)
        InvisibleBtn.Text = "👻 Невидимка [ВКЛ]"
        
        -- Включение невидимости
        for _, part in pairs(player.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = 1  -- Полная прозрачность
                if part:FindFirstChildOfClass("Decal") then
                    part:FindFirstChildOfClass("Decal").Transparency = 1
                end
            elseif part:IsA("Accessory") and part:FindFirstChild("Handle") then
                part.Handle.Transparency = 1
            end
        end
        
        -- Скрытие имени игрока
        if player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        end
        
        print("Режим невидимости: ВКЛ - Тебя никто не видит")
        
    else
        InvisibleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        InvisibleBtn.Text = "👻 Невидимка"
        
        -- Выключение невидимости
        for _, part in pairs(player.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = 0  -- Полная видимость
                if part:FindFirstChildOfClass("Decal") then
                    part:FindFirstChildOfClass("Decal").Transparency = 0
                end
            elseif part:IsA("Accessory") and part:FindFirstChild("Handle") then
                part.Handle.Transparency = 0
            end
        end
        
        -- Восстановление имени игрока
        if player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
        end
        
        print("Режим невидимости: ВЫКЛ")
    end
end)

-- Кнопка Бессмертие
GodModeBtn.Size = UDim2.new(0, 200, 0, 35)
GodModeBtn.Position = UDim2.new(0, 10, 0, 140)
GodModeBtn.Text = "💪 Бессмертие"
GodModeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
GodModeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GodModeBtn.BorderSizePixel = 1
GodModeBtn.BorderColor3 = Color3.fromRGB(100, 100, 120)
GodModeBtn.Font = Enum.Font.Gotham
GodModeBtn.TextSize = 12
GodModeBtn.Parent = MainFrame
GodModeBtn.MouseButton1Click:Connect(function()
    isGodMode = not isGodMode
    
    if isGodMode then
        GodModeBtn.BackgroundColor3 = Color3.fromRGB(80, 120, 80)
        GodModeBtn.Text = "💪 Бессмертие [ВКЛ]"
        
        -- Включение бессмертия
        godModeConnection = RunService.Heartbeat:Connect(function()
            if not isGodMode or not player.Character then return end
            
            -- Бесконечное здоровье
            if player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.Health = player.Character.Humanoid.MaxHealth
                player.Character.Humanoid.MaxHealth = math.huge
            end
            
            -- Защита от урона
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                    part.Material = Enum.Material.Neon
                end
            end
        end)
        
        print("Режим бессмертия: ВКЛ - Здоровье бесконечное")
        
    else
        GodModeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        GodModeBtn.Text = "💪 Бессмертие"
        
        -- Выключение бессмертия
        if godModeConnection then
            godModeConnection:Disconnect()
        end
        
        -- Восстановление нормального здоровья
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.MaxHealth = 100
            player.Character.Humanoid.Health = 100
        end
        
        print("Режим бессмертия: ВЫКЛ")
    end
end)

-- Кнопка Авто-стрельба
AutoShootBtn.Size = UDim2.new(0, 200, 0, 35)
AutoShootBtn.Position = UDim2.new(0, 10, 0, 185)
AutoShootBtn.Text = "🔫 Авто-Стрельба"
AutoShootBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
AutoShootBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoShootBtn.BorderSizePixel = 1
AutoShootBtn.BorderColor3 = Color3.fromRGB(100, 100, 120)
AutoShootBtn.Font = Enum.Font.Gotham
AutoShootBtn.TextSize = 12
AutoShootBtn.Parent = MainFrame
AutoShootBtn.MouseButton1Click:Connect(function()
    isAutoShoot = not isAutoShoot
    
    if isAutoShoot then
        AutoShootBtn.BackgroundColor3 = Color3.fromRGB(80, 120, 80)
        AutoShootBtn.Text = "🔫 Авто-Стрельба [ВКЛ]"
        
        -- Автоматическая стрельба по врагам
        autoShootConnection = RunService.Heartbeat:Connect(function()
            if not isAutoShoot or not player.Character then return end
            
            local targetPlayer = findClosestPlayer()
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                -- Наведение на цель
                local targetPos = targetPlayer.Character.HumanoidRootPart.Position
                player.Character.HumanoidRootPart.CFrame = CFrame.lookAt(
                    player.Character.HumanoidRootPart.Position,
                    Vector3.new(targetPos.X, player.Character.HumanoidRootPart.Position.Y, targetPos.Z)
                )
                
                -- Симуляция стрельбы (эмуляция нажатия мыши)
                if player.Character:FindFirstChildOfClass("Tool") then
                    -- Активация инструмента для стрельбы
                    for _, tool in pairs(player.Character:GetChildren()) do
                        if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                            tool:Activate()
                        end
                    end
                end
            end
        end)
        
        print("Авто-стрельба: ВКЛ - Автоматическая стрельба по врагам")
        
    else
        AutoShootBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        AutoShootBtn.Text = "🔫 Авто-Стрельба"
        
        -- Выключение авто-стрельбы
        if autoShootConnection then
            autoShootConnection:Disconnect()
        end
        
        print("Авто-стрельба: ВЫКЛ")
    end
end)

-- Автоматическое восстановление при респавне
player.CharacterAdded:Connect(function(character)
    wait(1) -- Ждем полной загрузки персонажа
    
    -- Восстанавливаем невидимость если была активна
    if isInvisible then
        wait(0.5)
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            elseif part:IsA("Accessory") and part:FindFirstChild("Handle") then
                part.Handle.Transparency = 1
            end
        end
    end
    
    -- Восстанавливаем бессмертие если было активно
    if isGodMode then
        wait(0.5)
        if godModeConnection then
            godModeConnection:Disconnect()
        end
        godModeConnection = RunService.Heartbeat:Connect(function()
            if character:FindFirstChild("Humanoid") then
                character.Humanoid.Health = character.Humanoid.MaxHealth
                character.Humanoid.MaxHealth = math.huge
            end
        end)
    end
end)

-- Горячие клавиши
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F1 then
        -- F1 - переключение следования
        FollowBtn:MouseButton1Click()
    elseif input.KeyCode == Enum.KeyCode.F2 then
        -- F2 - переключение невидимости
        InvisibleBtn:MouseButton1Click()
    elseif input.KeyCode == Enum.KeyCode.F3 then
        -- F3 - переключение бессмертия
        GodModeBtn:MouseButton1Click()
    elseif input.KeyCode == Enum.KeyCode.F4 then
        -- F4 - переключение авто-стрельбы
        AutoShootBtn:MouseButton1Click()
    elseif input.KeyCode == Enum.KeyCode.RightShift then
        -- Скрытие/показание меню
        MainFrame.Visible = not MainFrame.Visible
    end
end)

print("🎮 Xeno Учебное меню загружено успешно!")
print("📌 Функции:")
print("   👥 СЛ - Следование за ближайшим игроком")
print("   👻 Невидимка - Полная невидимость")
print("   💪 Бессмертие - Бесконечное здоровье")
print("   🔫 Авто-Стрельба - Автоматическая стрельба по врагам")
print("")
print("📋 Горячие клавиши:")
print("   F1 - Следование")
print("   F2 - Невидимка")
print("   F3 - Бессмертие")
print("   F4 - Авто-Стрельба")
print("   RightShift - Скрыть меню")
print("")
print("⚠️ Используется только для образовательных целей в контролируемой среде!")
