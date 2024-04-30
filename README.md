# Fortran Structure Extractor

## Description
Fortran Structure Extractor parses Fortran 90 source files and generates a corresponding program tree in DOT format. It facilitates the understanding of the program's structure by extracting the hierarchy of main programs, modules, functions, and subroutines.

## Features
- **Program Tree Generation**: Parses Fortran 90 source files to create a hierarchical representation of the program's structure.
- **Support for Main Programs, Modules, Functions, and Subroutines**: Recognizes and extracts the structure of main programs, modules, functions, and subroutines within the Fortran code.
- **DOT Format Output**: Generates the program tree in DOT format, suitable for visualization using graph visualization tools like Graphviz or in VS Code.
- **Command-Line Interface**: Provides a user-friendly command-line interface for specifying input and output file paths.

## Dependencies
- **Julia**: Programming language used for implementing the Fortran Structure Extractor.
  - Install Julia: [Download and installation instructions](https://julialang.org/downloads/)
  - **Julia Modules**:
    - PyCall: Julia package for interfacing with Python modules.
      ```julia
      using Pkg
      Pkg.add("PyCall")
      ```
    - ArgParse: Julia package for command-line argument parsing.
      ```julia
      using Pkg
      Pkg.add("ArgParse")
      ```
- **Python**: Required for interfacing with the ANTLR4 Python modules.
  - Install Python: [Download and installation instructions](https://www.python.org/downloads/)
  - **Python Modules**:
    - antlr4: Lexer and parser generator used for parsing Fortran 90 source files.
      ```bash
      pip install antlr4-python3-runtime
      ```
- **Graphviz**: Tool for visualizing DOT files as graphs, can be used with Visual Studio Code.
  - Install Graphviz: [Download and installation instructions](https://graphviz.org/download/)
  - **GraphViz VS Code Extension**
    - Graphviz Interactive Preview: A VSCode extension that provides syntax highlighting, snippets, and an interactive, zoom-, pan- and searchable, live preview with edge tracing for graphs in Graphviz / dot format.

## How to Use
1. **Installation**: Ensure all the dependencies are installed on your system.
2. **Clone the Repository**: Clone the Fortran Structure Extractor repository to your local machine.
3. **Navigate to Repository Directory**: Open a terminal and navigate to the directory where the repository is cloned.
4. **Run the Program**: Execute the program by running on example program.
   ```bash
   julia FSEFortran90.jl TestProgram/TestProgram.f90 TestProgram/TestProgram.f90 TestProgram/TestProgramStructure.dot
5. **Visualize the Program Tree**: Use graph visualization tools like Graphviz/VSCode to visualize the generated DOT file, representing the program's structure.

## License
This project is licensed under the MIT License.
