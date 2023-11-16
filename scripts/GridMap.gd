@tool
extends GridMap


# Called when the node enters the scene tree for the first time.
func _ready():
	var curr_cells = get_used_cells()
	print(curr_cells)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func solve(rule_set):
	pass

func set_cell(at, to):
	set_cell_item(at, to)
