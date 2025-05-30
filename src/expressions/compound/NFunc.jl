import Base: similar

"""
An `N`-argument operation, labelled by `Op`, which is usually the equivalent julia function. 
"""
struct NFunc{Op, N, T, Args <: NTuple{N, Expression}} <: CompoundExpression{T}
    arguments::Args
end

NFunc{Op, N, T}(arguments::Args) where {Op, N, T, Args <: NTuple{N, Expression}} = NFunc{Op, N, T, Args}(arguments)
NFunc{Op, N}(arguments::NTuple{N, Expression}) where {Op, N} = NFunc{Op, N, nfunc_valtype(Op, arguments)}(arguments)
NFunc{Op, N}(arguments::Expression...) where {Op, N} = NFunc{Op, N}(arguments)

similar(::NFunc{Op}, arguments...) where Op = NFunc{Op}(arguments...)
args(func::NFunc) = func.arguments

iscommutative(::Type{F}) where {F <: NFunc} = false
iscommutative(::F) where {F <: NFunc} = iscommutative(F)

function print(io::IO, (; arguments)::NFunc{Op}) where Op
    if isempty(arguments)
        return print(io, "$Op()")
    end

    firstexpr, rest = Iterators.peel(arguments)

    print(io, "$Op(")

    print(io, firstexpr)
    for expr in rest
        print(io, ", $expr")
    end

    print(io, ")")
end
