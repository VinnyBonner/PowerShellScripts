
## Note: You will need to have Az Modules already installed and already connected to Azure using Connect-AzAccount prior to running the script.
## https://learn.microsoft.com/en-us/powershell/module/az.accounts/connect-azaccount?view=azps-9.1.0#examples

## Subscription Array for use if multiple subscriptions desired
$subscriptions = @("########-####-####-####-############")

## Empty Array 
$functionAppsList = @()

## Loop over each Subscription
ForEach($subscription in $subscriptions) { 

    ## Get an array of all Azure Function Apps - https://learn.microsoft.com/en-us/powershell/module/az.functions/get-azfunctionapp?view=azps-9.1.0#example-4-get-function-apps-for-the-given-subscriptions
    $functionApps = Get-AzFunctionApp -SubscriptionId $subscription 

    ## Loop over each Function App in the Subscription
    ForEach($functionApp in $FunctionApps) {

        ## Get a list of all the Function App Settings - https://learn.microsoft.com/en-us/powershell/module/az.functions/get-azfunctionappsetting?view=azps-9.1.0#example-1-get-the-app-settings-of-a-function-app
        $tempFuncApp = Get-AzFunctionAppSetting -Name $functionApp.Name -ResourceGroupName $functionApp.ResourceGroupName

        ## Add a new object to the empty array containing relevent info
        $functionAppsList += @{
            AppName = $functionApp.Name
            ResourceGroupName = $functionapp.ResourceGroupName
            SubscriptionId = $functionApp.SubscriptionId
            FunctionsWorkerRuntime = $tempFuncApp.FUNCTIONS_WORKER_RUNTIME
            FunctionsExtensionVersion = $tempFuncApp.FUNCTIONS_EXTENSION_VERSION
            LinuxFxVerison = $functionApp.Config.LinuxFxVersion
            NetFrameworkVersion = $functionApp.SiteConfig.NetFrameworkVersion
        }
    }
} 

## Write out the array of objects
ForEach ($site in $functionAppsList) {
    Write-Output $site
    Write-Output ""
}
