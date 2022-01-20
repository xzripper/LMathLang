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

local __MATH_LANG32 = require("ml.ml")
local __ML_EXC32 = require("ml.mlexc")
local __ML_OPS32 = require("ml.mlm")
local __ML_OBJS32 = require("ml.mlobjs")

-- A language API.
MathLanguageAPI = {}

-- A math language.
MathLanguageAPI.MathLanguage = {}

-- A math language exceptions.
MathLanguageAPI.MathLanguageExceptions = {}

-- A math language operations.
MathLanguageAPI.MathLanguageOperations = {}

-- A math language objects.
MathLanguageAPI.MathLanguageObjects = {}

-- A language lua compiler functions.
MathLanguageAPI.LuaCompilerFunctions = require("cmpf")

-- A language version.
MathLanguageAPI.Version = 1.2

-- Source file.
MathLanguageAPI.MathLanguage.Source = nil

-- Language exceptions.
MathLanguageAPI.MathLanguageExceptions.Exceptions = __ML_EXC32.Exceptions

-- Language warning.
MathLanguageAPI.MathLanguageExceptions.Warning = __ML_EXC32.Warning

-- Language allowed objects.
MathLanguageAPI.MathLanguageObjects.Allowed = __ML_OBJS32.Allowed

-- Language math operators.
MathLanguageAPI.MathLanguageObjects.Operators = __ML_OBJS32.Operators

-- Create new session in language.
-- If file doesn't exists, it will return LuaMathLangException.
-- If file contains invalid extension, it will return LuaMathLangException.
---@param File string
---@return nil
function MathLanguageAPI.MathLanguage.NewSource(File)
    __MATH_LANG32.NewSource(File)
end

-- Read content of source file.
-- If source will not defined, then will be exception LuaMathLangException.
-- Return's content or nil if error.
---@return nil | string
function MathLanguageAPI.MathLanguage.ReadSource()
    return __MATH_LANG32.ReadSource()
end

-- Parse file lines.
-- If line will not ends with semicolon, it's will return LuaMathLangSyntaxError.
---@return string[] | nil
function MathLanguageAPI.MathLanguage.ParseSource()
    return __MATH_LANG32.ParseSource()
end

-- Main function of class.
-- Run source file.
---@param Beautify boolean
---@return number[]
function MathLanguageAPI.MathLanguage.SolveIt(Beautify)
    return __MATH_LANG32.SolveIt(Beautify)
end

-- Throw language exception.
-- If line not defined, then line will be "?".
-- If Kill is true, exception will kill app.
-- Type can be choosed from MathLanguageAPI.MathLanguageException.Exceptions.
-- Line and Kill optionaly to write.
---@param Type string
---@param Message string
---@param Line? number | nil
---@param Kill? boolean
---@return nil
function MathLanguageAPI.MathLanguageExceptions.Throw(Type, Message, Line, Kill)
    __ML_EXC32.Throw(Type, Message, Line, Kill)
end

-- Get cos of value.
---@param Value number
---@return number
function MathLanguageAPI.MathLanguageOperations.Cos(Value)
    return __ML_OPS32.Cos(Value)
end

-- Get sin of value.
---@param Value number
---@return number
function MathLanguageAPI.MathLanguageOperations.Sin(Value)
    return __ML_OPS32.Sin(Value)
end

-- Get tan of value.
---@param Value number
---@return number
function MathLanguageAPI.MathLanguageOperations.Tan(Value)
    return __ML_OPS32.Tan(Value)
end

-- Get acos of value.
---@param Value number
---@return number
function MathLanguageAPI.MathLanguageOperations.ACos(Value)
    return __ML_OPS32.ACos(Value)
end

-- Get asin of value.
---@param Value number
---@return number
function MathLanguageAPI.MathLanguageOperations.ASin(Value)
    return __ML_OPS32.ASin(Value)
end

-- Get atan of value.
---@param Value number
---@return number
function MathLanguageAPI.MathLanguageOperations.ATan(Value)
    return __ML_OPS32.ATan(Value)
end

-- Get ceiled value.
---@param Value number
---@return number
function MathLanguageAPI.MathLanguageOperations.Ceil(Value)
    return __ML_OPS32.Ceil(Value)
end

-- Get degress value.
---@param Value number
---@return number
function MathLanguageAPI.MathLanguageOperations.Degress(Value)
    return __ML_OPS32.Degress(Value)
end

-- Get radian value.
---@param Value number
---@return number
function MathLanguageAPI.MathLanguageOperations.Radian(Value)
    return __ML_OPS32.Radian(Value)
end

-- Get exp value.
---@param Value number
---@return number
function MathLanguageAPI.MathLanguageOperations.Exp(Value)
    return __ML_OPS32.Exp(Value)
end

-- Floor value.
---@param Value number
---@return number
function MathLanguageAPI.MathLanguageOperations.Floor(Value)
    return __ML_OPS32.Floor(Value)
end

-- Log value.
---@param Value number
---@return number
function MathLanguageAPI.MathLanguageOperations.Log(Value)
    return __ML_OPS32.Log(Value)
end

-- Get root of value.
---@param Value number
---@return number
function MathLanguageAPI.MathLanguageOperations.Root(Value)
    return __ML_OPS32.Root(Value)
end

-- Get absolute value.
---@param Value number
---@return number
function MathLanguageAPI.MathLanguageOperations.Absolute(Value)
    return __ML_OPS32.Absolute(Value)
end

-- Get number PI.
---@return number
function MathLanguageAPI.MathLanguageOperations.PI()
    return __ML_OPS32.PI()
end

-- Run source file with settings.
---@param Source string
---@param Beautify boolean
---@param PrintExecutionTime boolean
function MathLanguageAPI.Run(Source, Beautify, PrintResults, PrintExecutionTime)
    local Start = os.clock()

    MathLanguageAPI.MathLanguage.NewSource(Source)

    local Result = MathLanguageAPI.MathLanguage.SolveIt(Beautify)

    if PrintResults then
        print(Result)
    end

    local Stop = os.clock() - Start

    if PrintExecutionTime then
        print(string.format("Time wasted to run code is %s.", tostring(Stop):gsub("[.]", ",")))
    end
end

-- Get language version.
---@return number
function MathLanguageAPI.GetVersion()
    return __MATH_LANG32.Version
end
