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
    CodeGenerator.new().generate(tree) 
  end
end
