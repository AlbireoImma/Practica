ECHO OFF
CLS
:MENU
ECHO.
ECHO ...............................................
ECHO            Seleccione una opcion
ECHO ...............................................
ECHO.
ECHO 1) Obtener script para MAESTRO_DNS
ECHO 2) Obtener KB [via wmi]
ECHO 3) Obtener KB [via sesiones]
ECHO 4) Obtener KB en archivo CSV [via wmi]
ECHO 5) Obtener KB en archivo CSV [via sesiones]
ECHO 6) Obtener KB en archivo CSV [via wmi] [Solo servidores]
ECHO 7) Obtener KB en archivo CSV [via sesiones] [Solo servidores]
ECHO 0) Salir
ECHO.
SET /P M=Seleccione una opcion luego presione ENTER:
IF %M%==1 GOTO DNS
IF %M%==2 GOTO KB1
IF %M%==3 GOTO KB2
IF %M%==4 GOTO CSV
IF %M%==5 GOTO CSV2
IF %M%==6 GOTO CSVS
IF %M%==7 GOTO CSVS2
IF %M%==0 exit /b 0
exit /b 0

:DNS
CLS
Powershell.exe %cd%\dns\dns.ps1
GOTO MENU
:KB1
CLS
Powershell.exe %cd%\vulnerabilidades\populate_BD2.ps1
GOTO MENU
:KB2
CLS
Powershell.exe %cd%\vulnerabilidades\populate_BD.ps1
GOTO MENU
:CSV
CLS
Powershell.exe %cd%\vulnerabilidades\kb_search.ps1
GOTO MENU
:CSV2
CLS
Powershell.exe %cd%\vulnerabilidades\kb_search_2.ps1
GOTO MENU
:CSVS
CLS
Powershell.exe %cd%\vulnerabilidades\kb_search_server.ps1
GOTO MENU
:CSVS2
CLS
Powershell.exe %cd%\vulnerabilidades\kb_search_server_2.ps1
GOTO MENU