module Redef

export @extendnullable

using MacroTools

macro ordefault(nullable, default)
    return quote
        value = $(esc(nullable))

        isnothing(value) ? $(esc(default)) : value
    end
end

function callable_arg(argdef)
    name, _, isslurped, _ = splitarg(argdef)

    if isslurped
        :($(name)...)
    else
        name
    end
end

esc_split_item(item) = esc(item)
esc_split_item(items::Union{Vector, Tuple}) = map(esc, items)
esc_splitdef(funcdef) = Dict(k => esc_split_item(v) for (k, v) in splitdef(funcdef))

macro extendnullable(new_method::Expr)
    old_world = Base.get_world_counter()

    unpacked = esc_splitdef(new_method)

    unpacked[:body] = quote
        @ordefault(
            Base.invoke_in_world(
                $old_world, $(unpacked[:name]),
                $(map(callable_arg, unpacked[:args])...);
                $(map(callable_arg, unpacked[:kwargs])...)
            ),
            $(unpacked[:body])
        )
    end

    return combinedef(unpacked)
end

end

using .Redef