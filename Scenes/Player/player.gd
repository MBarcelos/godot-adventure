extends CharacterBody2D
class_name Player

@export var move_speed: float = 60
@export var push_strength: float = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_treasure_label()
	update_hp_bar()
	if SceneManager.player_spawn_position != Vector2(0,0):
		position = SceneManager.player_spawn_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	move_player()
	push_blocks()
	update_treasure_label()
	
	if Input.is_action_just_pressed("interact"):
		attack()
	
	move_and_slide()

func move_player() -> void:
	var move_vector: Vector2 = Input.get_vector('move_left', 'move_right', 'move_up', 'move_down')
	
	velocity = move_vector * move_speed
	
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
	if SceneManager.player_hp > 0: return
	
	kill_player()
	

func kill_player() -> void:
	SceneManager.player_hp = SceneManager.INITIAL_HP
	get_tree().call_deferred("reload_current_scene")

func update_hp_bar():
	%HPBar.play("%s_hp" % SceneManager.player_hp)

func attack():
	$Weapon.visible = true
	$Weapon/WeaponArea2D.monitoring = true
	$AttackDurationTimer.start()

func _on_weapon_area_2d_body_entered(body: Node2D) -> void:
	body.queue_free() # Deletes the body


func _on_attack_duration_timer_timeout() -> void:
	$Weapon.visible = false
	$Weapon/WeaponArea2D.monitoring = false
