extends HSplitContainer

@onready
var _node_actions: HFlowContainer = %NodeActions
@onready
var _workspace: GraphEdit = %Workspace

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _ready() -> void:
	self.split_offset = self.size.x * 0.1
	
	%AddVar.pressed.connect(func() -> void:
		pass
	)
	%AddConst.pressed.connect(func() -> void:
		pass
	)
	%AddFunc.pressed.connect(func() -> void:
		_add_to_workspace(EditorFunctionNode.new())
	)
	%AddClass.pressed.connect(func() -> void:
		pass
	)
	%AddRaw.pressed.connect(func() -> void:
		_add_to_workspace(EditorRawNode.new())
	)
	%AddComment.pressed.connect(func() -> void:
		_add_to_workspace(EditorCommentNode.new())
	)

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

func _add_to_workspace(node: EditorFlowNode) -> void:
	node.node_selected.connect(func() -> void:
		for child in _node_actions.get_children():
			child.free()
		
		for i in node.get_actions():
			var button := Button.new()
			button.text = i
			button.pressed.connect(func() -> void:
				node.handle_action(i)
			)
			
			_node_actions.add_child(button)
		
		_node_actions.visible = _node_actions.get_child_count() != 0
	)
	
	_workspace.add_child(node)
	_workspace.set_selected(node)

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

