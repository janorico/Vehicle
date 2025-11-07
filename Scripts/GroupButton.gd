class_name GroupButton extends Button

const checkmark = preload("res://Assets/2D/Checkmark.svg")


func _draw() -> void:
	if pressed:
		var pos = (rect_size - checkmark.get_size()) / 2
		draw_texture(checkmark, pos)
