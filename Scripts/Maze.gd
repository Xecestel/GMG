extends Node2D
class_name Maze
const Cell = preload("res://Scripts/Cell.gd");
const Utils = preload("res://Scripts/Utils.gd")
const WIDTH = 25
const HEIGHT = 25

var Algorithm

#Ui Variables
onready var panel: Node =  get_node("/root/Game")

# Maze variables
var cells: Array;
var generatingMaze = false
var cellStack = []
var completeMaze = false

func _ready():
	pass

func _process(delta):
	if panel.complete :
		panel.complete = false
		while generatingMaze:
			Algorithm.process(self)
	elif panel.runStop :
		if !generatingMaze:
			panel.stop = false
		else:
			Algorithm.process(self)
	elif panel.step :
		panel.step = false
		Algorithm.process(self)
	pass


func getCell(x,y):
	return cells[y * WIDTH +x];


func getNeighbors(x,y):
	var dummy = Cell.new()
	var width = HEIGHT
	var height = WIDTH
	dummy.visit()
	return {
		Cell.Wall.UP: getCell(x,y-1) if y > 0 else dummy, 			#UP
		Cell.Wall.DOWN: getCell(x,y+1) if y < height-1 else dummy,	#DOWN
		Cell.Wall.LEFT: getCell(x-1,y) if x > 0 else dummy,			#LEFT
		Cell.Wall.RIGHT: getCell(x+1,y) if x < width-1 else dummy	#RIGHT
	}


func prepareMaze():	
	var width = WIDTH
	var height = HEIGHT
	generatingMaze = false
	cells = []
	var size = height*width;
	for i in range(size):
		var cell = Cell.new();
		cell.x = i%int(width);
		cell.y = i/int(width);
		cells.append(cell);
	buildTiles()
	scale = Utils.fixScale(Vector2(WIDTH*2+1, HEIGHT*2+1) * $TileMap.get_cell_size(), get_parent().get_parent().rect_size)


func startGeneration(algorithm):
	Algorithm = algorithm
	algorithm.generate(self)
	generatingMaze = true
	completeMaze = false
	scale = Utils.fixScale(Vector2(WIDTH*2+1, HEIGHT*2+1) * $TileMap.get_cell_size(), get_parent().get_parent().rect_size)


func finishGeneration(mazeCompleted = true):
	generatingMaze = false
	completeMaze = mazeCompleted
	buildTiles()
	panel.finishGeneration()
	scale = Utils.fixScale(Vector2(WIDTH*2+1, HEIGHT*2+1) * $TileMap.get_cell_size(), get_parent().get_parent().rect_size)


func buildTiles():
	var width = WIDTH
	var height = HEIGHT
	$TileMap.clear()
	for x in range(-1,width*2):
		for y in range(-1,height*2):
			$TileMap.set_cell(x+1,y+1,1)
	for cell in cells:
		buildCell(cell)


func buildCell(cell):
	var tm = $TileMap
	var vec = Vector2(cell.x*2,cell.y*2) + Vector2(+1,+1)
	tm.set_cellv(vec, !cell.visited)
	tm.set_cellv(vec + Vector2(0,-1), cell.walls[Cell.Wall.UP])
	tm.set_cellv(vec + Vector2(0,+1), cell.walls[Cell.Wall.DOWN])
	tm.set_cellv(vec + Vector2(-1,0), cell.walls[Cell.Wall.LEFT])
	tm.set_cellv(vec + Vector2(+1,0), cell.walls[Cell.Wall.RIGHT])
