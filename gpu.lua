-- ORION Menu UI para Roblox - GUIs Separadas PC/Mobile
-- Cole este código em um LocalScript dentro de StarterPlayerScripts ou StarterGui

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Sistema de detecção de plataforma
local function isMobile()
	return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
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

-- ============================================
-- CORES DO TEMA (Roxo vibrante + Neon Roxo)
-- ============================================
local Colors = {
	Background = Color3.fromRGB(20, 18, 28),
	CardBackground = Color3.fromRGB(16, 14, 24),
	Border = Color3.fromRGB(50, 40, 65),
	Blue = Color3.fromRGB(150, 80, 220),
	BlueDim = Color3.fromRGB(120, 60, 180),
	BlueGlow = Color3.fromRGB(180, 120, 255),
	Neon = Color3.fromRGB(170, 90, 255),
	NeonGlow = Color3.fromRGB(200, 150, 255),
	NeonDim = Color3.fromRGB(130, 70, 200),
	TextWhite = Color3.fromRGB(255, 255, 255),
	TextGray = Color3.fromRGB(136, 136, 136),
	TextDark = Color3.fromRGB(102, 102, 102),
	TextFooter = Color3.fromRGB(68, 68, 68),
	SliderBg = Color3.fromRGB(40, 35, 55),
	DropdownBg = Color3.fromRGB(30, 25, 45),
	HoverBg = Color3.fromRGB(35, 30, 50),
	ActiveBg = Color3.fromRGB(150, 80, 220),
	Cyan = Color3.fromRGB(170, 100, 255),
}

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
	local creator = IconCreators[iconType]
	if creator then
		return creator(parent, size, color)
	end
	return nil
end

-- ============================================
-- GUI ESPECÍFICA PARA CADA PLATAFORMA
-- ============================================

