arithmetic = {}

function arithmetic.plus(FirstValue, SecondValue)
    return FirstValue + SecondValue
end

function arithmetic.minus(FirstValue, SecondValue)
    return FirstValue - SecondValue
end

function arithmetic.mult(FirstValue, SecondValue)
    return FirstValue * SecondValue
end

function arithmetic.div(FirstValue, SecondValue)
    return FirstValue / SecondValue
end

function arithmetic.pow(FirstValue, SecondValue)
    -- local Result = FirstValue

    -- for _ = 1, SecondValue do
    --     Result = Result ^ Result
    -- end

    return math.floor(math.abs(FirstValue ^ SecondValue))
end

function arithmetic.intdiv(FirstValue, SecondValue)
    return FirstValue // SecondValue
end
