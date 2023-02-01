class_name GDFlowNode
extends Resource

## Array of nodes that directly lead to this node.
@export
var from: Array[GDFlowNode] = []
## Array of nodes that this node directly leads to.
@export
var to: Array[GDFlowNode] = []

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

