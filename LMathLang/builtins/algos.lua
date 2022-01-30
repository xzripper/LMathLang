require "ml.mltls"
require "ml.mlexc"

algos = {}

function algos.fibonacci(Number)
    local X = 0
    local Y = 1

    for _ = 1, Number do
        X, Y = Y, X + Y
    end

    return X
end

function algos.nextint(Number)
    return Number + 1
end

function algos.prevint(Number)
    return Number - 1
end

function algos.half(Number)
    local Half = Number / 2

    if MathLangTools.Endswith(tostring(Half), ".0") then
        return math.ceil(math.abs(Half))
    end

    return Half
end

function algos.hex(Number)
    return string.format("0x%x", tostring(Number))
end

function algos.hton(Number)
    local Result = load("return "..tostring(Number))()

    if type(Result) ~= "number" then
        Throw(Exceptions[4], "Not number instance.", Lib(40))
    end

    return Result
end

