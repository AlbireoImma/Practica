import csv
import sys

with open("./user_logged/log/"+str(sys.argv[1]),"rb") as fuente:
    with open("sin_BOM.txt","w+b") as destino:
        contenido = fuente.read()
        destino.write(contenido.decode('utf-16').encode('utf-8'))

fp = open("sin_BOM.txt","r")
row = ["UserName","ComputerName","Server","SessionName","ID","State","IdleTime","LogonTime","Error"]
datos = []
datos.append(row)
contador = 0
linea = []
trap_fecha = True
for line in fp:
    stripped = line.rstrip('\n')
    info = stripped.split(":",1)
    if (len(info)>1):
        if (trap_fecha == True):
            trap_fecha = False
        else:
            contador = contador + 1
            linea.append(info[1])
            if (contador == 9):
                datos.append(linea)
                linea = []
                contador = 0

with open(str(sys.argv[1]).split(".")[0]+'.csv', 'w') as csvFile:
    writer = csv.writer(csvFile)
    writer.writerows(datos)
csvFile.close()
