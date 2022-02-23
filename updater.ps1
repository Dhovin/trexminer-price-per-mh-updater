#IP address of T-Rex Miner
$ipaddress=""
#password used to access T-Rex Miner via http
$password=""

$ipaddress = Read-host "Enter IP Address"
$password = Read-host "Enter password"

#pull numbers from whattomine
$alephium = wget "https://whattomine.com/coins/349.json?hr=1.0&p=0.0&fee=0.0&cost=0.0&hcost=0.0&span_br=1h&span_d=24" | ConvertFrom-Json
$etherium = wget "https://whattomine.com/coins/151.json?hr=1000.0&p=0.0&fee=0.0&cost=0.0&hcost=0.0&span_br=1h&span_d=24" | ConvertFrom-Json

$ALPHcoefficient = ([decimal]$alephium.profit.Replace("$",""))/1000
$ETHcoefficient = ([decimal]$etherium.profit.Replace("$",""))/1000

#Login to T-Rex Miner
$sid = Invoke-WebRequest -Uri "http://$ipaddress`:4067/login?password=$password" | ConvertFrom-Json
#updates profit-per-mh
Invoke-RestMethod -Method POST -Body "{`"profit_per_mh`":`"$ETHcoefficient`:$ALPHcoefficient`",`"sid`":`"$($sid.sid)`"}" -Uri "http://192.168.10.49:4067/config"
#logs out 
Invoke-WebRequest -Uri "http://$ipaddress`:4067/logout?sid=$($sid.sid)"
pause