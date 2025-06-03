extends CharacterBody2D

@export var hp: int = 2
@export var enemy_speed: float = 30
@export var acceleration: float = 5

var target: Node2D = null

func _physics_process(_delta: float) -> void:
	chase_target()
	animate_enemy()
	move_and_slide()
	

func chase_target() -> void:
	if !target: return
	
	var distance_to_player: Vector2 = target.global_position - global_position
	var direction_normal: Vector2 = distance_to_player.normalized()
	
	velocity = velocity.move_toward(direction_normal * enemy_speed, acceleration)
	
func animate_enemy() -> void:
	if velocity == Vector2(0, 0): return
	
	var normal_velocity: Vector2 = velocity.normalized()
	
	if normal_velocity.x > 0.707:
		$AnimatedSprite2D.play('move_right')
	elif normal_velocity.x < -0.707:
		$AnimatedSprite2D.play('move_left')
	elif normal_velocity.y > 0.707:
		$AnimatedSprite2D.play('move_down')
	elif normal_velocity.y < -0.707:
		$AnimatedSprite2D.play('move_up')
	else:
		$AnimatedSprite2D.stop()

func _on_detection_area_2d_body_entered(body: Node2D) -> void:
	if body is not Player: return
	
	target = body
