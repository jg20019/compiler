require './lib/lexer.rb' 
require './lib/parser.rb' 
require './lib/code_generator.rb'

class Compiler
  def initialize(source) 
    @source = source
  end

  def compile 
    tokens = Lexer.new(@source).tokenize
    tree = Parser.new(tokens).parse
    code_generator = CodeGenerator.new() 
    code_generator.generate(tree) 
  end
end

compiler = Compiler.new("1+2") 
compiler.compile
