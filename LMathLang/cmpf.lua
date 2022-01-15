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

-- The lua compiler functions.
CompilerFunctions = {}

-- Good code.
CompilerFunctions.Good = 0

-- Bad code.
CompilerFunctions.Bad = 1

-- Get folder with lua.
---@return string
function CompilerFunctions.GetFolder() return "luacmp\\" end

-- Get lua executable.
---@return string
function CompilerFunctions.GetLua() return CompilerFunctions.GetFolder().."lua.exe" end

-- Get lua compiler.
---@return string
function CompilerFunctions.GetLuaCompiler() return CompilerFunctions.GetFolder().."luac.exe" end

-- Get lua DLL.
---@return string
function CompilerFunctions.GetLuaDLL() return CompilerFunctions.GetFolder().."lua54.dll" end

-- Get lua version.
---@return string
function CompilerFunctions.GetLuaVersion() return 5.4 end

-- Run lua file.
---@param File string
---@return string
function CompilerFunctions.RunLua(File) return os.execute(CompilerFunctions.GetLua().." "..File) end

-- Compile lua file.
---@param File string
---@return string
function CompilerFunctions.Compile(File) return os.execute(CompilerFunctions.GetLuaCompiler().." "..File) end

-- Get lua paths.
---@return string
function CompilerFunctions.GetPaths() return {CompilerFunctions.GetFolder(), CompilerFunctions.GetLua(), CompilerFunctions.GetLuaCompiler(), CompilerFunctions.GetLuaDLL()} end

return CompilerFunctions
