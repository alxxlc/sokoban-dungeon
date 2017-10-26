extends TextureButton

func _ready():
	pass

func SetText(sentText):
	get_node("Patch9Frame/VBoxContainer/RichTextLabel").set_text(("[center]{" + sentText + "}[/center]"))