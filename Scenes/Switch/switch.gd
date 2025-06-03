extends StaticBody2D

signal switch_activated
signal switch_deactivated

var can_interact: bool = false
var is_activated: bool = false

func _process(delta: float) -> void:
	if !can_interact or !Input.is_action_just_pressed('interact'): return
	
	$AudioStreamPlayer2D.play()
	
	if is_activated:
		deactivate_switch()
	else:
		activate_switch()

func activate_switch():
	$AnimatedSprite2D.play('activated')
	switch_activated.emit()
	is_activated = true

func deactivate_switch():
	$AnimatedSprite2D.play('deactivated')
	switch_deactivated.emit()
	is_activated = false
