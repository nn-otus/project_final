# Развертывание высокодоступного отказоустойчивого веб-приложения

```txt
    Схема начального стенда

       [ ИНТЕРНЕТ (Default Libvirt Bridge 192.168.122.x) ]
                           |
                +----------+----------+
                |          |          |
            [ROUTER-1] [ROUTER-2] (Keepalived VIP: 192.168.122.254)
                |          |          |
        ________/----------+----------\_________
       /                   |                   \
[ DMZ (10.0.10.x) ]  [ APP (10.0.20.x) ]  [ DB (10.0.30.x) ]
      |                    |                    |
[blnc-1, blnc-2]     [back-1, back-2]     [db-1, db-2]
[front-1, front-2]   [mon-1]
```
+ На первом этапе создана инфраструктура проекта, настроена сетевая связность

```bash
curl -k https://10.0.10.100
<!DOCTYPE html>
<html>
<head>
    <title>Otus-Lab Frontend</title>
    <style>
        body { font-family: sans-serif; text-align: center; margin-top: 50px; }
        .info { color: #555; font-size: 1.2em; }
    </style>
</head>
<body>
    <h1>Welcome to ToDo App!</h1>
    <div class="info">
        <p>Served by node: <strong>front-1</strong></p>
        <p>Internal IP: 10.0.10.21</p>
    </div>
</body>
</html>
```
+ Балансировщики отвечают при обращении на virtual ip

```bash
curl -k -I https://10.0.10.100
HTTP/1.1 200 OK
Server: nginx/1.22.1
Date: Sat, 31 Jan 2026 18:26:41 GMT
Content-Type: text/html
Content-Length: 415
Connection: keep-alive
Last-Modified: Sat, 31 Jan 2026 17:26:34 GMT
ETag: "697e3b4a-19f"
Accept-Ranges: bytes
```

+ Сертификаты используются самоподписанные, требуется установить доменные от Let's Encrypt

