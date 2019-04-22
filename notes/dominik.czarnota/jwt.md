```
root@k8s-1:/home/vagrant# kubectl get secret -o json
{
    "apiVersion": "v1",
    "items": [
        {
            "apiVersion": "v1",
            "data": {
                "ca.crt": "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUN5RENDQWJDZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRFNU1ETXlOakV6TURFek0xb1hEVEk1TURNeU16RXpNREV6TTFvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTCthCmpmVjVkY0RUYndSc2JaNEpHT2hkWTJpbnlVSFlXU3E2WDNVZlpKSXEzeGt4T0RETllrMzBuLzFQdWdhTGl3ckkKaWpHU0l0VVZiclF3RlY4dEY0aW55OE9UWlA5QkRBcmRnaDduL0YvWHdnWmV5R2NRbEZYL0psVzE1UVNacEFtcgpHTlo2VkhLbm5yVHA0emlRRFZaMVhRQnZkbGtTaXBKRnF2dFo1Tjk4K1hQMjJqc1FKNW9XZTQ5RVBlWmdCQUNnCmlmRGxCbWo0RWw4TGZ4REdyY2c4RUZ1eE1wekpGS1FBMjlXa25BQUJWSFoya3JvRGUrWjFEQ2JXNjZTdlpERksKUnUzRVQ1cDJrSEdRajlNVjhZZE4wYTB1aUwrYjdiRjliYTdzNElGTUZnR3V6SVBOeERLcHJQN25HOU9hL1NseApPZkNMMUs5RXowcEhHRXNZZno4Q0F3RUFBYU1qTUNFd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0RRWUpLb1pJaHZjTkFRRUxCUUFEZ2dFQkFJSzBzL1N1eTM3ZGNkQThZVjNaTjFZVDQzWWwKZUoyYmRTbSsrcVUzRytueldXOFV2Y0J3VW9Kby9KUWFvZmk0MkVlUUdKRGZEd1luUS92c1hhTzN4Z3M5TXNXSgo3T1czSmg1a3ZibTJlTm9LMmxuTitGVGF3V3ROOVd3eCtDNDJmeTVRYzFuRXBIbWJZMUxCVllIR0FKMEp0TW56ClZMQ3RPanBCMjA3UlZ1SW9GV0pseEFZU1FTOGFoWkpVWmdVR0RlRUNJNW83U0RPa0d1ZDFEL3U3djJiOUZoQ0UKTXFOZE1TVE1UR01oVVk1OVYwNEhLM1EvZ0piKzVlUXUzVjNoc2RtSEhvTUs3MHB3aTNKZk4reDNYNEc4dkw4KwpOZGN2YjFiK1U1U2lBQ0lmMHV5T1ZMTjR6NUZtQnF3dWlDSTJwR3M3ZEtJNUlDS1pwa2gyK3NGVGwxQT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=",
                "namespace": "ZGVmYXVsdA==",
                "token": "ZXlKaGJHY2lPaUpTVXpJMU5pSXNJbXRwWkNJNklpSjkuZXlKcGMzTWlPaUpyZFdKbGNtNWxkR1Z6TDNObGNuWnBZMlZoWTJOdmRXNTBJaXdpYTNWaVpYSnVaWFJsY3k1cGJ5OXpaWEoyYVdObFlXTmpiM1Z1ZEM5dVlXMWxjM0JoWTJVaU9pSmtaV1poZFd4MElpd2lhM1ZpWlhKdVpYUmxjeTVwYnk5elpYSjJhV05sWVdOamIzVnVkQzl6WldOeVpYUXVibUZ0WlNJNkltUmxabUYxYkhRdGRHOXJaVzR0WmpSMFpuWWlMQ0pyZFdKbGNtNWxkR1Z6TG1sdkwzTmxjblpwWTJWaFkyTnZkVzUwTDNObGNuWnBZMlV0WVdOamIzVnVkQzV1WVcxbElqb2laR1ZtWVhWc2RDSXNJbXQxWW1WeWJtVjBaWE11YVc4dmMyVnlkbWxqWldGalkyOTFiblF2YzJWeWRtbGpaUzFoWTJOdmRXNTBMblZwWkNJNklqWXhNV1EwWVdZNExUUm1ZemN0TVRGbE9TMWhPVFF4TFRBNE1EQXlOekUxT0Rsak9DSXNJbk4xWWlJNkluTjVjM1JsYlRwelpYSjJhV05sWVdOamIzVnVkRHBrWldaaGRXeDBPbVJsWm1GMWJIUWlmUS5KNWh2TC1jMWtJbGFUdEEwMUROX1F6NGdBYkV0YkYyWnJIOUZXTGVaRElQcFBfYVFPdlZ6cGRLc0p0SUZ0LV9pOG1nVWdlcmI2emJaVXZ4SUYwaEVzR3pLQm16amZZUmdUTkRLX0pEWHZVWUFwc05QV2hYQkpjeFA4eWdUM05jVXp2YU1ybzZrZ3hfaEQzUkVHbkt0TUtpZjJ1UDFXQ0NGZUxyclVRU0F0ai1LSDRKOUdTSlZaRTBJaTF5Z3BYeUJ1VWt1YnNuN3oxaFR0NTJ0TWtGUW1XWW5pNnVLaFFxcHlBT0d6ZWkxcGc1Z1VqNi1vaTZlN3UxaDlZcWRqMGRwejZpWTRDQmpBMEV0ODIweWVkdjl4elJjeUZXOFd2M1IwbmxKbEQxaGJLS2swaDVrMGlWMHVEZVhQMDM0TlhWWTVwSXIxcFlYVDh4N3R5TXEtYkE3V0E="
            },
            "kind": "Secret",
            "metadata": {
                "annotations": {
                    "kubernetes.io/service-account.name": "default",
                    "kubernetes.io/service-account.uid": "611d4af8-4fc7-11e9-a941-0800271589c8"
                },
                "creationTimestamp": "2019-03-26T13:02:15Z",
                "name": "default-token-f4tfv",
                "namespace": "default",
                "resourceVersion": "342",
                "selfLink": "/api/v1/namespaces/default/secrets/default-token-f4tfv",
                "uid": "6133adb6-4fc7-11e9-a941-0800271589c8"
            },
            "type": "kubernetes.io/service-account-token"
        }
    ],
    "kind": "List",
    "metadata": {
        "resourceVersion": "",
        "selfLink": ""
    }
}
```


