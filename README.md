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