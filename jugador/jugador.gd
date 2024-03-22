extends CharacterBody2D

#Base 
var movement_speed = 40.0
var hp = 80
var maxhp = 80
var last_movement = Vector2.UP
var time = 0

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

#Mejoras
var collected_upgrades = []
var upgrade_options = []
var armor = 0
var speed = 0
var spell_cooldown = 0
var spell_size = 0
var additional_attacks = 0

#Flecha
var Flecha_ammo = 0
var Flecha_baseammo = 0
var Flecha_attackspeed = 0.75
var Flecha_level = 0

#Tompa
var Tompa_ammo = 0
var Tompa_baseammo = 0
var Tompa_attackspeed = 3.0
var Tompa_level = 0

#Jinetompa
var Jinetompa_ammo = 0
var Jinetompa_level = 0

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
@onready var HPBar = get_node("%HPBar")
@onready var LbTimer = get_node("%LbTimer")
@onready var Weaponscol = get_node("%WeaponsCol")
@onready var Upgradescol = get_node("%UpgradesCol")
@onready var Itemcon = preload("res://jugador/HUD/item_con.tscn")
#Menu
@onready var Gameover = get_node("%GameOver")
@onready var Lblresult = get_node("%lbl_result")
@onready var audvictory = get_node("%Aud_victory")
@onready var audloss = get_node("%Aud_loss")
#Señales
signal playerdeath()

func _ready():
	upgrade_character("flecha1")
	attack()
	set_ExpBar(experience, calculate_experiencecap())
	_on_hurt_box_hurt(0,0,0)

func _physics_process(_delta):
	movement()

#Movimiento
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
		FlechaTimer.wait_time = Flecha_attackspeed * (1-spell_cooldown)
		if FlechaTimer.is_stopped():
			FlechaTimer.start()
	if Tompa_level > 0:
		TompaTimer.wait_time = Tompa_attackspeed * (1-spell_cooldown)
		if TompaTimer.is_stopped():
			TompaTimer.start()
	if Jinetompa_level > 0:
		spawn_jinetompa()

#contador de hp
func _on_hurt_box_hurt(damage, _angle, _knockback):
	hp -= clamp(damage-armor, 1.0, 999.0)
	HPBar.max_value = maxhp
	HPBar.value = hp
	if hp <= 0:
		death()


func _on_flecha_timer_timeout():
	Flecha_ammo += Flecha_baseammo + additional_attacks
	FlechaAttackTimer.start()


func _on_flecha_attack_timer_timeout():
	if Flecha_ammo > 0:
		var Flecha_attack = Flecha.instantiate()
		Flecha_attack.position = position
		Flecha_attack.target = get_global_mouse_position()
		Flecha_attack.level = Flecha_level
		add_child(Flecha_attack)
		Flecha_ammo -= 1
		if Flecha_ammo > 0:
			FlechaAttackTimer.start()
		else:
			FlechaAttackTimer.stop()

func _on_tompa_timer_timeout():
	Tompa_ammo += Tompa_baseammo + additional_attacks
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
	var calc_spawn = (Jinetompa_ammo + additional_attacks) - get_jinetompa_total
	while calc_spawn > 0:
		var jinetompa_spawn = Jinetompa.instantiate()
		jinetompa_spawn.global_position = global_position
		JinetompaBase.add_child(jinetompa_spawn)
		calc_spawn -= 1
	#Para que el Jinetompa actualice stats
	var get_jinetompa = JinetompaBase.get_children()
	for i in get_jinetompa:
		if i.has_method("update_jinetompa"):
			i.update_jinetompa()

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
		option_choice.item = get_random_item()
		UpgradeOptions.add_child(option_choice)
		options += 1
	
	get_tree().paused = true

