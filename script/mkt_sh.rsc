:global url
:global id
:global sn
:global date [/system clock get date]
:global time [/system clock get time]

:local uptime [/system resource get uptime]
:local freememory [/system resource get free-memory]
:local freehddspace [/system resource get free-hdd-space]
:local cpuload [/system resource get cpu-load]
:local badblocks [/system resource get bad-blocks]
:local voltage [/system health get voltage]
:local temperature [/system health get temperature]

:local uri

:set uri ("$url" ."/mkt_sh.php?id=$id&sn=$sn&date=$date&time=$time&uptime=$uptime&freememory=$freememory&freehddspace=$freehddspace&cpuload=$cpuload&badblocks=$badblocks&voltage=$voltage&temperature=$temperature")

#:put $uri
 
:do {
/tool fetch url="$uri" mode=http keep-result=no
:delay 1
} on-error={ 
:log error "script error system health can not fetch !!!"
}