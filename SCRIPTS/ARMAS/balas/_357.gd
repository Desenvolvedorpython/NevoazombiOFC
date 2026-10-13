extends MeshInstance3D

@export var velocidade: float = 200.0
@export var tempo_vida: float = 2.0

var tempo = 0.0


@onready var audio = $AudioStreamPlayer3D

func _ready():
	audio.play()

func _process(delta):

	# Move para frente
	global_position += -global_transform.basis.z * velocidade * delta

	# Conta quanto tempo existe
	tempo += delta

	if tempo >= tempo_vida:
		queue_free()
