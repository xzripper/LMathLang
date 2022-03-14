files = {}

function files.read(filename)
    return io.open(filename, "r"):read("a")
end

function files.write(filename, data)
    return io.open(filename, "w"):write(data)
end

function files.append(filename, data)
    return io.open(filename, "a"):write(data)
end

function files.exists(filename)
    return (io.open(filename) ~= nil) and 1 or 0
end

return files

