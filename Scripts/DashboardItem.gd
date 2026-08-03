extends Label

var value := 0.0 setget set_value
export(String) var title := "" setget set_title
export(String) var content_text := "" setget set_content_text
export(int) var minimum = 0
export(int) var maximum = 200

func _ready():
	update_text()
	update_rotation()

func set_value(new_value):
	value = new_value
	update_rotation()

func set_title(new_title):
	title = new_title
	update_text()

func set_content_text(new_content_text):
	content_text = new_content_text
	update_text()

func update_rotation():
	if minimum >= 0:
		value = abs(value)
	$ColorRect.rect_rotation = clamp(range_lerp(value, minimum, maximum, -90, 90), -90, 90)

func update_text():
	text = title
	$Text.text = content_text
