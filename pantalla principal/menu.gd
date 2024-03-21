extends Control

var level = "res://Mundo/mundo.tscn"

func _on_btn_jugar_click_end():
	var _level = get_tree().change_scene_to_file(level)

func _on_btn_salir_click_end():
	get_tree().quit()
