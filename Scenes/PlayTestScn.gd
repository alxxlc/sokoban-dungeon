extends Node2D

export var levelSet = 0
export var levelNum = 1
var levelStrAry = []
var boxPlaces = []

# Tile int constants
const WALL_DR = 0
const WALL_DLR = 1
const WALL_DL = 2
const WALL_UD = 3
const WALL_UDR = 4
const WALL_UDLR = 5
const WALL_UDL = 6
const WALL_LR = 7
const WALL_UR = 8
const WALL_ULR = 9
const WALL_UL = 10
const WALL = 11
const WALL_U = 12
const WALL_D = 13
const WALL_L = 14
const WALL_R = 15
const FLOOR = 16
const TARGET = 17

func _ready():
	DrawLevel(levelSet, levelNum)

func DrawLevel(sentLvlSet, sentLvlNum):
	levelStrAry = LevelLoader.GetLevel(sentLvlSet, sentLvlNum)
	get_node("TileMap").clear()
	boxPlaces.clear()
	
	var curTile = Vector2(0, 0)
	
	for curInd in levelStrAry:
		for i in range(0, curInd.length()):
			if (curInd[i] == " "):
				get_node("TileMap").set_cell(curTile.x, curTile.y, FLOOR)
			elif (curInd[i] == "@"):
				get_node("TileMap").set_cell(curTile.x, curTile.y, FLOOR)
				get_node("Player").set_pos(Vector2((curTile.x * get_node("TileMap").get_cell_size().x), (curTile.y * get_node("TileMap").get_cell_size().y)))
			elif (curInd[i] == "$"):
				get_node("TileMap").set_cell(curTile.x, curTile.y, FLOOR)
				boxPlaces.append(curTile)
			elif (curInd[i] == "*"):
				get_node("TileMap").set_cell(curTile.x, curTile.y, TARGET)
				boxPlaces.append(curTile)
			elif (curInd[i] == "."):
				get_node("TileMap").set_cell(curTile.x, curTile.y, TARGET)
			elif (curInd[i] == "#"):
				var tmpWallType = CheckWallType(curTile.x, curTile.y)
				get_node("TileMap").set_cell(curTile.x, curTile.y, tmpWallType)
			
			curTile.x += 1
		
		curTile.x = 0
		curTile.y += 1

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