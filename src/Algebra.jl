module Algebra

using Logging

using Base.Order

include("util/typing.jl")
include("util/nullable.jl")
include("util/iterating.jl")
include("expressions/Expression.jl")
include("expressions/Literal.jl")
include("expressions/Variable.jl")
include("expressions/compound/CompoundExpression.jl")
include("expressions/compound/typeinference/errors.jl")
include("expressions/compound/Associative.jl")
include("expressions/compound/NFunc.jl")
include("expressions/compound/typeinference/assoc_valtype.jl")
include("expressions/compound/typeinference/nfunc_valtype.jl")
include("expressions/compound/operations/Sum.jl")
include("expressions/compound/operations/Prod.jl")
include("expressions/compound/operations/Pow.jl")
include("expressions/checks.jl")
include("simplify/Simplifier.jl")
include("simplify/StandardSimplifiers.jl")
include("simplify/Approximate.jl")
include("simplify/compound.jl")
include("simplify/literals.jl")
include("simplify/associative.jl")
include("simplify/multiples.jl")
include("simplify/powers.jl")
include("worlds/logicaltypes.jl")
include("worlds/scalar/ring.jl")
include("worlds/scalar/powers.jl")
include("worlds/array/addition.jl")
include("worlds/array/matmul.jl")
include("worlds/array/scalar.jl")
include("interface/constructors.jl")
include("interface/operations.jl")
include("interface/constants.jl")
include("interface/conversions.jl")
include("interface/variables.jl")
include("interface/exports.jl")

end
