Curl CheatSheet
===============



GET Request
-----------
```bash
curl -X GET www.ilives.tk
```


POST Request
------------
```bash
curl -X POST www.ilives.tk
```


UPDATE Request
--------------
```bash
curl -X PUT www.ilives.tk
```

Sending Payload
---------------
+ string as payload
```bash
curl -X POST -d '[{"name":"vic","interest":"OpenStack"}]' www.ilives.tk
```
+ file as payload

payload.json:
```javascript
[{"name":"vic","interest":"OpenStack"}]
```
```bash
curl -X POST -d @payload.json www.ilives.tk
```
Access HTTPS without cert
-------------------------
```bash
curl -k -X GET https://www.ilives.tk
```

use proxy
---------
```bash
curl -x myproxy:port -X GET http://www.ilives.tk
```

multipart form upload
---------------------
+ upload password file with form name 'password'

```bash
curl -F password=@/etc/passwd www.mypasswords.com
```

+ upload the content of password file with form name 'password_content'
```bash
curl -F password=</etc/passwd www.mypasswords.com
```


DEBUG
-----
write the trace log to trace.log
```bash
curl --trace trace.log -X http://www.ilives.tk
```






