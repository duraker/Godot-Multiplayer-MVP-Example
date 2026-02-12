extends Node


const plr := preload("res://scenes/char.tscn")


const IP_ADDRESS := "localhost"
const PORT := 42069

var peer: ENetMultiplayerPeer

func startServer() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	spawnPlr(1)


func peerConnected(id: int) -> void:
	print("peer connected: ", id)
	spawnPlr(id)


func _ready() -> void:
	multiplayer.peer_connected.connect(peerConnected)


func startClient() -> void:
	print("startClient ", get_multiplayer_authority())
	peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer


func spawnPlr(id: int) -> void:
	if not multiplayer.is_server(): return
	print("spawning char ", id)
	var plr := plr.instantiate()
	plr.name = str(id)
	get_tree().current_scene.call_deferred("add_child", plr)
