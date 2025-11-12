extends WorldEnvironment

export(float) var background_energy: float setget set_bg_energy


func _ready() -> void:
	environment.tonemap_mode = Global.graphics_tonemap
	environment.glow_enabled = Global.graphics_glow


func set_bg_energy(energy):
	environment.set_bg_energy(energy)
