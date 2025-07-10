export Variable

const VarName = Union{AbstractString, Symbol}

abstract type Variable{T} <: Expression{T} end

mutable struct UniqueVariable{T, S <: VarName} <: Variable{T}
    name::S
end

struct VariableByName{T, S <: VarName} <: Variable{T}
    name::S
end

name(variable::Union{UniqueVariable, VariableByName}) = variable.name

Variable{T}(name::S, equality_by_name::Bool = false) where {T, S} = if equality_by_name
    VariableByName{T, S}(name)
else
    UniqueVariable{T, S}(name)
end

isequal(var1::VariableByName{T}, var2::VariableByName{T}) where T = name(var1) == name(var2) 

isless(first::UniqueVariable{T}, second::UniqueVariable{T}) where T = isless(objectid(first), objectid(second))
isless(first::VariableByName{T}, second::VariableByName{T}) where T = isless(name(first), name(second))

print(io::IO, variable::Variable) = print(io, name(variable))
show(io::IO, ::MIME"text/plain", variable::VariableByName{T}) where T = print(io, "$(name(variable)) ∈ $T")
show(io::IO, ::MIME"text/plain", variable::UniqueVariable{T}) where T = print(io, "$(name(variable))#$(objectid(variable)) ∈ $T")




