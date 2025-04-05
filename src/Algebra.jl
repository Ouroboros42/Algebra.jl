module Algebra

__precompile__(false)
include("./core/Redef.jl")
include("./core/util.jl")
include("./expressions/Expression.jl")
include("./expressions/Variable.jl")
include("./expressions/compound.jl")
include("./simplify/simplify.jl")
include("./simplify/associative.jl")

end
