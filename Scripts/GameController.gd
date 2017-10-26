extends Node

var nextDiff = 0
var nextLevel = 0

func _ready():
	pass

func SetNextLevel(sentDiff, sentLevel):
	nextDiff = sentDiff
	nextLevel = sentLevel

func IncLevel():
	nextLevel += 1

func GetNextLevel():
	return Vector2(nextDiff, nextLevel)