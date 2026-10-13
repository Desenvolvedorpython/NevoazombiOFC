
extends Node3D

@export var sensibilidade := 0.003
@export var limite_vertical_inferior := -50.0
@export var limite_vertical_superior := 50.0

@onready var player = $"../../playerlocomotion"

@export var cam_normal: Camera3D
@export var cam_aim: Camera3D


var rot_x := 0.0
var rot_y := 0.0


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event):
	if global.mirando:
		
		cam_aim.current = true
		cam_normal.current = false
		
		var movimento_x := 0.0
		var movimento_y := 0.0

		# Mouse
		if event is InputEventMouseMotion:
			if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
				movimento_x = event.relative.x
				movimento_y = event.relative.y

		# Dedo na tela
		elif event is InputEventScreenDrag:
			movimento_x = event.relative.x
			movimento_y = event.relative.y

		else:
			return


		# Rotação horizontal da câmera
		rot_y -= movimento_x * sensibilidade

		# Rotação vertical da câmera
		rot_x -= movimento_y * sensibilidade

		# Limita vertical
		rot_x = clamp(
			rot_x,
			deg_to_rad(limite_vertical_inferior),
			deg_to_rad(limite_vertical_superior)
		)


		# CÂMERA
		rotation.x = rot_x
		rotation.y = rot_y


		# PLAYER acompanha somente a direção horizontal da câmera
		player.rotation.y = rot_y