if IS_MOBILE then
	-- ============================================
	-- GUI MOBILE (baseada no is-menu original)
	-- ============================================

	-- Escala para mobile
	local SCALE = 0.55
	local MOBILE_SIZES = {
		mainWidth = math.floor(900 * SCALE),
		mainHeight = math.floor(520 * SCALE) + 25,
		sidebarWidth = math.floor(200 * SCALE) - 10,
		logoSize = math.floor(50 * SCALE) + 5,
		logoContainerHeight = math.floor(70 * SCALE) + 10,
		neonLineHeight = math.floor(60 * SCALE),
		cornerRadius = math.floor(8 * SCALE) + 2,
		padding = math.floor(8 * SCALE) + 2,
		iconSize = math.floor(16 * SCALE) + 4,
		buttonHeight = math.floor(32 * SCALE) + 4,
		sectionTitleHeight = math.floor(20 * SCALE) + 4,
		menuSectionPadding = math.floor(16 * SCALE) + 2,
		headerHeight = math.floor(36 * SCALE) + 4,
		rowHeight = math.floor(20 * SCALE) + 4,
		toggleWidth = math.floor(40 * SCALE) + 4,
		toggleHeight = math.floor(20 * SCALE) + 2,
		checkboxSize = math.floor(16 * SCALE) + 4,
		sliderWidth = math.floor(96 * SCALE),
		sliderHeight = math.floor(6 * SCALE) + 2,
		sliderDotSize = math.floor(10 * SCALE) + 4,
		sliderTouchPadding = 20,
		dropdownWidth = math.floor(60 * SCALE) + 10,
		dropdownHeight = math.floor(20 * SCALE) + 4,
		cardCornerRadius = math.floor(6 * SCALE) + 2,
		cardIconSize = math.floor(14 * SCALE) + 4,
		neonLineWidth = math.floor(40 * SCALE),
		footerHeight = math.floor(30 * SCALE) + 4,
		scrollBarThickness = 3,
		fontSize = {
			title = math.floor(14 * SCALE) + 3,
			label = math.floor(11 * SCALE) + 3,
			button = math.floor(13 * SCALE) + 2,
			section = math.floor(11 * SCALE) + 2,
			footer = math.floor(10 * SCALE) + 2,
			dropdown = math.floor(10 * SCALE) + 2,
		},
		chevronSize = math.floor(10 * SCALE) + 2,
	}

	local sizes = MOBILE_SIZES

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "ORIONMenu"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.IgnoreGuiInset = true
	screenGui.Parent = playerGui

	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, sizes.mainWidth, 0, sizes.mainHeight)
	mainFrame.Position = UDim2.new(0.5, -sizes.mainWidth/2, 0.5, -sizes.mainHeight/2)
	mainFrame.BackgroundColor3 = Colors.Background
	mainFrame.BackgroundTransparency = 0.05
	mainFrame.Parent = screenGui
	addCorner(mainFrame, sizes.cornerRadius)
	addStroke(mainFrame, Colors.Border, 1)

	local mainNeonBorder = Instance.new("Frame")
	mainNeonBorder.Name = "NeonBorder"
	mainNeonBorder.Size = UDim2.new(1, 4, 1, 4)
	mainNeonBorder.Position = UDim2.new(0, -2, 0, -2)
	mainNeonBorder.BackgroundTransparency = 1
	mainNeonBorder.ZIndex = 0
	mainNeonBorder.Parent = mainFrame
	addCorner(mainNeonBorder, sizes.cornerRadius + 2)
	local mainNeonStroke = addStroke(mainNeonBorder, Colors.Neon, 2)
	mainNeonStroke.Transparency = 0.6

	-- Sidebar
	local sidebar = Instance.new("Frame")
	sidebar.Name = "Sidebar"
	sidebar.Size = UDim2.new(0, sizes.sidebarWidth, 1, 0)
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
	sidebarNeonLine.Size = UDim2.new(0, 2, 0, sizes.neonLineHeight)
	sidebarNeonLine.Position = UDim2.new(1, -1, 0, sizes.logoContainerHeight)
	sidebarNeonLine.BackgroundColor3 = Colors.Neon
	sidebarNeonLine.BackgroundTransparency = 0.5
	sidebarNeonLine.BorderSizePixel = 0
	sidebarNeonLine.Parent = sidebar

	-- Logo
	local logoContainer = Instance.new("Frame")
	logoContainer.Size = UDim2.new(1, 0, 0, sizes.logoContainerHeight)
	logoContainer.BackgroundTransparency = 1
	logoContainer.Parent = sidebar

	local logoHolder = Instance.new("Frame")
	logoHolder.Name = "LogoHolder"
	logoHolder.Size = UDim2.new(0, sizes.logoSize, 0, sizes.logoSize)
	logoHolder.Position = UDim2.new(0.5, -sizes.logoSize/2, 0.5, -sizes.logoSize/2)
	logoHolder.BackgroundTransparency = 1
	logoHolder.Parent = logoContainer

	local duckLogo = Instance.new("ImageLabel")
	duckLogo.Name = "DuckLogo"
	duckLogo.Size = UDim2.new(0, sizes.logoSize, 0, sizes.logoSize)
	duckLogo.Position = UDim2.new(0, 0, 0, 0)
	duckLogo.BackgroundTransparency = 1
	duckLogo.Image = "rbxassetid://82264532716857"
	duckLogo.ScaleType = Enum.ScaleType.Fit
	duckLogo.Parent = logoHolder

	-- Animação da logo
	spawn(function()
		local scaleUp = true
		local bigSize = sizes.logoSize + 3
		local smallSize = sizes.logoSize - 2
		while duckLogo.Parent do
			local targetSize = scaleUp and UDim2.new(0, bigSize, 0, bigSize) or UDim2.new(0, smallSize, 0, smallSize)
			local offset = scaleUp and -1.5 or 1
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

	-- Menu container
	local menuContainer = Instance.new("ScrollingFrame")
	menuContainer.Name = "MenuContainer"
	menuContainer.Size = UDim2.new(1, -sizes.padding*2, 1, -sizes.logoContainerHeight - 10)
	menuContainer.Position = UDim2.new(0, sizes.padding, 0, sizes.logoContainerHeight)
	menuContainer.BackgroundTransparency = 1
	menuContainer.ScrollBarThickness = 2
	menuContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
	menuContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
	menuContainer.Parent = sidebar

	local menuLayout = Instance.new("UIListLayout")
	menuLayout.SortOrder = Enum.SortOrder.LayoutOrder
	menuLayout.Padding = UDim.new(0, sizes.menuSectionPadding)
	menuLayout.Parent = menuContainer

	local activeItem = "aimbot"
	local menuButtons = {}

	local menuData = {
		{title = "Player", items = {{id = "aimbot", label = "Aimbot", icon = "crosshair"}, {id = "player", label = "Player", icon = "user"}}},
		{title = "Visuals", items = {{id = "players", label = "Players", icon = "users"}, {id = "world", label = "World", icon = "globe"}}},
		{title = "Misc", items = {{id = "lists", label = "Lists", icon = "list"}, {id = "misc", label = "Misc", icon = "settings"}, {id = "configs", label = "Configs", icon = "folder"}}}
	}

	local function updateIconColor(iconContainer, color)
		if not iconContainer then return end
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
		sectionLayout.Padding = UDim.new(0, 2)
		sectionLayout.Parent = section

		local titleLabel = Instance.new("TextLabel")
		titleLabel.Name = "Title"
		titleLabel.Size = UDim2.new(1, 0, 0, sizes.sectionTitleHeight)
		titleLabel.BackgroundTransparency = 1
		titleLabel.Text = sectionData.title
		titleLabel.TextColor3 = Colors.Neon
		titleLabel.TextTransparency = 0.3
		titleLabel.TextSize = sizes.fontSize.section
		titleLabel.Font = Enum.Font.GothamMedium
		titleLabel.TextXAlignment = Enum.TextXAlignment.Left
		titleLabel.LayoutOrder = 0
		titleLabel.Parent = section
		addPadding(titleLabel, 0, 0, sizes.padding, 0)

		for i, item in ipairs(sectionData.items) do
			local isActive = (item.id == activeItem)

			local button = Instance.new("TextButton")
			button.Name = item.id
			button.Size = UDim2.new(1, -sizes.padding, 0, sizes.buttonHeight)
			button.Position = UDim2.new(0, sizes.padding/2, 0, 0)
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

			local iconContainer = createIcon(button, item.icon, sizes.iconSize, isActive and Colors.Blue or Colors.TextDark)
			if iconContainer then
				iconContainer.Position = UDim2.new(0, sizes.padding, 0.5, -sizes.iconSize/2)
				iconContainer.Name = "Icon"
			end

			local textLabel = Instance.new("TextLabel")
			textLabel.Name = "Label"
			textLabel.Size = UDim2.new(1, -sizes.iconSize - sizes.padding*3, 1, 0)
			textLabel.Position = UDim2.new(0, sizes.iconSize + sizes.padding*2, 0, 0)
			textLabel.BackgroundTransparency = 1
			textLabel.Text = item.label
			textLabel.TextColor3 = isActive and Colors.Blue or Colors.TextGray
			textLabel.TextSize = sizes.fontSize.button
			textLabel.Font = Enum.Font.Gotham
			textLabel.TextXAlignment = Enum.TextXAlignment.Left
			textLabel.Parent = button

			menuButtons[item.id] = {button = button, indicator = indicator, label = textLabel, iconContainer = iconContainer}

			button.MouseButton1Click:Connect(function()
				if menuButtons[activeItem] then
					local prev = menuButtons[activeItem]
					if prev.indicator then prev.indicator.Visible = false end
					tween(prev.button, {BackgroundTransparency = 1}, 0.2)
					tween(prev.label, {TextColor3 = Colors.TextGray}, 0.2)
					if prev.iconContainer then updateIconColor(prev.iconContainer, Colors.TextDark) end
				end

				activeItem = item.id
				indicator.Visible = true
				indicator.BackgroundColor3 = Colors.Neon
				tween(button, {BackgroundTransparency = 0.9}, 0.2)
				tween(textLabel, {TextColor3 = Colors.Blue}, 0.2)
				if iconContainer then updateIconColor(iconContainer, Colors.Blue) end
			end)
		end
	end

	for i, sectionData in ipairs(menuData) do
		createMenuSection(sectionData, i)
	end

	-- Content Area
	local contentArea = Instance.new("Frame")
	contentArea.Name = "ContentArea"
	contentArea.Size = UDim2.new(1, -sizes.sidebarWidth, 1, -sizes.footerHeight)
	contentArea.Position = UDim2.new(0, sizes.sidebarWidth, 0, 0)
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
	cardsScroll.ScrollBarThickness = sizes.scrollBarThickness
	cardsScroll.ScrollBarImageColor3 = Colors.Blue
	cardsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	cardsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	cardsScroll.ElasticBehavior = Enum.ElasticBehavior.Always
	cardsScroll.ScrollingDirection = Enum.ScrollingDirection.Y
	cardsScroll.Parent = cardsContainer

	-- Componentes
	local function createToggle(parent, enabled)
		local toggleContainer = Instance.new("Frame")
		toggleContainer.Size = UDim2.new(0, sizes.toggleWidth, 0, sizes.toggleHeight)
		toggleContainer.BackgroundTransparency = 1
		toggleContainer.Parent = parent

		local toggle = Instance.new("TextButton")
		toggle.Size = UDim2.new(1, 0, 1, 0)
		toggle.BackgroundColor3 = enabled and Colors.Blue or Colors.SliderBg
		toggle.Text = ""
		toggle.AutoButtonColor = false
		toggle.Parent = toggleContainer
		addCorner(toggle, sizes.toggleHeight/2)

		if enabled then addNeonGlow(toggle, Colors.Neon, 0.6) end

		local circleSize = sizes.toggleHeight - 4
		local circle = Instance.new("Frame")
		circle.Name = "Circle"
		circle.Size = UDim2.new(0, circleSize, 0, circleSize)
		circle.Position = enabled and UDim2.new(1, -circleSize-2, 0.5, -circleSize/2) or UDim2.new(0, 2, 0.5, -circleSize/2)
		circle.BackgroundColor3 = Colors.TextWhite
		circle.Parent = toggle
		addCorner(circle, circleSize/2)

		local isOn = enabled
		toggle.MouseButton1Click:Connect(function()
			isOn = not isOn
			local targetPos = isOn and UDim2.new(1, -circleSize-2, 0.5, -circleSize/2) or UDim2.new(0, 2, 0.5, -circleSize/2)
			tween(circle, {Position = targetPos}, 0.2)
			tween(toggle, {BackgroundColor3 = isOn and Colors.Blue or Colors.SliderBg}, 0.2)
			local neonGlow = toggle:FindFirstChild("NeonGlow")
			if isOn and not neonGlow then addNeonGlow(toggle, Colors.Neon, 0.6)
			elseif not isOn and neonGlow then neonGlow:Destroy() end
		end)

		return toggleContainer
	end

	local function createCheckbox(parent, checked, onLabel)
		local checkbox = Instance.new("TextButton")
		checkbox.Size = UDim2.new(0, sizes.checkboxSize, 0, sizes.checkboxSize)
		checkbox.BackgroundColor3 = checked and Colors.Blue or Colors.CardBackground
		checkbox.Text = ""
		checkbox.AutoButtonColor = false
		checkbox.Parent = parent
		addCorner(checkbox, 3)
		addStroke(checkbox, checked and Colors.Blue or Colors.SliderBg, 1)

		local checkContainer = Instance.new("Frame")
		checkContainer.Size = UDim2.new(1, -4, 1, -4)
		checkContainer.Position = UDim2.new(0, 2, 0, 2)
		checkContainer.BackgroundTransparency = 1
		checkContainer.Visible = checked
		checkContainer.Parent = checkbox

		local short = Instance.new("Frame")
		short.Size = UDim2.new(0, 2, 0, sizes.checkboxSize * 0.35)
		short.Position = UDim2.new(0, sizes.checkboxSize * 0.15, 0, sizes.checkboxSize * 0.3)
		short.BackgroundColor3 = Colors.TextWhite
		short.BorderSizePixel = 0
		short.Rotation = -45
		short.Parent = checkContainer

		local long = Instance.new("Frame")
		long.Size = UDim2.new(0, 2, 0, sizes.checkboxSize * 0.5)
		long.Position = UDim2.new(0, sizes.checkboxSize * 0.4, 0, 0)
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
			if stroke then tween(stroke, {Color = isChecked and Colors.Blue or Colors.SliderBg}, 0.15) end
			if onLabel then tween(onLabel, {TextColor3 = isChecked and Colors.TextWhite or Colors.TextDark}, 0.15) end
		end)

		return checkbox
	end

	local function createSlider(parent, value)
		local sliderContainer = Instance.new("Frame")
		sliderContainer.Size = UDim2.new(0, sizes.sliderWidth, 0, sizes.sliderHeight)
		sliderContainer.BackgroundColor3 = Colors.SliderBg
		sliderContainer.Parent = parent
		addCorner(sliderContainer, sizes.sliderHeight/2)

		local sliderFill = Instance.new("Frame")
		sliderFill.Name = "Fill"
		sliderFill.Size = UDim2.new(value / 100, 0, 1, 0)
		sliderFill.BackgroundColor3 = Colors.Blue
		sliderFill.BorderSizePixel = 0
		sliderFill.Parent = sliderContainer
		addCorner(sliderFill, sizes.sliderHeight/2)

		local dotSize = sizes.sliderDotSize
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
		touchArea.Size = UDim2.new(1, sizes.sliderTouchPadding, 1, sizes.sliderTouchPadding)
		touchArea.Position = UDim2.new(0, -sizes.sliderTouchPadding/2, 0, -sizes.sliderTouchPadding/2)
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
		dropdown.Size = UDim2.new(0, sizes.dropdownWidth, 0, sizes.dropdownHeight)
		dropdown.BackgroundColor3 = Colors.DropdownBg
		dropdown.Parent = parent
		addCorner(dropdown, 4)
		addStroke(dropdown, Colors.Border, 1)

		local text = Instance.new("TextLabel")
		text.Size = UDim2.new(1, -sizes.dropdownHeight, 1, 0)
		text.Position = UDim2.new(0, 6, 0, 0)
		text.BackgroundTransparency = 1
		text.Text = value
		text.TextColor3 = Colors.TextWhite
		text.TextSize = sizes.fontSize.dropdown
		text.Font = Enum.Font.Gotham
		text.TextXAlignment = Enum.TextXAlignment.Left
		text.Parent = dropdown

		local chevronSize = sizes.chevronSize
		local chevron = createChevronIcon(dropdown, chevronSize, Colors.TextGray)
		chevron.Position = UDim2.new(1, -chevronSize-4, 0.5, -chevronSize/2)

		return dropdown
	end

	local function createSettingRow(parent, label, settingType, value, yPos)
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, -sizes.padding*2, 0, sizes.rowHeight)
		row.Position = UDim2.new(0, sizes.padding, 0, yPos)
		row.BackgroundTransparency = 1
		row.Parent = parent

		local isActive = (settingType ~= "checkbox") or (settingType == "checkbox" and value == true)

		local labelText = Instance.new("TextLabel")
		labelText.Name = "Label"
		labelText.Size = UDim2.new(0.5, 0, 1, 0)
		labelText.BackgroundTransparency = 1
		labelText.Text = label
		labelText.TextColor3 = isActive and Colors.TextWhite or Colors.TextDark
		labelText.TextSize = sizes.fontSize.label
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
			valueLabel.TextSize = sizes.fontSize.label
			valueLabel.Font = Enum.Font.Gotham
			valueLabel.TextXAlignment = Enum.TextXAlignment.Right
			valueLabel.Parent = controlContainer
		elseif settingType == "checkbox" then
			local cb = createCheckbox(controlContainer, value, labelText)
			cb.Position = UDim2.new(1, -sizes.checkboxSize, 0.5, -sizes.checkboxSize/2)
		elseif settingType == "slider" then
			local sl = createSlider(controlContainer, value)
			sl.Position = UDim2.new(1, -sizes.sliderWidth, 0.5, -sizes.sliderHeight/2)
		elseif settingType == "dropdown" then
			local dd = createDropdown(controlContainer, value)
			dd.Position = UDim2.new(1, -sizes.dropdownWidth, 0.5, -sizes.dropdownHeight/2)
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
		addCorner(card, sizes.cardCornerRadius)
		addStroke(card, Colors.Border, 1)

		local header = Instance.new("Frame")
		header.Name = "Header"
		header.Size = UDim2.new(1, 0, 0, sizes.headerHeight)
		header.BackgroundTransparency = 1
		header.Parent = card

		local headerBorder = Instance.new("Frame")
		headerBorder.Size = UDim2.new(1, 0, 0, 1)
		headerBorder.Position = UDim2.new(0, 0, 1, -1)
		headerBorder.BackgroundColor3 = Colors.Border
		headerBorder.BorderSizePixel = 0
		headerBorder.Parent = header

		local headerNeonLine = Instance.new("Frame")
		headerNeonLine.Size = UDim2.new(0, sizes.neonLineWidth, 0, 2)
		headerNeonLine.Position = UDim2.new(0, sizes.padding, 1, -1)
		headerNeonLine.BackgroundColor3 = Colors.Neon
		headerNeonLine.BackgroundTransparency = 0.4
		headerNeonLine.BorderSizePixel = 0
		headerNeonLine.Parent = header

		local cardIcon = createIcon(header, iconType, sizes.cardIconSize, Colors.Blue)
		if cardIcon then cardIcon.Position = UDim2.new(0, sizes.padding, 0.5, -sizes.cardIconSize/2) end

		local titleLabel = Instance.new("TextLabel")
		titleLabel.Size = UDim2.new(1, -100, 1, 0)
		titleLabel.Position = UDim2.new(0, sizes.cardIconSize + sizes.padding + 6, 0, 0)
		titleLabel.BackgroundTransparency = 1
		titleLabel.Text = title
		titleLabel.TextColor3 = Colors.TextWhite
		titleLabel.TextSize = sizes.fontSize.button
		titleLabel.Font = Enum.Font.GothamMedium
		titleLabel.TextXAlignment = Enum.TextXAlignment.Left
		titleLabel.Parent = header

		local mainToggle = createToggle(header, true)
		mainToggle.Position = UDim2.new(1, -sizes.toggleWidth - 8, 0.5, -sizes.toggleHeight/2)

		local content = Instance.new("Frame")
		content.Name = "Content"
		content.Size = UDim2.new(1, 0, 1, -(sizes.headerHeight + 8))
		content.Position = UDim2.new(0, 0, 0, sizes.headerHeight + 4)
		content.BackgroundTransparency = 1
		content.Parent = card

		for i, setting in ipairs(settings) do
			createSettingRow(content, setting.label, setting.type, setting.value, (i - 1) * sizes.rowHeight + 4)
		end

		return card
	end

	-- Cards Layout
	local cardLayout = Instance.new("UIListLayout")
	cardLayout.SortOrder = Enum.SortOrder.LayoutOrder
	cardLayout.Padding = UDim.new(0, 8)
	cardLayout.Parent = cardsScroll

	addPadding(cardsScroll, 4, 4, 4, 4)

	createSettingsCard(cardsScroll, "Aimbot", "crosshair", {
		{label = "Hotkey", type = "text", value = "M2"},
		{label = "Target Peds", type = "checkbox", value = true},
		{label = "Visible", type = "checkbox", value = true},
		{label = "FOV", type = "slider", value = 70},
		{label = "Smooth", type = "slider", value = 80},
		{label = "Hitbox", type = "dropdown", value = "Head"},
	}, UDim2.new(0, 0, 0, 0), UDim2.new(1, -8, 0, 160))

	createSettingsCard(cardsScroll, "Silent Aim", "sparkles", {
		{label = "Enable", type = "checkbox", value = true},
		{label = "FOV", type = "slider", value = 90},
		{label = "Hitbox", type = "dropdown", value = "Head"},
	}, UDim2.new(0, 0, 0, 0), UDim2.new(1, -8, 0, 100))

	createSettingsCard(cardsScroll, "Triggerbot", "zap", {
		{label = "Use Hotkey", type = "checkbox", value = true},
		{label = "Players", type = "checkbox", value = true},
		{label = "Delay", type = "slider", value = 60},
	}, UDim2.new(0, 0, 0, 0), UDim2.new(1, -8, 0, 100))

	createSettingsCard(cardsScroll, "Magic Bullet", "target", {
		{label = "Enable", type = "checkbox", value = true},
		{label = "FOV", type = "slider", value = 95},
		{label = "Hitbox", type = "dropdown", value = "Head"},
	}, UDim2.new(0, 0, 0, 0), UDim2.new(1, -8, 0, 100))

	-- Footer
	local footer = Instance.new("Frame")
	footer.Name = "Footer"
	footer.Size = UDim2.new(1, -sizes.sidebarWidth, 0, sizes.footerHeight)
	footer.Position = UDim2.new(0, sizes.sidebarWidth, 1, -sizes.footerHeight)
	footer.BackgroundTransparency = 1
	footer.Parent = mainFrame

	local footerBorder = Instance.new("Frame")
	footerBorder.Size = UDim2.new(1, 0, 0, 1)
	footerBorder.Position = UDim2.new(0, 0, 0, 0)
	footerBorder.BackgroundColor3 = Colors.Border
	footerBorder.BorderSizePixel = 0
	footerBorder.Parent = footer

	local footerText = Instance.new("TextLabel")
	footerText.Size = UDim2.new(1, -24, 1, 0)
	footerText.Position = UDim2.new(0, 8, 0, 0)
	footerText.BackgroundTransparency = 1
	footerText.Text = "ORION v1.0 | Premium"
	footerText.TextColor3 = Colors.TextFooter
	footerText.TextSize = sizes.fontSize.footer
	footerText.Font = Enum.Font.Gotham
	footerText.TextXAlignment = Enum.TextXAlignment.Left
	footerText.Parent = footer

	local neonDotSize = 4
	local footerNeonDot = Instance.new("Frame")
	footerNeonDot.Size = UDim2.new(0, neonDotSize, 0, neonDotSize)
	footerNeonDot.Position = UDim2.new(1, -neonDotSize*3, 0.5, -neonDotSize/2)
	footerNeonDot.BackgroundColor3 = Colors.Neon
	footerNeonDot.Parent = footer
	addCorner(footerNeonDot, neonDotSize/2)

	spawn(function()
		local bright = true
		while footerNeonDot.Parent do
			tween(footerNeonDot, {BackgroundTransparency = bright and 0 or 0.5}, 1)
			bright = not bright
			wait(1)
		end
	end)

	-- Toggle Mobile
	local toggleButton = Instance.new("TextButton")
	toggleButton.Name = "MobileToggle"
	toggleButton.Size = UDim2.new(0, 44, 0, 44)
	toggleButton.Position = UDim2.new(1, -54, 0, 10)
	toggleButton.BackgroundColor3 = Colors.Blue
	toggleButton.Text = ""
	toggleButton.AutoButtonColor = false
	toggleButton.Parent = screenGui
	addCorner(toggleButton, 22)
	addStroke(toggleButton, Colors.Neon, 2)

	local toggleIcon = Instance.new("ImageLabel")
	toggleIcon.Size = UDim2.new(0, 26, 0, 26)
	toggleIcon.Position = UDim2.new(0.5, -13, 0.5, -13)
	toggleIcon.BackgroundTransparency = 1
	toggleIcon.Image = "rbxassetid://82264532716857d"
	toggleIcon.Parent = toggleButton

	local menuVisible = true
	toggleButton.MouseButton1Click:Connect(function()
		menuVisible = not menuVisible
		mainFrame.Visible = menuVisible
	end)

	-- Draggable Mobile
	local dragging = false
	local dragStart = nil
	local startPos = nil

	mainFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = mainFrame.Position
		end
	end)

	mainFrame.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

