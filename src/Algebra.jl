module Algebra

using Logging
using Base.Order

import Base: valtype
import Base: isless, isequal
import Base: iterate, isinteger
import Base: zero, one
import Base: print, show
import Base: convert
import Base: +, *, ^, -, /, &, |, ==

# Core interface
export @var, Variable, Literal
export simplify

# Expressions types - ideally rarely needed
export Expression, valtype, args
export Sum, Prod, Pow, base, exponent

# Simplifiers
export NoSimplify, Trivial

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
include("expressions/compound/simple/Simple.jl")
include("expressions/compound/simple/valtype.jl")
include("expressions/compound/operators.jl")
include("expressions/compound/associative/ops/Sum.jl")
include("expressions/compound/associative/ops/Prod.jl")
include("expressions/compound/associative/ops/And.jl")
include("expressions/compound/associative/ops/Or.jl")
include("expressions/compound/simple/ops/Pow.jl")
include("expressions/compound/simple/ops/Equality.jl")
include("simplify/checks.jl")
include("simplify/simplifiers/Simplifier.jl")
include("simplify/simplifiers/Trivial.jl")
include("simplify/simplifiers/Approximate.jl")
include("simplify/compound.jl")
include("simplify/literals.jl")
include("simplify/associative.jl")
include("simplify/multiples.jl")
include("simplify/powers.jl")
include("simplify/equality.jl")
include("worlds/logicaltypes.jl")
include("worlds/scalar/ring.jl")
include("worlds/scalar/powers.jl")
include("worlds/array/addition.jl")
include("worlds/array/matmul.jl")
include("worlds/array/scalar.jl")

end
