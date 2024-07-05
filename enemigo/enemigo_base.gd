extends CharacterBody2D

class_name EnemyBody

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

@onready var sprite = $EnemigoBase/Sprite
@onready var anim = $AnimationPlayer
@onready var snd_hit = $EnemigoBase/en_hit
@onready var Hitbox = $EnemigoBase/HitBox
@onready var Hurtbox = $EnemigoBase/HurtBox
@onready var collision = $CollisionShape2D
@onready var hidetimer = $EnemigoBase/HideTimer

var death_anim = preload("res://enemigo/explosion.tscn")
var exp_coin = preload("res://Objetos/experience_coin.tscn")
var Magnet_Train = preload("res://Objetos/Magnet_Train.tscn")

signal remove_from_array(object)

var screen_size

func _ready():
	add_to_group("Enemigo")
	anim.play("walk")
	Hitbox.damage = enemy_damage
	screen_size = get_viewport_rect().size
	Hurtbox.connect("hurt",Callable(self,"_on_hurt_box_hurt")) 
	hidetimer.connect("timeout",Callable(self,"_on_hide_timer_timeout"))
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
	var rand_num = randi() % 100
	if rand_num == 1:
		var magnet_train = Magnet_Train.instantiate()
		magnet_train.global_position = global_position
		loot_base.call_deferred("add_child",magnet_train)
	queue_free()

func _on_hurt_box_hurt(damage, angle, knockback_amount):
	hp -= damage
	knockback = angle * knockback_amount
	if hp <= 0:
		death()
	else:
		snd_hit.play()

func _on_hide_timer_timeout():
	var location_dif = global_position - player.global_position
	if abs(location_dif.x) > (screen_size.x/2) * 1.4 || abs(location_dif.y) > (screen_size.y/2) * 1.4:
		visible = false
	else:
		visible = true
