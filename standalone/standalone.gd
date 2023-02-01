extends CanvasLayer

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _init() -> void:
	pass

func _ready() -> void:
	var editor := preload("res://addons/gdflow/editor/editor.tscn").instantiate()
	editor.plugin = self
	$PanelContainer.add_child(editor)

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

## Intentionally does nothing. Only exists to mimic the functionality of the editor plugin.
func inject_tool(_node: Node) -> void:
	pass

func nyi() -> void:
	OS.alert("Not yet implemented!")
