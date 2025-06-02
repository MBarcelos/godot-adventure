extends TileMapLayer

func enable_secret_wall():
	visible = true
	collision_enabled = true

func disable_secret_wall():
	visible = false
	collision_enabled = false


func _on_switch_switch_activated() -> void:
	disable_secret_wall()


func _on_switch_switch_deactivated() -> void:
	enable_secret_wall()
