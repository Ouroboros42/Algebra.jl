module Algebra

using Logging
using Base.Order

import Base: valtype
import Base: isless, isequal
import Base: iterate
import Base: isinteger, isreal
import Base: zero, one, iszero, isone
import Base: print, show
import Base: convert
import Base: +, *, ^, -, /, &, |, ==, !

# Core interface
export @var, Variable, Literal
export apply, simplify, approximate, substitute

# Expressions types - ideally rarely needed
export Expression, valtype, args
export Sum, Prod, Pow, base, exponent

include("util/typing.jl")
include("util/nullable.jl")
include("util/iterating.jl")
include("expressions/Expression.jl")
include("expressions/atoms/literals/Literal.jl")
include("expressions/atoms/literals/constants.jl")
include("expressions/atoms/variables/Variable.jl")
include("expressions/atoms/variables/constructors.jl")
include("expressions/compound/Compound.jl")
include("expressions/errors.jl")
include("expressions/conversions.jl")
include("expressions/compound/associative/Associative.jl")
include("expressions/compound/associative/valtype.jl")
include("expressions/compound/operation/Operation.jl")
include("expressions/compound/operation/valtype.jl")
include("expressions/compound/operators.jl")
include("expressions/compound/associative/ops/Sum.jl")
include("expressions/compound/associative/ops/Prod.jl")
include("expressions/compound/associative/ops/And.jl")
include("expressions/compound/associative/ops/Or.jl")
include("expressions/compound/operation/ops/Pow.jl")
include("expressions/compound/operation/ops/Equality.jl")
include("expressions/compound/operation/ops/Not.jl")
include("transforms/checks.jl")
include("transforms/Transform.jl")
include("transforms/compound.jl")
include("transforms/simplify/Simplifier.jl")
include("transforms/simplify/Trivial.jl")
include("transforms/Substitute.jl")
include("transforms/simplify/Approximate.jl")
include("transforms/simplify/cases/literals.jl")
include("transforms/simplify/cases/associative.jl")
include("transforms/simplify/cases/multiples.jl")
include("transforms/simplify/cases/powers.jl")
include("transforms/simplify/cases/boolean.jl")
include("worlds/logicaltypes.jl")
include("worlds/scalar/ring.jl")
include("worlds/scalar/powers.jl")
include("worlds/array/addition.jl")
include("worlds/array/matmul.jl")
include("worlds/array/scalar.jl")

end
