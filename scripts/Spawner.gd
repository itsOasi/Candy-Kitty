extends Node3D

@export_file("*.tscn") var path: String
var obj = load(path)
		
func spawn():
	if !obj:
		return
	print("spawning")
	var child = obj.instantiate()
	child.connect("tree_exiting", %Timer.start)
	add_child(child)
