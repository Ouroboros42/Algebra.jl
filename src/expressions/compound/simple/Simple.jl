"""
An `N`-argument operation, labelled by `Op`, which is usually the equivalent julia function. 
"""
struct Simple{Op, N, T, Args <: NTuple{N, Expression}} <: Compound{T}
    arguments::Args
end

Simple{Op, N, T}(arguments::Args) where {Op, N, T, Args <: NTuple{N, Expression}} = Simple{Op, N, T, Args}(arguments)
Simple{Op, N}(arguments::NTuple{N, Expression}) where {Op, N} = Simple{Op, N, simple_valtype(Op, map(valtype, arguments)...)}(arguments)
Simple{Op, N}(arguments::Expression...) where {Op, N} = Simple{Op, N}(arguments)
(F::Type{<:Simple})(arguments...) = F(map(Expression, arguments)...)

similar(::Simple{Op, N}, arguments...) where {Op, N} = Simple{Op, N}(arguments...)

args(func::Simple) = func.arguments
arg(func::Simple{Op, 1}) where Op = only(args(func))

isequal(first::Simple{Op, N}, second::Simple{Op, N}) where {Op, N} = isequal(args(first), args(second))
isless(first::Simple{Op, N}, second::Simple{Op, N}) where {Op, N} = isless(args(first), args(second))

function print(io::IO, (; arguments)::Simple{Op}) where Op
    argstr = join(map(string, arguments), ", ")

    print(io, "$Op($argstr)")
end
