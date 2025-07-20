"""
An `N`-argument operation, labelled by `Op`, which is usually the equivalent julia function. 
"""
struct Operation{Op, N, T, Args <: NTuple{N, Expression}} <: Compound{T}
    arguments::Args
end

Operation{Op, N, T}(arguments::Args) where {Op, N, T, Args <: NTuple{N, Expression}} = Operation{Op, N, T, Args}(arguments)
Operation{Op, N}(arguments::NTuple{N, Expression}) where {Op, N} = Operation{Op, N, operation_valtype(Op, map(valtype, arguments)...)}(arguments)
Operation{Op, N}(arguments::Expression...) where {Op, N} = Operation{Op, N}(arguments)
(F::Type{<:Operation})(arguments...) = F(map(Expression, arguments)...)

logicaltype(::Type{<:Operation{Op, N}}) where {Op, N} = Operation{Op, N}
op(operation::Operation) = op(typeof(operation))
op(::Type{<:Operation{Op}}) where Op = Op

args(func::Operation) = func.arguments
arg(func::Operation{Op, 1}) where Op = only(args(func))

print(io::IO, operation::Operation) = print(io, funcstr(operation))