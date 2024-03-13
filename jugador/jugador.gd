extends CharacterBody2D

#Estadisticas
var movement_speed = 40.0
var hp = 80
var last_movement = Vector2.UP

#Level
var experience = 0
var experience_level = 1
var collected_experience = 0

#Ataques
var Flecha = preload("res://jugador/Attack/flecha.tscn")
var Tompa = preload("res://jugador/Attack/tompa.tscn")
var Jinetompa = preload("res://jugador/Attack/jinetompa.tscn")

#Nodos de ataque
@onready var FlechaTimer = get_node("%FlechaTimer")
@onready var FlechaAttackTimer = get_node("%FlechaAttackTimer")
@onready var TompaTimer = get_node("%TompaTimer")
@onready var TompaAttackTimer = get_node("%TompaAttackTimer")
@onready var JinetompaBase = get_node("%JinetompaBase")

#Flecha
var Flecha_ammo = 0
var Flecha_baseammo = 1
var Flecha_attackspeed = 1.0
var Flecha_level = 1

#Tompa
var Tompa_ammo = 0
var Tompa_baseammo = 1
var Tompa_attackspeed = 3.0
var Tompa_level = 1

#Jinetompa
var Jinetompa_ammo = 1
var Jinetompa_level = 1

#Contra enemigos
var enemy_close = []
#Modelo
@onready var sprite = $Kotone
@onready var walkTimer = get_node("%walkTimer")

#HUD
@onready var ExpBar = get_node("%ExperienceBar")
@onready var lbllevel = get_node("%lbl_level")
@onready var LevelPanel = get_node("%LevelUP")
@onready var UpgradeOptions = get_node("%UpgradeOptions")
@onready var ItemOptions = preload("res://Datos/item_options.tscn")
@onready var AudLevelUP = get_node("%Aud_LevelUP")

func _ready():
	attack()
	set_ExpBar(experience, calculate_experiencecap())
#movimiento
func _physics_process(_delta):
	movement()

func movement():
	var x_mov = Input.get_axis("left","right")
	var y_mov = Input.get_axis("up","down" )
	var mov = Vector2(x_mov,y_mov)
	if mov.x > 0:
		sprite.flip_h = true
	elif mov.x < 0: 
		sprite.flip_h = false
		
	if mov != Vector2.ZERO:
		last_movement = mov
		if walkTimer.is_stopped():
			if sprite.frame >= sprite.hframes - 1:
				sprite.frame = 0
			else:
				sprite.frame += 1
			walkTimer.start()
	
	velocity = mov.normalized()*movement_speed
	move_and_slide()
#ataque
func attack():
	if Flecha_level > 0:
		FlechaTimer.wait_time = Flecha_attackspeed
		if FlechaTimer.is_stopped():
			FlechaTimer.start()
	if Tompa_level > 0:
		TompaTimer.wait_time = Tompa_attackspeed
		if TompaTimer.is_stopped():
			TompaTimer.start()
	if Jinetompa_level > 0:
		spawn_jinetompa()

#contador de hp
func _on_hurt_box_hurt(damage, _angle, _knockback):
	hp -= damage
	print(hp)


func _on_flecha_timer_timeout():
	Flecha_ammo += Flecha_baseammo
	FlechaAttackTimer.start()


func _on_flecha_attack_timer_timeout():
	if Flecha_ammo > 0:
		var Flecha_attack = Flecha.instantiate()
		Flecha_attack.position = position
		Flecha_attack.target = get_random_target()
		Flecha_attack.level = Flecha_level
		add_child(Flecha_attack)
		Flecha_ammo -= 1
		if Flecha_ammo > 0:
			FlechaAttackTimer.start()
		else:
			FlechaAttackTimer.stop()

func _on_tompa_timer_timeout():
	Tompa_ammo += Tompa_baseammo
	TompaAttackTimer.start()

func _on_tompa_attack_timer_timeout():
	if Tompa_ammo > 0:
		var Tompa_attack = Tompa.instantiate()
		Tompa_attack.position = position
		Tompa_attack.last_movement = last_movement
		Tompa_attack.level = Tompa_level
		add_child(Tompa_attack)
		Tompa_ammo -= 1
		if Tompa_ammo > 0:
			TompaAttackTimer.start()
		else:
			TompaAttackTimer.stop()

func spawn_jinetompa():
	var get_jinetompa_total = JinetompaBase.get_child_count()
	var calc_spawn = Jinetompa_ammo - get_jinetompa_total
	while calc_spawn > 0:
		var jinetompa_spawn = Jinetompa.instantiate()
		jinetompa_spawn.global_position = global_position
		JinetompaBase.add_child(jinetompa_spawn)
		calc_spawn -= 1

#sistema de apuntado
func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP

#detección de hit
func _on_enemy_detection_area_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)


func _on_enemy_detection_area_body_exited(body):
	if enemy_close.has(body):
		enemy_close.erase(body)



func _on_grab_area_area_entered(area):
	if area.is_in_group("loot"):
		area.target = self


func _on_collect_area_area_entered(area):
	if area.is_in_group("loot"):
		var coin_exp = area.collect()
		calculate_experience(coin_exp)
#Exp
func calculate_experience(coin_exp):
	var exp_required = calculate_experiencecap()
	collected_experience += coin_exp
	if experience + collected_experience >= exp_required:
		collected_experience -= exp_required-experience
		experience_level += 1
		experience = 0
		exp_required = calculate_experiencecap()
		Levelup()
	else:
		experience += collected_experience
		collected_experience = 0
	
	set_ExpBar(experience, exp_required)

func calculate_experiencecap():
	var exp_cap = experience_level
	if experience_level < 20:
		exp_cap = experience_level*5
	elif experience_level < 40:
		exp_cap = 95 * (experience_level-19)*8
	else:
		exp_cap = 255 + (experience_level-39)*12
		
	return exp_cap

func set_ExpBar(set_value = 1, set_max_value = 100):
	ExpBar.value = set_value
	ExpBar.max_value = set_max_value

func Levelup():
	AudLevelUP.play()
	lbllevel.text = str("Level:", experience_level)
	var tween = LevelPanel.create_tween()
	tween.tween_property(LevelPanel,"position",Vector2(220,50),0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.play()
	LevelPanel.visible = true
	var options = 0
	var optionsmax = 3
	while options < optionsmax:
		var option_choice = ItemOptions.instantiate()
		UpgradeOptions.add_child(option_choice)
		options += 1
	
	get_tree().paused = true

func upgrade_character(upgrade):
	var option_children = UpgradeOptions.get_children()
	for i in option_children:
		i.queue_free()
	LevelPanel.visible = false
	LevelPanel.position = Vector2(800,50)
	get_tree().paused = false
	calculate_experience(0)
