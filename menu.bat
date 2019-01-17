ECHO OFF
CLS
:MENU
ECHO.
ECHO ...............................................
ECHO            Seleccione una opcion
ECHO ...............................................
ECHO.
ECHO 1) Historico de Logins [~3000 min]
ECHO 2) Usuarios conectados tiempo real [~30 min]
ECHO 3) Obtener Procesos [~50 min]
ECHO 4) Obtener Tareas programadas [~25 min]
ECHO 5) Obtener Clases WMI
ECHO 0) Salir
ECHO.
SET /P M=Seleccione una opcion luego presione ENTER:
IF %M%==1 GOTO SESS
IF %M%==2 GOTO USUV
IF %M%==3 GOTO PROC
IF %M%==4 GOTO SCHD
IF %M%==5 GOTO WMIC
IF %M%==0 exit /b 0
exit /b 0

:SESS
CLS
Powershell.exe %cd%\user_logged\logged_on.ps1
GOTO MENU
:USUV
CLS
Powershell.exe %cd%\user_logged\Get-LoggedOnUser.ps1
GOTO MENU
:PROC
CLS
Powershell.exe %cd%\procesos_servicios\get_proc_ip.ps1
GOTO MENU
:SCHD
CLS
Powershell.exe %cd%\scheduled\scheduled_task.ps1
GOTO MENU
:WMIC
CLS
Powershell.exe %cd%\wmi\get_wmi_count.ps1
GOTO MENU