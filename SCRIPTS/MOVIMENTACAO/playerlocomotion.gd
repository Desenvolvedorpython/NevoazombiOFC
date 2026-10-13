extends CharacterBody3D

var SPEED: float = 7.0
var RUN = 8
var JUMP_VELOCITY = 4.
var velocity_linear = 0
var speedANIM = 0
var Vsubir = 5.0
var Vdescer = 8.0
var ACELERACAO := 20.0
var DESACELERACAO := 9.0

@onready var animationtree = $"../AnimationTree"
@onready var ik_cabeca = $Skeleton3D/SkeletonIK3D
@onready var skeleton: Skeleton3D = $Skeleton3D

@onready var animation_tree = $"../AnimationTree"


func _ready() -> void:
	global.player_animation_tree = $"../AnimationTree"

	print("=== ANIMATION TREE ===")
	print(global.player_animation_tree)
	print("ATIVO: ", global.player_animation_tree.active)

	print("=== PARÂMETROS ===")
	for prop in global.player_animation_tree.get_property_list():
		if prop.name.begins_with("parameters/"):
			print(prop.name)

	var peso := PesoModifier.new()
	peso.nome_do_osso = "mixamorig_Spine"
	peso.velocidade = 8.0
	peso.active = true
	skeleton.add_child(peso)
	#ik_cabeca.start()
	print("player criado")
	if cam_normal == null or cam_aim == null:
		push_error("Player: atribua cam_normal e cam_aim no Inspector")
		set_process(false)
		set_process_input(false)


@export var cam_normal: Camera3D
@export var cam_aim: Camera3D
var mirou = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventario"):
		$"../inventario".visible = true
		
	if global.arma_on:
		if event.is_action_released("mirar"):
			mirou = !mirou
		if mirou:
			global.mirando = true
			cam_aim.current = true
			cam_normal.current = false
		else:
			global.atirando = false
			global.mirando = false
			cam_aim.current = false
			cam_normal.current = true







func _physics_process(delta: float) -> void:

	# Gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Pulo
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movimento
	var input_dir := Input.get_vector(
		"ui_left",
		"ui_right",
		"ui_up",
		"ui_down"
	)

	velocity_linear = input_dir

	# Velocidade
	if input_dir != Vector2.ZERO:
		SPEED = move_toward(
			SPEED,
			7.0,
			Vsubir * delta
		)
	else:
		SPEED = move_toward(
			SPEED,
			0.0,
			Vdescer * delta
		)

	# Animação
	speedANIM = SPEED / 2.5

	animationtree.set(
		"parameters/locomotion/blend_position",
		speedANIM
	)

	# Direção baseada na câmera
	var direction := (
		global.direct_camDI * -input_dir.x +
		global.direct_cam * -input_dir.y
	).normalized()

	# Quando estiver mirando, ignora a câmera
	if global.mirando:
		direction = (
			transform.basis.x * input_dir.x +
			-transform.basis.z * -input_dir.y
		).normalized()

	if direction:

		# Só gira o player automaticamente fora da mira
		if not global.mirando:

			var angulo_desejado := atan2(
				-direction.x,
				-direction.z
			)

			var velocidade_giro: float = 14.0 / max(SPEED, 1.0)

			rotation.y = lerp_angle(
				rotation.y,
				angulo_desejado,
				velocidade_giro * delta
			)

		# Frente atual do personagem
		var direcao_frente := -transform.basis.z

		# Fora da mira: mantém EXATAMENTE o comportamento antigo
		# Durante a mira: usa o eixo do player para permitir strafe
		var velocidade_desejada: Vector3

		if global.mirando:
			velocidade_desejada = direction * SPEED
		else:
			velocidade_desejada = direcao_frente * SPEED

		# Aceleração física
		velocity.x = move_toward(
			velocity.x,
			velocidade_desejada.x,
			ACELERACAO * delta
		)

		velocity.z = move_toward(
			velocity.z,
			velocidade_desejada.z,
			ACELERACAO * delta
		)

		global.andando = true

	else:

		# Inércia
		velocity.x = move_toward(
			velocity.x,
			0.0,
			DESACELERACAO * delta
		)

		velocity.z = move_toward(
			velocity.z,
			0.0,
			DESACELERACAO * delta
		)

		global.andando = false

	move_and_slide()





class PesoModifier extends SkeletonModifier3D:

	var nome_do_osso: String = "mixamorig_Spine"
	var velocidade: float = 8.0
	var bone_idx: int = -1
	var extra_suavizada := Quaternion.IDENTITY

	@onready var player = $"../.."

	func _process_modification() -> void:
		var skel := get_skeleton()
		if not skel:
			return

		if bone_idx == -1:
			bone_idx = skel.find_bone(nome_do_osso)
			if bone_idx == -1:
				push_error("Osso não encontrado: " + nome_do_osso)
				return

		var base_local := skel.get_bone_pose_rotation(bone_idx)

		var input := Input.get_vector(
			"ui_left",
			"ui_right",
			"ui_up",
			"ui_down"
		)

		# Pega a SPEED do player
		var speed_atual: float = player.SPEED

		# Ângulo padrão
		var angulo_inclinacao: float = 15.0

		# Entre 3 e 4 = inclinação maior
		if speed_atual >= 3.0 and speed_atual <= 5.0:
			angulo_inclinacao = 50.0

		# Inclinação lateral
		var rot_lateral := Quaternion(
			Vector3.FORWARD,
			-input.x * deg_to_rad(15.0)
		)

		# W e S inclinam para frente
		var intensidade_frente: float = abs(input.y)

		var rot_frente := Quaternion(
			Vector3.RIGHT,
			intensidade_frente * deg_to_rad(angulo_inclinacao)
		)

		var extra_alvo := rot_lateral * rot_frente

		# Suavização
		var delta := get_process_delta_time()
		var t := 1.0 - exp(-velocidade * delta)

		extra_suavizada = extra_suavizada.slerp(
			extra_alvo,
			t
		)

		skel.set_bone_pose_rotation(
			bone_idx,
			extra_suavizada * base_local
		)
