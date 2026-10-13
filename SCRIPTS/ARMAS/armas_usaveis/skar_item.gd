extends Node3D

# ── Info da arma ──────────────────────────────────────────────
const ID_ARMA: int = 174 # usado para saber se a arma está ativa no global
const PROJETIL: PackedScene = preload("res://CENAS/armas/balas/_556.tscn")

var atirando = false


@export var nome: String = "Scar"
@export var calibre: int = 556
@export var speed: float = 8000.0
@export var tamanho_pente: int = 30
@export var municao_pente: int = 30
@export var municao_total: int = 28
@export var pode_mirar: bool = true

# ── Referências ───────────────────────────────────────────────
@onready var boca: Node3D = $skar2/boca


func _input(event: InputEvent) -> void:
	if global.itemsegurado == ID_ARMA:
		if global.atirando:
			global.player_animation_tree.set("parameters/BLENDRIFLEIDLE/blend_amount", 0.0)
		
		if event.is_action_pressed("shot"):
			global.mirando = true
			global.atirando = true
			atirar()
		
		if event.is_action_pressed("reload"):
			recarregar()
			
		if global.atirando == false:
			global.player_animation_tree.set("parameters/MIRARIFLE/blend_amount", 0.0)
			global.player_animation_tree.set("parameters/BLENDRIFLEIDLE/blend_amount", 1.0)
		
	else:
		global.player_animation_tree.set("parameters/MIRARIFLE/blend_amount", 0.0)
		global.player_animation_tree.set("parameters/BLENDRIFLEIDLE/blend_amount", 0.0)


func atirar():
	global.player_animation_tree.set("parameters/BLENDRIFLEIDLE/blend_amount", 0.0)
	global.player_animation_tree.set("parameters/MIRARIFLE/blend_amount", 1.0)

	if municao_pente > 0:
		pass
		

















func recarregar():
	pass
