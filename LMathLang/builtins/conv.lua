conv = {}

function conv.string(object)
    return tostring(object)
end

function conv.number(object)
    return tonumber(object)
end

function conv.boolean(object)
    local bls = {["true"] = true, ["false"] = false}

    return bls[object]
end
