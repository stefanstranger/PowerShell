# Environment Configuration
# Environmental configuration defines the environment in which the configuration is deployed. 
# For instance, the node names and source file locations can change from a development to a test to a production environment
@{
    AllNodes = @(
        @{
            Nodename = "OM12R2DSC-DC"
            Role = "Primary DC"
            DomainName = "dsc.contoso.com"
            PSDscAllowPlainTextPassword = $true
            Users = @(
                @{
                    UserName = "om_saa"
                }
                @{
                    UserName = "om_das"
                }
                @{
                    UserName = "om_dra"
                }
                @{
                    UserName = "om_dwa"
                }
                @{
                    UserName = "installer"
                }

            )
            GroupName = "Domain Admins"
            Members = @('om_saa','om_das','om_dra','om_dwa','installer')
                        
        }
    )
}
