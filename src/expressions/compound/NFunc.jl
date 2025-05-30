"""
An `N`-argument operation, labelled by `Op`, which is usually the equivalent julia function. 
"""
struct NFunc{Op, N, T, Args <: NTuple{N, Expression}} <: CompoundExpression{T}
    arguments::Args
end

NFunc{Op, N, T}(arguments::Args) where {Op, N, T, Args <: NTuple{N, Expression}} = NFunc{Op, N, T, Args}(arguments)
NFunc{Op, N}(arguments::NTuple{N, Expression}) where {Op, N} = NFunc{Op, N, nfunc_valtype(Op, map(valtype, arguments)...)}(arguments)
NFunc{Op, N}(arguments::Expression...) where {Op, N} = NFunc{Op, N}(arguments)

similar(::NFunc{Op, N}, arguments...) where {Op, N} = NFunc{Op, N}(arguments...)

args(func::NFunc) = func.arguments
arg(func::NFunc{Op, 1}) where Op = only(args(func))

iscommutative(::Type{F}) where {F <: NFunc} = false
iscommutative(::F) where {F <: NFunc} = iscommutative(F)

function print(io::IO, (; arguments)::NFunc{Op}) where Op
    argstr = join(map(string, arguments), ", ")

    print(io, "$Op($argstr)")
end
