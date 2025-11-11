extends Control

var selected_world := 0 setget ,_get_selected_world
var _bg = ButtonGroup.new()
var _buttons = []


func init_buttons() -> void:
	var i = 0
	for wn in Global.worlds:
		var wd = Global.worlds[wn]
		var b = GroupButton.new()
		b.toggle_mode = true
		if i == selected_world:
			b.pressed = true
		b.icon = load(wd.preview_path)
		b.hint_tooltip = wd.name
		b.group = _bg
		add_child(b)
		_buttons.append(b)
		i += 1


func _get_selected_world() -> int:
	return _buttons.find(_bg.get_pressed_button())
