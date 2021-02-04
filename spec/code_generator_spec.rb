require './lib/node.rb' 
require './lib/code_generator.rb' 

describe CodeGenerator do 
  describe "#generate" do 
    it "generates code for a single number expression" do 
      tree = IntegerNode.new(1)
      emitter = Emitter.new
      generator = CodeGenerator.new(emitter)
      generator.generate(tree)
      expect(emitter.lines[0]).to eql("\tMOVE #1, D0")
    end
  end 
end
