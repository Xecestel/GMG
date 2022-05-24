extends Node
const Utils = preload("res://Scripts/Utils.gd")

var Maze = load('res://Scenes/Maze.tscn')

var algorithms = [
	preload("res://Scripts/Algorithms/DepthFirst.gd").new(),
	preload("res://Scripts/Algorithms/Prim.gd").new(),
	preload("res://Scripts/Algorithms/AldousBroder.gd").new(),
]

onready var maze : Maze = get_node("CanvasLayer/Divider/ViewportContainer/Viewport/Maze/")

var step = false
var runStop = false
var complete = false

func _ready():
	randomize()
	var algorithm_index = randi() % algorithms.size()
	generate_maze(algorithms[algorithm_index])


func startGeneration(algorithm):
	print_debug(algorithm)
	maze.startGeneration(algorithm)


func finishGeneration():
	runStop = false


func generate_maze(algorithm):
	complete = true
	runStop = false
	if !maze.generatingMaze:
		startGeneration(algorithm)


func _on_ResetButton_pressed():
	maze.prepareMaze()
	maze.finishGeneration(false)
