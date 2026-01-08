-- ORION Menu UI para Roblox - Versão Mobile Corrigida
-- Cole este código em um LocalScript dentro de StarterPlayerScripts ou StarterGui

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Detecção de mobile melhorada
local function isMobile()
	local hasTouch = UserInputService.TouchEnabled
	local hasKeyboard = UserInputService.KeyboardEnabled
	local camera = workspace.CurrentCamera
	local viewportSize = camera and camera.ViewportSize or Vector2.new(1920, 1080)
	local isSmallScreen = math.min(viewportSize.X, viewportSize.Y) < 800
	return (hasTouch and not hasKeyboard) or (hasTouch and isSmallScreen)
end

local function getScreenSize()
	local camera = workspace.CurrentCamera
	if camera then
		return camera.ViewportSize
	end
	return Vector2.new(1920, 1080)
end

local IS_MOBILE = isMobile()
local screenSize = getScreenSize()

local function updateScreenSize()
	screenSize = getScreenSize()
end

if workspace.CurrentCamera then
	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScreenSize)
end

local safeAreaInsets = {top = 0, bottom = 0, left = 0, right = 0}
pcall(function()
	local insets = GuiService:GetGuiInset()
	safeAreaInsets.top = insets.Y
end)

-- Tamanhos completamente refeitos para mobile - muito maiores
local UI_SIZES = {
	-- Mobile: menu ocupa 95% da tela
	mainWidth = IS_MOBILE and math.min(screenSize.X * 0.95, 600) or 900,
	mainHeight = IS_MOBILE and math.min(screenSize.Y * 0.85, 700) or 520,
	-- Sidebar oculta no mobile, usa tabs no topo
	sidebarWidth = IS_MOBILE and 0 or 200,
	fontSize = {
		title = IS_MOBILE and 18 or 14,
		label = IS_MOBILE and 14 or 11,
		button = IS_MOBILE and 16 or 13,
		section = IS_MOBILE and 14 or 11,
		footer = IS_MOBILE and 12 or 10,
	},
	iconSize = IS_MOBILE and 20 or 16,
	logoSize = IS_MOBILE and 70 or 90,
	cardIconSize = IS_MOBILE and 18 or 14,
	rowHeight = IS_MOBILE and 44 or 20,
	headerHeight = IS_MOBILE and 50 or 36,
	buttonHeight = IS_MOBILE and 48 or 32,
	padding = IS_MOBILE and 12 or 8,
	-- Controles MUITO maiores para touch
	toggleWidth = IS_MOBILE and 60 or 40,
	toggleHeight = IS_MOBILE and 32 or 20,
	checkboxSize = IS_MOBILE and 28 or 16,
	sliderWidth = IS_MOBILE and 140 or 96,
	sliderHeight = IS_MOBILE and 12 or 6,
	dropdownWidth = IS_MOBILE and 100 or 60,
	dropdownHeight = IS_MOBILE and 36 or 20,
}

-- ============================================
-- CORES DO TEMA (Amarelo vibrante + Neon Amarelo)
-- ============================================
local Colors = {
	Background = Color3.fromRGB(20, 22, 28),
	CardBackground = Color3.fromRGB(16, 18, 24),
	Border = Color3.fromRGB(50, 45, 35),
	Blue = Color3.fromRGB(255, 200, 0),
	BlueDim = Color3.fromRGB(200, 160, 0),
	BlueGlow = Color3.fromRGB(255, 230, 100),
	Neon = Color3.fromRGB(255, 255, 0),
	NeonGlow = Color3.fromRGB(255, 255, 150),
	NeonDim = Color3.fromRGB(200, 200, 0),
	TextWhite = Color3.fromRGB(255, 255, 255),
	TextGray = Color3.fromRGB(136, 136, 136),
	TextDark = Color3.fromRGB(102, 102, 102),
	TextFooter = Color3.fromRGB(68, 68, 68),
	SliderBg = Color3.fromRGB(40, 45, 55),
	DropdownBg = Color3.fromRGB(30, 35, 45),
	HoverBg = Color3.fromRGB(35, 40, 50),
	ActiveBg = Color3.fromRGB(255, 200, 0),
	Cyan = Color3.fromRGB(255, 230, 0),
}

-- ============================================
-- CONFIGURAÇÃO DE ÍCONES POR DECAL ID
-- ============================================
local DecalIcons = {
	crosshair = nil,
	user = nil,
	users = nil,
	globe = nil,
	list = nil,
	settings = nil,
	folder = nil,
	sparkles = nil,
	zap = nil,
	target = nil,
}

local function createDecalIcon(parent, decalId, size)
	local container = Instance.new("ImageLabel")
	container.Name = "DecalIcon"
	container.Size = UDim2.new(0, size, 0, size)
	container.BackgroundTransparency = 1
	container.Image = "rbxassetid://" .. tostring(decalId)
	container.ImageColor3 = Colors.Blue
	container.ScaleType = Enum.ScaleType.Fit
	container.Parent = parent
	return container
end

-- ============================================
-- FUNÇÕES UTILITÁRIAS
-- ============================================

local function addCorner(parent, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius or 6)
	corner.Parent = parent
	return corner
end

local function addStroke(parent, color, thickness)
	local stroke = Instance.new("UIStroke")
	stroke.Color = color or Colors.Border
	stroke.Thickness = thickness or 1
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = parent
	return stroke
end

local function addNeonGlow(parent, color, transparency)
	local glow = Instance.new("UIStroke")
	glow.Name = "NeonGlow"
	glow.Color = color or Colors.Neon
	glow.Thickness = 1.5
	glow.Transparency = transparency or 0.3
	glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	glow.Parent = parent
	return glow
end

local function addPadding(parent, top, bottom, left, right)
	local pad = Instance.new("UIPadding")
	pad.PaddingTop = UDim.new(0, top or 0)
	pad.PaddingBottom = UDim.new(0, bottom or top or 0)
	pad.PaddingLeft = UDim.new(0, left or top or 0)
	pad.PaddingRight = UDim.new(0, right or left or top or 0)
	pad.Parent = parent
	return pad
end

local function tween(object, properties, duration)
	local t = TweenService:Create(object, TweenInfo.new(duration or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), properties)
	t:Play()
	return t
end

-- ============================================
-- ÍCONES DESENHADOS
-- ============================================

local function createCrosshairIcon(parent, size, color)
	local container = Instance.new("Frame")
	container.Name = "CrosshairIcon"
	container.Size = UDim2.new(0, size, 0, size)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local padding = 2
	local innerSize = size - (padding * 2)

	local circle = Instance.new("Frame")
	circle.Name = "Circle"
	circle.Size = UDim2.new(0, innerSize, 0, innerSize)
	circle.Position = UDim2.new(0, padding, 0, padding)
	circle.BackgroundTransparency = 1
	circle.Parent = container
	addCorner(circle, innerSize / 2)
	addStroke(circle, color, 1.5)

	local hLine = Instance.new("Frame")
	hLine.Name = "HLine"
	hLine.Size = UDim2.new(0, innerSize * 0.5, 0, 1.5)
	hLine.Position = UDim2.new(0.5, -innerSize * 0.25, 0.5, -0.75)
	hLine.BackgroundColor3 = color
	hLine.BorderSizePixel = 0
	hLine.Parent = container

	local vLine = Instance.new("Frame")
	vLine.Name = "VLine"
	vLine.Size = UDim2.new(0, 1.5, 0, innerSize * 0.5)
	vLine.Position = UDim2.new(0.5, -0.75, 0.5, -innerSize * 0.25)
	vLine.BackgroundColor3 = color
	vLine.BorderSizePixel = 0
	vLine.Parent = container

	local dot = Instance.new("Frame")
	dot.Name = "Dot"
	dot.Size = UDim2.new(0, 3, 0, 3)
	dot.Position = UDim2.new(0.5, -1.5, 0.5, -1.5)
	dot.BackgroundColor3 = color
	dot.Parent = container
	addCorner(dot, 2)

	return container
