class_name EditorCommentNode
extends EditorFlowNode

var text_edit: TextEdit = null

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _init() -> void:
	super._init("Comment", Groups.COMMENT)
	
	text_edit = TextEdit.new()
	text_edit.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(text_edit)

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

func get_data() -> Variant:
	return text_edit.text

func get_actions() -> PackedStringArray:
	var r := PackedStringArray()
	
	return r
