ECHO OFF
CLS
:MENU
ECHO.
ECHO ...............................................
ECHO            Seleccione una opcion
ECHO ...............................................
ECHO.
ECHO 1) Script Autentificaciones
ECHO 2) Script Logins
ECHO 3) Script Sesiones [~60 min]
ECHO 4) Script Usuarios [~30 min]
ECHO 5) Script Usuarios Verbose [~30 min]
ECHO 0) Salir
ECHO.
SET /P M=Seleccione una opcion luego presione ENTER:
IF %M%==1 GOTO AUTH
IF %M%==2 GOTO LOGN
IF %M%==3 GOTO SESS
IF %M%==4 GOTO USUR
IF %M%==5 GOTO USUV
IF %M%==0 exit /b 0
exit /b 0

:AUTH
Powershell.exe %cd%\user_logged\get_auth.ps1
GOTO MENU
:LOGN
Powershell.exe %cd%\user_logged\logged_on.ps1
GOTO MENU
:SESS
Powershell.exe %cd%\user_logged\logged_wmi.ps1
GOTO MENU
:USUR
Powershell.exe %cd%\user_logged\swept_user.ps1
GOTO MENU
:USUV
Powershell.exe %cd%\user_logged\Get-LoggedOnUser.ps1
GOTO MENU
