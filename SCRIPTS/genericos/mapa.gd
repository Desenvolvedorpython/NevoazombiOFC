extends Node3D



#teste
var revolver357 = preload("res://CENAS/armas/pistola_357.tscn")
var skar = preload("res://CENAS/armas/skar.tscn")
var shoretgun = preload("res://CENAS/armas/doze.tscn")


func _input(event):
	if event.is_action_pressed("j"):
		var revolver357I = revolver357.instantiate()
		add_child(revolver357I)
		print(global.inventario)
		var skarI = skar.instantiate()
		add_child(skarI)
		var shortgunI = shoretgun.instantiate()
		add_child(shortgunI)
		
		
