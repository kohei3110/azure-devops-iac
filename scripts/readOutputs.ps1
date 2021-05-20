param(
    [Parameter(Mandatory)]
    [string]$clientSecret_s
)

$tenantId = $env:TENANTID
$subscriptionId = $env:SUBSCRIPTIONID
$resourceGroupName = "koheisaitolearn"
$clientSecret = $clientSecret_s

Describe "テストのテスト" {

    BeforeAll {
        # Login as a Service Principal
        az login --service-principal -u $applicationIdUrl -p $clientSecret --tenant $tenantId
        az account set --subscription $subscriptionId
    }

    Context "テスト" {
        It "テスト1" {
            $resourceProviderName_t = "Microsoft.Network/networkInterfaces"
            $resourceName_t         = "demoVMNic"
            $resourceId_t           = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/$resourceProviderName_t/$resourceName_t"

            $value_e     = "demoVMNic"
            $rawResponse = az resource show --ids $resourceId_t | ConvertFrom-Json
            $currentStatus = $rawResponse.properties

        }
    }
}