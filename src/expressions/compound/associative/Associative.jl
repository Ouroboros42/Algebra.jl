"""
An associative operation, labelled by `Op`, which is usually the equivalent julia function. 
"""
struct Associative{Op, T} <: Compound{T}
    arguments::Vector{Expression}

    Associative{Op, T}(arguments) where {Op, T} = new(vec(collect(Expression, arguments)))
end

Associative{Op, T}(arguments, emptyvalue::Expression) where {Op, T} = isempty(arguments) ? emptyvalue : Associative{Op, T}(arguments)
Associative{Op, T}(args::Expression...) where {Op, T} = Associative{Op, T}(args)
Associative{Op}(arg1::Expression, arg2::Expression) where Op = Associative{Op, infervaltype(Associative{Op}, valtype(arg1), valtype(arg2))}(arg1, arg2)
Associative{Op}(arg::Expression) where Op = Associative{Op, valtype(arg)}(arg)

logicaltype(::Type{<:Associative{Op}}) where Op = Associative{Op}
op(operation::Associative) = op(typeof(operation))
op(::Type{<:Associative{Op}}) where Op = Op

args(operation::Associative) = operation.arguments

print(io::IO, associative::Associative) = print(io, infixstr(associative))

isidentity(Op, ::Expression) = false
isidentity(assoc::Associative) = element -> isidentity(op(assoc), element)

isabsorbing(Op, ::Expression) = false
isabsorbing(assoc::Associative) = element -> isabsorbing(op(assoc), element)

iscentral(Op, element::Expression) = isidentity(Op, element) || isabsorbing(Op, element)
iscentral(assoc::Associative) = element -> iscentral(op(assoc), element)

isplitargs(operation::Associative) = ipartition(iscentral(operation), operation.arguments)

struct CentralFirst{Op} <: Ordering end

CentralFirst(assoc::Associative) = CentralFirst{op(assoc)}()

function Order.lt(::CentralFirst{Op}, a::Expression, b::Expression) where Op
    if !iscentral(Op, a); return false end

    if !iscentral(Op, b); return true end

    isless(a, b)
end
