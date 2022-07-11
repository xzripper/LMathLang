require "ml.mlexc"

tests = {}

function tests.check(Expression)
    if not Expression then
        Throw(Warning, "Check failed.", "tests::check::7")
    end
end

function tests.testall(...)
    for Test, Expression in ipairs({...}) do
        if not Expression then
            Throw(Warning, string.format("Test %s failed.", Test), "tests::testall:14")
        end
    end
end

function tests.istrue(Expression)
    if Expression then
        return true
    else
        return false
    end
end

function tests.ifcnd(Expression, Function, ...)
    if Expression then
        Function(...)
    end
end

