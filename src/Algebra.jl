module Algebra

using Logging

include("util/typing.jl")
include("util/nullable.jl")
include("util/iterating.jl")
include("expressions/Expression.jl")
include("expressions/Literal.jl")
include("expressions/Variable.jl")
include("expressions/compound/CompoundExpression.jl")
include("expressions/compound/typeinference/errors.jl")
include("expressions/compound/typeinference/numbers.jl")
include("expressions/compound/associative/resulttype.jl")
include("expressions/compound/associative/AssociativeExpression.jl")
include("expressions/valuetypes.jl")
include("simplify/Simplifier.jl")
include("simplify/standard.jl")
include("simplify/associative.jl")
include("simplify/literals.jl")
include("simplify/multiples.jl")
include("interface/operations.jl")
include("interface/constants.jl")
include("interface/conversions.jl")
include("interface/variables.jl")
include("interface/display.jl")

end
