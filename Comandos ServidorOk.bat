@echo off
cls
echo.
echo Digite o numero da opcao desejada
echo. 
:Inicio
:Downloads
:Link .Net
echo  1 Links 
echo  2 Criar servico e Porta Firewall 8589 e 44340
echo  3 Colocar descricao servico
echo  4 Sair
echo.
set /p opcao= Digite a opcao desejada: 

if "%opcao%" == "1" goto op1 (goto Downloads)
if "%opcao%" == "2" goto op2 (goto Inicio)
if "%opcao%" == "3" goto op3 
if "%opcao%" == "4" goto op4 

:op1
cls
echo Downloads
ECHO 1 - ClientHost
ECHO 2 - Link .Net
ECHO 3 - Retornar ao menu inicial
echo.
set /p opcao= Digite a opcao desejada: 
if "%opcao%" == "1" goto N1 (goto Downloads)
if "%opcao%" == "2" goto N2 (goto Link .Net)
if "%opcao%" == "3" goto N3 (goto Inicio) 


:N1
cls
start https://drive.google.com/drive/folders/1vtR5nk1N6h9GBJPbXn_z5q8P5wMjd345? usp=sharing
echo.
goto Downloads 

:N2
cls
echo Link .Net
ECHO 1 - ASP.NET Core 5.0 Runtime (v2.2.8)
ECHO 2 - ASP.NET Core 7.0 Runtime (v5.0.7)
ECHO 3 - .NET Framework 4.8.1
ECHO 4 - Menu Inicial
echo.
set /p opcao= Digite a opcao desejada: 
if "%opcao%" == "1" goto M1 (goto Link .Net)
if "%opcao%" == "2" goto M1 (goto Link .Net)
if "%opcao%" == "3" goto M3 (goto Link .Net) 
if "%opcao%" == "4" goto M4 (goto Inicio) 


:N3
cls
goto Inicio

:M1
cls
start https://dotnet.microsoft.com/download/dotnet/thank-you/runtime-aspnetcore-5.0.7-windows-x64-installer usp=sharing
pause
goto Link .Net

:M2
cls
start https://dotnet.microsoft.com/pt-br/download/dotnet/thank-you/runtime-aspnetcore-7.0.13-windows-x64-installer usp=sharing
pause
goto Link .Net

:M3
cls
start https://dotnet.microsoft.com/pt-br/download/dotnet-framework/thank-you/net481-web-installer usp=sharing
pause
goto Link .Net

:M4
cls
goto Inicio

:N3
goto Inicio



:op2
cls
sc create MeepClientHost binpath= "C:\ClientHost\ClientHost.exe" Start= "delayed-auto" DisplayName= "Meep - Gateway de Impressao" & netsh advfirewall firewall add rule name="Meep Client Host" dir=in action=allow protocol=TCP localport=8589 
echo Operacao Concluida & netsh advfirewall firewall add rule name="Meep Client Host" dir=in action=allow protocol=TCP localport=44340
pause
cls
goto Inicio

:op3
cls
sc description MeepClientHost "Gateway de Impressao" >nul
echo.
echo Operacao executada com sucesso
goto inicio


:op4
cls
net start MeepClientHost & exit
echo.
goto fim

:fim
echo.
echo Operacao executada com sucesso!
echo.
pause
