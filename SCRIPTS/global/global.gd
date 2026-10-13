extends Node

var andando:bool = false
var direct_cam: Vector3
var direct_camDI: Vector3

var mirando = false



#uso de armas gerais
var item_equipadoGLOBAL = null

var arma_on = false

var atirando = false #pra poder interligar e desligar o modo tiro com a mira

var equipede_selecionado = null

var itemsegurado = null



var player_animation_tree = null





var id_corrigido = null
var inventario = {}

var inventario_grid = [
	false, false, false,
	false, false, false,
	false, false, false
	]
var maoUSE = [
	false,false,false
			]

var mao1 = null
var mao2 = null
var mao3 = null






func liberar_item(posicao: Vector2i, tamanho: int) -> void:
	for i in range(tamanho):
		var indice = posicao.y * 3 + posicao.x + i
		inventario_grid[indice] = false



signal item_adicionado(nome, id, posicao, tamanho)

func tentar_adicionar_item(nome: String, id: int, Anin: int, tamanho: int) -> bool:
	print(nome)
	for linha in range(3):
		for coluna in range(3 - tamanho + 1):

			var livres := true

			for i in range(tamanho):
				var indice = linha * 3 + coluna + i

				if inventario_grid[indice]:
					livres = false
					break

			if livres:
				if id in IDs:
					  #converte o id de int pra str
					id_corrigido = IDs[id]
					#inventario.append(id) #aqui ele pega o numero do id do item e ver se o id esta na lista de ids existentes, e ai troca o numero do id pelo caminho ate o item no preload
					print(id_corrigido)
				
				else:
					print("o item n existe")
				for i in range(tamanho):
					var indice = linha * 3 + coluna + i
					inventario_grid[indice] = true

				# AVISA O INVENTÁRIO
				item_adicionado.emit(
					nome,
					id,
					Anin,
					id_corrigido,
					Vector2i(coluna, linha),
					tamanho
				)

				return true

	return false









#IDs dos itens

var IDs = {
	357: [preload("res://CENAS/armas/pistola_357.tscn"), preload("res://CENAS/armas/armas_usaveis/revolver_357_item.tscn")],
	174: [preload("res://CENAS/armas/skar.tscn"), preload("res://CENAS/armas/armas_usaveis/skar_item.tscn")],
	12: [preload("res://CENAS/armas/doze.tscn"), preload("res://CENAS/armas/armas_usaveis/doze_item.tscn")]
	
	
	
}