end

local function createUserIcon(parent, size, color)
	local container = Instance.new("Frame")
	container.Name = "UserIcon"
	container.Size = UDim2.new(0, size, 0, size)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local headSize = math.floor(size * 0.4)
	local head = Instance.new("Frame")
	head.Name = "Head"
	head.Size = UDim2.new(0, headSize, 0, headSize)
	head.Position = UDim2.new(0.5, -headSize / 2, 0, 1)
	head.BackgroundColor3 = color
	head.BorderSizePixel = 0
	head.Parent = container
	addCorner(head, headSize / 2)

	local bodyWidth = math.floor(size * 0.7)
	local bodyHeight = math.floor(size * 0.4)
	local body = Instance.new("Frame")
	body.Name = "Body"
	body.Size = UDim2.new(0, bodyWidth, 0, bodyHeight)
	body.Position = UDim2.new(0.5, -bodyWidth / 2, 1, -bodyHeight)
	body.BackgroundColor3 = color
	body.BorderSizePixel = 0
	body.Parent = container
	addCorner(body, bodyWidth / 2)

	return container
end

local function createUsersIcon(parent, size, color)
	local container = Instance.new("Frame")
	container.Name = "UsersIcon"
	container.Size = UDim2.new(0, size, 0, size)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local head1Size = math.floor(size * 0.35)
	local head1 = Instance.new("Frame")
	head1.Size = UDim2.new(0, head1Size, 0, head1Size)
	head1.Position = UDim2.new(0, 0, 0, size * 0.1)
	head1.BackgroundColor3 = color
	head1.BorderSizePixel = 0
	head1.Parent = container
	addCorner(head1, head1Size / 2)

	local body1Width = math.floor(size * 0.5)
	local body1Height = math.floor(size * 0.35)
	local body1 = Instance.new("Frame")
	body1.Size = UDim2.new(0, body1Width, 0, body1Height)
	body1.Position = UDim2.new(0, -2, 1, -body1Height + 2)
	body1.BackgroundColor3 = color
	body1.BorderSizePixel = 0
	body1.Parent = container
	addCorner(body1, body1Width / 2)

	local head2Size = math.floor(size * 0.3)
	local head2 = Instance.new("Frame")
	head2.Size = UDim2.new(0, head2Size, 0, head2Size)
	head2.Position = UDim2.new(1, -head2Size - 1, 0, size * 0.15)
	head2.BackgroundColor3 = color
	head2.BorderSizePixel = 0
	head2.Parent = container
	addCorner(head2, head2Size / 2)

	local body2Width = math.floor(size * 0.45)
	local body2Height = math.floor(size * 0.3)
	local body2 = Instance.new("Frame")
	body2.Size = UDim2.new(0, body2Width, 0, body2Height)
	body2.Position = UDim2.new(1, -body2Width + 1, 1, -body2Height + 2)
	body2.BackgroundColor3 = color
	body2.BorderSizePixel = 0
	body2.Parent = container
	addCorner(body2, body2Width / 2)

	return container
end

local function createGlobeIcon(parent, size, color)
	local container = Instance.new("Frame")
	container.Name = "GlobeIcon"
	container.Size = UDim2.new(0, size, 0, size)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local padding = 1
	local innerSize = size - (padding * 2)

	local circle = Instance.new("Frame")
	circle.Size = UDim2.new(0, innerSize, 0, innerSize)
	circle.Position = UDim2.new(0, padding, 0, padding)
	circle.BackgroundTransparency = 1
	circle.Parent = container
	addCorner(circle, innerSize / 2)
	addStroke(circle, color, 1.5)

	local ellipseV = Instance.new("Frame")
	ellipseV.Size = UDim2.new(0, innerSize * 0.5, 0, innerSize - 2)
	ellipseV.Position = UDim2.new(0.5, -innerSize * 0.25, 0, padding + 1)
	ellipseV.BackgroundTransparency = 1
	ellipseV.Parent = container
	addCorner(ellipseV, innerSize * 0.25)
	addStroke(ellipseV, color, 1)

	local equator = Instance.new("Frame")
	equator.Size = UDim2.new(0, innerSize - 2, 0, 1)
	equator.Position = UDim2.new(0, padding + 1, 0.5, -0.5)
	equator.BackgroundColor3 = color
	equator.BorderSizePixel = 0
	equator.Parent = container

	return container
end

local function createListIcon(parent, size, color)
	local container = Instance.new("Frame")
	container.Name = "ListIcon"
	container.Size = UDim2.new(0, size, 0, size)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local lineHeight = 2
	local bulletSize = 3
	local spacing = (size - 6) / 2

	for i = 0, 2 do
		local yPos = 2 + (i * spacing)

		local bullet = Instance.new("Frame")
		bullet.Size = UDim2.new(0, bulletSize, 0, bulletSize)
		bullet.Position = UDim2.new(0, 1, 0, yPos)
		bullet.BackgroundColor3 = color
		bullet.BorderSizePixel = 0
		bullet.Parent = container
		addCorner(bullet, bulletSize / 2)

		local line = Instance.new("Frame")
		line.Size = UDim2.new(0, size - bulletSize - 5, 0, lineHeight)
		line.Position = UDim2.new(0, bulletSize + 4, 0, yPos + (bulletSize - lineHeight) / 2)
		line.BackgroundColor3 = color
		line.BorderSizePixel = 0
		line.Parent = container
		addCorner(line, 1)
	end

	return container
end

local function createSettingsIcon(parent, size, color)
	local container = Instance.new("Frame")
	container.Name = "SettingsIcon"
	container.Size = UDim2.new(0, size, 0, size)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local padding = 2
	local innerSize = size - (padding * 2)

	local outer = Instance.new("Frame")
	outer.Size = UDim2.new(0, innerSize, 0, innerSize)
	outer.Position = UDim2.new(0, padding, 0, padding)
	outer.BackgroundTransparency = 1
	outer.Parent = container
	addCorner(outer, innerSize / 2)
	addStroke(outer, color, 1.5)

	local centerSize = math.floor(innerSize * 0.35)
	local center = Instance.new("Frame")
	center.Size = UDim2.new(0, centerSize, 0, centerSize)
	center.Position = UDim2.new(0.5, -centerSize / 2, 0.5, -centerSize / 2)
	center.BackgroundColor3 = color
	center.BorderSizePixel = 0
	center.Parent = container
	addCorner(center, centerSize / 2)

	local teethPositions = {
		{0.5, 0}, {1, 0.5}, {0.5, 1}, {0, 0.5},
	}

	for _, pos in ipairs(teethPositions) do
		local tooth = Instance.new("Frame")
		tooth.Size = UDim2.new(0, 4, 0, 4)
		tooth.Position = UDim2.new(pos[1], -2, pos[2], -2)
		tooth.BackgroundColor3 = color
		tooth.BorderSizePixel = 0
		tooth.Parent = container
		addCorner(tooth, 2)
	end

	return container
end

