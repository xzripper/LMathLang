require "ml.mltls"

arrays = {}

function arrays.print_array(Array)
    local Converted = {}

    for _, Element in ipairs(Array) do
        table.insert(Converted, tostring(Element))
    end

    return string.format("<[%s]>", MathLangTools.JoinList(Converted, ", "))
end

function arrays.get(Array, Index)
    if MathLangTools.IsNull(Array[Index + 1]) then
        return "null"
    end

    return Array[Index + 1]
end

function arrays.add(Array, Object)
    if type(Object) ~= "string" then
        if type(Object) ~= "number" then
            if type(Object) ~= "boolean" then
                return
            end
        end
    end

    table.insert(Array, Object)
end

function arrays.insert(Array, Object, Index)
    if type(Object) ~= "string" then
        if type(Object) ~= "number" then
            if type(Object) ~= "boolean" then
                return
            end
        end
    end

    table.insert(Array, Index + 1, Object)
end

function arrays.delete(Array, Index)
    table.remove(Array, Index + 1)
end

function arrays.where(Array, Object)
    for Index, Element in ipairs(Array) do
        if Element == Object then
            return Index - 1
        end
    end

    return -1
end

function arrays.count(Array, Object)
    local Count = 0

    for _, Element in ipairs(Array) do
        if Element == Object then
            Count = Count + 1
        end
    end

    return Count
end

function arrays.nodup(Array)
    local Removed = Array

    for Index, Element in ipairs(Array) do
        if arrays.count(Array, Element) > 1 then
            table.remove(Removed, Index)
        end
    end

    return Removed
end
