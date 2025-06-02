extends StaticBody2D

@export var chest_name: String
var can_interact: bool = false
var is_open: bool = false

func _ready() -> void:
	if SceneManager.opened_chest.has(chest_name):
		is_open = true
		$AnimatedSprite2D.play("open")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !can_interact or !Input.is_action_just_pressed('interact'): return
	if is_open: return
	
	open_chest()

func open_chest() -> void:
	is_open = true
	$AnimatedSprite2D.play("open")
	$Sprite2D.visible = true
	$Timer.start()
	SceneManager.opened_chest.append(chest_name)

func _on_timer_timeout() -> void:
	$Sprite2D.visible = false
