@tool
extends EditorPlugin

const PLUGIN_NAME := "GdFlow"

const Editor := preload("res://addons/gdflow/editor/editor.tscn")
var editor: PanelContainer = null

var editor_manager: GDFlowEditorManager = null

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _enter_tree() -> void:
	editor = Editor.instantiate()
	self.inject_tool(editor)
	editor.plugin = self
	get_editor_interface().get_editor_main_screen().add_child(editor)
	
	editor_manager = GDFlowEditorManager.new()
	editor_manager.name = GDFlowEditorManager.NAME
	get_tree().root.call_deferred("add_child", editor_manager)
	
	_make_visible(false)

func _exit_tree() -> void:
	if editor != null:
		editor.queue_free()
	if editor_manager != null:
		editor_manager.queue_free()

func _has_main_screen() -> bool:
	return true

func _make_visible(visible: bool) -> void:
	editor.visible = visible

func _get_plugin_name() -> String:
	return PLUGIN_NAME

func _get_plugin_icon() -> Texture2D:
	return get_editor_interface().get_base_control().get_theme_icon("GraphEdit", "EditorIcons")

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

func inject_tool(node: Node) -> void:
	var script: GDScript = node.get_script().duplicate()
	script.source_code = "@tool\n%s" % script.source_code
	
	if script.reload() != OK:
		printerr("Failed to convert script into a tool script.")
		return
	
	node.set_script(script)

func nyi() -> void:
	OS.alert("Not yet implemented!")
