extends StaticBody2D

var can_interact: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !can_interact: $CanvasLayer.visible = false
	if !can_interact or !Input.is_action_just_pressed('interact'): return
	
	$CanvasLayer.visible = !$CanvasLayer.visible
