extends Sprite

var tileSize = 32

func _ready():
	pass

func SetPos(tilePosX, tilePosY):
	self.set_pos(Vector2((tilePosX * tileSize), (tilePosY * tileSize)))

func GetTilePos():
	var curPos = self.get_pos()
	curPos.x = int(curPos.x / tileSize)
	curPos.y = int(curPos.y / tileSize)
	return curPos