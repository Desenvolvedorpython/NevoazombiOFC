extends Control

var item_equiped = null
var itens_equipados = [null, null, null]

var idR = null #id real do item

@onready var slot1INV = $"equip/1/fundo"
@onready var slot2INV = $"equip/2/fundo"
@onready var slot3INV = $"equip/3/fundo"

@onready var slot1HUD = $"../../../../hudJOGADOR/equipados/s1/Panel"
@onready var slot2HUD = $"../../../../hudJOGADOR/equipados/s2/Panel"
@onready var slot3HUD = $"../../../../hudJOGADOR/equipados/s3/Panel"


var equiped_selecionado = null



var usarSLOT = null

var nomedoITEM = null


func _ready():
	var script1 = $"../../areaINV"
	script1.mao_encontrada.connect(_quando_achar_mao)


#mao do player, sempre equipar nela
@onready var mao = $"../../../../playerlocomotion/Skeleton3D/BoneAttachment3D"

func id_ja_equipado(id) -> bool:
	if global.mao1 == id:
		return true

	if global.mao2 == id:
		return true

	if global.mao3 == id:
		return true

	return false



func _quando_achar_mao(i, id, _id, Anin, nomeITEM):
	if id_ja_equipado(id):
		print("esse item já está equipado!")
		return
	nomedoITEM = nomeITEM

	# daqui pra baixo continua o equipamento...
	
	
	var _idI = _id.instantiate()

	mao.add_child(_idI)

	_idI.position = Vector3.ZERO
	_idI.rotation = Vector3.ZERO

	_idI.visible = false
	itens_equipados[i] = _idI

	global.maoUSE[i] = true

	if i == 0:
		global.mao1 = id

	elif i == 1:
		global.mao2 = id

	elif i == 2:
		global.mao3 = id

	global.arma_on = true

	print("slot: ", i)
	print("ID real: ", id)
	criar_button(nomeITEM, id, Anin, i)


func criar_button(nomeITEM, id, Anin, i):
	var _botao = Button.new()

	_botao.text = nomeITEM
	_botao.set_meta("id", id)

	if i == 0:
		slot1INV.add_child(_botao)

	elif i == 1:
		slot2INV.add_child(_botao)

	elif i == 2:
		slot3INV.add_child(_botao)
	
	_botao.pressed.connect(selecionar_equipado.bind(_botao))

	_botao.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	
	
	#aqui vai criar o button dentro do hud tambem
	var _botaohud = Button.new()
	
	_botaohud.text = nomeITEM
	_botaohud.set_meta("id", id)
	_botaohud.set_meta("Anin", Anin)
	print("anin do item: ", Anin)
	
	if i == 0:
		slot1HUD.add_child(_botaohud)
	elif i == 1:
		slot2HUD.add_child(_botaohud)
	elif i == 2:
		slot3HUD.add_child(_botaohud)
	
	_botaohud.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_botaohud.pressed.connect(slot_selecionado.bind(_botaohud, i))



func slot_selecionado(botao, i):
	var id = botao.get_meta("id")
	var Anin = botao.get_meta("Anin")
	global.itemsegurado = id

	print("Slot selecionado!")
	print("ID: ", id)
	print("Anin: ", Anin)

	if item_equiped != null:
		item_equiped.visible = false

	item_equiped = itens_equipados[i]

	item_equiped.visible = true




func selecionar_equipado(_botao):
	global.equipede_selecionado = _botao.get_meta("id")
	print("equipado selecionado")


func _on_desequipar_pressed() -> void:
	var id = global.equipede_selecionado

	if id == null:
		print("nenhum item equipado selecionado")
		return

	print("tentando desequipar ID: ", id)

	if global.mao1 == id:
		desequipar(0)
		idR = null

	elif global.mao2 == id:
		desequipar(1)
		idR = null

	elif global.mao3 == id:
		desequipar(2)
		idR = null
	

	else:
		print("esse ID não está equipado")


func desequipar(i):

	var item = itens_equipados[i]

	if item != null:
		item.queue_free()

	itens_equipados[i] = null

	if item_equiped == item:
		item_equiped = null

	# liberar o slot
	global.maoUSE[i] = false

	if i == 0:
		global.mao1 = null
	elif i == 1:
		global.mao2 = null
	elif i == 2:
		global.mao3 = null

	# apagar os buttons
	apagar_button(global.equipede_selecionado)

	global.equipede_selecionado = null
	global.arma_on = false

func apagar_button(id):
	for botao in [slot1INV, slot2INV, slot3INV, slot1HUD, slot2HUD, slot3HUD]:
		for filho in botao.get_children():
			if filho.has_meta("id"):
				if filho.get_meta("id") == id:
					filho.queue_free()





func espaco():
	pass
