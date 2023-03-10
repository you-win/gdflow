extends CanvasLayer

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _ready() -> void:
	var editor := preload("res://addons/gdflow/editor/editor.tscn").instantiate()
	editor.plugin = self
	$PanelContainer.add_child(editor)
	
	var manager := GDFlowEditorManager.new()
	manager.name = GDFlowEditorManager.NAME
	get_tree().root.call_deferred("add_child", manager)

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
