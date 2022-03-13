files = {}

function files.read(filename)
    local file = io.open(filename, "r")
    local content = file:read("a")

    file:close()

    return content
end

function files.write(filename, data)
    local file = io.open(filename, "w")

    file:write(data)
    file:close()
end

function files.append(filename, data)
    local file = io.open(filename, "a")

    file:write(data)
    file:close()
end

function files.exists(filename)
    return (io.open(filename) ~= nil) and 1 or 0
end

return files
