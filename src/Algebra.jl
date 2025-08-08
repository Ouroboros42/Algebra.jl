module Algebra

using Logging
using Base.Order

using StaticArrays

import Base: valtype, isvalid
import Base: iterate, length, getindex
import Base: isless, isequal, hash
import Base: isinteger, isreal
import Base: zero, one, iszero, isone
import Base: print, show
import Base: convert
import Base: +, *, ^, -, /, &, |, ==, !, <
import Base: sin, cos, tan
import Base: sqrt, ifelse

# Core interface
export @var, Variable, Literal
export apply, simplify, approximate, substitute
export dependencies

# Expressions types - ideally rarely needed
export Expression, valtype, args
export Sum, Prod, And, Or, Equality, Not, IfElse
export Pow, base, exponent

include("util/typing.jl")
include("util/nullable.jl")
include("util/iterating.jl")
include("expressions/Expression.jl")
include("expressions/atoms/variables/Variable.jl")
include("expressions/atoms/variables/constructors.jl")
include("expressions/atoms/literals/Literal.jl")
include("expressions/atoms/literals/constants.jl")
include("expressions/compound/Compound.jl")
include("expressions/errors.jl")
include("expressions/conversions.jl")
include("expressions/compound/associative/Associative.jl")
include("expressions/compound/operation/Operation.jl")
include("expressions/compound/transitive/Transitive.jl")
include("expressions/compound/operators.jl")
include("expressions/compound/associative/ops/Sum.jl")
include("expressions/compound/associative/ops/Prod.jl")
include("expressions/compound/associative/ops/And.jl")
include("expressions/compound/associative/ops/Or.jl")
include("expressions/compound/operation/ops/Pow.jl")
include("expressions/compound/operation/ops/Not.jl")
include("expressions/compound/operation/ops/Trig.jl")
include("expressions/compound/operation/ops/IfElse.jl")
include("expressions/compound/transitive/ops/Equality.jl")
include("expressions/compound/transitive/ops/Inequality.jl")
include("transforms/apply.jl")
include("transforms/recursive/RecursiveTransform.jl")
include("transforms/recursive/Substitute.jl")
include("transforms/derivations/Derivation.jl")
include("transforms/derivations/Partial.jl")
include("simplify/checks.jl")
include("simplify/Simplifier.jl")
include("simplify/simplify.jl")
include("simplify/contexts.jl")
include("simplify/cases/associative.jl")
include("simplify/cases/transitive.jl")
include("simplify/cases/multiples.jl")
include("simplify/cases/powers.jl")
include("simplify/cases/boolean.jl")
include("simplify/cases/tryimply.jl")
include("worlds/logicaltypes.jl")
include("worlds/scalar/ring.jl")
include("worlds/scalar/powers.jl")
include("worlds/scalar/trig.jl")
include("worlds/array/addition.jl")
include("worlds/array/matmul.jl")
include("worlds/array/scalar.jl")

end
