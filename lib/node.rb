
# File containing all of the defined node types.
# Used in parser.rb and code_generator.rb

IntegerNode = Struct.new(:value) 
FactorNode = Struct.new(:value) # an integer eventually terms will not just be a number 
TermNode = Struct.new(:factor, :mulopFactors)  # factor [ mulOp factor ]* 
AddOpNode = Struct.new(:type) # :plus or :minus
MulOpNode = Struct.new(:type) # :star or :slash
ExprNode = Struct.new(:term, :addopTerms) # term [ addOp term ]* 
