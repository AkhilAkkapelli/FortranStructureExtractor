module ProgramNodeMod

export newProgramNode, addChild, toDOT

mutable struct ProgramNodeType
    type::String
end

function createProgramNodeType(type::String)
    if type in ["File", "Program", "Module", "Function", "Subroutine", "FunctionInterface", "SubroutineInterface"]
        return ProgramNodeType(type)
    else
        throw(ArgumentError("Invalid ProgramNodeType: $type"))
    end
end

mutable struct ProgramNode
    data::String
    type::ProgramNodeType
    children::Vector{ProgramNode}
end

function newProgramNode(data::String, nodetype::String)
    children = ProgramNode[]
    return ProgramNode(data, createProgramNodeType(nodetype), children)
end

function addChild(parent::ProgramNode, child::ProgramNode)
    push!(parent.children, child)
end

function toDOT(node::ProgramNode)
    dotBuilder = String[]
    push!(dotBuilder, "digraph ProgramTree {")

    nodes = ProgramNode[]
    links = String[]

    buildDOTRecursive(nodes, links, node)

    for node in nodes
        shape = getShapeForNodeType(node.type)
        color = getColorForNodeType(node.type)
        push!(dotBuilder, "  \"$(node.data)\" [shape=$(shape), style=filled, fillcolor=\"$(color)\"];")
    end

    for link in links
        push!(dotBuilder, "  $link;")
    end

    push!(dotBuilder, "}")

    join(dotBuilder, "\n")
end

function getShapeForNodeType(type::ProgramNodeType)
    shape_mapping = Dict(
        "File" => "box",
        "Program" => "diamond",
        "Module" => "parallelogram",
        "Function" => "hexagon",
        "Subroutine" => "octagon",
        "FunctionInterface" => "pentagon",
        "SubroutineInterface" => "septagon"
    )
    return get(shape_mapping, type.type, "ellipse")
end

function getColorForNodeType(type::ProgramNodeType)
    color_mapping = Dict(
        "File" => "white",
        "Program" => "blue",
        "Module" => "green",
        "Function" => "yellow",
        "Subroutine" => "orange",
        "FunctionInterface" => "purple",
        "SubroutineInterface" => "pink"
    )
    return get(color_mapping, type.type, "red")
end


function buildDOTRecursive(nodes::Vector{ProgramNode}, links::Vector{String}, node::ProgramNode)
    push!(nodes, node)
    for child in node.children
        push!(links, "\"$(node.data)\" -> \"$(child.data)\"")
        buildDOTRecursive(nodes, links, child)
    end
end

end  # module
