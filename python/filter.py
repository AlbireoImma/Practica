with open('C:/scripts_power/txts/DNS.txt') as f:
    dns = f.read().splitlines()
with open('C:/scripts_power/txts/IP.txt') as f:
    ip = f.read().splitlines()

contador = 0
for a in ip:
    linea = ""
    linea += "INSERT INTO hosts (ip,hostname) VALUES ('"
    linea += a
    linea += "','"
    linea += dns[contador]
    linea += ""
    print(a,dns[contador])
    contador += 1