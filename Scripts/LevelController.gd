extends Node2D

var playerNode = load("res://Scenes/PlayerScene.tscn").instance()
var levelStrAry = []
var levelDrawn = false
var levelWon = false

# Tile int constants
const WALL_DR = 0; const WALL_DLR = 1; const WALL_DL = 2; const WALL_UD = 3;
const WALL_UDR = 4; const WALL_UDLR = 5; const WALL_UDL = 6; const WALL_LR = 7;
const WALL_UR = 8; const WALL_ULR = 9; const WALL_UL = 10; const WALL = 11;
const WALL_U = 12; const WALL_D = 13; const WALL_L = 14; const WALL_R = 15;
const FLOOR = 16; const TARGET = 17

func _ready():
	self.add_child(playerNode)
	playerNode.SetLevelController(self)
	self.DrawLevel()

func CheckPlayerMove(playerTilePos, moveVec):
	var checkPos = playerTilePos + moveVec
	
	# Check for wall collision
	if (levelStrAry[checkPos.y][checkPos.x] == "#"):
		return false
	
	# Check for box collision
	for curBox in get_node("BoxGroup").get_children():
		if (curBox.GetTilePos() == checkPos):
			if (not CheckBoxMove(curBox, moveVec)):
				return false
			else: return true
	
	return true

func CheckBoxMove(sentBox, moveVec):
	var checkPos = sentBox.GetTilePos() + moveVec
	
	# Check for wall collision
	if (levelStrAry[checkPos.y][checkPos.x] == "#"):
		return false
	
	# Check for box collision
	for curBox in get_node("BoxGroup").get_children():
		if (curBox.GetTilePos() == checkPos):
			return false
	
	# No collisions found; move box
	sentBox.SetPos(checkPos.x, checkPos.y)
	return true

func CheckWin():
	if (not levelDrawn):
		return
	
	for curBox in get_node("BoxGroup").get_children():
		if (not curBox.onTarget):
			return
	
	# Flag as won to let call stack finish processing before calling LevelWin()
	levelWon = true

func LevelWin():
	if (not levelWon): return
	levelWon = false
	print("Game won in ", playerNode.moveCount, " moves!")
	
	# Move on to next level
	GameController.IncLevel()
	self.DrawLevel()

func ResetLevel():
	levelDrawn = false
	get_node("TileMap").clear()
	playerNode.moveCount = 0
	
	for curBox in get_node("BoxGroup").get_children():
		curBox.free()

func DrawLevel():
	self.ResetLevel()
	var nextLevelVec = GameController.GetNextLevel()
	levelStrAry = LevelLoader.GetLevel(nextLevelVec.x, nextLevelVec.y)
	
	var curTile = Vector2(0, 0)
	
	for curInd in levelStrAry:
		for i in range(0, curInd.length()):
			if (curInd[i] == " "):
				# Check for floor tile
				get_node("TileMap").set_cell(curTile.x, curTile.y, FLOOR)
			elif (curInd[i] == "@"):
				# Check for player position
				get_node("TileMap").set_cell(curTile.x, curTile.y, FLOOR)
				playerNode.set_pos(Vector2((curTile.x * get_node("TileMap").get_cell_size().x), (curTile.y * get_node("TileMap").get_cell_size().y)))
			elif (curInd[i] == "$"):
				# Check for box
				get_node("TileMap").set_cell(curTile.x, curTile.y, FLOOR)
				var newBox = load("res://Scenes/BoxScene.tscn").instance()
				newBox.Init(self, curTile.x, curTile.y)
				get_node("BoxGroup").add_child(newBox)
			elif (curInd[i] == "*"):
				# Check for box on target tile
				get_node("TileMap").set_cell(curTile.x, curTile.y, TARGET)
				var newBox = load("res://Scenes/BoxScene.tscn").instance()
				newBox.Init(self, curTile.x, curTile.y)
				get_node("BoxGroup").add_child(newBox)
			elif (curInd[i] == "."):
				# Check for target tile
				get_node("TileMap").set_cell(curTile.x, curTile.y, TARGET)
			elif (curInd[i] == "#"):
				# Check for wall tile
				var tmpWallType = CheckWallType(curTile.x, curTile.y)
				get_node("TileMap").set_cell(curTile.x, curTile.y, tmpWallType)
			
			curTile.x += 1
		
		curTile.x = 0
		curTile.y += 1
	
	levelDrawn = true

func CheckWallType(sentX, sentY):
	var levelLength = levelStrAry[0].length()
	var levelHeight = levelStrAry.size()
	
	var wallU = false
	var wallD = false
	var wallL = false
	var wallR = false
	
	if (sentY != 0):
		# Check up
		if (levelStrAry[(sentY - 1)][sentX] == "#"):
			wallU = true
	if ((sentY + 1) != levelHeight):
		# Check down
		if (levelStrAry[(sentY + 1)][sentX] == "#"):
			wallD = true
	if (sentX != 0):
		# Check left
		if (levelStrAry[sentY][(sentX - 1)] == "#"):
			wallL = true
	if ((sentX + 1) != levelLength):
		# Check right
		if (levelStrAry[sentY][(sentX + 1)] == "#"):
			wallR = true
	
	if (wallU):
		if (wallD):
			if (wallL):
				if (wallR):
					return WALL_UDLR
				else:
					return WALL_UDL
			else:
				if (wallR):
					return WALL_UDR
				else:
					return WALL_UD
		else:
			if (wallL):
				if (wallR):
					return WALL_ULR
				else:
					return WALL_UL
			else:
				if (wallR):
					return WALL_UR
				else:
					return WALL_U
	elif (wallD):
		if (wallL):
			if (wallR):
				return WALL_DLR
			else:
				return WALL_DL
		else:
			if (wallR):
				return WALL_DR
			else:
				return WALL_D
	elif (wallL):
		if (wallR):
			return WALL_LR
		else:
			return WALL_L
	elif (wallR):
		return WALL_R
	
	return WALL
