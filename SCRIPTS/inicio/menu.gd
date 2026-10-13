extends Control


func _on_jogar_pressed() -> void:
	get_tree().change_scene_to_file("res://CENAS/inicio/inicio.tscn")
	print("chamando inicio")
