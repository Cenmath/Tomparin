extends Sprite2D


func _ready():
	$Animacion.play("explosion")


func _on_animacion_animation_finished(_Animacion):
	queue_free()
