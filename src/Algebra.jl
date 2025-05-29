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
include("expressions/compound/typeinference/resulttype.jl")
include("expressions/compound/AssociativeExpression.jl")
include("expressions/compound/identities.jl")
include("expressions/valuetypes.jl")
include("simplify/Simplifier.jl")
include("simplify/standard.jl")
include("simplify/compound.jl")
include("simplify/associative.jl")
include("simplify/literals.jl")
include("simplify/multiples.jl")
include("worlds/scalars/arithmetic.jl")
include("interface/operations.jl")
include("interface/constants.jl")
include("interface/conversions.jl")
include("interface/variables.jl")
include("interface/exports.jl")

end