local function createFolderIcon(parent, size, color)
	local container = Instance.new("Frame")
	container.Name = "FolderIcon"
	container.Size = UDim2.new(0, size, 0, size)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local tabWidth = math.floor(size * 0.4)
	local tabHeight = math.floor(size * 0.2)
	local tab = Instance.new("Frame")
	tab.Size = UDim2.new(0, tabWidth, 0, tabHeight)
	tab.Position = UDim2.new(0, 1, 0, size * 0.15)
	tab.BackgroundColor3 = color
	tab.BorderSizePixel = 0
	tab.Parent = container
	addCorner(tab, 2)

	local bodyHeight = math.floor(size * 0.55)
	local body = Instance.new("Frame")
	body.Size = UDim2.new(0, size - 2, 0, bodyHeight)
	body.Position = UDim2.new(0, 1, 1, -bodyHeight - 1)
	body.BackgroundColor3 = color
	body.BorderSizePixel = 0
	body.Parent = container
	addCorner(body, 3)

	return container
end

local function createSparklesIcon(parent, size, color)
	local container = Instance.new("Frame")
	container.Name = "SparklesIcon"
	container.Size = UDim2.new(0, size, 0, size)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local star1CenterX = size * 0.35
	local star1CenterY = size * 0.35
	local star1Size = size * 0.5

	local star1V = Instance.new("Frame")
	star1V.Size = UDim2.new(0, 2, 0, star1Size)
	star1V.Position = UDim2.new(0, star1CenterX - 1, 0, star1CenterY - star1Size / 2)
	star1V.BackgroundColor3 = color
	star1V.BorderSizePixel = 0
	star1V.Parent = container

	local star1H = Instance.new("Frame")
	star1H.Size = UDim2.new(0, star1Size, 0, 2)
	star1H.Position = UDim2.new(0, star1CenterX - star1Size / 2, 0, star1CenterY - 1)
	star1H.BackgroundColor3 = color
	star1H.BorderSizePixel = 0
	star1H.Parent = container

	local star2CenterX = size * 0.75
	local star2CenterY = size * 0.7
	local star2Size = size * 0.35

	local star2V = Instance.new("Frame")
	star2V.Size = UDim2.new(0, 2, 0, star2Size)
	star2V.Position = UDim2.new(0, star2CenterX - 1, 0, star2CenterY - star2Size / 2)
	star2V.BackgroundColor3 = color
	star2V.BorderSizePixel = 0
	star2V.Parent = container

	local star2H = Instance.new("Frame")
	star2H.Size = UDim2.new(0, star2Size, 0, 2)
	star2H.Position = UDim2.new(0, star2CenterX - star2Size / 2, 0, star2CenterY - 1)
	star2H.BackgroundColor3 = color
	star2H.BorderSizePixel = 0
	star2H.Parent = container

	return container
end

local function createZapIcon(parent, size, color)
	local container = Instance.new("Frame")
	container.Name = "ZapIcon"
	container.Size = UDim2.new(0, size, 0, size)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local bar1 = Instance.new("Frame")
	bar1.Size = UDim2.new(0, size * 0.5, 0, 2)
	bar1.Position = UDim2.new(0, size * 0.25, 0, 2)
	bar1.BackgroundColor3 = color
	bar1.BorderSizePixel = 0
	bar1.Parent = container

	local bar2 = Instance.new("Frame")
	bar2.Size = UDim2.new(0, size * 0.6, 0, 2)
	bar2.Position = UDim2.new(0.5, -size * 0.3, 0.5, -1)
	bar2.BackgroundColor3 = color
	bar2.BorderSizePixel = 0
	bar2.Rotation = -55
	bar2.Parent = container

	local bar3 = Instance.new("Frame")
	bar3.Size = UDim2.new(0, size * 0.5, 0, 2)
	bar3.Position = UDim2.new(0, size * 0.2, 1, -4)
	bar3.BackgroundColor3 = color
	bar3.BorderSizePixel = 0
	bar3.Parent = container

	return container
end

local function createTargetIcon(parent, size, color)
	local container = Instance.new("Frame")
	container.Name = "TargetIcon"
	container.Size = UDim2.new(0, size, 0, size)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local padding = 1
	local outerSize = size - (padding * 2)
	local innerSize = outerSize * 0.55

	local outer = Instance.new("Frame")
	outer.Size = UDim2.new(0, outerSize, 0, outerSize)
	outer.Position = UDim2.new(0, padding, 0, padding)
	outer.BackgroundTransparency = 1
	outer.Parent = container
	addCorner(outer, outerSize / 2)
	addStroke(outer, color, 1.5)

	local inner = Instance.new("Frame")
	inner.Size = UDim2.new(0, innerSize, 0, innerSize)
	inner.Position = UDim2.new(0.5, -innerSize / 2, 0.5, -innerSize / 2)
	inner.BackgroundTransparency = 1
	inner.Parent = container
	addCorner(inner, innerSize / 2)
	addStroke(inner, color, 1.5)

	local dotSize = 4
	local center = Instance.new("Frame")
	center.Size = UDim2.new(0, dotSize, 0, dotSize)
	center.Position = UDim2.new(0.5, -dotSize / 2, 0.5, -dotSize / 2)
	center.BackgroundColor3 = color
	center.BorderSizePixel = 0
	center.Parent = container
	addCorner(center, dotSize / 2)

	return container
end

local function createChevronIcon(parent, size, color)
	local container = Instance.new("Frame")
	container.Name = "ChevronIcon"
	container.Size = UDim2.new(0, size, 0, size)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local armLength = size * 0.35

	local left = Instance.new("Frame")
	left.Size = UDim2.new(0, 2, 0, armLength)
	left.Position = UDim2.new(0.5, -armLength * 0.5, 0.5, -armLength * 0.3)
	left.BackgroundColor3 = color
	left.BorderSizePixel = 0
	left.Rotation = -45
	left.Parent = container

	local right = Instance.new("Frame")
	right.Size = UDim2.new(0, 2, 0, armLength)
	right.Position = UDim2.new(0.5, armLength * 0.15, 0.5, -armLength * 0.3)
	right.BackgroundColor3 = color
	right.BorderSizePixel = 0
	right.Rotation = 45
	right.Parent = container

	return container
end

local IconCreators = {
	crosshair = createCrosshairIcon,
	user = createUserIcon,
	users = createUsersIcon,
	globe = createGlobeIcon,
	list = createListIcon,
	settings = createSettingsIcon,
	folder = createFolderIcon,
	sparkles = createSparklesIcon,
	zap = createZapIcon,
	target = createTargetIcon,
	chevron = createChevronIcon,
}

local function createIcon(parent, iconType, size, color)
	local decalId = DecalIcons[iconType]
	if decalId then
		return createDecalIcon(parent, decalId, size)
	end

	local creator = IconCreators[iconType]
	if creator then
		return creator(parent, size, color)
	end
	return nil
end

-- ============================================
-- LOGO ORION
-- ============================================

