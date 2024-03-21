extends CharacterBody2D

#estadisticas
@export var movement_speed = 20.0
@export var hp = 10
@export var knockback_recovery = 3.5
@export var experience = 1
@export var enemy_damage = 1
var knockback = Vector2.ZERO
#Nodos
@onready var player = get_tree().get_first_node_in_group("player")
@onready var loot_base = get_tree().get_first_node_in_group("loot")
@onready var sprite = $Hater
@onready var anim = $AnimationPlayer
@onready var snd_hit = $en_hit
@onready var Hitbox = $HitBox

var death_anim = preload("res://enemigo/explosion.tscn")
var exp_coin = preload("res://Objetos/experience_coin.tscn")

signal remove_from_array(object)


func _ready():
	anim.play("walk")
	Hitbox.damage = enemy_damage
#movimiento
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	var direction = global_position.direction_to(player.global_position)
	velocity = direction*movement_speed
	velocity += knockback
	move_and_collide(velocity * delta)
	
	if direction.x > 0.1:
		sprite.flip_h = false
	elif direction.x < -0.1:
		sprite.flip_h = true

func death():
	emit_signal("remove_from_array",self)
	var enemy_death = death_anim.instantiate()
	enemy_death.scale = sprite.scale
	enemy_death.global_position = global_position
	get_parent().call_deferred("add_child",enemy_death)
	var new_coin = exp_coin.instantiate()
	new_coin.global_position = global_position
	new_coin.experience = experience
	loot_base.call_deferred("add_child", new_coin)
	queue_free()

func _on_hurt_box_hurt(damage, angle, knockback_amount):
	hp -= damage
	knockback = angle * knockback_amount
	if hp <= 0:
		death()
	else:
		snd_hit.play()
