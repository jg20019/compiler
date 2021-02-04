require './lib/node.rb' 
require './lib/code_generator.rb' 

class MockIOStream 
  attr_reader :lines

  def initialize()
    @lines = []
  end

  def puts(s)  
    @lines << s
  end 
end 

describe CodeGenerator do 
  describe "#generate" do 
    it "generates code for a single number expression" do 
      tree = IntegerNode.new(1)
      iostream = MockIOStream.new
      generator = CodeGenerator.new(iostream) 
      generator.generate(tree)
      expect(iostream.lines[0]).to eql("\tMOVE #1, D0")
    end
  end 
end
