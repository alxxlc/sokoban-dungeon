extends Node2D

func _ready():
	pass

func _on_ExitButton_pressed():
	get_tree().quit()
	
func _on_LevelSelectButton_pressed():
	get_node("MainMenu").hide()
	get_node("PlayMenu").show()

func _on_PlayBackBtn_pressed():
	get_node("PlayMenu").hide()
	get_node("MainMenu").show()

func _on_StartGameBtn_pressed():
	var setDiff = get_node("PlayMenu/VBoxContainer/HBoxContainer/DiffEdit").get_value()
	var setLevel = get_node("PlayMenu/VBoxContainer/HBoxContainer/LevelEdit").get_value()
	
	GameController.SetNextLevel(setDiff, setLevel)
	get_tree().change_scene("res://Scenes/LevelScene.tscn")
