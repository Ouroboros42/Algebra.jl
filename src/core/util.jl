isinst(::Type{T}) where T = val -> val isa T

# Unused
function bifilter(condition, items::Vector)
    passing = empty(items)
    failing = empty(items)
    
    outvecs = (passing, failing)

    for outvec in outvecs
        sizehint!(outvec, length(items))  
    end

    for item in items
        if condition(item)
            push!(passing, item)
        else
            push!(failing, item)
        end
    end

    outvecs
end