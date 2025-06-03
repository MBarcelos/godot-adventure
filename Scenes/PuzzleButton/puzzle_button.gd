extends Area2D

@export var is_single_use: bool = false

var bodies_on_top: int = 0
signal pressed
signal unpressed

func _on_body_entered(body: Node2D) -> void:
	bodies_on_top += 1
	if !body.is_in_group('pushable') and body is not Player: return
	if bodies_on_top != 1: return
	
	$AnimatedSprite2D.play('pressed')
	$AudioStreamPlayer2D.pitch_scale = 0.8
	$AudioStreamPlayer2D.play()
	pressed.emit()


func _on_body_exited(body: Node2D) -> void:
	bodies_on_top -= 1
	if !body.is_in_group('pushable') and body is not Player: return
	if bodies_on_top != 0: return
	if is_single_use: return
	
	$AnimatedSprite2D.play('unpressed')
	$AudioStreamPlayer2D.pitch_scale = 0.6
	$AudioStreamPlayer2D.play()
	unpressed.emit()
