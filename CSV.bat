ECHO OFF
CLS
:MENU
ECHO.
ECHO ...............................................
ECHO            Seleccione una opcion
ECHO ...............................................
ECHO.
ECHO 1) Historico de Logins [Toda la Red]
ECHO 2) Historico de Logins [Servidores]
ECHO 3) Usuarios conectados tiempo real [Toda la Red]
ECHO 4) Usuarios conectados tiempo real [Servidores]
ECHO 5) Obtener Procesos [Toda la Red]
ECHO 6) Obtener Procesos [Servidores]
ECHO 7) Obtener Tareas programadas [Toda la Red]
ECHO 8) Obtener Tareas programadas [Servidores]
ECHO 9) Obtener Clases WMI [Toda la Red]
ECHO 10) Obtener Clases WMI [Servidores]
ECHO 0) Salir
ECHO.
SET /P M=Seleccione una opcion luego presione ENTER:
IF %M%==1 GOTO SESS
IF %M%==2 GOTO SESSSERVER
IF %M%==3 GOTO USUV
IF %M%==4 GOTO USUVSERVER
IF %M%==5 GOTO PROC
IF %M%==6 GOTO PROCSERVER
IF %M%==7 GOTO SCHD
IF %M%==8 GOTO SCHDSERVER
IF %M%==9 GOTO WMIC
IF %M%==10 GOTO WMICSERVER
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
:SESSSERVER
CLS
Powershell.exe %cd%\user_logged\logged_on_server.ps1
GOTO MENU
:USUVSERVER
CLS
Powershell.exe %cd%\user_logged\Get-LoggedOnUser_server.ps1
GOTO MENU
:PROCSERVER
CLS
Powershell.exe %cd%\procesos_servicios\get_proc_ip_server.ps1
GOTO MENU
:SCHDSERVER
CLS
Powershell.exe %cd%\scheduled\scheduled_task_server.ps1
GOTO MENU
:WMICSERVER
CLS
Powershell.exe %cd%\wmi\get_wmi_count_server.ps1
GOTO MENU