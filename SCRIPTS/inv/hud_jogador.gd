extends Control


func _on_coletar_pressed() -> void:
	pass


func _on_inventario_pressed() -> void:
	$"../inventario".visible = true
	$".".visible = false
