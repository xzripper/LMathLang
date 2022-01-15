# MathLang Documentation.
## Create file.
Create file like...
```
*.lmtl
```
## Run it.
To run file we need to run this command in console.<br><br>
For Console Command Line.
```cmd
Path\LMathLang PathToMathLang File: String PrintState: Y/n
```
For PowerShell.
```cmd
./Path\LMathLang PathToMathLang File: String PrintState: Y/n
```
## Hello World App.
Create project and write next code.
```
write:Hello World!
```
Lets run it, using command...<br><br>
For Console Command Line.
```cmd
LMathLang PathToMathlang *.lmtl n
```
For PowerShell.
```cmd
./LMathLang PathToMathlang *.lmtl n
```
When we run, we see it.
```
Hello World!
```
## Print version of language.
Lets write this in our file.
```
write:The version is 
write:@Version!
```
When we run, wee see next.
```
The version is 1.0!
```
## Commentaries.
```
? Commentaries starting with "?" keyword.
? If you write comment keyword without space, language will throw you a warning.
```
## Variables.
```
? It's very easy to create variables.
def name = value
```
## Types.
```
? Number.
def x = 1.0
def y = 1

? String.
def z = value

? Bool.
def g = true
```
## Print variable.
```
? How to print variable content?
def x = Var1\nVar2\nVar3
plink:x
```
Result is...
```
Var1
Var2
Var3
```
## Semicolons?
We need to write semicolon, only if this a math operation, else we don't need to do this.
## Math problems.
Main goal of language, math.<br>
So, lets speak about math problems in language.
```
def x = 5
def y = 5

x + y;
```
Lets run it, using command...<br><br>
For Console Command Line.
```cmd
LMathLang PathToMathlang *.lmtl n
```
For PowerShell.
```cmd
./LMathLang PathToMathlang *.lmtl n
```
Result...
```
10
```
That's so fun!
```
456 * 987;
```
Result...
```
450072
```
Another example.
```
5 * 1;
5 * 2;
5 * 3;
5 * 4;
5 * 5;
5 * 6;
5 * 7;
5 * 8;
5 * 9;
5 * 10;
```
Result...
```
5, 10, 15, 20, 25, 30, 35, 40, 45, 50
```
That's so easy!
## Enable language features.
In language we have only 2 features.
<ul>
    <li>Algebra - Use algebra in your code.</li>
    <li>Instantly - Eval problems instantly.</li>
</ul>
How add feature.<br><br>
Without algebra using.<br><br>

```
Cos(1);

? An Lua MathLang error raised.
?     LuaMathLangError: An error happened while solving problem.
?         Line: 1.
```

With algebra.
```
add algebra;

Cos(1);
Sin(1);
```
Run it.<br>

Result...
```
0.8414709848079, 0.54030230586814
```
Using instantly.
```
add instantly;

write:1/3\n
5 * 2;
write:2/3\n
5 * 3;
write:3/3\n
5 * 4;
```

Result.
```
1/3
10
2/3
15
3/3
20
```
Use instantly if you want print data in runtime.
## Add space to string?
```
def x = Hello~S
def y = World!

plink:x
plink:y
```
Result...
```
Hello World!
```
## Exceptions.
MathLang have only 6 exceptions.
<ul>
    <li>LuaMathLangException</li>
    <li>LuaMathLangSyntaxError</li>
    <li>LuaMathLangMissingArgs</li>
    <li>LuaMathLangUsingError</li>
    <li>LuaMathLangLinkError</li>
    <li>LuaMathLangSolutionError</li>
</ul><br>
LuaMathLangException - Something other than another.<br>
LuaMathLangSyntaxError - Syntax error.<br>
LuaMathLangMissingArgs - Missing arguments in object.<br>
LuaMathLangUsingError - Error using object.<br>
LuaMathLangLinkError - Link is not defined.<br>
LuaMathLangSolutionError - Error while solving math problem.<br>
<br>
Lets explore exception message.
<br><br>

```
[ An Lua MathLang error raised. ] - Message about error happened.
    [ LuaMathLangError ]: [ An error happened while solving problem. ] - Exception type, exception message.
        Line: [ 1 ]. - Line where error happened. If line is ?, that means error was happened not in code.
```
## About language.
This language was created in 14.01.2022!<br>
On moment writing this documentation, version of language is 1.0!<br>
Type of language is interpreted.<br>
Author is Ivan Perzhinsky.<br>
Licension is Mit.<br>
Version is 1.0!<br><br>

# End.
Now you know, how to use this language, you know all information about this language! I hope you like my language. Have a good day, bye!
<br><br><hr><p align="center">^_^</p><br>
