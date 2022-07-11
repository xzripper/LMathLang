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

Exceptions = {
    "LuaMathLangException",
    "LuaMathLangSyntaxError",
    "LuaMathLangMissingArgs",
    "LuaMathLangUsingError",
    "LuaMathLangLinkError",
    "LuaMathLangSolutionError"
}

Warning = "Warning"

function Throw(Type, Message, Line, Kill)
    if Line == nil then
        Line = "?"
    end

    if Kill == nil then
        Kill = true
    end

    print(string.format("\x1b[1mAn Lua MathLang error raised.\n    \x1b[31m%s\x1b[37m: \x1b[32m%s\x1b[37m\n        \x1b[34mLine: %s.\x1b[37m\x1b[0m", Type, Message, tostring(Line)))

    if Kill then
        os.exit(1)
    end
end

return _ENV
