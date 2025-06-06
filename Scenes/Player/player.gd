extends CharacterBody2D
class_name Player

@export var acceleration: float = 5
@export var move_speed: float = 60
@export var push_strength: float = 10

var is_attacking: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_treasure_label()
	update_hp_bar()
	if SceneManager.player_spawn_position != Vector2(0,0):
		position = SceneManager.player_spawn_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if not is_attacking:
		move_player()
	push_blocks()
	update_treasure_label()
	
	if Input.is_action_just_pressed("interact"):
		attack()
	
	move_and_slide()

func move_player() -> void:
	var move_vector: Vector2 = Input.get_vector('move_left', 'move_right', 'move_up', 'move_down')
	
	velocity = velocity.move_toward(move_vector * move_speed, acceleration)
	
	if velocity.x > 0:
		$AnimatedSprite2D.play('move_right')
		$InteractArea2D.position = Vector2(5, 2)
	elif velocity.y < 0:
		$AnimatedSprite2D.play('move_up')
		$InteractArea2D.position = Vector2(0, -4)
	elif velocity.x < 0:
		$AnimatedSprite2D.play('move_left')
		$InteractArea2D.position = Vector2(-5, 2)
	elif velocity.y > 0:
		$AnimatedSprite2D.play('move_down')
		$InteractArea2D.position = Vector2(0, 8)
	else:
		$AnimatedSprite2D.stop()

func update_treasure_label():
	%TreasureLabel.text = str(SceneManager.opened_chest.size())

# Get last collision
# Check if it's the block
# If it is the block, push it
func push_blocks() -> void:
	var collision: KinematicCollision2D = get_last_slide_collision()
	if !collision: return
	
	var collider_node = collision.get_collider()
	
	if !collider_node.is_in_group('pushable'): return
	
	var collision_normal: Vector2 = collision.get_normal()
	collider_node.apply_central_force(-collision_normal * push_strength)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('interactable'):
		body.can_interact = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group('interactable'):
		body.can_interact = false

func _on_hitbox_area_2d_body_entered(body: Node2D) -> void:
	# Body is always an enemy because the hitbox only interacts (mask) with layer 5 - Enemies
	SceneManager.player_hp -= 1
	update_hp_bar()

	if SceneManager.player_hp <= 0: kill_player()
	
	var distance_to_player: Vector2 = global_position - body.global_position
	var knockback_direction: Vector2 = distance_to_player.normalized()
	var knockback_strength: float = 150
	
	velocity += knockback_direction * knockback_strength
	

func kill_player() -> void:
	SceneManager.player_hp = SceneManager.INITIAL_HP
	get_tree().call_deferred("reload_current_scene")

func update_hp_bar():
	%HPBar.play("%s_hp" % SceneManager.player_hp)

func attack():
	$Weapon.visible = true
	$Weapon/WeaponArea2D.monitoring = true
	$AttackDurationTimer.start()
	is_attacking = true
	velocity = Vector2(0, 0)
	
	var current_animation = $AnimatedSprite2D.animation
	if current_animation == "move_right":
		$AnimatedSprite2D.play("attack_right")
		$AnimationPlayer.play("attack_right")
	elif current_animation == "move_down":
		$AnimatedSprite2D.play("attack_down")
		$AnimationPlayer.play("attack_down")
	elif current_animation == "move_left":
		$AnimatedSprite2D.play("attack_left")
		$AnimationPlayer.play("attack_left")
	elif current_animation == "move_up":
		$AnimatedSprite2D.play("attack_up")
		$AnimationPlayer.play("attack_up")

func _on_weapon_area_2d_body_entered(body: Node2D) -> void:
	var distance_to_enemy: Vector2 = body.global_position - global_position
	var knockback_direction: Vector2 = distance_to_enemy.normalized()
	var knockback_strenght: float = 150
	body.velocity += knockback_direction * knockback_strenght
	body.hp -= 1
	
	if body.hp <= 0: body.queue_free()

func _on_attack_duration_timer_timeout() -> void:
	$Weapon.visible = false
	$Weapon/WeaponArea2D.monitoring = false
	is_attacking = false
	
	var current_animation = $AnimatedSprite2D.animation
	if current_animation == "attack_right":
		$AnimatedSprite2D.play("move_right")
	elif current_animation == "attack_down":
		$AnimatedSprite2D.play("move_down")
	elif current_animation == "attack_left":
		$AnimatedSprite2D.play("move_left")
	elif current_animation == "attack_up":
		$AnimatedSprite2D.play("move_up")