else
	-- ============================================
	-- GUI PC (baseada no is-mobile com tamanhos grandes)
	-- ============================================

	local PC_SIZES = {
		mainWidth = 900,
		mainHeight = 520,
		sidebarWidth = 200,
		logoSize = 90,
		logoContainerHeight = 110,
		neonLineHeight = 60,
		cornerRadius = 8,
		padding = 8,
		iconSize = 16,
		buttonHeight = 32,
		sectionTitleHeight = 20,
		menuSectionPadding = 16,
		headerHeight = 36,
		rowHeight = 20,
		toggleWidth = 40,
		toggleHeight = 20,
		checkboxSize = 16,
		sliderWidth = 96,
		sliderHeight = 6,
		sliderDotSize = 10,
		sliderTouchPadding = 10,
		dropdownWidth = 60,
		dropdownHeight = 20,
		cardCornerRadius = 6,
		cardIconSize = 14,
		neonLineWidth = 40,
		footerHeight = 30,
		scrollBarThickness = 0,
		fontSize = {
			title = 14,
			label = 11,
			button = 13,
			section = 11,
			footer = 10,
			dropdown = 10,
		},
		chevronSize = 10,
	}

	local sizes = PC_SIZES

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "ORIONMenu"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = playerGui

	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, sizes.mainWidth, 0, sizes.mainHeight)
	mainFrame.Position = UDim2.new(0.5, -sizes.mainWidth/2, 0.5, -sizes.mainHeight/2)
	mainFrame.BackgroundColor3 = Colors.Background
	mainFrame.BackgroundTransparency = 0.05
	mainFrame.Parent = screenGui
	addCorner(mainFrame, sizes.cornerRadius)
	addStroke(mainFrame, Colors.Border, 1)

	local mainNeonBorder = Instance.new("Frame")
	mainNeonBorder.Name = "NeonBorder"
	mainNeonBorder.Size = UDim2.new(1, 4, 1, 4)
	mainNeonBorder.Position = UDim2.new(0, -2, 0, -2)
	mainNeonBorder.BackgroundTransparency = 1
	mainNeonBorder.ZIndex = 0
	mainNeonBorder.Parent = mainFrame
	addCorner(mainNeonBorder, sizes.cornerRadius + 2)
	local mainNeonStroke = addStroke(mainNeonBorder, Colors.Neon, 2)
	mainNeonStroke.Transparency = 0.6

	-- Sidebar
	local sidebar = Instance.new("Frame")
	sidebar.Name = "Sidebar"
	sidebar.Size = UDim2.new(0, sizes.sidebarWidth, 1, 0)
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
	sidebarNeonLine.Size = UDim2.new(0, 2, 0, sizes.neonLineHeight)
	sidebarNeonLine.Position = UDim2.new(1, -1, 0, sizes.logoContainerHeight)
	sidebarNeonLine.BackgroundColor3 = Colors.Neon
	sidebarNeonLine.BackgroundTransparency = 0.5
	sidebarNeonLine.BorderSizePixel = 0
	sidebarNeonLine.Parent = sidebar

	-- Logo
	local logoContainer = Instance.new("Frame")
	logoContainer.Size = UDim2.new(1, 0, 0, sizes.logoContainerHeight)
	logoContainer.BackgroundTransparency = 1
	logoContainer.Parent = sidebar

	local logoHolder = Instance.new("Frame")
	logoHolder.Name = "LogoHolder"
	logoHolder.Size = UDim2.new(0, sizes.logoSize, 0, sizes.logoSize)
	logoHolder.Position = UDim2.new(0.5, -sizes.logoSize/2, 0.5, -sizes.logoSize/2)
	logoHolder.BackgroundTransparency = 1
	logoHolder.Parent = logoContainer

	local duckLogo = Instance.new("ImageLabel")
	duckLogo.Name = "DuckLogo"
	duckLogo.Size = UDim2.new(0, sizes.logoSize, 0, sizes.logoSize)
	duckLogo.Position = UDim2.new(0, 0, 0, 0)
	duckLogo.BackgroundTransparency = 1
	duckLogo.Image = "rbxassetid://82264532716857"
	duckLogo.ScaleType = Enum.ScaleType.Fit
	duckLogo.Parent = logoHolder

	spawn(function()
		local scaleUp = true
		local bigSize = sizes.logoSize + 5
		local smallSize = sizes.logoSize - 2
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

	-- Menu container
	local menuContainer = Instance.new("ScrollingFrame")
	menuContainer.Name = "MenuContainer"
	menuContainer.Size = UDim2.new(1, -sizes.padding*2, 1, -sizes.logoContainerHeight)
	menuContainer.Position = UDim2.new(0, sizes.padding, 0, sizes.logoContainerHeight)
	menuContainer.BackgroundTransparency = 1
	menuContainer.ScrollBarThickness = 0
	menuContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
	menuContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
	menuContainer.Parent = sidebar

	local menuLayout = Instance.new("UIListLayout")
	menuLayout.SortOrder = Enum.SortOrder.LayoutOrder
	menuLayout.Padding = UDim.new(0, sizes.menuSectionPadding)
	menuLayout.Parent = menuContainer

	local activeItem = "aimbot"
	local menuButtons = {}

	local menuData = {
		{title = "Player", items = {{id = "aimbot", label = "Aimbot", icon = "crosshair"}, {id = "player", label = "Player", icon = "user"}}},
		{title = "Visuals", items = {{id = "players", label = "Players", icon = "users"}, {id = "world", label = "World", icon = "globe"}}},
		{title = "Miscellaneous", items = {{id = "lists", label = "Lists", icon = "list"}, {id = "misc", label = "Miscellaneous", icon = "settings"}, {id = "configs", label = "Configs", icon = "folder"}}}
	}

	local function updateIconColor(iconContainer, color)
		if not iconContainer then return end
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
		titleLabel.Size = UDim2.new(1, 0, 0, sizes.sectionTitleHeight)
		titleLabel.BackgroundTransparency = 1
		titleLabel.Text = sectionData.title
		titleLabel.TextColor3 = Colors.Neon
		titleLabel.TextTransparency = 0.3
		titleLabel.TextSize = sizes.fontSize.section
		titleLabel.Font = Enum.Font.GothamMedium
		titleLabel.TextXAlignment = Enum.TextXAlignment.Left
		titleLabel.LayoutOrder = 0
		titleLabel.Parent = section
		addPadding(titleLabel, 0, 0, 12, 0)

		for i, item in ipairs(sectionData.items) do
			local isActive = (item.id == activeItem)

			local button = Instance.new("TextButton")
			button.Name = item.id
			button.Size = UDim2.new(1, -sizes.padding, 0, sizes.buttonHeight)
			button.Position = UDim2.new(0, sizes.padding/2, 0, 0)
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

			local iconContainer = createIcon(button, item.icon, sizes.iconSize, isActive and Colors.Blue or Colors.TextDark)
			if iconContainer then
				iconContainer.Position = UDim2.new(0, 12, 0.5, -sizes.iconSize/2)
				iconContainer.Name = "Icon"
			end

			local textLabel = Instance.new("TextLabel")
			textLabel.Name = "Label"
			textLabel.Size = UDim2.new(1, -50, 1, 0)
			textLabel.Position = UDim2.new(0, 38, 0, 0)
			textLabel.BackgroundTransparency = 1
			textLabel.Text = item.label
			textLabel.TextColor3 = isActive and Colors.Blue or Colors.TextGray
			textLabel.TextSize = sizes.fontSize.button
			textLabel.Font = Enum.Font.Gotham
			textLabel.TextXAlignment = Enum.TextXAlignment.Left
			textLabel.Parent = button

			menuButtons[item.id] = {button = button, indicator = indicator, label = textLabel, iconContainer = iconContainer}

			button.MouseEnter:Connect(function()
				if item.id ~= activeItem then
					tween(button, {BackgroundTransparency = 0.95}, 0.15)
					tween(textLabel, {TextColor3 = Color3.fromRGB(170, 170, 170)}, 0.15)
				end
			end)

			button.MouseLeave:Connect(function()
				if item.id ~= activeItem then
					tween(button, {BackgroundTransparency = 1}, 0.15)
					tween(textLabel, {TextColor3 = Colors.TextGray}, 0.15)
				end
			end)

			button.MouseButton1Click:Connect(function()
				if menuButtons[activeItem] then
					local prev = menuButtons[activeItem]
					prev.indicator.Visible = false
					tween(prev.button, {BackgroundTransparency = 1}, 0.2)
					tween(prev.label, {TextColor3 = Colors.TextGray}, 0.2)
					if prev.iconContainer then updateIconColor(prev.iconContainer, Colors.TextDark) end
				end

				activeItem = item.id
				indicator.Visible = true
				indicator.BackgroundColor3 = Colors.Neon
				tween(button, {BackgroundTransparency = 0.9}, 0.2)
				tween(textLabel, {TextColor3 = Colors.Blue}, 0.2)
				if iconContainer then updateIconColor(iconContainer, Colors.Blue) end
			end)
		end
	end

	for i, sectionData in ipairs(menuData) do
		createMenuSection(sectionData, i)
	end

	-- Content Area
	local contentArea = Instance.new("Frame")
	contentArea.Name = "ContentArea"
	contentArea.Size = UDim2.new(1, -sizes.sidebarWidth, 1, -sizes.footerHeight)
	contentArea.Position = UDim2.new(0, sizes.sidebarWidth, 0, 0)
	contentArea.BackgroundTransparency = 1
	contentArea.Parent = mainFrame

	local pageTitle = Instance.new("TextLabel")
	pageTitle.Size = UDim2.new(1, 0, 0, 40)
	pageTitle.BackgroundTransparency = 1
	pageTitle.Text = "Aim"
	pageTitle.TextColor3 = Colors.TextDark
	pageTitle.TextSize = sizes.fontSize.title
	pageTitle.Font = Enum.Font.Gotham
	pageTitle.Parent = contentArea

	local cardsContainer = Instance.new("Frame")
	cardsContainer.Size = UDim2.new(1, -16, 1, -50)
	cardsContainer.Position = UDim2.new(0, 8, 0, 40)
	cardsContainer.BackgroundTransparency = 1
	cardsContainer.ClipsDescendants = true
	cardsContainer.Parent = contentArea

	-- Componentes PC
	local function createToggle(parent, enabled)
		local toggleContainer = Instance.new("Frame")
		toggleContainer.Size = UDim2.new(0, sizes.toggleWidth, 0, sizes.toggleHeight)
		toggleContainer.BackgroundTransparency = 1
		toggleContainer.Parent = parent

		local toggle = Instance.new("TextButton")
		toggle.Size = UDim2.new(1, 0, 1, 0)
		toggle.BackgroundColor3 = enabled and Colors.Blue or Colors.SliderBg
		toggle.Text = ""
		toggle.AutoButtonColor = false
		toggle.Parent = toggleContainer
		addCorner(toggle, sizes.toggleHeight/2)

		if enabled then addNeonGlow(toggle, Colors.Neon, 0.6) end

		local circleSize = sizes.toggleHeight - 4
		local circle = Instance.new("Frame")
		circle.Name = "Circle"
		circle.Size = UDim2.new(0, circleSize, 0, circleSize)
		circle.Position = enabled and UDim2.new(1, -circleSize-2, 0.5, -circleSize/2) or UDim2.new(0, 2, 0.5, -circleSize/2)
		circle.BackgroundColor3 = Colors.TextWhite
		circle.Parent = toggle
		addCorner(circle, circleSize/2)

		local isOn = enabled
		toggle.MouseButton1Click:Connect(function()
			isOn = not isOn
			local targetPos = isOn and UDim2.new(1, -circleSize-2, 0.5, -circleSize/2) or UDim2.new(0, 2, 0.5, -circleSize/2)
			tween(circle, {Position = targetPos}, 0.2)
			tween(toggle, {BackgroundColor3 = isOn and Colors.Blue or Colors.SliderBg}, 0.2)
			local neonGlow = toggle:FindFirstChild("NeonGlow")
			if isOn and not neonGlow then addNeonGlow(toggle, Colors.Neon, 0.6)
			elseif not isOn and neonGlow then neonGlow:Destroy() end
		end)

		return toggleContainer
	end

	local function createCheckbox(parent, checked, onLabel)
		local checkbox = Instance.new("TextButton")
		checkbox.Size = UDim2.new(0, sizes.checkboxSize, 0, sizes.checkboxSize)
		checkbox.BackgroundColor3 = checked and Colors.Blue or Colors.CardBackground
		checkbox.Text = ""
		checkbox.AutoButtonColor = false
		checkbox.Parent = parent
		addCorner(checkbox, 3)
		addStroke(checkbox, checked and Colors.Blue or Colors.SliderBg, 1)

		local checkContainer = Instance.new("Frame")
		checkContainer.Size = UDim2.new(1, -4, 1, -4)
		checkContainer.Position = UDim2.new(0, 2, 0, 2)
		checkContainer.BackgroundTransparency = 1
		checkContainer.Visible = checked
		checkContainer.Parent = checkbox

		local short = Instance.new("Frame")
		short.Size = UDim2.new(0, 2, 0, 5)
		short.Position = UDim2.new(0, 2, 0, 4)
		short.BackgroundColor3 = Colors.TextWhite
		short.BorderSizePixel = 0
		short.Rotation = -45
		short.Parent = checkContainer

		local long = Instance.new("Frame")
		long.Size = UDim2.new(0, 2, 0, 8)
		long.Position = UDim2.new(0, 6, 0, 0)
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
			if stroke then tween(stroke, {Color = isChecked and Colors.Blue or Colors.SliderBg}, 0.15) end
			if onLabel then tween(onLabel, {TextColor3 = isChecked and Colors.TextWhite or Colors.TextDark}, 0.15) end
		end)

		return checkbox
	end

	local function createSlider(parent, value)
		local sliderContainer = Instance.new("Frame")
		sliderContainer.Size = UDim2.new(0, sizes.sliderWidth, 0, sizes.sliderHeight)
		sliderContainer.BackgroundColor3 = Colors.SliderBg
		sliderContainer.Parent = parent
		addCorner(sliderContainer, 3)

		local sliderFill = Instance.new("Frame")
		sliderFill.Name = "Fill"
		sliderFill.Size = UDim2.new(value / 100, 0, 1, 0)
		sliderFill.BackgroundColor3 = Colors.Blue
		sliderFill.BorderSizePixel = 0
		sliderFill.Parent = sliderContainer
		addCorner(sliderFill, 3)

		local dotSize = 10
		local sliderDot = Instance.new("Frame")
		sliderDot.Name = "SliderDot"
		sliderDot.Size = UDim2.new(0, dotSize, 0, dotSize)
		sliderDot.Position = UDim2.new(value / 100, -dotSize/2, 0.5, -dotSize/2)
		sliderDot.BackgroundColor3 = Colors.Neon
		sliderDot.BorderSizePixel = 0
		sliderDot.Parent = sliderContainer
		addCorner(sliderDot, dotSize/2)

		local dragging = false

		sliderContainer.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				local relativeX = math.clamp((input.Position.X - sliderContainer.AbsolutePosition.X) / sliderContainer.AbsoluteSize.X, 0, 1)
				tween(sliderFill, {Size = UDim2.new(relativeX, 0, 1, 0)}, 0.1)
				tween(sliderDot, {Position = UDim2.new(relativeX, -dotSize/2, 0.5, -dotSize/2)}, 0.1)
			end
		end)

		sliderContainer.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = false
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				local relativeX = math.clamp((input.Position.X - sliderContainer.AbsolutePosition.X) / sliderContainer.AbsoluteSize.X, 0, 1)
				sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
				sliderDot.Position = UDim2.new(relativeX, -dotSize/2, 0.5, -dotSize/2)
			end
		end)

		return sliderContainer
	end

	local function createDropdown(parent, value)
		local dropdown = Instance.new("Frame")
		dropdown.Size = UDim2.new(0, sizes.dropdownWidth, 0, sizes.dropdownHeight)
		dropdown.BackgroundColor3 = Colors.DropdownBg
		dropdown.Parent = parent
		addCorner(dropdown, 3)
		addStroke(dropdown, Colors.Border, 1)

		local text = Instance.new("TextLabel")
		text.Size = UDim2.new(1, -20, 1, 0)
		text.Position = UDim2.new(0, 8, 0, 0)
		text.BackgroundTransparency = 1
		text.Text = value
		text.TextColor3 = Colors.TextDark
		text.TextSize = 10
		text.Font = Enum.Font.Gotham
		text.TextXAlignment = Enum.TextXAlignment.Left
		text.Parent = dropdown

		local chevronSize = 10
		local chevron = createChevronIcon(dropdown, chevronSize, Colors.TextDark)
		chevron.Position = UDim2.new(1, -chevronSize-4, 0.5, -chevronSize/2)

		return dropdown
	end

	local function createSettingRow(parent, label, settingType, value, yPos)
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, -16, 0, sizes.rowHeight)
		row.Position = UDim2.new(0, 8, 0, yPos)
		row.BackgroundTransparency = 1
		row.Parent = parent

		local isActive = (settingType ~= "checkbox") or (settingType == "checkbox" and value == true)

		local labelText = Instance.new("TextLabel")
		labelText.Name = "Label"
		labelText.Size = UDim2.new(0.55, 0, 1, 0)
		labelText.BackgroundTransparency = 1
		labelText.Text = label
		labelText.TextColor3 = isActive and Colors.TextWhite or Colors.TextDark
		labelText.TextSize = sizes.fontSize.label
		labelText.Font = Enum.Font.Gotham
		labelText.TextXAlignment = Enum.TextXAlignment.Left
		labelText.Parent = row

		local controlContainer = Instance.new("Frame")
		controlContainer.Size = UDim2.new(0.45, 0, 1, 0)
		controlContainer.Position = UDim2.new(0.55, 0, 0, 0)
		controlContainer.BackgroundTransparency = 1
		controlContainer.Parent = row

		if settingType == "text" then
			local valueLabel = Instance.new("TextLabel")
			valueLabel.Size = UDim2.new(1, -4, 1, 0)
			valueLabel.BackgroundTransparency = 1
			valueLabel.Text = tostring(value)
			valueLabel.TextColor3 = Colors.TextDark
			valueLabel.TextSize = sizes.fontSize.label
			valueLabel.Font = Enum.Font.Gotham
			valueLabel.TextXAlignment = Enum.TextXAlignment.Right
			valueLabel.Parent = controlContainer
		elseif settingType == "checkbox" then
			local cb = createCheckbox(controlContainer, value, labelText)
			cb.Position = UDim2.new(1, -sizes.checkboxSize, 0.5, -sizes.checkboxSize/2)
		elseif settingType == "slider" then
			local sl = createSlider(controlContainer, value)
			sl.Position = UDim2.new(1, -sizes.sliderWidth, 0.5, -sizes.sliderHeight/2)
		elseif settingType == "dropdown" then
			local dd = createDropdown(controlContainer, value)
			dd.Position = UDim2.new(1, -sizes.dropdownWidth, 0.5, -sizes.dropdownHeight/2)
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
		addCorner(card, 6)
		addStroke(card, Colors.Border, 1)

		local header = Instance.new("Frame")
		header.Name = "Header"
		header.Size = UDim2.new(1, 0, 0, sizes.headerHeight)
		header.BackgroundTransparency = 1
		header.Parent = card

		local headerBorder = Instance.new("Frame")
		headerBorder.Size = UDim2.new(1, 0, 0, 1)
		headerBorder.Position = UDim2.new(0, 0, 1, -1)
		headerBorder.BackgroundColor3 = Colors.Border
		headerBorder.BorderSizePixel = 0
		headerBorder.Parent = header

		local headerNeonLine = Instance.new("Frame")
		headerNeonLine.Size = UDim2.new(0, 40, 0, 2)
		headerNeonLine.Position = UDim2.new(0, 12, 1, -1)
		headerNeonLine.BackgroundColor3 = Colors.Neon
		headerNeonLine.BackgroundTransparency = 0.4
		headerNeonLine.BorderSizePixel = 0
		headerNeonLine.Parent = header

		local cardIcon = createIcon(header, iconType, sizes.cardIconSize, Colors.Blue)
		if cardIcon then cardIcon.Position = UDim2.new(0, 12, 0.5, -sizes.cardIconSize/2) end

		local titleLabel = Instance.new("TextLabel")
		titleLabel.Size = UDim2.new(1, -100, 1, 0)
		titleLabel.Position = UDim2.new(0, 32, 0, 0)
		titleLabel.BackgroundTransparency = 1
		titleLabel.Text = title
		titleLabel.TextColor3 = Colors.TextWhite
		titleLabel.TextSize = sizes.fontSize.button
		titleLabel.Font = Enum.Font.GothamMedium
		titleLabel.TextXAlignment = Enum.TextXAlignment.Left
		titleLabel.Parent = header

		local mainToggle = createToggle(header, true)
		mainToggle.Position = UDim2.new(1, -sizes.toggleWidth - 12, 0.5, -sizes.toggleHeight/2)

		local content = Instance.new("Frame")
		content.Name = "Content"
		content.Size = UDim2.new(1, 0, 1, -(sizes.headerHeight + 8))
		content.Position = UDim2.new(0, 0, 0, sizes.headerHeight + 4)
		content.BackgroundTransparency = 1
		content.Parent = card

		for i, setting in ipairs(settings) do
			createSettingRow(content, setting.label, setting.type, setting.value, (i - 1) * sizes.rowHeight + 4)
		end

		return card
	end

	-- Cards PC - Grid 2x2
	local cardWidth = 0.485
	local cardGap = 10

	createSettingsCard(cardsContainer, "Aimbot", "crosshair", {
		{label = "Aimbot Hotkey", type = "text", value = "Mouse 2"},
		{label = "Target Peds", type = "checkbox", value = true},
		{label = "Visible Check", type = "checkbox", value = true},
		{label = "Field Of View", type = "slider", value = 70},
		{label = "Smooth", type = "slider", value = 80},
		{label = "Curve", type = "slider", value = 40},
		{label = "Aim Distance", type = "slider", value = 85},
		{label = "Hitbox", type = "dropdown", value = "Head"},
		{label = "Dual Aimbot", type = "checkbox", value = false},
		{label = "FOV Circle", type = "checkbox", value = false},
	}, UDim2.new(0, 0, 0, 0), UDim2.new(cardWidth, 0, 0, 250))

	createSettingsCard(cardsContainer, "Silent Aim", "sparkles", {
		{label = "Enable Silent Aim", type = "checkbox", value = true},
		{label = "Silent Aim Hotkey", type = "text", value = "Mouse 2"},
		{label = "Field Of View", type = "slider", value = 90},
		{label = "Hitbox", type = "dropdown", value = "Head"},
		{label = "FOV Circle", type = "checkbox", value = false},
	}, UDim2.new(cardWidth, cardGap, 0, 0), UDim2.new(cardWidth, 0, 0, 145))

	createSettingsCard(cardsContainer, "Triggerbot", "zap", {
		{label = "Use Hotkey", type = "checkbox", value = true},
		{label = "Triggerbot Key", type = "text", value = "Mouse 2"},
		{label = "Target Players", type = "checkbox", value = true},
		{label = "Target Peds", type = "checkbox", value = true},
		{label = "Target Dead", type = "checkbox", value = true},
		{label = "Delay", type = "slider", value = 60},
	}, UDim2.new(0, 0, 0, 260), UDim2.new(cardWidth, 0, 0, 165))

	createSettingsCard(cardsContainer, "Magic Bullet", "target", {
		{label = "Enable Magic Bullet", type = "checkbox", value = true},
		{label = "Magic Bullet Hotkey", type = "text", value = "Mouse 2"},
		{label = "Field Of View", type = "slider", value = 95},
		{label = "Hitbox", type = "dropdown", value = "Head"},
		{label = "FOV Circle", type = "checkbox", value = false},
	}, UDim2.new(cardWidth, cardGap, 0, 155), UDim2.new(cardWidth, 0, 0, 145))

	-- Footer
	local footer = Instance.new("Frame")
	footer.Name = "Footer"
	footer.Size = UDim2.new(1, -sizes.sidebarWidth, 0, sizes.footerHeight)
	footer.Position = UDim2.new(0, sizes.sidebarWidth, 1, -sizes.footerHeight)
	footer.BackgroundTransparency = 1
	footer.Parent = mainFrame

	local footerBorder = Instance.new("Frame")
	footerBorder.Size = UDim2.new(1, 0, 0, 1)
	footerBorder.Position = UDim2.new(0, 0, 0, 0)
	footerBorder.BackgroundColor3 = Colors.Border
	footerBorder.BorderSizePixel = 0
	footerBorder.Parent = footer

	local footerText = Instance.new("TextLabel")
	footerText.Size = UDim2.new(1, -24, 1, 0)
	footerText.Position = UDim2.new(0, 12, 0, 0)
	footerText.BackgroundTransparency = 1
	footerText.Text = "unsilenced v1.0 | discord.gg/silenced | Premium User"
	footerText.TextColor3 = Colors.TextFooter
	footerText.TextSize = sizes.fontSize.footer
	footerText.Font = Enum.Font.Gotham
	footerText.TextXAlignment = Enum.TextXAlignment.Left
	footerText.Parent = footer

	local neonDotSize = 6
	local footerNeonDot = Instance.new("Frame")
	footerNeonDot.Size = UDim2.new(0, neonDotSize, 0, neonDotSize)
	footerNeonDot.Position = UDim2.new(1, -neonDotSize*3, 0.5, -neonDotSize/2)
	footerNeonDot.BackgroundColor3 = Colors.Neon
	footerNeonDot.Parent = footer
	addCorner(footerNeonDot, neonDotSize/2)

	spawn(function()
		local bright = true
		while footerNeonDot.Parent do
			tween(footerNeonDot, {BackgroundTransparency = bright and 0 or 0.5}, 1)
			bright = not bright
			wait(1)
		end
	end)

	-- Toggle PC (INSERT key)
	local menuVisible = true
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.KeyCode == Enum.KeyCode.Insert then
			menuVisible = not menuVisible
			mainFrame.Visible = menuVisible
		end
	end)

	-- Draggable PC
	local dragging = false
	local dragStart = nil
	local startPos = nil

	mainFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = mainFrame.Position
		end
	end)

	mainFrame.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end
