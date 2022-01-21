--[[
    MIT License

    Copyright (c) 2022 Ivan Perzhinsky.

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
]]

require "ml.mlexc"
require "ml.mltls"
require "ml.mlobjs"

MathLang = {}

MathLang.Source = nil
MathLang.NewLine = "\n"
MathLang.Semicolon = ";"

MathLang.Version = 1.3

function MathLang.NewSource(File)
    if not MathLangTools.IsFileExist(File) then
        Throw(Exceptions[1], "File doesn't exists.")
    elseif not MathLangTools.IsTrueExtension(File) then
        Throw(Exceptions[1], "Invalid extension.")
    else
        MathLang.Source = File
    end
end

function MathLang.ReadSource()
    if MathLangTools.IsNull(MathLang.Source) then
        Throw(Exceptions[1], "Source is not defined.")
    end

    local Opened = io.open(MathLang.Source, "r")
    local Content = Opened:read("a")

    Content = Content:gsub("@Version", tostring(MathLang.Version))

    Opened:close()

    return Content
end

function MathLang.ParseSource()
    local Content = MathLang.ReadSource()
    local Lines = MathLangTools.SplitString(Content, MathLang.NewLine)

    if #Lines == 0 then
        return Lines
    end

    if not MathLangTools.Endswith(Content, MathLang.NewLine) then
        Throw(Warning, "Missing newline at end of file.", #Lines, false)
    end

    for LineNum, Line in ipairs(Lines) do
        if not MathLangTools.Endswith(Line, MathLang.Semicolon) then
            if not MathLangTools.Startswith(Line, "?") then
                if not MathLangTools.Startswith(Line, "write") then
                    if not MathLangTools.Startswith(Line, "def") then
                        if not MathLangTools.Startswith(Line, "plink") then
                            if not MathLangTools.Startswith(Line, "assertion") then
                                if not MathLangTools.Startswith(Line, "uinp") then
                                    if not MathLangTools.Startswith(Line, "includes") then
                                        if not MathLangTools.Startswith(Line, "call") then
                                            if not MathLangTools.Startswith(Line, "for") then
                                                Throw(Exceptions[2], "Line must end on semicolon.", LineNum)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return Lines
end

function MathLang.SolveIt(Beautify)
    local Results = {}
    local Lines = MathLang.ParseSource()

    local UsingAlgebra = false
    local UsingInstantly = false

    for _, Line in ipairs(Lines) do
        if MathLangTools.Startswith(Line, "add algebra") then
            UsingAlgebra = true
        end

        if MathLangTools.Startswith(Line, "add instantly") then
            UsingInstantly = true
        end
    end

    if UsingAlgebra then
        require "ml.mlm"
    end

    for LineNum, Line in ipairs(Lines) do
        if MathLangTools.Startswith(Line, "def") then
            local SplittedOnSpaces = MathLangTools.SplitString(Line, " ")

            local Name = SplittedOnSpaces[2]
            local Value = SplittedOnSpaces[4]

            if MathLangTools.IsNull(Name) then
                Throw(Exceptions[2], "Missing variable name.", LineNum)
            end

            if MathLangTools.IsNull(Value) then
                Throw(Exceptions[2], "Missing variable value.", LineNum)
            end

            local ToBool = {["true"]=true, ["false"]=false}

            if not MathLangTools.IsNull(tonumber(Value)) then
                _G[Name] = tonumber(Value)

            else
                local SlicedText = MathLangTools.Slice(SplittedOnSpaces, 3, false)
                local TheText = ""

                for _, Text in ipairs(SlicedText) do
                    TheText = TheText.." "..Text
                end

                Characters = {} TheText:gsub(".", function(Char) table.insert(Characters, Char) end)
                Characters = MathLangTools.Slice(Characters, 1, false)
                TheText = MathLangTools.JoinList(Characters)
                TheText = TheText:gsub("~S", " ")

                if MathLangTools.Startswith(Name, "EVAL_") then
                    local Evaled = load("return "..TheText)()

                    if MathLangTools.IsNull(Evaled) then
                        Throw(Exceptions[3], "Unable to eval expression.", LineNum)
                    end

                    TheText = Evaled

                    Name = Name:gsub("EVAL_", "")

                    _G[Name] = TheText
                else
                    if MathLangTools.Startswith(Value, "!") then
                        local Var = Value:sub(2)
                        local Content = _G[Var]

                        if MathLangTools.IsNull(Content) then
                            Throw(Exceptions[5], string.format("\"%s\" is not defined.", Var), LineNum)
                        end

                        _G[Name] = tostring(Content:gsub([[\n]], "\n"))
                    else
                        _G[Name] = tostring(TheText:gsub([[\n]], "\n"))
                    end
                end
            end
        end

        if MathLangTools.Startswith(Line, "?") then
            local Character = Line:sub(2, 2)
            local Space = " "

            if Character ~= Space then
                Throw(Warning, "Use space after commentary declaration.", LineNum, false)
            end
        else
            if MathLangTools.Startswith(Line, Allowed[22]) then
                local Text = MathLangTools.SplitString(Line, ":")

                table.remove(Text, 1)

                if #Text < 1 then
                    Throw(Exceptions[3], "Not enough arguments given.", LineNum)
                end

                if #Text == 1 then
                    local OnlyText = Text[1]:gsub([[\n]], "\n")

                    io.write(OnlyText)
                else
                    io.write(MathLangTools.JoinList(Text, " "))
                end
            end

            if MathLangTools.Startswith(Line, Allowed[26]) then
                local Var = MathLangTools.SplitString(Line, ":")

                table.remove(Var, 1)

                if #Var > 1 then
                    Throw(Exceptions[4], "Too many arguments given.", LineNum)
                end

                if #Var < 1 then
                    Throw(Exceptions[3], "Not enough arguments.", LineNum)
                end

                if #Var == 1 then
                    local Name = MathLangTools.Strip(Var[1])
                    local Content = _G[Name]

                    if MathLangTools.IsNull(Content) then
                        Throw(Exceptions[5], string.format("\"%s\" is not defined.", Name), LineNum)
                    else
                        io.write(tostring(Content))
                    end
                end
            end

            if MathLangTools.Startswith(Line, Allowed[27]) then
                local Arguments = MathLangTools.SplitString(Line, ":")

                table.remove(Arguments, 1)

                if #Arguments > 2 then
                    Throw(Exceptions[4], "Too many arguments given.", LineNum)
                end

                if #Arguments < 2 then
                    Throw(Exceptions[3], "Not enough arguments given.", LineNum)
                end

                local Expression = Arguments[1]
                local Message = Arguments[2]

                local EvaluatedExpression = load("return "..Expression)()

                if MathLangTools.IsNull(Expression) then
                    Throw(Exceptions[4], "Invalid expression.", LineNum)
                end

                if not EvaluatedExpression then
                    Throw(Warning, Message, LineNum)
                end
            end

            if MathLangTools.Startswith(Line, Allowed[28]) then
                local Arguments = MathLangTools.SplitString(Line, ":")

                table.remove(Arguments, 1)

                if #Arguments > 3 then
                    Throw(Exceptions[4], "Too many arguments given.", LineNum)
                end

                if #Arguments < 3 then
                    Throw(Exceptions[3], "Not enough arguments.", LineNum) 
                end

                local Placeholder = Arguments[1]:gsub("~C", ":")
                local WriteTo = Arguments[2]
                local ConvertTo = Arguments[3]:lower()

                io.write(Placeholder)

                local Input = io.read("l")

                if ConvertTo == "integer" then
                    local Converted = tonumber(Input)

                    if MathLangTools.IsNull(Converted) then
                        Converted = -0.0
                    end

                    _G[WriteTo] = Converted
                elseif ConvertTo == "string" then
                    _G[WriteTo] = Input
                else
                    Throw(Exceptions[4], "Invalid type.", LineNum)
                end
            end

            if MathLangTools.Startswith(Line, Allowed[29]) then
                local Package = MathLangTools.SplitString(Line, " ")[2]:sub(2):sub(1, -2)

                if Package == "files" then
                    Package = "builtins.files" 
                end

                local function ImportIt()
                    require(Package)
                end

                if not pcall(ImportIt) then
                    Throw(Exceptions[4], "Failed to include package.", LineNum)
                end
            end

            if MathLangTools.Startswith(Line, Allowed[30]) then
                local Arguments = MathLangTools.SplitString(Line, ":")

                table.remove(Arguments, 1)

                if #Arguments == 0 then
                    Throw(Exceptions[3], "Not enough arguments given.", LineNum)
                end

                local Function = Arguments[1]

                local FunctionArguments = {}

                if #Arguments > 1 then
                    local Args = MathLangTools.Slice(Arguments, 1, false)

                    for Index=1, #Args do
                        if type(Args[Index]) == "string" then
                            FunctionArguments[Index] = Args[Index]:gsub("~C", ":")
                        end
                    end
                end

                local ToLoad = ""

                if #FunctionArguments == 0 then
                    ToLoad = string.format("%s()", Function)
                else
                    ToLoad = string.format("%s(%s)", Function, MathLangTools.JoinList(FunctionArguments, ", "))
                end

                local function Run()
                    local Output = load("return "..ToLoad)()

                    local ReturnsSomething = not MathLangTools.IsNull(Output)

                    if ReturnsSomething then
                        local ReturnType = type(Output)

                        if ReturnType == "string" or ReturnType == "number" then
                            print(tostring(Output))
                        elseif ReturnType == "table" then
                            local Table = Output

                            for Index=1, #Table do
                                Table[Index] = tostring(Table[Index])
                            end

                            print(string.format("<[%s]>", MathLangTools.JoinList(Output, ", ")))
                        end
                    end
                end

                if not pcall(Run) then
                    Throw(Exceptions[4], "Unnable to run function.", LineNum)
                end
            end

            if MathLangTools.Startswith(Line, Allowed[31]) then
                local Arguments = MathLangTools.SplitString(Line, ":")

                table.remove(Arguments, 1)

                if #Arguments < 3 then
                    Throw(Exceptions[3], "Not enough arguments given.", LineNum)
                end

                local Start = tonumber(Arguments[1])
                local End = tonumber(Arguments[2])
                local FunctionName = Arguments[3]

                if MathLangTools.IsNull(Start) or MathLangTools.IsNull(End) then
                    Throw(Exceptions[4], "Start and end must be integer.", LineNum)
                end

                if MathLangTools.IsNull(_G[FunctionName]) then
                    Throw(Exceptions[4], "Function is not defined.", LineNum)
                end

                local FunctionArguments = {}

                if #Arguments > 3 then
                    local Args = MathLangTools.Slice(Arguments, 3, false)

                    for Index=1, #Args do
                        if type(Args[Index]) == "string" then
                            FunctionArguments[Index] = Args[Index]:gsub("~C", ":")
                        end
                    end
                end

                for Number=Start, End do
                    local function RunIt()
                        if #FunctionArguments == 0 then
                            load(string.format("%s(%s)", FunctionName, tostring(Number)))()
                        else
                            load(string.format("%s(%s, %s)", FunctionName, tostring(Number), MathLangTools.JoinList(FunctionArguments, ", ")))()
                        end
                    end

                    if not pcall(RunIt) then
                        Throw(Exceptions[4], "Exception raised in cycle life time.", LineNum)
                    end
                end
            end

            if MathLangTools.Startswith(Line, Allowed[22]) then
                -- Do nothing.
            elseif MathLangTools.Startswith(Line, Allowed[23]) then
                -- Do nothing.
            elseif MathLangTools.Startswith(Line, Allowed[24]) then
                -- Do nothing.
            elseif MathLangTools.Startswith(Line, Allowed[25]) then
                -- Do nothing.
            elseif MathLangTools.Startswith(Line, Allowed[26]) then
                -- Do nothing.
            elseif MathLangTools.Startswith(Line, Allowed[27]) then
                -- Do nothing.
            elseif MathLangTools.Startswith(Line, Allowed[28]) then
                -- Do nothing.
            elseif MathLangTools.Startswith(Line, Allowed[29]) then
                -- Do nothing.
            elseif MathLangTools.Startswith(Line, Allowed[30]) then
                -- Do nothing.
            elseif MathLangTools.Startswith(Line, Allowed[31]) then
                -- Do nothing.
            elseif MathLangTools.Startswith(Line, "help!") then
                -- Do nothing.
            else
                local Equals = MathLangTools.EvalProblem(Line)

                if MathLangTools.IsNull(Equals) then
                    Throw(Exceptions[6], "An error happened while solving problem.", LineNum)
                else
                    if type(Equals) ~= "number" then
                        Throw(Exceptions[6], "Invalid return.", LineNum)
                    end

                    if UsingInstantly then
                        print(Equals)
                    end

                    table.insert(Results, Equals)
                end
            end
        end
    end

    for _, Line in ipairs(Lines) do
        if Line:lower() == "help!;" then
            local Doc = io.open("docs\\MathLang.txt", "r")
            local Content = Doc:read("a")

            Doc:close()

            print(Content)
        end
    end

    if Beautify then
        return MathLangTools.JoinList(Results, ", ")
    elseif not Beautify then
        return Results
    end
end

return MathLang
