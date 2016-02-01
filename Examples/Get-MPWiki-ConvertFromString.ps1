#requires -version 5.0

# define a sample-driven template describing the data structure:
$template = @'
<TD class=sortable><A href="{url*:http://www.microsoft.com/en-us/download/details.aspx?id=23024}" target=_blank>{name:Application Virtualization 4.5 (APP-V)}</A></TD>
<TD class=ra>{version:4.5.0.0}</TD>
<TD class=ra>{date:10/09/2008}</TD></TR>
<TD class=sortable><A href="{url*:http://www.microsoft.com/en-us/download/details.aspx?id=38418}" target=_blank>{name:Application Virtualization Server 5.0 (APP-V)}</A></TD>
<TD class=ra>{version:1.0}</TD>
<TD class=ra>{date:04/12/2013}</TD></TR>
<TD class=sortable><A href="{url*:https://www.microsoft.com/en-in/download/details.aspx?id=45884}" target=_blank>{name:BizTalk Server 2013 R2}</A><BR></TD>
<TD class=ra>{version:7.0.2008.0}<BR></TD>
<TD class=ra>{date:02/19/2015}<BR></TD></TR>
<TD class=sortable><A href="{url*:http://www.microsoft.com/en-us/download/details.aspx?id=11872}" target=_blank>{name:Dynamics AX 2009}</A></TD>
<TD class=ra>{version:1.0.0.50}</TD>
<TD class=ra>{date:06/16/2009}</TD></TR>
<TD class=sortable><A href="{url*:http://www.microsoft.com/en-us/download/details.aspx?id=46832}">{name:Windows Server Storage Spaces 2012 R2}</A></TD>
<TD class=ra>
<P>{version:1.1.253.0}</P></TD>
<TD class=ra>
<P>{date:04/27/2015}</P></TD></TR>
<TD class=sortable><A href="{url*:http://www.microsoft.com/en-us/download/details.aspx?id=49101}" target=_blank>{name:Windows Azure Pack (WAP) Update 1}</A><BR></TD>
<TD class=ra>{version:1.0.0.466} <BR></TD>
<TD class=ra>{date:09/16/2015} <BR></TD></TR>
'@

#Load data from MP Wiki website
$url = 'http://social.technet.microsoft.com/wiki/contents/articles/16174.microsoft-management-packs.aspx'
$html = ((Invoke-WebRequest $url).AllElements| Where-Object {$_.tagname -eq 'tbody'}).innerhtml
$html |  ConvertFrom-String -TemplateContent $template -ErrorAction SilentlyContinue |
   select name,url,version, @{L='date';E={[datetime]$_.date}} |
        Out-GridView -Title 'Microsoft Management Packs Overview' -PassThru