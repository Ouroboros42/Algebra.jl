"""
An `N`-argument operation, labelled by `Op`, which is usually the equivalent julia function. 
"""
struct Operation{Op, N, T} <: Compound{T}
    arguments::SVector{N, Expression}
end

Operation{Op, N}(arguments::SVector{N}) where {Op, N} = Operation{Op, N, infervaltype(Operation{Op, N}, arguments)}(arguments)
Operation{Op, N}(arguments::Expression...) where {Op, N} = Operation{Op, N}(SVector{N, Expression}(arguments))
(F::Type{<:Operation})(arguments...) = F(map(Expression, arguments)...)

logicaltype(::Type{<:Operation{Op, N}}) where {Op, N} = Operation{Op, N}
op(operation::Operation) = op(typeof(operation))
op(::Type{<:Operation{Op}}) where Op = Op

args(func::Operation) = func.arguments
arg(func::Operation{Op, 1}) where Op = only(args(func))

print(io::IO, operation::Operation) = print(io, funcstr(operation))