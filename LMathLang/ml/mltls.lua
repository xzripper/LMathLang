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

MathLangTools = {}

MathLangTools.IsTrueExtensionRegex = ".lmtl$"
MathLangTools.TrueExtension = ".lmtl"
MathLangTools.Undefined = nil

function MathLangTools.IsFileExist(TheFile)
    local File = io.open(TheFile, "r")

    if File == nil then
        return false
    else
        return true
    end
end

function MathLangTools.IsTrueExtension(FileName)
    if string.gmatch(FileName, MathLangTools.IsTrueExtensionRegex)() == MathLangTools.TrueExtension then
        return true
    else
        return false
    end
end

function MathLangTools.IsNull(Object)
    return Object == MathLangTools.Undefined
end

function MathLangTools.SplitString(String, Separator)
    local Lines = {}

    for Str in string.gmatch(String, "([^"..Separator.."]+)") do
        table.insert(Lines, Str)
    end

    return Lines
end

function MathLangTools.Startswith(String, Starts)
    if string.find(String, "^"..Starts) then
        return true
    else
        return false
    end
end

function MathLangTools.Endswith(String, Ends)
    if string.find(String, Ends.."$") then
        return true
    else
        return false
    end
end

function MathLangTools.RemoveFromStartToEnd(String, Start, End)
    return string.sub(String, Start, End)
end

function MathLangTools.IsElementInString(String, Element, MinIsOne)
    if type(Element) == "table" then
        if not MinIsOne then
            local Contains = 0

            for _, Object in ipairs(Element) do
                if string.find(String, Object) then
                    Contains = Contains + 1
                end
            end
    
            if Contains == #Element then
                return true
            else
                return false
            end
        elseif MinIsOne then
            for _, Object in ipairs(Element) do
                if string.find(String, Object) then
                    return true
                end
            end

            return false
        end
    elseif type(Element) == "string" then
        if string.find(String, Element) then
            return true
        else
            return false
        end
    else
        return nil
    end
end

function MathLangTools.EvalProblem(Problem)
    function Eval() 
        local Result = load("return "..Problem.."")()

        if type(Result) == "number" then
            return tonumber(Result)
        elseif type(Result) == "boolean" then
            return Result and 1 or 0
        else
            return tostring(Result)
        end
    end

    if pcall(Eval) then
        return Eval()
    else
        return nil
    end
end

function MathLangTools.JoinList(List, Separator)
    return table.concat(List, Separator)
end

function MathLangTools.Strip(String)
    return string.gsub(String, "%s+", "")
end

function MathLangTools.Slice(List, From, Reverse)
    local Sliced = {}

    if From + 1 > #List then
        return nil
    end

    for Index=From + 1, #List do
        table.insert(Sliced, List[Index])
    end

    if Reverse then
        Reversed = {}

        for Index=1, #Sliced do
            Reversed[Index] = Sliced[#Sliced + 1 - Index]
        end

        return Reversed
    end

    return Sliced
end
