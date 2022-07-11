comparisons = {}

function comparisons.equals(FirstValue, SecondValue)
    return FirstValue == SecondValue
end

function comparisons.nequals(FirstValue, SecondValue)
    return FirstValue ~= SecondValue
end

function comparisons.more(FirstValue, SecondValue)
    return FirstValue > SecondValue
end

function comparisons.less(FirstValue, SecondValue)
    return FirstValue < SecondValue
end

function comparisons.more_eq(FirstValue, SecondValue)
    return FirstValue >= SecondValue
end

function comparisons.less_eq(FirstValue, SecondValue)
    return FirstValue <= SecondValue
end

function comparisons.isnot(Value)
    return not Value
end
