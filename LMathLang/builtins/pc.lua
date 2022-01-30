require "ml.mltls"

pc = {}

function pc.system(Command)
    os.execute(Command)
end

function pc.output(Command)
    return io.popen(Command):read("*l")
end

function pc.rename(File, On)
    os.rename(File, On)
end

function pc.delete(File)
    os.remove(File)
end

function pc.sizeof(File)
    local Opened = io.open(File, "r")

    local Current = Opened:seek()
    local Size = Opened:seek("end")

    Opened:seek("set", Current)

    Opened:close()

    return Size
end

function pc.dir()
    return pc.output("cd")
end

function pc.user()
    local Path = pc.dir()
    local Elements = MathLangTools.SplitString(Path, "\\")

    local UserName = Elements[3]

    return UserName
end

function pc.where(File)
    local RawOutput = pc.output(string.format("where %s", File))

    if MathLangTools.IsNull(RawOutput) then
        return
    end

    local FoundArray = MathLangTools.SplitString(RawOutput, "\n")
    local Formatted = string.format("<[%s]>", MathLangTools.JoinList(FoundArray, ", "))

    return Formatted
end

