extends Marker2D

signal puzzle_solved
signal puzzle_failed

var score: int = 0
@export var TARGET_SCORE = 2

func increase_score():
	score += 1
	
	if score >= TARGET_SCORE:
		puzzle_solved.emit()

func decrease_score():
	score -= 1
	
	if score < TARGET_SCORE:
		puzzle_failed.emit()
