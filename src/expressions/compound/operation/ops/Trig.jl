const Sin = @operator Operation{sin, 1}
const Cos = @operator Operation{cos, 1}

const Trig = Union{Sin, Cos}

tan(expression::Expression) = sin(expression) / cos(expression)