Decoded:

```
In [20]: a, b, c = b64decode('ZXlKaGJHY2lPaUpTVXpJMU5pSXNJbXRwWkNJNklpSjkuZXlKcGMzTWlPaUpyZFdKbGNtNWxkR1Z6TDNObGNuWnBZMlZoWTJOdmRXNTBJaXdpYTNWaVpYSnVaWFJsY3k1cGJ5OXpaWEoyYVdObFlXTmpiM1Z1ZEM5dVlXMWxj
    ...: M0JoWTJVaU9pSmtaV1poZFd4MElpd2lhM1ZpWlhKdVpYUmxjeTVwYnk5elpYSjJhV05sWVdOamIzVnVkQzl6WldOeVpYUXVibUZ0WlNJNkltUmxabUYxYkhRdGRHOXJaVzR0WmpSMFpuWWlMQ0pyZFdKbGNtNWxkR1Z6TG1sdkwzTmxjblpwWTJWaFkyT
    ...: nZkVzUwTDNObGNuWnBZMlV0WVdOamIzVnVkQzV1WVcxbElqb2laR1ZtWVhWc2RDSXNJbXQxWW1WeWJtVjBaWE11YVc4dmMyVnlkbWxqWldGalkyOTFiblF2YzJWeWRtbGpaUzFoWTJOdmRXNTBMblZwWkNJNklqWXhNV1EwWVdZNExUUm1ZemN0TVRGbE
    ...: 9TMWhPVFF4TFRBNE1EQXlOekUxT0Rsak9DSXNJbk4xWWlJNkluTjVjM1JsYlRwelpYSjJhV05sWVdOamIzVnVkRHBrWldaaGRXeDBPbVJsWm1GMWJIUWlmUS5KNWh2TC1jMWtJbGFUdEEwMUROX1F6NGdBYkV0YkYyWnJIOUZXTGVaRElQcFBfYVFPdlZ
    ...: 6cGRLc0p0SUZ0LV9pOG1nVWdlcmI2emJaVXZ4SUYwaEVzR3pLQm16amZZUmdUTkRLX0pEWHZVWUFwc05QV2hYQkpjeFA4eWdUM05jVXp2YU1ybzZrZ3hfaEQzUkVHbkt0TUtpZjJ1UDFXQ0NGZUxyclVRU0F0ai1LSDRKOUdTSlZaRTBJaTF5Z3BYeUJ1
    ...: VWt1YnNuN3oxaFR0NTJ0TWtGUW1XWW5pNnVLaFFxcHlBT0d6ZWkxcGc1Z1VqNi1vaTZlN3UxaDlZcWRqMGRwejZpWTRDQmpBMEV0ODIweWVkdjl4elJjeUZXOFd2M1IwbmxKbEQxaGJLS2swaDVrMGlWMHVEZVhQMDM0TlhWWTVwSXIxcFlYVDh4N3R5T
    ...: XEtYkE3V0E=').split(b'.')

In [21]: a, b, c = b64decode(a), b64decode(b+b'=='), b64decode(c)

In [22]: print(json.loads(a))
{'alg': 'RS256', 'kid': ''}

In [23]: print(json.loads(b))
{'iss': 'kubernetes/serviceaccount', 'kubernetes.io/serviceaccount/namespace': 'default', 'kubernetes.io/serviceaccount/secret.name': 'default-token-f4tfv', 'kubernetes.io/serviceaccount/service-account.name': 'default', 'kubernetes.io/serviceaccount/service-account.uid': '611d4af8-4fc7-11e9-a941-0800271589c8', 'sub': 'system:serviceaccount:default:default'}

In [24]: c
Out[24]: b'\'\x98o-\xcdd"V\x93\xb4\r5\x0c\xd43\xe2\x00\x1b\x12\xd6\xc5\xd9\x9a\xc7\xf4U\x8by\x90\xc8>\x93\xda@\xeb\xd5\xce\x97J\xb0\x9bH\x16\xd8\xbc\x9a\x05 z\xb6\xfa\xcd\xb6T\xbf\x12\x05\xd2\x11,\x1b2\x81\x9b8\xdfa\x18\x1342\x89\r{\xd4`\nl4\xf5\xa1\\\x12\\\xc4\xff2\x81=\xcdqL\xefh\xca\xe8\xeaH1\x84=\xd1\x10i\xca\xb4\xc2\xa2\x7fk\x8f\xd5`\x82\x15\xe2\xeb\xadD\x12\x02\xd8\xca\x1f\x82}\x19"UdM\x08\x8b\\\xa0\xa5|\x81\xb9I.n\xc9\xfb\xcfXS\xb7\x9d\xad2AP\x99f\'\x8b\xab\x8a\x85\n\xa9\xc8\x03\x86\xcd\xe8\xb5\xa6\x0e`R>\xa8\x8b\xa7\xbb\xbbX}b\xa7c\xd1\xdas\xea&8\x08\x18\xc0\xd0K|\xdbL\x9ev\xffq\xcd\x172\x15o\x16\xbftt\x9eRe\x0fX[(\xa94\x87\x994\x89].\r\xe5\xcf\xd3~\r]V9\xa4\x8a\xf5\xa5\x85\xd3\xf3\x1e\xed\xc8\xca\x9b\x03\xb5\x80'
```
