class_name GDFlowEditorManager
extends Node

class KnownFlow extends RefCounted:
	var flow: Control = null
	
	var known_root_nodes := {}
	
	func _init(flow: Control) -> void:
		self.flow = flow
		
		self.flow.workspace.child_entered_tree.connect(func(node: EditorFlowNode) -> void:
			if (
				not node is EditorVarNode or
				not node is EditorConstNode or
				not node is EditorFunctionNode or
				not node is EditorRawNode or
				not node is EditorCommentNode
			):
				return
			
			known_root_nodes[node.uuid] = node
		)

const NAME := "GDFlowEditorManager"

## UUID to [code]KnownFlow[/code].
var known_flows := {}

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _init() -> void:
	pass

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

func register_flow(flow: Control) -> void:
	known_flows[flow.uuid] = KnownFlow.new(flow)
