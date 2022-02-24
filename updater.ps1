#IP address of T-Rex Miner
$ipaddress=""
#password used to access T-Rex Miner via http
$password=""

$ipaddress = Read-host "Enter IP Address"
$password = Read-host "Enter password"

#pull numbers from whattomine
$alephium = wget "https://whattomine.com/coins/349.json?hr=1.0&p=0.0&fee=0.0&cost=0.0&hcost=0.0&span_br=1h&span_d=24" | ConvertFrom-Json
$etherium = wget "https://whattomine.com/coins/151.json?hr=1000.0&p=0.0&fee=0.0&cost=0.0&hcost=0.0&span_br=1h&span_d=24" | ConvertFrom-Json

$ALPHppMH = ([decimal]$alephium.profit.Replace("$",""))/1000
$ETHppMH = ([decimal]$etherium.profit.Replace("$",""))/1000

#Login to T-Rex Miner
Write-Host "Logging into T-Rex API"
$sid = Invoke-WebRequest -Uri "http://$ipaddress`:4067/login?password=$password" | ConvertFrom-Json
#updates profit-per-mh
Write-Host "Updating price per MH"
$trash=Invoke-RestMethod -Method POST -Body "{`"profit_per_mh`":`"$ETHppMH`:$ALPHppMH`",`"sid`":`"$($sid.sid)`"}" -Uri "http://$ipaddress`:4067/config"
#restart T-Rex Miner (unfortunately required to update)
Write-Host "Restarting T-Rex Miner"
$trash=Invoke-WebRequest -Uri "http://$ipaddress`:4067/control?command=restart&sid=$($sid.sid)"
#logs out
Write-Host "Logging out"
$trash=Invoke-WebRequest -Uri "http://$ipaddress`:4067/logout?sid=$($sid.sid)"
pause