local function createOrionLogo(parent)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, IS_MOBILE and 80 or 110)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local logoHolder = Instance.new("Frame")
	logoHolder.Name = "LogoHolder"
	logoHolder.Size = UDim2.new(0, UI_SIZES.logoSize, 0, UI_SIZES.logoSize)
	logoHolder.Position = UDim2.new(0.5, -UI_SIZES.logoSize/2, 0.5, -UI_SIZES.logoSize/2)
	logoHolder.BackgroundTransparency = 1
	logoHolder.Parent = container

	local duckLogo = Instance.new("ImageLabel")
	duckLogo.Name = "DuckLogo"
	duckLogo.Size = UDim2.new(0, UI_SIZES.logoSize, 0, UI_SIZES.logoSize)
	duckLogo.Position = UDim2.new(0, 0, 0, 0)
	duckLogo.BackgroundTransparency = 1
	duckLogo.Image = "rbxassetid://77012017631835"
	duckLogo.ScaleType = Enum.ScaleType.Fit
	duckLogo.Parent = logoHolder

	spawn(function()
		local scaleUp = true
		local bigSize = UI_SIZES.logoSize + 5
		local smallSize = UI_SIZES.logoSize - 2
		while duckLogo.Parent do
			local targetSize = scaleUp and UDim2.new(0, bigSize, 0, bigSize) or UDim2.new(0, smallSize, 0, smallSize)
			local offset = scaleUp and -2.5 or 1
			local targetPos = UDim2.new(0, offset, 0, offset)
			tween(duckLogo, {Size = targetSize, Position = targetPos}, 0.8)
			scaleUp = not scaleUp
			wait(0.8)
		end
	end)

	spawn(function()
		local rotateRight = true
		while duckLogo.Parent do
			local targetRotation = rotateRight and 5 or -5
			tween(duckLogo, {Rotation = targetRotation}, 1.2)
			rotateRight = not rotateRight
			wait(1.2)
		end
	end)

	return container
end

-- ============================================
-- CRIAR GUI PRINCIPAL
-- ============================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ORIONMenu"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, UI_SIZES.mainWidth, 0, UI_SIZES.mainHeight)
local yOffset = IS_MOBILE and (safeAreaInsets.top + 10) or 0
mainFrame.Position = UDim2.new(0.5, -UI_SIZES.mainWidth/2, 0.5, -UI_SIZES.mainHeight/2 + yOffset)
mainFrame.BackgroundColor3 = Colors.Background
mainFrame.BackgroundTransparency = 0.05
mainFrame.Parent = screenGui
addCorner(mainFrame, 12)
addStroke(mainFrame, Colors.Border, 1)

local mainNeonBorder = Instance.new("Frame")
mainNeonBorder.Name = "NeonBorder"
mainNeonBorder.Size = UDim2.new(1, 4, 1, 4)
mainNeonBorder.Position = UDim2.new(0, -2, 0, -2)
mainNeonBorder.BackgroundTransparency = 1
mainNeonBorder.ZIndex = 0
mainNeonBorder.Parent = mainFrame
addCorner(mainNeonBorder, 14)
local mainNeonStroke = addStroke(mainNeonBorder, Colors.Neon, 2)
mainNeonStroke.Transparency = 0.6

-- ============================================
-- MOBILE: HEADER COM TABS (substitui sidebar)
-- ============================================

local contentStartY = 0
local activeItem = "aimbot"
local menuButtons = {}

if IS_MOBILE then
	-- Header com logo e tabs para mobile
	local mobileHeader = Instance.new("Frame")
	mobileHeader.Name = "MobileHeader"
	mobileHeader.Size = UDim2.new(1, 0, 0, 60)
	mobileHeader.Position = UDim2.new(0, 0, 0, 0)
	mobileHeader.BackgroundColor3 = Colors.CardBackground
	mobileHeader.Parent = mainFrame
	addCorner(mobileHeader, 12)
	
	-- Logo pequena no header mobile
	local mobileLogo = Instance.new("ImageLabel")
	mobileLogo.Size = UDim2.new(0, 40, 0, 40)
	mobileLogo.Position = UDim2.new(0, 10, 0.5, -20)
	mobileLogo.BackgroundTransparency = 1
	mobileLogo.Image = "rbxassetid://77012017631835"
	mobileLogo.Parent = mobileHeader
	
	local mobileTitle = Instance.new("TextLabel")
	mobileTitle.Size = UDim2.new(0, 100, 0, 30)
	mobileTitle.Position = UDim2.new(0, 55, 0.5, -15)
	mobileTitle.BackgroundTransparency = 1
	mobileTitle.Text = "ORION"
	mobileTitle.TextColor3 = Colors.Neon
	mobileTitle.TextSize = 20
	mobileTitle.Font = Enum.Font.GothamBold
	mobileTitle.TextXAlignment = Enum.TextXAlignment.Left
	mobileTitle.Parent = mobileHeader
	
	-- Tabs horizontais
	local tabsContainer = Instance.new("ScrollingFrame")
	tabsContainer.Name = "TabsContainer"
	tabsContainer.Size = UDim2.new(1, -20, 0, 50)
	tabsContainer.Position = UDim2.new(0, 10, 0, 65)
	tabsContainer.BackgroundTransparency = 1
	tabsContainer.ScrollBarThickness = 0
	tabsContainer.ScrollingDirection = Enum.ScrollingDirection.X
	tabsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
	tabsContainer.AutomaticCanvasSize = Enum.AutomaticSize.X
	tabsContainer.Parent = mainFrame
	
	local tabsLayout = Instance.new("UIListLayout")
	tabsLayout.FillDirection = Enum.FillDirection.Horizontal
	tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabsLayout.Padding = UDim.new(0, 8)
	tabsLayout.Parent = tabsContainer
	
	local tabs = {
		{id = "aimbot", label = "Aimbot", icon = "crosshair"},
		{id = "player", label = "Player", icon = "user"},
		{id = "players", label = "ESP", icon = "users"},
		{id = "world", label = "World", icon = "globe"},
		{id = "misc", label = "Misc", icon = "settings"},
	}
	
	for i, tab in ipairs(tabs) do
		local isActive = (tab.id == activeItem)
		
		local tabBtn = Instance.new("TextButton")
		tabBtn.Name = tab.id
		tabBtn.Size = UDim2.new(0, 90, 0, 44)
		tabBtn.BackgroundColor3 = isActive and Colors.Blue or Colors.CardBackground
		tabBtn.BackgroundTransparency = isActive and 0.8 or 0
		tabBtn.Text = ""
		tabBtn.AutoButtonColor = false
		tabBtn.LayoutOrder = i
		tabBtn.Parent = tabsContainer
		addCorner(tabBtn, 8)
		addStroke(tabBtn, isActive and Colors.Neon or Colors.Border, isActive and 2 or 1)
		
		local tabIcon = createIcon(tabBtn, tab.icon, 18, isActive and Colors.Neon or Colors.TextGray)
		if tabIcon then
			tabIcon.Position = UDim2.new(0.5, -9, 0, 4)
		end
		
		local tabLabel = Instance.new("TextLabel")
		tabLabel.Size = UDim2.new(1, 0, 0, 16)
		tabLabel.Position = UDim2.new(0, 0, 1, -18)
		tabLabel.BackgroundTransparency = 1
		tabLabel.Text = tab.label
		tabLabel.TextColor3 = isActive and Colors.Neon or Colors.TextGray
		tabLabel.TextSize = 12
		tabLabel.Font = Enum.Font.GothamMedium
		tabLabel.Parent = tabBtn
		
		menuButtons[tab.id] = {
			button = tabBtn,
			label = tabLabel,
			iconContainer = tabIcon
		}
		
		tabBtn.MouseButton1Click:Connect(function()
			-- Desativar anterior
			if menuButtons[activeItem] then
				local prev = menuButtons[activeItem]
				tween(prev.button, {BackgroundTransparency = 0}, 0.2)
				prev.button.BackgroundColor3 = Colors.CardBackground
				tween(prev.label, {TextColor3 = Colors.TextGray}, 0.2)
				local prevStroke = prev.button:FindFirstChildOfClass("UIStroke")
				if prevStroke then
					prevStroke.Color = Colors.Border
					prevStroke.Thickness = 1
				end
			end
			
			-- Ativar novo
			activeItem = tab.id
			tween(tabBtn, {BackgroundTransparency = 0.8}, 0.2)
			tabBtn.BackgroundColor3 = Colors.Blue
			tween(tabLabel, {TextColor3 = Colors.Neon}, 0.2)
			local stroke = tabBtn:FindFirstChildOfClass("UIStroke")
			if stroke then
				stroke.Color = Colors.Neon
				stroke.Thickness = 2
			end
		end)
	end
	
	contentStartY = 120
