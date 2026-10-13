extends Node3D

var id = 174
var nome = "skar"
var Anin = 3
#VARIAVEIS
var player_on = false

func _input(event: InputEvent) -> void:
	
	if player_on == true:
		if event.is_action_pressed("coletar"):
			var _conseguiu = global.tentar_adicionar_item(nome, id, Anin, 3)
			if _conseguiu:
				print("coletou ", nome)
				queue_free()
			else:
				print("inv cheio")

@onready var area_arma: Area3D = $RigidBody3D/Area3D

func _ready():
	area_arma.body_entered.connect(_on_area_body_entered)
	area_arma.body_exited.connect(_on_area_body_exited)

func _on_area_body_entered(body):
	if body.is_in_group("players"):
		player_on = true
		print("Entrou na área: ", body.name)
		
func _on_area_body_exited(body):
	if body.is_in_group("players"):
		player_on = false
		print("Saiu da área: ", body.name)
