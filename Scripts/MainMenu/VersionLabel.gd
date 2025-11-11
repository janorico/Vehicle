extends Label


func _ready() -> void:
	text = text % ProjectSettings.get("application/config/version")
