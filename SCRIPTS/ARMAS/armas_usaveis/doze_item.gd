extends Node3D

#info da arma
var id = 12 #id usavel para saber se a arma esta ativa no glnal, assim usando para saber se a arma esta on e pode liberar
var nome = "shortgun"
var calibre = 12
var speed = 8000
var municaoPENTE = 122
var municaoTOAL = 28


var projetil = preload("res://CENAS/armas/balas/_556.tscn")


func _input(event: InputEvent) -> void:

	if global.itemsegurado == id:

		if event.is_action_pressed("shot"):
			print("tentando atirar")

			if municaoPENTE > 0:
				global.player_animation_tree.set(
					"parameters/Blend2/blend_amount",
					0.0)
				global.player_animation_tree.set(
					"parameters/blend2 2/blend_amount",
					1.0)
				print("atirando")

				var projetilI = projetil.instantiate()

				get_tree().current_scene.add_child(projetilI)

				#projetilI.global_position = $skar2/boca.global_position
				#projetilI.velocity = $skar2/boca.global_transform.basis.z * speed

				municaoPENTE -= 1
				global.player_animation_tree.set(
					"parameters/Blend2/blend_amount",
					1.0)
				global.player_animation_tree.set(
					"parameters/blend2 2/blend_amount",
					0.0)
			else:
				print("sem municao")

func _process(_delta):
	if global.itemsegurado == id:
		global.player_animation_tree.set(
			"parameters/Blend2/blend_amount",
			1.0
		)
	else:
		global.player_animation_tree.set(
			"parameters/Blend2/blend_amount",
			0.0
		)
