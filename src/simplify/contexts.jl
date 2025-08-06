argcontexts(compound::Compound) = nothing

argcontexts(outer::And) = Iterators.map(otherargs -> And(otherargs, TRUE), others(args(outer)))
argcontexts(outer::Or) = Iterators.map(otherargs -> And(.!otherargs, TRUE), others(args(outer)))

argcontexts(outer::IfElse) = (nothing, condition(outer), !condition(outer))