else
	-- Desktop: sidebar normal
	local sidebar = Instance.new("Frame")
	sidebar.Name = "Sidebar"
	sidebar.Size = UDim2.new(0, UI_SIZES.sidebarWidth, 1, 0)
	sidebar.Position = UDim2.new(0, 0, 0, 0)
	sidebar.BackgroundTransparency = 1
	sidebar.Parent = mainFrame

	local sidebarBorder = Instance.new("Frame")
	sidebarBorder.Size = UDim2.new(0, 1, 1, 0)
	sidebarBorder.Position = UDim2.new(1, 0, 0, 0)
	sidebarBorder.BackgroundColor3 = Colors.Border
	sidebarBorder.BorderSizePixel = 0
	sidebarBorder.Parent = sidebar

	local sidebarNeonLine = Instance.new("Frame")
	sidebarNeonLine.Size = UDim2.new(0, 2, 0, 60)
	sidebarNeonLine.Position = UDim2.new(1, -1, 0, 110)
	sidebarNeonLine.BackgroundColor3 = Colors.Neon
	sidebarNeonLine.BackgroundTransparency = 0.5
	sidebarNeonLine.BorderSizePixel = 0
	sidebarNeonLine.Parent = sidebar

	createOrionLogo(sidebar)

	local menuContainer = Instance.new("ScrollingFrame")
	menuContainer.Name = "MenuContainer"
	menuContainer.Size = UDim2.new(1, -UI_SIZES.padding*2, 1, -120)
	menuContainer.Position = UDim2.new(0, UI_SIZES.padding, 0, 110)
	menuContainer.BackgroundTransparency = 1
	menuContainer.ScrollBarThickness = 0
	menuContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
	menuContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
	menuContainer.Parent = sidebar

	local menuLayout = Instance.new("UIListLayout")
	menuLayout.SortOrder = Enum.SortOrder.LayoutOrder
	menuLayout.Padding = UDim.new(0, 16)
	menuLayout.Parent = menuContainer

	local menuData = {
		{
			title = "Player",
			items = {
				{id = "aimbot", label = "Aimbot", icon = "crosshair"},
				{id = "player", label = "Player", icon = "user"}
			}
		},
		{
			title = "Visuals",
			items = {
				{id = "players", label = "Players", icon = "users"},
				{id = "world", label = "World", icon = "globe"}
			}
		},
		{
			title = "Misc",
			items = {
				{id = "lists", label = "Lists", icon = "list"},
				{id = "misc", label = "Misc", icon = "settings"},
				{id = "configs", label = "Configs", icon = "folder"}
			}
		}
	}

	local function updateIconColor(iconContainer, color)
		if iconContainer:IsA("ImageLabel") then
			tween(iconContainer, {ImageColor3 = color}, 0.15)
			return
		end
		for _, child in ipairs(iconContainer:GetDescendants()) do
			if child:IsA("Frame") and child.BackgroundTransparency < 1 then
				tween(child, {BackgroundColor3 = color}, 0.15)
			end
			if child:IsA("UIStroke") then
				tween(child, {Color = color}, 0.15)
			end
		end
	end

	local function createMenuSection(sectionData, order)
		local section = Instance.new("Frame")
		section.Name = sectionData.title
		section.Size = UDim2.new(1, 0, 0, 0)
		section.AutomaticSize = Enum.AutomaticSize.Y
		section.BackgroundTransparency = 1
		section.LayoutOrder = order
		section.Parent = menuContainer

		local sectionLayout = Instance.new("UIListLayout")
		sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
		sectionLayout.Padding = UDim.new(0, 4)
		sectionLayout.Parent = section

		local titleLabel = Instance.new("TextLabel")
		titleLabel.Name = "Title"
		titleLabel.Size = UDim2.new(1, 0, 0, 20)
		titleLabel.BackgroundTransparency = 1
		titleLabel.Text = sectionData.title
		titleLabel.TextColor3 = Colors.Neon
		titleLabel.TextTransparency = 0.3
		titleLabel.TextSize = UI_SIZES.fontSize.section
		titleLabel.Font = Enum.Font.GothamMedium
		titleLabel.TextXAlignment = Enum.TextXAlignment.Left
		titleLabel.LayoutOrder = 0
		titleLabel.Parent = section
		addPadding(titleLabel, 0, 0, 12, 0)

		for i, item in ipairs(sectionData.items) do
			local isActive = (item.id == activeItem)

			local button = Instance.new("TextButton")
			button.Name = item.id
			button.Size = UDim2.new(1, -UI_SIZES.padding, 0, UI_SIZES.buttonHeight)
			button.Position = UDim2.new(0, UI_SIZES.padding/2, 0, 0)
			button.BackgroundColor3 = Colors.Blue
			button.BackgroundTransparency = isActive and 0.9 or 1
			button.Text = ""
			button.AutoButtonColor = false
			button.LayoutOrder = i
			button.Parent = section
			addCorner(button, 4)

			local indicator = Instance.new("Frame")
			indicator.Name = "Indicator"
			indicator.Size = UDim2.new(0, 2, 0.6, 0)
			indicator.Position = UDim2.new(0, 0, 0.2, 0)
			indicator.BackgroundColor3 = isActive and Colors.Neon or Colors.Blue
			indicator.BorderSizePixel = 0
			indicator.Visible = isActive
			indicator.Parent = button

			local iconContainer = createIcon(button, item.icon, UI_SIZES.iconSize, isActive and Colors.Blue or Colors.TextDark)
			if iconContainer then
				iconContainer.Position = UDim2.new(0, 12, 0.5, -UI_SIZES.iconSize/2)
				iconContainer.Name = "Icon"
			end

			local textLabel = Instance.new("TextLabel")
			textLabel.Name = "Label"
			textLabel.Size = UDim2.new(1, -40, 1, 0)
			textLabel.Position = UDim2.new(0, 38, 0, 0)
			textLabel.BackgroundTransparency = 1
			textLabel.Text = item.label
			textLabel.TextColor3 = isActive and Colors.Blue or Colors.TextGray
			textLabel.TextSize = UI_SIZES.fontSize.button
			textLabel.Font = Enum.Font.Gotham
			textLabel.TextXAlignment = Enum.TextXAlignment.Left
			textLabel.Parent = button

			menuButtons[item.id] = {
				button = button,
				indicator = indicator,
				label = textLabel,
				iconContainer = iconContainer
			}

			button.MouseEnter:Connect(function()
				if item.id ~= activeItem then
					tween(button, {BackgroundTransparency = 0.95}, 0.15)
				end
			end)

			button.MouseLeave:Connect(function()
				if item.id ~= activeItem then
					tween(button, {BackgroundTransparency = 1}, 0.15)
				end
			end)

			button.MouseButton1Click:Connect(function()
				if menuButtons[activeItem] then
					local prev = menuButtons[activeItem]
					if prev.indicator then prev.indicator.Visible = false end
					tween(prev.button, {BackgroundTransparency = 1}, 0.2)
					tween(prev.label, {TextColor3 = Colors.TextGray}, 0.2)
					if prev.iconContainer then
						updateIconColor(prev.iconContainer, Colors.TextDark)
					end
				end

				activeItem = item.id
				indicator.Visible = true
				indicator.BackgroundColor3 = Colors.Neon
				tween(button, {BackgroundTransparency = 0.9}, 0.2)
				tween(textLabel, {TextColor3 = Colors.Blue}, 0.2)
				if iconContainer then
					updateIconColor(iconContainer, Colors.Blue)
				end
			end)
		end
	end

	for i, sectionData in ipairs(menuData) do
		createMenuSection(sectionData, i)
	end
