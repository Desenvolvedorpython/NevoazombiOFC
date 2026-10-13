extends Control

var botao_selecionado = null

func _on_fechar_pressed() -> void:
	$"../..".visible = false
	$"../../../hudJOGADOR".visible = true

var item_selecionado = null #aqui fica o id (set.meta) do ultimo botao clicado
var nomeITEM = null
var itemID = null #id real do numero 




const TAMANHO_CELULA = 150

func _ready():
	global.item_adicionado.connect(_quando_item_adicionado)


func _quando_item_adicionado(nome, id, Anin, id_corrigido, posicao, tamanho):
	var botao = Button.new()

	botao.text = nome

	botao.position = Vector2(
		posicao.x * TAMANHO_CELULA,
		posicao.y * TAMANHO_CELULA
	)

	botao.size = Vector2(
		tamanho * TAMANHO_CELULA,
		TAMANHO_CELULA
	)

	botao.set_meta("tem_id", id_corrigido)
	botao.set_meta("id_real", id)
	botao.set_meta("nome", nome)
	botao.set_meta("posicao", posicao)
	botao.set_meta("tamanho", tamanho)
	botao.set_meta("Anin", Anin)

	botao.pressed.connect(_botao_item_pressed.bind(id_corrigido, botao))

	add_child(botao)


##pega o id do item e poe na variavel
func _botao_item_pressed(id_corrigido, botao):
	item_selecionado = id_corrigido
	botao_selecionado = botao

	itemID = botao.get_meta("id_real")
	nomeITEM = botao.get_meta("nome")

	print("ID: ", itemID)
	print("Nome: ", nomeITEM)
	print("Anin: ", botao.get_meta("Anin"))


@export var player: Node3D


func _on_dropar_pressed() -> void:
	if item_selecionado == null:
		print("selecione um item")
		return

	if global.arma_on == true:
		return

	# Pega a posição e o tamanho salvos no botão
	var posicao = botao_selecionado.get_meta("posicao")
	var tamanho = botao_selecionado.get_meta("tamanho")

	# Cria o item físico
	var item = item_selecionado[0].instantiate()
	get_tree().current_scene.add_child(item)

	item.global_position = player.global_position - player.global_transform.basis.z * 0.8

	print("o item foi dropado")

	# Remove o item do inventário global
	global.inventario.erase(item_selecionado)

	# Libera as células que ele ocupava
	global.liberar_item(posicao, tamanho)

	# Remove o botão da interface
	botao_selecionado.queue_free()

	# Limpa a seleção
	item_selecionado = null
	botao_selecionado = null



#@onready var mao = $"../../../playerlocomotion/Skeleton3D/BoneAttachment3D"
#var arma = preload("res://CENAS/armas/armas_usaveis/revolver_357_item.tscn")#teste
#tenta equipar o item

#signal mao_encontrada(i, itemID, _id, nomeITEM) #manda o sinal falando q achou a mao, pede pra equipar na mao
signal mao_encontrada(i, itemID, _id, _Anin, nomeITEM)

func _on_equipar_pressed() -> void:
	var _Anin = botao_selecionado.get_meta("Anin")
	if item_selecionado == null:
		print("selecione um item para equipar")
		return

	print("item selecionado")

	for i in range(global.maoUSE.size()):

		if not global.maoUSE[i]:

			print("achei uma mão livre: ", i)

			var _id = item_selecionado[1]

			mao_encontrada.emit(
				i,
				itemID,
				_id,
				_Anin,
				nomeITEM
			)
			item_selecionado = null

			break

		else:
			print("sem mãos disponíveis")







#espacador
func u():
	pass