func upgrade_character(upgrade):
	match upgrade:
		"flecha1":
			Flecha_level = 1
			Flecha_baseammo += 1
		"flecha2":
			Flecha_level = 2
			Flecha_attackspeed -= 0.25
		"flecha3":
			Flecha_level = 3
		"flecha4":
			Flecha_level = 4
			Flecha_baseammo += 1
		"tompa1":
			Tompa_level = 1
			Tompa_baseammo += 1
		"tompa2":
			Tompa_level = 2
			Tompa_baseammo += 1
		"tompa3":
			Tompa_level = 3
		"tompa4":
			Tompa_level = 4
			Tompa_attackspeed -= 0.5
		"jinetompa1":
			Jinetompa_level = 1
			Jinetompa_ammo = 1
		"jinetompa2":
			Jinetompa_level = 2
		"jinetompa3":
			Jinetompa_level = 3
		"jinetompa4":
			Jinetompa_level = 4
		"armadura1","armadura2","armadura3","armadura4":
			armor += 1
		"velocidad1","velocidad2","velocidad3","velocidad4":
			movement_speed += 20.0
		"doujin1","doujin2","doujin3","doujin4":
			spell_size += 0.10
		"escrituras1","escrituras2","escrituras3","escrituras4":
			spell_cooldown += 0.05
		"agecito1","agecito2":
			additional_attacks += 1
		"croissant":
			hp += 20
			hp = clamp(hp,0,maxhp)
	adjust_hud_col(upgrade)
	
	attack()
	var option_children = UpgradeOptions.get_children()
	for i in option_children:
		i.queue_free()
	upgrade_options.clear()
	collected_upgrades.append(upgrade)
	LevelPanel.visible = false
	LevelPanel.position = Vector2(800,50)
	get_tree().paused = false
	calculate_experience(0)
	
func get_random_item():
	var dblist = []
	for i in UpgradeDb.UPGRADES:
		if i in collected_upgrades: 
			pass
		elif i in upgrade_options:
			pass
		elif UpgradeDb.UPGRADES[i]["type"] == "item": 
			pass
		elif UpgradeDb.UPGRADES[i]["prerequisite"].size() > 0:
			var to_add = true
			for n in UpgradeDb.UPGRADES[i]["prerequisite"]:
				if not n in collected_upgrades:
					to_add = false
			if to_add:
					dblist.append(i)
		else:
			dblist.append(i)
	if dblist.size() > 0:
		var randomitem = dblist.pick_random()
		upgrade_options.append(randomitem)
		return randomitem
	else:
		return null

func cambiar_tiempo(argtime = 0):
	time = argtime
	var m = int(time/60.0)
	var s = time % 60
	if m < 10:
		m = str(0,m)
	if s < 10:
		s = str(0,s)
	LbTimer.text = str(m,":",s)

func adjust_hud_col(upgrade):
	var get_upgraded_displaynames = UpgradeDb.UPGRADES[upgrade]["displayname"]
	var get_type = UpgradeDb.UPGRADES[upgrade]["type"]
	if get_type != "item":
		var get_collected_displayname = []
		for i in collected_upgrades:
			get_collected_displayname.append(UpgradeDb.UPGRADES[i]["displayname"])
		if not get_upgraded_displaynames in get_collected_displayname:
			var new_item = Itemcon.instantiate()
			new_item.upgrade = upgrade
			match get_type:
				"weapon":
					Weaponscol.add_child(new_item)
				"upgrade":
					Upgradescol.add_child(new_item)

func death():
	Gameover.visible = true
	emit_signal("playerdeath")
	get_tree().paused = true
	var tween = Gameover.create_tween()
	tween.tween_property(Gameover,"position",Vector2(220,50), 3.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	if time >= 300:
		Lblresult.text = "Victoria del Corral"
		audvictory.play()
	else:
		Lblresult.text = "Los Hater te hacen asado"
		audloss.play()


func _on_btn_menu_click_end():
	get_tree().paused = false
	var _level = get_tree().change_scene_to_file("res://pantalla principal/menu.tscn")
