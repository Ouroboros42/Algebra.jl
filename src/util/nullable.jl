macro tryreturn(expr)
    return quote
        local value = $(esc(expr))
        
        if !isnothing(value)
            return value
        end
    end
end

macro returnnothing(expr)
    return quote
        local value = $(esc(expr))
        
        if isnothing(value); return end

        value
    end
end

mapsome(f, ::Nothing) = nothing
mapsome(f, arg) = f(arg)