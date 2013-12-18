$trackingnumber = read-host "Enter DHL Tracking number"

$url = "http://www.dhl-usa.com/content/us/en/express/tracking.shtml?brand=DHL&AWB=$trackingnumber"

$result = Invoke-WebRequest -Uri $url

$result.ParsedHtml.getElementsByTagName("table") | select -expandProperty OuterText