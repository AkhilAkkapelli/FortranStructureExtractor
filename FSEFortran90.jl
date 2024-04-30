# Import necessary modules and packages
include("ProgramNode/ProgramNode.jl")

# Importing PyCall to interact with Python modules
using PyCall

# Importing Program Node routines for Program Tree
import .ProgramNodeMod: newProgramNode, addChild, toDOT
# Importing ArgParse for command-line argument parsing
import ArgParse: ArgParseSettings, parse_args, @add_arg_table!  

# Importing antlr4 Python modules
const antlr4 = pyimport("antlr4")

const ParseTreeWalker = antlr4.ParseTreeWalker
const FileStream = antlr4.FileStream
const CommonTokenStream = antlr4.CommonTokenStream

# Add current directory to Python sys path
pushfirst!(PyVector(pyimport("sys")."path"), pwd())

# Import necessary modules from the local Python files
const Fortran90Lexer = pyimport("Fortran90Grammer.Fortran90Lexer")
const Fortran90Parser = pyimport("Fortran90Grammer.Fortran90Parser")

Fortran90ParserListener = pyimport("Fortran90Grammer.Fortran90ParserListener")

# Defining a Julia struct representing a listener for Fortran90Parser events
@pydef mutable struct FSEFortran90Listener <: Fortran90ParserListener.Fortran90ParserListener
  function __init__(self, root)
    self.root = root
    self.parentStack = [root]
  end

  function enterMainProgram(listener::PyObject, ctx::PyObject)
    # Retrieving Program name from context
    mainProgramName = ""
    if ctx.programStmt() !== nothing
      mainProgramName = ctx.programStmt().NAME().getText()
    end
    # Adding the main program node as a child to the current parent node
    mainProgramNode = newProgramNode(mainProgramName, "Program")
    currentParent = last(listener.parentStack)
    addChild(currentParent, mainProgramNode)
    # Updating the parent stack to include the main Program node
    listener.parentStack = [listener.parentStack..., mainProgramNode]
  end
   
  function exitMainProgram(listener::PyObject, ctx::PyObject)
    listener.parentStack = listener.parentStack[1:end-1]
  end   
   
  function enterModule(listener::PyObject, ctx::PyObject)
    # Retrieving Module name from context
    moduleName = ctx.moduleStmt().moduleName().ident().NAME().getText()
    # Adding the Module node as a child to the current parent node
    moduleNode = newProgramNode(moduleName, "Module")
    currentParent = last(listener.parentStack)
    addChild(currentParent, moduleNode)
    # Updating the parent stack to include the Module node
    listener.parentStack = [listener.parentStack..., moduleNode]
  end
    
  function exitModule(listener::PyObject, ctx::PyObject)
    listener.parentStack = listener.parentStack[1:end-1]
  end

  function enterFunctionSubprogram(listener::PyObject, ctx::PyObject)
    # Retrieving Function name from context
    functionName = ctx.functionName().NAME().getText()
    # Adding the Function node as a child to the current parent node
    functionNode = newProgramNode(functionName, "Function")
    currentParent = last(listener.parentStack)
    addChild(currentParent, functionNode)
    # Updating the parent stack to include the Function node
    listener.parentStack = [listener.parentStack..., functionNode]
  end

  function exitFunctionSubprogram(listener::PyObject, ctx::PyObject)
    listener.parentStack = listener.parentStack[1:end-1]
  end

  function enterSubroutineSubprogram(listener::PyObject, ctx::PyObject)
    # Retrieving Subroutine name from context
    subroutineName = ctx.subroutineName().NAME().getText()
    # Adding the Subroutine node as a child to the current parent node
    subroutineNode = newProgramNode(subroutineName, "Subroutine")
    currentParent = last(listener.parentStack)
    addChild(currentParent, subroutineNode)
    # Updating the parent stack to include the Subroutine node
    listener.parentStack = [listener.parentStack..., subroutineNode]
  end

  function exitSubroutineSubprogram(listener::PyObject, ctx::PyObject)
    listener.parentStack = listener.parentStack[1:end-1]
  end

  function enterFunctionInterfaceBody(listener::PyObject, ctx::PyObject)
    # Retrieving Interface Function name from context
    functionName = ctx.NAME().getText()
    # Adding the Interface Function node as a child to the current parent node
    functionNode = newProgramNode(functionName, "FunctionInterface")
    currentParent = last(listener.parentStack)
    addChild(currentParent, functionNode)
    # Updating the parent stack to include the Interface Function node
    listener.parentStack = [listener.parentStack..., functionNode]
  end

  function exitFunctionInterfaceBody(listener::PyObject, ctx::PyObject)
    listener.parentStack = listener.parentStack[1:end-1]
  end

  function enterSubroutineInterfaceBody(listener::PyObject, ctx::PyObject)
    # Retrieving Interface Subroutine name from context
    subroutineName = ctx.NAME().getText()
    # Adding the Interface Function node as a child to the current parent node
    subroutineNode = newProgramNode(subroutineName, "SubroutineInterface")
    currentParent = last(listener.parentStack)
    addChild(currentParent, subroutineNode)
    # Updating the parent stack to include the Interface Subroutine node
    listener.parentStack = [listener.parentStack..., subroutineNode]
  end

  function exitSubroutineInterfaceBody(listener::PyObject, ctx::PyObject)
    listener.parentStack = listener.parentStack[1:end-1]
  end

end

# Function for processing a source file
function process_source_file(filePath::String, listener::PyObject)
  input = FileStream(filePath)
  lexer = Fortran90Lexer.Fortran90Lexer(input)
  tokens = CommonTokenStream(lexer)
  parser = Fortran90Parser.Fortran90Parser(tokens)
  tree = parser.program()
  walker = ParseTreeWalker()
  walker.walk(listener, tree)
end

# Setting up command-line arguments
settings = ArgParseSettings()
@add_arg_table! settings begin
  "inputFilePath"
    help = "Path to the input file (.f90)"
    required = true
  "outputFilePath"
    help = "Path to the output file (.dot)"
    required = true
end
# Parsing command-line arguments
parsed_args = parse_args(settings)

# Retrieving input Fortran File path from parsed arguments
inputFilePath = parsed_args["inputFilePath"]
# Retrieving output DOT File path from parsed arguments
outputFilePath = parsed_args["outputFilePath"]

# Initializing the listener with an File node
root = newProgramNode(basename(inputFilePath), "File")
listener = FSEFortran90Listener(root)

try
  process_source_file(inputFilePath, listener)

  # Getting the procedure dictionary content
  dotRepresentation = toDOT(root)

  open(outputFilePath, "w") do f
    # Writing content to the output file
    write(f, dotRepresentation)
  end
# Handling unexpected errors
catch e
  println("An unexpected error occurred:", e)
  rethrow()
end
