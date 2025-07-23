"""
An associative operation, labelled by `Op`, which is usually the equivalent julia function. 
"""
struct Associative{Op, T} <: Compound{T}
    arguments::Vector{Expression}
end

function tryinfervaltype(assoc::Type{<:Associative}, args::Vector{<:Expression})
    if isempty(args); return end

    mapreduce(valtype, infervaltype(assoc), args)
end

Associative{Op}(arguments::Vector{<:Expression}) where Op = Associative{Op, infervaltype(Associative{Op}, arguments)}(arguments)
Associative{Op}(arguments::Expression...) where Op = Associative{Op}(collect(Expression, arguments))
(A::Type{<:Associative})(arguments...) = A(map(Expression, arguments)...)

logicaltype(::Type{<:Associative{Op}}) where Op = Associative{Op}
op(operation::Associative) = op(typeof(operation))
op(::Type{<:Associative{Op}}) where Op = Op

args(operation::Associative) = operation.arguments

print(io::IO, associative::Associative) = print(io, infixstr(associative))

replacesomeargs(operation::Associative, replacements...) = similar(operation, replacesome(args(operation), replacements...))

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
