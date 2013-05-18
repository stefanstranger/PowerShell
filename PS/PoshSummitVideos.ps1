#$url = "http://gdata.youtube.com/feeds/api/users/UCX27-k3xeNSgXVklCx-dnXQ/uploads"

irm http://tinyurl.com/pshsummit | select @{L="Link";E={$_.id}}, @{L="Title";E={$_.title."#text"}}, @{L="ViewCount";E={($_.Statistics).ViewCount}}

Invoke-RestMethod -uri $url | select @{L="Link";E={$_.id}}, @{L="Title";E={$_.title."#text"}}, @{L="Statistics";E={[System.Double]::Parse($_.statistics.viewcount)}} | sort statistics | out-chart -ChartType bar -GroupAxis Title -DataAxis Statistics
