extends StaticBody2D

@export var dialog_lines: Array[String] = []
var dialog_index: int = 0

var can_interact: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !can_interact or !Input.is_action_just_pressed('interact'): return
	
	$AudioStreamPlayer2D.play()
	
	if dialog_index < dialog_lines.size():
		$CanvasLayer.visible = true
		get_tree().paused = true
		
		$CanvasLayer/DialogueText.text = dialog_lines[dialog_index]
		dialog_index += 1
	else:
		$CanvasLayer.visible = false
		get_tree().paused = false
		dialog_index = 0
