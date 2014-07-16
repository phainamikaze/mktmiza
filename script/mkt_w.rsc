:global url
:global id
:global sn
:global walarm 1
:global wanstatuslist
:global waniplist
:global wan

:local uri
:local alarmuri
:local alarm 0
:local w
:local wip ""
:local wstatus ""
:local ip
:local tmp

:local urlcheck "'',http://myip.dnsomatic.com,http://myip.dnsdynamic.com,http://myip.dtdns.com,http://ip.3322.org"
:set urlcheck [:toarray $urlcheck]
:set uri ("$url" ."/mkt_w.php?id=$id&sn=$sn&wan=$wan")
:set alarmuri ("$url" ."/mkt_walarm.php?id=$id&sn=$sn")
:for w from=1 to=$wan do={
  :do {
  :local tmp ($urlcheck->$w."/index.php");
  /tool fetch url=$tmp mode=http
  :delay 1

  :local result [/file get index.php contents]
  :local iend [:find $result "\n" -1]
  :if ([:typeof $iend]="nil") do={ :set iend 16}
  :set ip [:pick $result 0 $iend]
  
  :set uri ("$uri" ."&wip[]="."$ip"."&wstatus[]="."up")
  :set wip ("$wip".","."$ip")
  :set wstatus ("$wstatus".","."up")

  :if ("up" != $wanstatuslist->($w-1)) do={
    :log info "Wan$w UP!!"
    :set alarmuri ("$alarmuri" ."&link[]=$w&wstatus[]="."up")
    :set alarm 1
  }
  } on-error={ 
  
  :set ip ($waniplist->($w-1))
  :set uri ("$uri" ."&wip[]="."$ip"."&wstatus[]="."down")
  :set wip ("$wip".","."$ip")
  :set wstatus ("$wstatus".","."down")

  :if ("down" != $wanstatuslist->($w-1)) do={
    :log error "Wan$w down!!"
    :set alarmuri ("$alarmuri" ."&link[]=$w&wstatus[]="."down")
    :set alarm 1
  }


  }
}

:global waniplist [:toarray $wip]
:global wanstatuslist [:toarray $wstatus]


#:put $uri
:put $alarmuri 

:if (walarm=1) do={
  :if (alarm=1) do={
    :do {
      /tool fetch url="$alarmuri" mode=http keep-result=no;
      :delay 1
    } on-error={ 
      :log error "script error wan alarm can not fetch !!!"
    }
  }
}

:do {
/tool fetch url="$uri" mode=http keep-result=no
:delay 1
} on-error={ 
:log error "script error wan can not fetch !!!"
}
