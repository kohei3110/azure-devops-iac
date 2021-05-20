foreach($arg in $args) {
    Write-Output "Retrieved input: $arg"
    $armOutputObj = $arg | ConvertFrom-Json

    $armOutputObj.PSObject.Properties | ForEach-Object {
        $type = ($_.value.type).ToLower()
        $keyname = "Output_"+$_.name
        $value = $_.value.value

        if ($type -eq "securestring") {
            Write-Output "##vso[task.setvariable variable=$keyname;isSecret=true]$value"
            Write-Output "Added variable '$keyname' ('$type')"
        } elseif ($type -eq "string") {
            Write-Output "##vso[task.setvariable variable=$keyname]$value"
            Write-Output "Added variable '$keyname' ('$type') with value '$value'"
        } else {
            Throw "Type '$type' is not supported for '$keyname'"
        }
    }
}