end

-- ============================================
-- ÁREA DE CONTEÚDO
-- ============================================

local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.Size = IS_MOBILE and UDim2.new(1, -20, 1, -contentStartY - 40) or UDim2.new(1, -UI_SIZES.sidebarWidth, 1, -30)
contentArea.Position = IS_MOBILE and UDim2.new(0, 10, 0, contentStartY) or UDim2.new(0, UI_SIZES.sidebarWidth, 0, 0)
contentArea.BackgroundTransparency = 1
contentArea.Parent = mainFrame

local cardsContainer = Instance.new("Frame")
cardsContainer.Size = UDim2.new(1, 0, 1, -10)
cardsContainer.Position = UDim2.new(0, 0, 0, 0)
cardsContainer.BackgroundTransparency = 1
cardsContainer.ClipsDescendants = true
cardsContainer.Parent = contentArea

local cardsScroll = Instance.new("ScrollingFrame")
cardsScroll.Name = "CardsScroll"
cardsScroll.Size = UDim2.new(1, 0, 1, 0)
cardsScroll.BackgroundTransparency = 1
cardsScroll.ScrollBarThickness = IS_MOBILE and 6 or 3
cardsScroll.ScrollBarImageColor3 = Colors.Blue
cardsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
cardsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
cardsScroll.ElasticBehavior = Enum.ElasticBehavior.Always
cardsScroll.ScrollingDirection = Enum.ScrollingDirection.Y
cardsScroll.Parent = cardsContainer

local cardsParent = cardsScroll

-- ============================================
-- COMPONENTES DE CONFIGURAÇÃO
-- ============================================

local function createToggle(parent, enabled)
	local toggleContainer = Instance.new("Frame")
	toggleContainer.Size = UDim2.new(0, UI_SIZES.toggleWidth, 0, UI_SIZES.toggleHeight)
	toggleContainer.BackgroundTransparency = 1
	toggleContainer.Parent = parent

	local toggle = Instance.new("TextButton")
	toggle.Size = UDim2.new(1, 0, 1, 0)
	toggle.BackgroundColor3 = enabled and Colors.Blue or Colors.SliderBg
	toggle.Text = ""
	toggle.AutoButtonColor = false
	toggle.Parent = toggleContainer
	addCorner(toggle, UI_SIZES.toggleHeight/2)

	if enabled then
		addNeonGlow(toggle, Colors.Neon, 0.6)
	end

	local circleSize = UI_SIZES.toggleHeight - 6
	local circle = Instance.new("Frame")
	circle.Name = "Circle"
	circle.Size = UDim2.new(0, circleSize, 0, circleSize)
	circle.Position = enabled and UDim2.new(1, -circleSize-3, 0.5, -circleSize/2) or UDim2.new(0, 3, 0.5, -circleSize/2)
	circle.BackgroundColor3 = Colors.TextWhite
	circle.Parent = toggle
	addCorner(circle, circleSize/2)

	local isOn = enabled

	toggle.MouseButton1Click:Connect(function()
		isOn = not isOn
		local targetPos = isOn and UDim2.new(1, -circleSize-3, 0.5, -circleSize/2) or UDim2.new(0, 3, 0.5, -circleSize/2)
		local targetColor = isOn and Colors.Blue or Colors.SliderBg

		tween(circle, {Position = targetPos}, 0.2)
		tween(toggle, {BackgroundColor3 = targetColor}, 0.2)

		local neonGlow = toggle:FindFirstChild("NeonGlow")
		if isOn and not neonGlow then
			addNeonGlow(toggle, Colors.Neon, 0.6)
		elseif not isOn and neonGlow then
			neonGlow:Destroy()
		end
	end)

	return toggleContainer
end

local function createCheckbox(parent, checked, onLabel)
	local checkbox = Instance.new("TextButton")
	checkbox.Size = UDim2.new(0, UI_SIZES.checkboxSize, 0, UI_SIZES.checkboxSize)
	checkbox.BackgroundColor3 = checked and Colors.Blue or Colors.CardBackground
	checkbox.Text = ""
	checkbox.AutoButtonColor = false
	checkbox.Parent = parent
	addCorner(checkbox, 4)
	addStroke(checkbox, checked and Colors.Blue or Colors.SliderBg, 1)

	local checkContainer = Instance.new("Frame")
	checkContainer.Size = UDim2.new(1, -6, 1, -6)
	checkContainer.Position = UDim2.new(0, 3, 0, 3)
	checkContainer.BackgroundTransparency = 1
	checkContainer.Visible = checked
	checkContainer.Parent = checkbox

	local short = Instance.new("Frame")
	short.Size = UDim2.new(0, 3, 0, IS_MOBILE and 8 or 5)
	short.Position = UDim2.new(0, IS_MOBILE and 4 or 2, 0, IS_MOBILE and 6 or 4)
	short.BackgroundColor3 = Colors.TextWhite
	short.BorderSizePixel = 0
	short.Rotation = -45
	short.Parent = checkContainer

	local long = Instance.new("Frame")
	long.Size = UDim2.new(0, 3, 0, IS_MOBILE and 14 or 8)
	long.Position = UDim2.new(0, IS_MOBILE and 10 or 6, 0, 0)
	long.BackgroundColor3 = Colors.TextWhite
	long.BorderSizePixel = 0
	long.Rotation = 45
	long.Parent = checkContainer

	local isChecked = checked

	checkbox.MouseButton1Click:Connect(function()
		isChecked = not isChecked

		tween(checkbox, {BackgroundColor3 = isChecked and Colors.Blue or Colors.CardBackground}, 0.15)
		checkContainer.Visible = isChecked

		local stroke = checkbox:FindFirstChildOfClass("UIStroke")
		if stroke then
			tween(stroke, {Color = isChecked and Colors.Blue or Colors.SliderBg}, 0.15)
		end

		if onLabel then
			tween(onLabel, {TextColor3 = isChecked and Colors.TextWhite or Colors.TextDark}, 0.15)
		end
	end)

	return checkbox
end

