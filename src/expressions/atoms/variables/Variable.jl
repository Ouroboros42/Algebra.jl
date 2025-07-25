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
hash(variable::VariableByName, h::UInt) = hash(name(variable), h)

isless(first::UniqueVariable{T}, second::UniqueVariable{T}) where T = isless(objectid(first), objectid(second))
isless(first::VariableByName{T}, second::VariableByName{T}) where T = isless(name(first), name(second))

print(io::IO, variable::Variable) = print(io, name(variable))

uniquename(variable::VariableByName) = name(variable)
uniquename(variable::UniqueVariable) = "$(name(variable))#$(objectid(variable))"

show(io::IO, ::MIME"text/plain", variable::Variable) = print(io, "$(uniquename(variable)) ∈ $(valtype(variable))")
show(io::IO, ::MIME"text/plain", variables::NTuple{N, Variable{T}}) where {N, T} = print(io, "$(join(uniquename.(variables), ", ")) ∈ $T")

const Dependencies = Set{Variable}
dependencies(variable::Variable) = Dependencies((variable,))