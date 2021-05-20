# Azure Pipelines IaC

## Project 作成
Azure DevOps でプロジェクトを作成。

## master ブランチに Push

```Powershell
git add .
git commit -m "first commit"
git push -u origin master
```

![alt text](./images/devops-repos.png)

## Pipeline の設定
[Set up build] > [Starter pipeline] > [Save and run] を選択し、Pipeline を実行する。

![alt text](./images/devops-running-jobs.png)

## リソースの作成
ARM Template を活用して、リソースを作成する。

```
trigger:
- azure-pipelines

pool:
  vmImage: ubuntu-latest

steps:    
- task: AzureResourceManagerTemplateDeployment@3
  inputs:
    deploymentScope: 'Resource Group'
    azureResourceManagerConnection: 'Azure Internal Access Program WW Inside Sales_Subscription Cont(f0efe35e-b5a6-42ef-9a7a-e11fa99a1f8f)'
    subscriptionId: 'f0efe35e-b5a6-42ef-9a7a-e11fa99a1f8f'
    action: 'Create Or Update Resource Group'
    resourceGroupName: 'koheisaitolearn'
    location: 'West US'
    templateLocation: 'Linked artifact'
    csmFile: 'templates/azuredeploy.json'
    csmParametersFile: 'parameters/azuredeploy.json'
    deploymentMode: 'Incremental' 
```

## テスト実行
設定値が正しいか確認するため、Pester を活用してテストを実行する。

### Service Principal の作成
テスト実行用アカウントとして、Service Principal を作成する。

```powershell
> az ad sp create-for-rbac -n "azure-pipelines-cicd" --role contributor
{
  "appId": "xxxxx-xxxxx-xxxxx-xxxxx-xxxxx",
  "displayName": "azure-pipelines-cicd",
  "name": "http://azure-pipelines-cicd",
  "password": "xxxxxxxxxxxxxxxxxxxxxxxxx",
  "tenant": "xxxxxxxxxx-xxxxx-xxxxx-xxxxx-xxxxx"
}
```
<b>※一度しか出力されないため、メモを取ること。</b>

### Service Connection の作成
Service Principal を Pipeline から使用するため、Service Connection を作成する。<br>
[Project settings] > [Service connections] > [New service connection] を選択する。<br>
[Azure Resource Manager] > [Service principal (manual)] を選択し、上記で出力された値を入力する。

### Secret 情報を Variables に登録
テストファイルで Service Principal を使用するため、Service Principal の各種値を環境変数に登録する。

 - APPLICATIONIDURL
 - CLIENTSECRET
 - SUBSCRIPTIONID
 - TENANTID

これらは、テストファイルの中で下記のように参照される。

```
$tenantId = $env:TENANTID
$subscriptionId = $env:SUBSCRIPTIONID
$resourceGroupName = "koheisaitolearn"
$clientSecret = $clientSecret_s
$applicationIdUrl = $env:APPLICATIONIDURL

Describe "テストのテスト" {

    BeforeAll {
        # Login as a Service Principal
        az login --service-principal -u $applicationIdUrl -p $clientSecret --tenant $tenantId
        az account set --subscription $subscriptionId
    }

    ・・・
    
```