:global url
:global id
:global sn

:local uri
:local u
:local online 0
:set uri ("$url" ."/mkt_au.php?id=$id&sn=$sn")
foreach u in [/ip hotspot active find] do={
:set uri ("$uri" ."&name[]="."$[/ip hotspot active get value-name=user number=$u]")
:set uri ("$uri" ."&bytesin[]="."$[/ip hotspot active get value-name=bytes-in number=$u]")
:set uri ("$uri" ."&bytesout[]="."$[/ip hotspot active get value-name=bytes-out number=$u]")
:set online ($online + 1)
}
:set uri ("$uri&online=$online")

:put $uri
 
:do {
/tool fetch url="$uri" mode=http keep-result=no
:delay 1
} on-error={ 
:log error "script error active user can not fetch !!!"
}
