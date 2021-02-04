
# File containing all of the defined node types.
# Used in parser.rb and code_generator.rb

IntegerNode = Struct.new(:value) 
TermNode = Struct.new(:value) # an integer eventually terms will not just be a number 
AddOpNode = Struct.new(:type) # :plus or :minus
ExprNode = Struct.new(:term, :addopTerms) # term [ addOp term ]* 
