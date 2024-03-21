extends Button

signal click_end()

func _on_mouse_entered():
	$Aud_hov.play()

func _on_pressed():
	$Aud_click.play()

func _on_aud_click_finished():
	emit_signal("click_end")
