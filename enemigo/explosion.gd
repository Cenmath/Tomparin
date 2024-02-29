extends Sprite2D


func _ready():
	$Animacion.play("explosion")


func _on_animacion_animation_finished(anim_name):
	queue_free()
