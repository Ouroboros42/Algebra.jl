"""
An `N`-argument operation, labelled by `Op`, which is usually the equivalent julia function. 
"""
struct Operation{Op, N, T, Args <: NTuple{N, Expression}} <: Compound{T}
    arguments::Args
end

Operation{Op, N, T}(arguments::Args) where {Op, N, T, Args <: NTuple{N, Expression}} = Operation{Op, N, T, Args}(arguments)
Operation{Op, N}(arguments::NTuple{N, Expression}) where {Op, N} = Operation{Op, N, simple_valtype(Op, map(valtype, arguments)...)}(arguments)
Operation{Op, N}(arguments::Expression...) where {Op, N} = Operation{Op, N}(arguments)
(F::Type{<:Operation})(arguments...) = F(map(Expression, arguments)...)

similar(::Operation{Op, N}, arguments...) where {Op, N} = Operation{Op, N}(arguments...)

args(func::Operation) = func.arguments
arg(func::Operation{Op, 1}) where Op = only(args(func))

isequal(first::Operation{Op, N}, second::Operation{Op, N}) where {Op, N} = isequal(args(first), args(second))
isless(first::Operation{Op, N}, second::Operation{Op, N}) where {Op, N} = isless(args(first), args(second))

function print(io::IO, (; arguments)::Operation{Op}) where Op
    argstr = join(map(string, arguments), ", ")

    print(io, "$Op($argstr)")
end
