extends Camera3D

@export var sensibilidade := 0.003
@export var limite_vertical_inferior := -50.0
@export var limite_vertical_superior := 65.0

var rot_x := 0.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event):

	# ESC alterna entre mouse travado e livre
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			else:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	# Mouse
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			rot_x -= event.relative.y * sensibilidade

	# Dedo na tela
	elif event is InputEventScreenDrag:
		rot_x += event.relative.y * sensibilidade

	# Limite vertical
	rot_x = clamp(
		rot_x,
		deg_to_rad(limite_vertical_inferior),
		deg_to_rad(limite_vertical_superior)
	)

	rotation.x = rot_x
