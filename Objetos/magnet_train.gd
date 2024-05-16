extends Area2D

var target = null
var speed = -1

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var audio = $Aud

@onready var player = get_tree().get_first_node_in_group("player")

func collect():
	audio.play()
	collision.call_deferred("set","disabled",true)
	sprite.visible = false
	var tween = player.create_tween()
	var previous_size = player.grabAreaCollision.shape.radius
	player.grabAreaCollision.shape.radius = 99999.0
	tween.tween_property(player.grabAreaCollision.shape,"radius",previous_size,0.1)
	tween.play()
	return 0

func _on_aud_finished():
	queue_free()
