include("ProgramNode.jl")

import .ProgramNodeMod: newProgramNode, addChild, toDOT

# Create nodes for the tree
root = newProgramNode("Math.f90", "File")
node1 = newProgramNode("MathMod", "Module")
node2 = newProgramNode("Math", "Program")
node3 = newProgramNode("Factiorial", "Subroutine")
node4 = newProgramNode("Sum", "Function")
node5 = newProgramNode("Subtract", "Subroutine")


# Connect nodes to form the tree structure
addChild(root, node1)
addChild(root, node2)
addChild(node1, node3)
addChild(node1, node4)
addChild(node2, node5)

println(toDOT(root))
