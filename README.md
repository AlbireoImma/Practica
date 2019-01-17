# Practica
Documentación variada sobre el proceso de práctica Enero-Febrero
</br>
</br>
### Bitácora
Lista secuencial de la bitácora día a día
</br>

#### Jueves 3 de Enero del 2018 [9 Horas] [9h]
```
##### Hora Inicio
09:30
##### Hora término
18:30
##### Actividades Desarrolladas
- Creación de scripts para automatización de tareas
- Manual de procedimiento para bloqueo de powershell y aplicaciones de microsoft
- Investigación y documentación sobre uso de WMI como recurso de heurística
* Para llevar un registro de los avances físicos se mantendrá un repositorio git: https://github.com/AlbireoImma/Practica
##### Actividades Pendientes 
- Generalizar algunos scripts para máquinas con más de un servidor
- Intentar abrir smtp en el servidor de prueba
- Continuar con la investigación sobre la mitigación de ataques especificos y medios preventivos
```
#### Viernes 4 de Enero del 2018 [7,5 Horas] [16,5h]
```
##### Hora Inicio
08:30
##### Hora término
16:00
##### Actividades Desarrolladas
- Mejora de scripts para automatización de tareas y aumento en el alcance de las condiciones de estos
- Generalizar algunos scripts para máquinas con más de un servidor
- Manual instructivo sobre la herramienta de políticas de grupos en Windows
- Investigación y documentación sobre herramientas para el monitoreo de endpoints, botnets e identificación de estos
##### Actividades Pendientes
- Intentar abrir smtp en el servidor de prueba
- Continuar con la investigación sobre la mitigación de ataques especificos y medios preventivos
- Investigar las herramientas nepenthes y anubis
```

#### Lunes 7 de Enero del 2018 [9,5 Horas] [26h]
```
##### Hora Inicio
08:30
##### Hora término
18:00
##### Actividades Desarrolladas
- Scripting para monitorizar usuarios conectados a las ip de los servidores
- Buscar cuentas zombies dentro del servidor para cerrarlas
- Investigación ataques producidos con anterioridad y comprobación de la mitigación
##### Actividades Pendientes
- Arreglar el problema del RCP en algunos computadores con errores de comunicación 0x6BA
- Investigar problemas del error 0x5, continuándose con permisos privilegiados
- Investigar monitoreo de endpoints
```

#### Martes 8 de Enero del 2018 [9,5 Horas] [35,5h]
```
##### Hora Inicio
08:30
##### Hora término
18:00
##### Actividades Desarrolladas
- Acceso a procesos y servicios de una máquina mediante wmi y su ip
- Obtención de wmi de forma global y búsqueda específica por máquina y nombre de la clase wmi
- Alternativa encontrada a quser (RCP) mediante uso de wmi
##### Actividades Pendientes
- Arreglar el problema del RCP en algunos computadores con errores de comunicación 0x6BA
- Investigar monitoreo de endpoints
- Investigar herramientas SIEM, tanto como métodos de heurística
```

#### Miércoles 9 de Enero del 2018 [9,5 Horas] [45h]
```
##### Hora Inicio
08:30
##### Hora término
18:00
##### Actividades Desarrolladas
- Investigar herramientas SIEM, tanto como métodos de heurística
- Cambio de rango de IP para el funcionamiento de los scripts
- Desarrollo de un menú para la colección de scripts en un Bash
- Uso de logs para la conservación de datos
##### Actividades Pendientes
- Relacionar los distintos logs, para encontrar fallas
- Centralizar los datos para obtener un histórico
- Modificar funcionamiento de algunos scripts para barridos de IP
```

#### Jueves 10 de Enero del 2018 [9,5 Horas] [54,5h]
```
##### Hora Inicio
08:30
##### Hora término
18:00
##### Actividades Desarrolladas
- Intercambio de log a csv para integración con MS Excel
- Modificación y mejora del menu en Batch
- Modificación de scripts para integrar barrido de IP, enfocados al usuario
- Modificación de scripts para el parseo de información a CSV
##### Actividades Pendientes
- Generación de métricas con los datos obtenidos
- Recopilar distintas métricas de las ya obtenidas
- Buscar soluciones para el error 0x6BA, ya sea mediante el registro o reglas de firewall
```

#### Viernes 11 de Enero del 2018 [7,5 Horas] [62h]
```
##### Hora Inicio
08:30
##### Hora término
16:00
##### Actividades Desarrolladas
- Mapeo de la red interna con nmap
- Documentación sobre el uso de kali en conjunto con sus herramientas, así como el levantar un entorno explotable para la realización de pruebas seguras
- Representación de datos relevantes en Power BI de los CSV
##### Actividades Pendientes
- Buscar soluciones para el error 0x6BA, ya sea mediante el registro o reglas de firewall
- Investigar monitoreo de endpoints
- Investigar sobre el verbose de los logs de nmap
```

#### Lunes 14 de Enero del 2018 [9,5 Horas] [71,5h]
```
##### Hora Inicio
08:30
##### Hora término
18:00
##### Actividades Desarrolladas
- Cambio en el .bat y mejoras en el uso de la memoria para el uso de los scripts
- Recopilación de los csv
##### Actividades Pendientes
- Investigar funcionalidades sobre la consola metasploit
- Buscar vulnerabilidades dentro del conjunto de servidores
- Crear herramientas que usen los scripts de manera automática y sistematizada
```

#### Martes 15 de Enero del 2018 [9,5 Horas] [81h]
```
##### Hora Inicio
08:30
##### Hora término
18:00
##### Actividades Desarrolladas
- Script que obtiene procesos de las máquinas dado un rango o lista de ip
##### Actividades Pendientes
- Desarrollar un script para obtener las tareas programadas de los equipos de forma remota
- Resolver problema RCP en la comunicación entre las máquinas
```

#### Miércoles 16 de Enero del 2018 [9,5 Horas] [90,5h]
```
##### Hora Inicio
08:30
##### Hora término
18:00
##### Actividades Desarrolladas
- Script que obtiene las tareas programadas dado rangos o ip
##### Actividades Pendientes
- Añadir al menú los scripts nuevos
- Documentar los scripts de una manera más detallada
- Resolver problema RCP en la comunicación entre las máquinas
- Documentar sobre estándares ISOS sobre seguridad infromática empresaria
```

#### Jueves 17 de Enero del 2018 [9,5 Horas] [100h]
```
##### Hora Inicio
08:30
##### Hora término
18:00
##### Actividades Desarrolladas
- Búsqueda e investigación en incidentes de spam y virus via macro con archivos adjuntos *.doc
- Monitoreo de las configuraciones de la herramienta anti-spam y reporte/manual sobre su uso y configuración
- Cambio en la implementación de script para obtener las actualizaciones de máquinas en un rango de ip
##### Actividades Pendientes
- Completar script que identifica vulnerabilidades dada una vulnerabilidad (MSXX-XXX) y sus parches (KBXXXXXXX)
- Documentar sobre estándares ISOS sobre seguridad infromática empresarial
- Documentar los scripts de una manera más detallada
- Resolver problema RCP en la comunicación entre las máquinas
```
