#----------------- config variable---------------------------
:global url "http://www.yourdomain.com"
:global wan 2
#----------------- config variable---------------------------

:global id [/system identity get name]
:global sn [/system routerboard get serial-number]

:local totalmemory [/system resource get total-memory]
:local totalhddspace [/system resource get total-hdd-space]
:local cpufrequency [/system resource get cpu-frequency]
:local version [/system resource get version]
:local cpu [/system resource get cpu]
:local cpucount [/system resource get cpu-count]
:local architecturename [/system resource get architecture-name]
:local boardname [/system resource get  board-name]
:local platform [/system resource get platform]
:local softwareid [/system license get software-id]


:local uri

:set uri ("$url" ."/mkt_si.php?id=$id&sn=$sn&totalmemory=$totalmemory&totalhddspace=$totalhddspace&cpufrequency=$cpufrequency&version=$version&cpucount=$cpucount&architecturename=$architecturename&boardname=$boardname&platform=$platform&softwareid=$softwareid&cpu=$cpu")

#:put $uri
 
:do {
/tool fetch url="$uri" mode=http keep-result=no
:delay 1
} on-error={ 
:log error "script error system info can not fetch !!!"
}
