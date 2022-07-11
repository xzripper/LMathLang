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

MathLang.Version = 1.6

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
    Content = Content:gsub("@Language", "LMathLang")
    Content = Content:gsub("@File", arg[1])

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
                                                if not MathLangTools.Startswith(Line, "intr") then
                                                    if not MathLangTools.Startswith(Line, "extract") then
                                                        if not MathLangTools.Startswith(Line, "each") then
                                                            if not MathLangTools.Startswith(Line, "delete") then
                                                                if not MathLangTools.Startswith(Line, "typeof") then
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

            if not MathLangTools.IsNull(tonumber(Value)) then
                _G[Name] = tonumber(Value)
            elseif Value == "true" or Value == "false" then
                local Raw = MathLangTools.Startswith(Name, "RAW_")

                if Raw then
                    Name = Name:gsub("RAW_", "")

                    _G[Name] = Value
                else
                    local Booleans = {["true"] = true, ["false"] = false}

                    _G[Name] = Booleans[Value]
                end
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
                    local Evaled = load("return "..TheText)

                    if MathLangTools.IsNull(Evaled) then
                        Throw(Exceptions[3], "Unable to eval expression.", LineNum)
                    end

                    Evaled = Evaled()

                    if type(Evaled) ~= "number" then
                        Throw(Exceptions[4], string.format("Expected problem result as integer, got %s.", type(Evaled)), LineNum)
                    end

                    TheText = Evaled

                    Name = Name:gsub("EVAL_", "")

                    _G[Name] = TheText
                elseif TheText == "ct!" then
                    local Raw = MathLangTools.Startswith(Name, "RAW_")

                    if Raw then
                        Name = Name:gsub("RAW_", "")

                        _G[Name] = TheText
                    elseif not Raw then
                        _G[Name] = os.time()
                    end
                elseif TheText == "fct!" then
                    local Raw = MathLangTools.Startswith(Name, "RAW_")

                    if Raw then
                        Name = Name:gsub("RAW_", "")

                        _G[Name] = TheText
                    elseif not Raw then
                        _G[Name] = os.date("%Hh %Mm %Ss")
                    end
                elseif MathLangTools.Startswith(TheText, "%[]") then
                    local Data = MathLangTools.SplitString(TheText, " ")

                    if MathLangTools.IsNull(Data[2]) then
                        Throw(Exceptions[2], "Missing array elements.", LineNum)
                    end

                    local ArrayInitializer = Data[1]
                    local Elements = ArrayInitializer:sub(3)

                    if not MathLangTools.Startswith(Elements, "{") then
                        if Elements ~= "" then
                            Throw(Exceptions[2], "Missing start of bracket.", LineNum)
                        end
                    end

                    Elements = MathLangTools.JoinList(Data, " ")

                    if MathLangTools.Startswith(Elements, "%[] ") then
                        Elements = Elements:sub(4)
                    elseif MathLangTools.Startswith(Elements, "%[]") then
                        Elements = Elements:sub(3)
                    end

                    if not MathLangTools.Endswith(Elements, "}") then
                        Throw(Exceptions[2], "Missing end of bracket.", LineNum)
                    end

                    local AsLuaTable = load("return "..Elements)

                    if MathLangTools.IsNull(AsLuaTable) then
                        Throw(Exceptions[4], "Failed to create array. (Arrays not fully implemented).", LineNum)
                    end

                    AsLuaTable = AsLuaTable()

                    for _, Element in ipairs(AsLuaTable) do
                        if type(Element) ~= "string" then
                            if type(Element) ~= "number" then
                                if type(Element) ~= "boolean" then
                                    Throw(Exceptions[4], "Invalid type.", LineNum)
                                end
                            end
                        end
                    end

                    _G[Name] = AsLuaTable
                elseif MathLangTools.Startswith(TheText, "%(") and MathLangTools.Endswith(TheText, "%)") then
                    local Raw = MathLangTools.Startswith(Name, "RAW_")

                    if Raw then
                        Name = Name:gsub("RAW_", "")

                        _G[Name] = TheText
                    else
                        local Content = TheText:sub(1, -2):sub(2)

                        local LambdaBody = Content

                        if MathLangTools.IsNull(LambdaBody) then
                            Throw(Exceptions[2], "Missing lambda body.", LineNum)
                        end

                        if not MathLangTools.Startswith(LambdaBody, "%[") then
                            Throw(Exceptions[2], "Body must start on right square bracket.", LineNum)
                        end

                        if not MathLangTools.Endswith(LambdaBody, "%]") then
                            Throw(Exceptions[2], "Body must end on left square bracket.", LineNum)
                        end

                        LambdaBody = LambdaBody:sub(1, -2):sub(2)

                        local LambdaBodyLines = MathLangTools.SplitString(LambdaBody, ";")

                        local function RunLambda()
                            for ProblemPosition, LambdaBodyLine in ipairs(LambdaBodyLines) do
                                if LambdaBodyLine == string.rep(" ", #LambdaBodyLine) then
                                    Throw(Exceptions[2], "Found spaces instead of math problem.", LineNum)
                                end

                                local Result = MathLangTools.EvalProblem(LambdaBodyLine)

                                if type(Result) ~= "number" then
                                    Throw(Exceptions[6], string.format("An error occurred while solving problem %s in lambda.", ProblemPosition), LineNum)
                                end

                                if UsingInstantly then
                                    print(Result)
                                end

                                table.insert(Results, Result)
                            end
                        end

                        _G[Name] = RunLambda
                    end
                else
                    if MathLangTools.Startswith(Value, "!") then
                        local Raw = MathLangTools.Startswith(Name, "RAW_")

                        if not Raw then
                            local Content = _G[Value:sub(2)]

                            if type(Content) == "string" then
                                _G[Name] = tostring(Content:gsub([[\n]], "\n"))
                            elseif type(Content) == "number" then
                                _G[Name] = Content
                            else
                                Throw(Exceptions[5], "Trying to get content from undefined variable.", LineNum)
                            end
                        elseif Raw then
                            Name = Name:gsub("RAW_", "")

                            _G[Name] = tostring(TheText:gsub([[\n]], "\n"))
                        end
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
                        if type(Content) ~= "string" then
                            if type(Content) ~= "number" then
                                if type(Content) ~= "boolean" then
                                    io.write(string.format("<#%s> ~ &%s", type(Content), tostring(MathLangTools.SplitString(tostring(Content), ": ")[2])))
                                else
                                    io.write(tostring(Content))
                                end
                            else
                                io.write(tostring(Content))
                            end
                        else
                            io.write(tostring(Content))
                        end
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
                if MathLangTools.IsNull(MathLangTools.SplitString(Line, " ")[2]) then
                    Throw(Exceptions[4], "Missing package name.", LineNum)
                end

                local Package = MathLangTools.SplitString(Line, " ")[2]:sub(2):sub(1, -2)

                if #MathLangTools.SplitString(Package, ".") > 1 then
                    Throw(Exceptions[4], "Use '::' instead of dot.", LineNum)
                end

                Package = Package:gsub("::", ".")

                if Package == "files" then
                    Package = "builtins.files"
                elseif Package == "algos" then
                    Package = "builtins.algos"
                elseif Package == "pc" then
                    Package = "builtins.pc"
                elseif Package == "arrays" then
                    Package = "builtins.arrays"
                elseif Package == "tests" then
                    Package = "builtins.tests"
                elseif Package == "comparisons" then
                    Package = "builtins.cmprs"
                elseif Package == "conv" then
                    Package = "builtins.conv"
                elseif Package == "arithmetic" then
                    Package = "builtins.arithmetic"
                else
                    if not MathLangTools.IsFileExist(Package.."lua") then
                        Throw(Exceptions[4], "Package not exists.", LineNum)
                    end
                end

                local function ImportIt()
                    require(Package)
                end

                if not pcall(ImportIt) then
                    Throw(Exceptions[4], "Failed to include package.", LineNum)
                end

                local PackageScobes = MathLangTools.SplitString(Line, " ")[2]:sub(1, 1)
                PackageScobes = PackageScobes..MathLangTools.SplitString(Line, " ")[2]:sub(-1)

                local Scobes = {"()", "[]", "{}"}

                for _, Scobe in ipairs(Scobes) do
                    if PackageScobes == Scobe then
                        Throw(Exceptions[4], string.format("Expected '<>' got '%s'.", PackageScobes), LineNum)
                    end
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

                    for Index = 1, #Args do
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

                local LanguageVariables = {"MathLang", "MathLangTools"}

                for _, LangVar in ipairs(LanguageVariables) do
                    if MathLangTools.Startswith(Function, LangVar) then
                        Throw(Exceptions[4], "Trying to call language objects.", LineNum)
                    end
                end

                local function Run()
                    local Output = load("return "..ToLoad)()

                    local ReturnsSomething = not MathLangTools.IsNull(Output)

                    if ReturnsSomething then
                        local ReturnType = type(Output)

                        if ReturnType == "string" or ReturnType == "number" or ReturnType == "boolean" then
                            print(tostring(Output))
                        elseif ReturnType == "table" then
                            local Table = Output

                            for Index = 1, #Table do
                                Table[Index] = tostring(Table[Index])
                            end

                            print(string.format("<[%s]>", MathLangTools.JoinList(Output, ", ")))
                        end
                    end
                end

                -- TODO: Add better exception handling, like in problem solving exception handling.
                Run()

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

                local Start = nil
                local End = nil

                if MathLangTools.Startswith(Arguments[1], "&") then
                    local Link = Arguments[1]:sub(2, -1)

                    if MathLangTools.IsNull(_G[Link]) then
                        Throw(Exceptions[5], "Using link on null object.", LineNum)
                    end

                    Start = _G[Link]
                else
                    Start = tonumber(Arguments[1])
                end

                if MathLangTools.Startswith(Arguments[2], "&") then
                    local Link = Arguments[2]:sub(2, -1)

                    if MathLangTools.IsNull(_G[Link]) then
                        Throw(Exceptions[5], "Using link on null object.", LineNum)
                    end

                    End = _G[Link]
                else
                    End = tonumber(Arguments[2])
                end

                local FunctionName = Arguments[3]

                if MathLangTools.IsNull(Start) or MathLangTools.IsNull(End) then
                    Throw(Exceptions[4], "Start and end must be integer.", LineNum)
                end

                if MathLangTools.IsNull(_G[FunctionName]) then
                    if FunctionName ~= "&Print" then
                        Throw(Exceptions[4], "Function is not defined.", LineNum)
                    end
                end

                local FunctionArguments = {}

                if #Arguments > 3 then
                    local Args = MathLangTools.Slice(Arguments, 3, false)

                    for Index = 1, #Args do
                        if type(Args[Index]) == "string" then
                            FunctionArguments[Index] = Args[Index]:gsub("~C", ":")
                        end
                    end
                end

                for Number = Start, End do
                    local function RunIt()
                        if FunctionName == "&Print" then
                            print(Number)
                        else
                            if #FunctionArguments == 0 then
                                load(string.format("%s(%s)", FunctionName, tostring(Number)))()
                            else
                                load(string.format("%s(%s, %s)", FunctionName, tostring(Number), MathLangTools.JoinList(FunctionArguments, ", ")))()
                            end
                        end
                    end

                    if not pcall(RunIt) then
                        Throw(Exceptions[4], "Exception raised in cycle life time.", LineNum)
                    end
                end
            end

            if MathLangTools.Startswith(Line, Allowed[32]) then
                os.exit(0)
            end

            if MathLangTools.Startswith(Line, Allowed[33]) then
                local Arguments = MathLangTools.SplitString(Line, ":")

                table.remove(Arguments, 1)

                if #Arguments < 2 then
                    Throw(Exceptions[3], "Not enough arguments given.", LineNum)
                end

                local ToIntercept = Arguments[1]
                local ToWrite = Arguments[2]
                local FunctionArguments = MathLangTools.Slice(Arguments, 2, false)
                local FormattedArgs = {}

                local ToLoad = ""

                if not MathLangTools.IsNull(FunctionArguments) then
                    if #FunctionArguments == 0 then
                        FormattedArgs = nil
                    else
                        for _, Arg in ipairs(FunctionArguments) do
                            local Formatted, _ = Arg:gsub("~C", ":")
                            table.insert(FormattedArgs, Formatted)
                        end
                    end
                else
                    FormattedArgs = nil
                end

                if MathLangTools.IsNull(FormattedArgs) then
                    ToLoad = string.format("%s()", ToIntercept)
                else
                    ToLoad = string.format("%s(%s)", ToIntercept, MathLangTools.JoinList(FormattedArgs, ", "))
                end

                local function Intercept()
                    local Returned = load("return "..ToLoad)()

                    if MathLangTools.IsNull(Returned) then
                        _G[ToWrite] = -0.0
                    else
                        if type(Returned) ~= "string" then
                            if type(Returned) ~= "number" then
                                if type(Returned) ~= "boolean" then
                                    if type(Returned) ~= "table" then
                                        Throw(Exceptions[4], "Function returned unknown type.", LineNum)
                                    end
                                end
                            end
                        end

                        _G[ToWrite] = Returned
                    end
                end

                if not pcall(Intercept) then
                    Throw(Exceptions[4], "Cannot intercept function.", LineNum)
                end
            end

            if MathLangTools.Startswith(Line, Allowed[34]) then
                local Data = MathLangTools.SplitString(Line, " ")

                table.remove(Data, 1)

                local Target = Data[1]

                if MathLangTools.IsNull(Target) then
                    Throw(Exceptions[4], "Here's nothing to extract.", LineNum)
                end

                if not MathLangTools.IsFileExist(Target..".lmtl") then
                    Throw(Exceptions[4], "Target not found.", LineNum)
                end

                MathLang.NewSource(Target..".lmtl")
                MathLang.SolveIt(false)
            end

            if MathLangTools.Startswith(Line, Allowed[35]) then
                local Data = MathLangTools.SplitString(Line, ":")

                table.remove(Data, 1)

                if #Data < 2 then
                    Throw(Exceptions[3], "Not enough arguments given.", LineNum)
                end

                local Array = Data[1]
                local Handler = Data[2]
                local Arguments = MathLangTools.Slice(Data, 2, false)

                if MathLangTools.IsNull(Arguments) then
                    Arguments = {}
                end

                local PrintValue = false

                if MathLangTools.IsNull(_G[Array]) then
                    Throw(Exceptions[4], "Expected array, found null.", LineNum)
                end

                if type(_G[Array]) ~= "table" then
                    Throw(Exceptions[4], string.format("Expected array, found %s.", type(_G[Array])), LineNum)
                end

                if MathLangTools.IsNull(_G[Handler]) then
                    if Handler == "&Print" then
                        PrintValue = true
                    else
                        Throw(Exceptions[4], "Expected function, found null.", LineNum)
                    end
                end

                local ToLoad = ""

                for _, Value in ipairs(_G[Array]) do
                    local function Handle()
                        if PrintValue then
                            print(Value)
                        else
                            if #Arguments > 0 then
                                ToLoad = string.format("%s(%s, %s)", Handler, Value, MathLangTools.JoinList(Arguments, ", "))
                            elseif #Arguments == 0 then
                                ToLoad = string.format("%s(%s)", Handler, Value)
                            end

                            local Return = load("return "..ToLoad)()
                            local ReturnsSomething = not MathLangTools.IsNull(Return)

                            if ReturnsSomething then
                                if type(ReturnsSomething) ~= "string" then
                                    if type(ReturnsSomething) ~= "number" then
                                        if type(ReturnsSomething) ~= "boolean" then
                                            Throw(Exceptions[4], "Invalid return.", LineNum)
                                        end
                                    end
                                end

                                print(Return)
                            end
                        end
                    end

                    if not pcall(Handle) then
                        Throw(Exceptions[4], "An exception occurred in iteration.", LineNum)
                    end
                end
            end

            if MathLangTools.Startswith(Line, Allowed[36]) then
                local ToDestroy = MathLangTools.SplitString(Line, " ")[2]

                if MathLangTools.IsNull(_G[ToDestroy]) then
                    Throw(Exceptions[4], "Trying to delete non-existent object.", LineNum)
                end

                if ToDestroy == "MathLang" or ToDestroy == "MathLangTools" then
                    Throw(Exceptions[4], "Trying to delete language class.", LineNum)
                end

                _G[ToDestroy] = nil
            end

            if MathLangTools.Startswith(Line, Allowed[37]) then
                local Object = MathLangTools.SplitString(Line, " ")[2]
                local Type, _ = type(_G[Object]):gsub("table", "array")

                if Type == "nil" then
                    Type = "null"
                end

                io.write(Type)
            end

            if MathLangTools.Startswith(Line, '$$ignite') then
                Throw(Exceptions[1], "Ignited.", LineNum)
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
            elseif MathLangTools.Startswith(Line, Allowed[32]) then
                -- Do nothing.
            elseif MathLangTools.Startswith(Line, Allowed[33]) then
                -- Do nothing.
            elseif MathLangTools.Startswith(Line, Allowed[34]) then
                -- Do nothing.
            elseif MathLangTools.Startswith(Line, Allowed[35]) then
                -- Do nothing.
            elseif MathLangTools.Startswith(Line, Allowed[36]) then
                -- Do nothing.
            elseif MathLangTools.Startswith(Line, Allowed[37]) then
                -- Do nothing.
            elseif MathLangTools.Startswith(Line, "help!") then
                -- Do nothing.
            elseif MathLangTools.Startswith(Line, "grammar!") then
                -- Do nothing.
            else
                local Equals = MathLangTools.EvalProblem(Line)

                if type(Equals) == "table" then
                    local Message = Equals.Message

                    local DetailsByMessage = {
                        ["attempt to perform arithmetic on a nil value"] = "Using non-defined variable in problem.",
                        ["attempt to add a 'number' with a 'string'"] = "Trying to add string to number.",
                        ["attempt to add a 'string' with a 'number'"] = "Trying to add number to string.",
                        ["attempt to perform arithmetic on a boolean value"] = "Trying do operations on a boolean.",
                        ["attempt to perform arithmetic on a table value"] = "Trying do operations on a array.",
                        ["attempt to call a nil value"] = "Wrong syntax in math problem."
                    }

                    for LuaMessage, LanguageMessage in pairs(DetailsByMessage) do
                        if MathLangTools.Startswith(Message, LuaMessage) then
                            Throw(Exceptions[6], LanguageMessage, LineNum)
                        end
                    end
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
        if Line == "help!;" then
            local Doc = io.open("docs\\MathLang.txt", "r")
            local Content = Doc:read("a")

            Doc:close()

            print(Content)
        end

        if Line == "grammar!;" then
            local GrammarFile = io.open("grammar.txt", "r")
            local Grammar = GrammarFile:read("a")

            GrammarFile:close()

            print(Grammar)
        end
    end

    if Beautify then
        return MathLangTools.JoinList(Results, ", ")
    elseif not Beautify then
        return Results
    end
end

return MathLang
