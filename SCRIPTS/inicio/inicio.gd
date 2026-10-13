extends Node3D


var mapa3d = preload("res://CENAS/inicio/mapa.tscn")
var player3d = preload("res://CENAS/player/player.tscn")

func _ready() -> void:
	var _mapai = mapa3d.instantiate()
	var _playerI = player3d.instantiate()
	add_child(_mapai)
	add_child(_playerI)
	print("jogo iniciado")
