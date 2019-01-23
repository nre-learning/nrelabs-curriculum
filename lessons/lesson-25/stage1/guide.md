## Automating with JET

**Contributed by: [@valjeanchan](https://github.com/valjeanchan) and [@jnpr-raylam](https://github.com/jnpr-raylam)**

---

### Chapter 1 - JET rpc/notification configuration

[Placeholder for JET introduction]

[Placeholder for describing required procedures to enable rpc/notification services]

Apply below configuration to enable notification and GRPC request-response service on vQFX.

_Shall we explain the hidden command clear-text here?_

```
configure
set system services extension-service notification port 1883 allow-clients address 0.0.0.0/0
set system services extension-service request-response grpc clear-text port 32767
commit and-quit
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 0)">Run this snippet</button>

_Seems there is no operational commands to verify the rpc/notification status, so just verify the listening port_

We can check the listening port to verify the rpc and notification service are enabled.

```
show system connections | match LISTEN | match "\.1883|\.32767"
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 1)">Run this snippet</button>

> Expected output (remove later)
> 
> tcp4       0      0  *.1883                                        *.*                                           LISTEN
> tcp46      0      0  *.32767                                       *.*                                           LISTEN

