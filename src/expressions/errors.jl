import Base.showerror

abstract type ResultInferenceError <: Exception end

struct ResultTypeUndefinedError{Outer <: Compound, Args <: Tuple} <: ResultInferenceError
    args::Args
end

ResultTypeUndefinedError{Outer}(args...) where Outer = ResultTypeUndefinedError{Outer, typeof(args)}(args) 

struct EmptyOperationError{Op} <: ResultInferenceError end

function showerror(io::IO, ::ResultInferenceError)
    print(io, "Result type inference has gone wrong!\nA more detailed error should probably be implemented.")
end

function showerror(io::IO, ::EmptyOperationError{Op}) where Op
    print(io, "Cannot infer the result type of empty operation $Op")    
end

function showerror(io::IO, (; args)::ResultTypeUndefinedError{Outer}) where Outer
    print(io, "Cannot infer result of $Outer for arguments $args.\nMaybe implement it.")
end