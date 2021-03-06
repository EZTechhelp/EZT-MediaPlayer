#Get public and private function definition files.
#$global:thisApp = $thisApp
$Public = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -Exclude "*.Tests.*" -Recurse -ErrorAction SilentlyContinue )
#$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -Exclude "*.Tests.*" -Recurse -ErrorAction SilentlyContinue )

#Dot source the files
Foreach ($import in @($Public)) {
  Try {
    . $import.fullname
  } Catch {
    Write-Error -Message "Failed to import function $($import.fullname): $_"
  }
}

Export-ModuleMember -Function $Public.Basename