local function createSlider(parent, value)
	local sliderContainer = Instance.new("Frame")
	sliderContainer.Size = UDim2.new(0, UI_SIZES.sliderWidth, 0, UI_SIZES.sliderHeight)
	sliderContainer.BackgroundColor3 = Colors.SliderBg
	sliderContainer.Parent = parent
	addCorner(sliderContainer, 6)

	local sliderFill = Instance.new("Frame")
	sliderFill.Name = "Fill"
	sliderFill.Size = UDim2.new(value / 100, 0, 1, 0)
	sliderFill.BackgroundColor3 = Colors.Blue
	sliderFill.BorderSizePixel = 0
	sliderFill.Parent = sliderContainer
	addCorner(sliderFill, 6)

	local dotSize = IS_MOBILE and 20 or 10
	local sliderDot = Instance.new("Frame")
	sliderDot.Name = "SliderDot"
	sliderDot.Size = UDim2.new(0, dotSize, 0, dotSize)
	sliderDot.Position = UDim2.new(value / 100, -dotSize/2, 0.5, -dotSize/2)
	sliderDot.BackgroundColor3 = Colors.Neon
	sliderDot.BorderSizePixel = 0
	sliderDot.Parent = sliderContainer
	addCorner(sliderDot, dotSize/2)

	local dragging = false

	local touchArea = Instance.new("TextButton")
	touchArea.Size = UDim2.new(1, IS_MOBILE and 30 or 0, 1, IS_MOBILE and 30 or 0)
	touchArea.Position = UDim2.new(0, IS_MOBILE and -15 or 0, 0, IS_MOBILE and -15 or 0)
	touchArea.BackgroundTransparency = 1
	touchArea.Text = ""
	touchArea.Parent = sliderContainer

	touchArea.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			local relativeX = math.clamp((input.Position.X - sliderContainer.AbsolutePosition.X) / sliderContainer.AbsoluteSize.X, 0, 1)
			tween(sliderFill, {Size = UDim2.new(relativeX, 0, 1, 0)}, 0.1)
			tween(sliderDot, {Position = UDim2.new(relativeX, -dotSize/2, 0.5, -dotSize/2)}, 0.1)
		end
	end)

	touchArea.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local relativeX = math.clamp((input.Position.X - sliderContainer.AbsolutePosition.X) / sliderContainer.AbsoluteSize.X, 0, 1)
			sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
			sliderDot.Position = UDim2.new(relativeX, -dotSize/2, 0.5, -dotSize/2)
		end
	end)

	return sliderContainer
end

local function createDropdown(parent, value)
	local dropdown = Instance.new("Frame")
	dropdown.Size = UDim2.new(0, UI_SIZES.dropdownWidth, 0, UI_SIZES.dropdownHeight)
	dropdown.BackgroundColor3 = Colors.DropdownBg
	dropdown.Parent = parent
	addCorner(dropdown, 6)
	addStroke(dropdown, Colors.Border, 1)

	local text = Instance.new("TextLabel")
	text.Size = UDim2.new(1, -30, 1, 0)
	text.Position = UDim2.new(0, 10, 0, 0)
	text.BackgroundTransparency = 1
	text.Text = value
	text.TextColor3 = Colors.TextWhite
	text.TextSize = IS_MOBILE and 14 or 10
	text.Font = Enum.Font.Gotham
	text.TextXAlignment = Enum.TextXAlignment.Left
	text.Parent = dropdown

	local chevronSize = IS_MOBILE and 14 or 10
	local chevron = createChevronIcon(dropdown, chevronSize, Colors.TextGray)
	chevron.Position = UDim2.new(1, -chevronSize-8, 0.5, -chevronSize/2)

	return dropdown
end

local function createSettingRow(parent, label, settingType, value, yPos)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, -UI_SIZES.padding*2, 0, UI_SIZES.rowHeight)
	row.Position = UDim2.new(0, UI_SIZES.padding, 0, yPos)
	row.BackgroundTransparency = 1
	row.Parent = parent

	local isActive = (settingType ~= "checkbox") or (settingType == "checkbox" and value == true)

	local labelText = Instance.new("TextLabel")
	labelText.Name = "Label"
	labelText.Size = UDim2.new(0.5, 0, 1, 0)
	labelText.BackgroundTransparency = 1
	labelText.Text = label
	labelText.TextColor3 = isActive and Colors.TextWhite or Colors.TextDark
	labelText.TextSize = UI_SIZES.fontSize.label
	labelText.Font = Enum.Font.Gotham
	labelText.TextXAlignment = Enum.TextXAlignment.Left
	labelText.TextTruncate = Enum.TextTruncate.AtEnd
	labelText.Parent = row

	local controlContainer = Instance.new("Frame")
	controlContainer.Size = UDim2.new(0.5, 0, 1, 0)
	controlContainer.Position = UDim2.new(0.5, 0, 0, 0)
	controlContainer.BackgroundTransparency = 1
	controlContainer.Parent = row

	if settingType == "text" then
		local valueLabel = Instance.new("TextLabel")
		valueLabel.Size = UDim2.new(1, -4, 1, 0)
		valueLabel.BackgroundTransparency = 1
		valueLabel.Text = tostring(value)
		valueLabel.TextColor3 = Colors.TextGray
		valueLabel.TextSize = UI_SIZES.fontSize.label
		valueLabel.Font = Enum.Font.Gotham
		valueLabel.TextXAlignment = Enum.TextXAlignment.Right
		valueLabel.Parent = controlContainer

	elseif settingType == "checkbox" then
		local cb = createCheckbox(controlContainer, value, labelText)
		cb.Position = UDim2.new(1, -UI_SIZES.checkboxSize, 0.5, -UI_SIZES.checkboxSize/2)

	elseif settingType == "slider" then
		local sl = createSlider(controlContainer, value)
		sl.Position = UDim2.new(1, -UI_SIZES.sliderWidth, 0.5, -UI_SIZES.sliderHeight/2)

	elseif settingType == "dropdown" then
		local dd = createDropdown(controlContainer, value)
		dd.Position = UDim2.new(1, -UI_SIZES.dropdownWidth, 0.5, -UI_SIZES.dropdownHeight/2)
	end

	return row
end

