:global url
:global id
:global sn
:global nalarm 1
:global netwatchlist

:local uri
:local alarmuri
:local alarm 0
:local h
:local hostcount 0
:local hhost
:local hstatus

:local hstatuslist ""

:set uri ("$url" ."/mkt_n.php?id=$id&sn=$sn")
:set alarmuri ("$url" ."/mkt_nalarm.php?id=$id&sn=$sn")
:foreach h in [/tool netwatch find] do={

  :set hhost [/tool netwatch get value-name=host number=$h]
  :set hstatus [/tool netwatch get value-name=status number=$h]
  :set uri ("$uri" ."&host[]="."$hhost")
  :set uri ("$uri" ."&status[]="."$hstatus")
  :set uri ("$uri" ."&comment[]="."$[/tool netwatch get value-name=comment number=$h]")
  


  :set hstatuslist ("$hstatuslist,$hstatus")
  :if ($hstatus != $netwatchlist->$hostcount) do={
    :log info ("AP $hhost $hstatus")
    :set alarmuri ("$alarmuri" ."&ahost[]=$hhost&astatus[]=$hstatus")
    :set alarm 1
  }

:set hostcount ($hostcount + 1)
}
:set uri ("$uri&hostcount=$hostcount")


:global netwatchlist [:toarray $hstatuslist]

#:put $uri
#:put $alarmuri 

:if (nalarm=1) do={
  :if (alarm=1) do={
    :do {
      /tool fetch url="$alarmuri" mode=http keep-result=no;
      :delay 1
    } on-error={ 
      :log error "script error netwatch alarm can not fetch !!!"
    }
  }
}

:do {
/tool fetch url="$uri" mode=http keep-result=no
:delay 1
} on-error={ 
:log error "script error netwatch can not fetch !!!"
}
