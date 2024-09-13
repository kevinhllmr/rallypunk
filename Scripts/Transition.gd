extends CanvasLayer

signal transitioned

func _ready():
	$ColorRect.color = Color(0, 0, 0, 0)

func transition():
	$AnimationPlayer.play("fade_to_black")
	
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		print("transition")
		emit_signal("transitioned")
		$AnimationPlayer.play("fade_to_normal")