local function createSettingsCard(parent, title, iconType, settings, position, size)
	local card = Instance.new("Frame")
	card.Name = title:gsub(" ", "")
	card.Size = size
	card.Position = position
	card.BackgroundColor3 = Colors.CardBackground
	card.Parent = parent
	addCorner(card, 10)
	addStroke(card, Colors.Border, 1)

	local header = Instance.new("Frame")
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0, UI_SIZES.headerHeight)
	header.BackgroundTransparency = 1
	header.Parent = card

	local headerBorder = Instance.new("Frame")
	headerBorder.Size = UDim2.new(1, 0, 0, 1)
	headerBorder.Position = UDim2.new(0, 0, 1, -1)
	headerBorder.BackgroundColor3 = Colors.Border
	headerBorder.BorderSizePixel = 0
	headerBorder.Parent = header

	local headerNeonLine = Instance.new("Frame")
	headerNeonLine.Size = UDim2.new(0, IS_MOBILE and 40 or 40, 0, 2)
	headerNeonLine.Position = UDim2.new(0, IS_MOBILE and 12 or 12, 1, -1)
	headerNeonLine.BackgroundColor3 = Colors.Neon
	headerNeonLine.BackgroundTransparency = 0.4
	headerNeonLine.BorderSizePixel = 0
	headerNeonLine.Parent = header

	local cardIcon = createIcon(header, iconType, UI_SIZES.cardIconSize, Colors.Blue)
	if cardIcon then
		cardIcon.Position = UDim2.new(0, IS_MOBILE and 12 or 12, 0.5, -UI_SIZES.cardIconSize/2)
	end

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -120, 1, 0)
	titleLabel.Position = UDim2.new(0, IS_MOBILE and 38 or 32, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title
	titleLabel.TextColor3 = Colors.TextWhite
	titleLabel.TextSize = UI_SIZES.fontSize.button
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = header

	local mainToggle = createToggle(header, true)
	mainToggle.Position = UDim2.new(1, -UI_SIZES.toggleWidth - 12, 0.5, -UI_SIZES.toggleHeight/2)

	local content = Instance.new("Frame")
	content.Name = "Content"
	content.Size = UDim2.new(1, 0, 1, -(UI_SIZES.headerHeight + 12))
	content.Position = UDim2.new(0, 0, 0, UI_SIZES.headerHeight + 6)
	content.BackgroundTransparency = 1
	content.Parent = card

	for i, setting in ipairs(settings) do
		createSettingRow(content, setting.label, setting.type, setting.value, (i - 1) * UI_SIZES.rowHeight + 8)
	end

	return card
end

-- ============================================
-- CRIAR OS CARDS
-- ============================================

local cardPadding = Instance.new("UIPadding")
cardPadding.PaddingTop = UDim.new(0, 8)
cardPadding.PaddingBottom = UDim.new(0, 20)
cardPadding.PaddingLeft = UDim.new(0, 4)
cardPadding.PaddingRight = UDim.new(0, 4)
cardPadding.Parent = cardsParent

local cardsLayout = Instance.new("UIListLayout")
cardsLayout.SortOrder = Enum.SortOrder.LayoutOrder
cardsLayout.Padding = UDim.new(0, IS_MOBILE and 12 or 10)
cardsLayout.Parent = cardsParent

-- Cards sempre em coluna unica, tamanhos maiores para mobile
local cardWidth = UDim2.new(1, -8, 0, 0)

createSettingsCard(cardsParent, "Aimbot", "crosshair", {
	{label = "Hotkey", type = "text", value = "Mouse 2"},
	{label = "Target Peds", type = "checkbox", value = true},
	{label = "Visible Check", type = "checkbox", value = true},
	{label = "FOV", type = "slider", value = 70},
	{label = "Smooth", type = "slider", value = 80},
	{label = "Distance", type = "slider", value = 85},
	{label = "Hitbox", type = "dropdown", value = "Head"},
}, UDim2.new(0, 4, 0, 0), UDim2.new(1, -8, 0, IS_MOBILE and 380 or 250)).LayoutOrder = 1

createSettingsCard(cardsParent, "Silent Aim", "sparkles", {
	{label = "Enable", type = "checkbox", value = true},
	{label = "FOV", type = "slider", value = 90},
	{label = "Hitbox", type = "dropdown", value = "Head"},
}, UDim2.new(0, 4, 0, 0), UDim2.new(1, -8, 0, IS_MOBILE and 220 or 145)).LayoutOrder = 2

createSettingsCard(cardsParent, "Triggerbot", "zap", {
	{label = "Use Hotkey", type = "checkbox", value = true},
	{label = "Target Players", type = "checkbox", value = true},
	{label = "Delay", type = "slider", value = 60},
}, UDim2.new(0, 4, 0, 0), UDim2.new(1, -8, 0, IS_MOBILE and 220 or 145)).LayoutOrder = 3

createSettingsCard(cardsParent, "Magic Bullet", "target", {
	{label = "Enable", type = "checkbox", value = true},
	{label = "FOV", type = "slider", value = 95},
	{label = "Hitbox", type = "dropdown", value = "Head"},
}, UDim2.new(0, 4, 0, 0), UDim2.new(1, -8, 0, IS_MOBILE and 220 or 145)).LayoutOrder = 4

-- ============================================
-- FOOTER
-- ============================================

local footer = Instance.new("Frame")
footer.Name = "Footer"
footer.Size = IS_MOBILE and UDim2.new(1, -20, 0, 30) or UDim2.new(1, -UI_SIZES.sidebarWidth, 0, 30)
footer.Position = IS_MOBILE and UDim2.new(0, 10, 1, -35) or UDim2.new(0, UI_SIZES.sidebarWidth, 1, -30)
footer.BackgroundTransparency = 1
footer.Parent = mainFrame

local footerText = Instance.new("TextLabel")
footerText.Size = UDim2.new(1, -24, 1, 0)
footerText.Position = UDim2.new(0, 6, 0, 0)
footerText.BackgroundTransparency = 1
footerText.Text = "ORION v1.0"
footerText.TextColor3 = Colors.TextFooter
footerText.TextSize = UI_SIZES.fontSize.footer
footerText.Font = Enum.Font.Gotham
footerText.TextXAlignment = Enum.TextXAlignment.Left
footerText.Parent = footer

local neonDotSize = IS_MOBILE and 8 or 6
local footerNeonDot = Instance.new("Frame")
footerNeonDot.Size = UDim2.new(0, neonDotSize, 0, neonDotSize)
footerNeonDot.Position = UDim2.new(1, -neonDotSize*3, 0.5, -neonDotSize/2)
footerNeonDot.BackgroundColor3 = Colors.Neon
footerNeonDot.Parent = footer
addCorner(footerNeonDot, neonDotSize/2)

spawn(function()
	local bright = true
	while footerNeonDot.Parent do
		local targetTransp = bright and 0 or 0.5
		tween(footerNeonDot, {BackgroundTransparency = targetTransp}, 1)
		bright = not bright
		wait(1)
	end
end)

-- ============================================
-- TOGGLE DO MENU
-- ============================================

local menuVisible = true

if IS_MOBILE then
	-- Botão de toggle muito maior e mais visível
	local toggleButton = Instance.new("TextButton")
	toggleButton.Name = "MobileToggle"
	toggleButton.Size = UDim2.new(0, 64, 0, 64)
	toggleButton.Position = UDim2.new(1, -74, 0, safeAreaInsets.top + 10)
	toggleButton.BackgroundColor3 = Colors.Blue
	toggleButton.Text = ""
	toggleButton.AutoButtonColor = false
	toggleButton.Parent = screenGui
	addCorner(toggleButton, 32)
	addStroke(toggleButton, Colors.Neon, 3)

	local toggleIcon = Instance.new("ImageLabel")
	toggleIcon.Size = UDim2.new(0, 44, 0, 44)
	toggleIcon.Position = UDim2.new(0.5, -22, 0.5, -22)
	toggleIcon.BackgroundTransparency = 1
	toggleIcon.Image = "rbxassetid://77012017631835"
	toggleIcon.Parent = toggleButton

	toggleButton.MouseButton1Down:Connect(function()
		tween(toggleButton, {Size = UDim2.new(0, 58, 0, 58), Position = UDim2.new(1, -71, 0, safeAreaInsets.top + 13)}, 0.1)
	end)

	toggleButton.MouseButton1Up:Connect(function()
		tween(toggleButton, {Size = UDim2.new(0, 64, 0, 64), Position = UDim2.new(1, -74, 0, safeAreaInsets.top + 10)}, 0.1)
	end)

	toggleButton.MouseButton1Click:Connect(function()
		menuVisible = not menuVisible
		mainFrame.Visible = menuVisible
	end)
else
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.KeyCode == Enum.KeyCode.Insert then
			menuVisible = not menuVisible
			mainFrame.Visible = menuVisible
		end
	end)
end

-- ============================================
-- DRAGGABLE
-- ============================================

local dragging = false
local dragStart = nil
local startPos = nil

local dragArea = Instance.new("Frame")
dragArea.Name = "DragArea"
dragArea.Size = IS_MOBILE and UDim2.new(1, 0, 0, 60) or UDim2.new(1, 0, 0, 40)
dragArea.Position = UDim2.new(0, 0, 0, 0)
dragArea.BackgroundTransparency = 1
dragArea.Parent = mainFrame

dragArea.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
	end
end)

dragArea.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		local newX = startPos.X.Offset + delta.X
		local newY = startPos.Y.Offset + delta.Y
		
		local maxX = screenSize.X - UI_SIZES.mainWidth/2
		local minX = -UI_SIZES.mainWidth/2
		local maxY = screenSize.Y - UI_SIZES.mainHeight/2
		local minY = -UI_SIZES.mainHeight/2 + safeAreaInsets.top
		
		newX = math.clamp(newX, minX, maxX)
		newY = math.clamp(newY, minY, maxY)
		
		mainFrame.Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
	end
end)
