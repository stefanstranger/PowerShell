<#
    Goal: using Twitter API parameters like screen_name to retrieve tweets from a specific user.
    More info: https://dev.twitter.com/rest/reference/get/statuses/user_timeline
    Issue: Error "Could not authenticate you" when trying to add parameters to the HttpEndpoint.

    Remarks:
    Made a change to the Get-OAuthAuthorization function to be able to use the GET method instead of POST method.

#>


function Get-OAuthAuthorization {
	[CmdletBinding(DefaultParameterSetName = 'None')]
	[OutputType('System.Management.Automation.PSCustomObject')]
	param (
		[Parameter(Mandatory)]
		[string]$HttpEndPoint,
		[Parameter(Mandatory, ParameterSetName = 'NewTweet')]
		[string]$TweetMessage,
		[Parameter(Mandatory, ParameterSetName = 'DM')]
		[string]$DmMessage,
		[Parameter(Mandatory, ParameterSetName = 'DM')]
		[string]$Username
	)
	
	begin {
		$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
		Set-StrictMode -Version Latest
		try {
			[Reflection.Assembly]::LoadWithPartialName("System.Security") | Out-Null
			[Reflection.Assembly]::LoadWithPartialName("System.Net") | Out-Null
		} catch {
			Write-Error $_.Exception.Message
		}

    if(!(Test-Path -Path HKCU:\Software\MyTwitter))
    {
      #Call Set-OAuthorization function
      Set-OAuthAuthorization
    }
    else
    {
        Write-Verbose "Retrieving Twitter Application settings from registry HKCU:\Software\MyTwitter"
        $global:APIKey = (Get-Item HKCU:\Software\MyTwitter).getvalue("APIKey")
        $global:APISecret = (Get-Item HKCU:\Software\MyTwitter).getvalue("APISecret")
        $global:AccessToken = (Get-Item HKCU:\Software\MyTwitter).getvalue("AccessToken")
        $global:AccessTokenSecret = (Get-Item HKCU:\Software\MyTwitter).getvalue("AccessTokenSecret")

    }
	}
	
	process {
		try {
			## Generate a random 32-byte string. I'm using the current time (in seconds) and appending 5 chars to the end to get to 32 bytes
			## Base64 allows for an '=' but Twitter does not.  If this is found, replace it with some alphanumeric character
			$OauthNonce = [System.Convert]::ToBase64String(([System.Text.Encoding]::ASCII.GetBytes("$([System.DateTime]::Now.Ticks.ToString())12345"))).Replace('=', 'g')
			Write-Verbose "Generated Oauth none string '$OauthNonce'"
			
			## Find the total seconds since 1/1/1970 (epoch time)
			$EpochTimeNow = [System.DateTime]::UtcNow - [System.DateTime]::ParseExact("01/01/1970", "dd/MM/yyyy", $null)
			Write-Verbose "Generated epoch time '$EpochTimeNow'"
			$OauthTimestamp = [System.Convert]::ToInt64($EpochTimeNow.TotalSeconds).ToString();
			Write-Verbose "Generated Oauth timestamp '$OauthTimestamp'"
			
			## Build the signature
			$SignatureBase = "$([System.Uri]::EscapeDataString($HttpEndPoint))&"
			$SignatureParams = @{
				'oauth_consumer_key' = $ApiKey;
				'oauth_nonce' = $OauthNonce;
				'oauth_signature_method' = 'HMAC-SHA1';
				'oauth_timestamp' = $OauthTimestamp;
				'oauth_token' = $AccessToken;
				'oauth_version' = '1.0';
			}
			if ($TweetMessage) {
				$SignatureParams.status = $TweetMessage
			} elseif ($DmMessage) {
				$SignatureParams.screen_name = $Username
				$SignatureParams.text = $DmMessage
			}

		
			## Create a string called $SignatureBase that joins all URL encoded 'Key=Value' elements with a &
			## Remove the URL encoded & at the end and prepend the necessary 'POST&' verb to the front
			$SignatureParams.GetEnumerator() | sort name | foreach { $SignatureBase += [System.Uri]::EscapeDataString("$($_.Key)=$($_.Value)&") }
			$SignatureBase = $SignatureBase.TrimEnd('%26')
			$SignatureBase = 'GET&' + $SignatureBase
      #$SignatureBase = 'POST&' + $SignatureBase
			Write-Verbose "Base signature generated '$SignatureBase'"
			
			## Create the hashed string from the base signature
			$SignatureKey = [System.Uri]::EscapeDataString($ApiSecret) + "&" + [System.Uri]::EscapeDataString($AccessTokenSecret);
			
			$hmacsha1 = new-object System.Security.Cryptography.HMACSHA1;
			$hmacsha1.Key = [System.Text.Encoding]::ASCII.GetBytes($SignatureKey);
			$OauthSignature = [System.Convert]::ToBase64String($hmacsha1.ComputeHash([System.Text.Encoding]::ASCII.GetBytes($SignatureBase)));
			Write-Verbose "Using signature '$OauthSignature'"
			
			## Build the authorization headers using most of the signature headers elements.  This is joining all of the 'Key=Value' elements again
			## and only URL encoding the Values this time while including non-URL encoded double quotes around each value
			$AuthorizationParams = $SignatureParams
			$AuthorizationParams.Add('oauth_signature', $OauthSignature)
			
			## Remove any API call-specific params from the authorization params
			$AuthorizationParams.Remove('status')
			$AuthorizationParams.Remove('text')
			$AuthorizationParams.Remove('screen_name')
			
			$AuthorizationString = 'OAuth '
			$AuthorizationParams.GetEnumerator() | sort name | foreach { $AuthorizationString += $_.Key + '="' + [System.Uri]::EscapeDataString($_.Value) + '", ' }
			$AuthorizationString = $AuthorizationString.TrimEnd(', ')
			Write-Verbose "Using authorization string '$AuthorizationString'"
			
			$AuthorizationString
			
		} catch {
			Write-Error $_.Exception.Message
		}
	}
}


Function Get-TweetTimeline
{

  [CmdletBinding()]
	[OutputType('System.Management.Automation.PSCustomObject')]
	param (
		[string[]]$User
	)

  process 
  {
    $HttpEndPoint = 'https://api.twitter.com/1.1/statuses/user_timeline.json' #working
    $HttpEndPoint = "http://api.twitter.com/1.1/statuses/user_timeline.json?include_entities=true&include_rts=true&exclude_replies=true&count=20&screen_name=$user" #notworking
    Write-Verbose $HttpEndPoint	
    $AuthorizationString = Get-OAuthAuthorization -HttpEndPoint $HttpEndPoint -Verbose
    $Timeline = Invoke-RestMethod -URI $HttpEndPoint -Method Get -Headers @{ 'Authorization' = $AuthorizationString } -ContentType "application/x-www-form-urlencoded"
	$Timeline | Select Id, created_at, text, retweet_count, favorite_count
	}



}
 
Get-TweetTimeLine -User 'twitterapi' -Verbose