<#
    .SYNOPSIS
    Creates a new application
    .DESCRIPTION
    Creates a new application and saves it locally (file) so you may re-use it without setting it every time
    .EXAMPLE
    PS C:\> New-SpotifyApplication -ClientId 'ClientIdOfSpotifyApplication' -ClientSecret 'ClientSecretOfSpotifyApplication'
    Creates the default application json in the store, named default.json and containing default as Name, ClientId and ClientSecret.
    .EXAMPLE
    PS C:\> New-SpotifyApplication -Name 'dev' -ClientId 'ClientIdOfSpotifyApplication' -ClientSecret 'ClientSecretOfSpotifyApplication'
    Creates a new application json in the store, named dev.json and containing Name, ClientId and ClientSecret.
    .PARAMETER Name
    Specifies the name of the application you want to save ('default' if not specified).
    .PARAMETER ClientId
    Specifies the Client ID of the Spotify Application
    .PARAMETER ClientSecret
    Specifies the Client Secret of the Spotify Application
    .PARAMETER RedirectUri
    Specifies the Redirect Uri of the Spotify Application
#>
function New-SpotifyApplication {

  param (
    [String]
    $Name = 'default',

    [Parameter(Mandatory)]
    [String]
    $ClientId,

    [Parameter(Mandatory)]
    [String]
    $ClientSecret,

    [String]
    $RedirectUri = 'http://localhost:8080/spotishell'
  )

  #$StorePath = Get-StorePath

  <#  if (!(Test-Path -Path $StorePath)) {

      # There is no Spotishell store, let's try to make one.
      try {
      write-host "Attempting to create Spotishell store at $StorePath"
      New-Item -Path $StorePath -ItemType Directory -ErrorAction Stop | Out-Null
      write-host "Successfully created Spotishell store at $StorePath"
      }
      catch {
      write-host "Failed attempting to create Spotishell store at $StorePath : $($PSItem[0].ToString())"
      }
      }
      else {
      write-host "Spotishell store exists at $StorePath"
  }#>

  # Construct filepath
  #$ApplicationFilePath = $StorePath + $Name + ".json"

  <#  if (Test-Path -Path $ApplicationFilePath -PathType Leaf) {
      write-host 'The specified Application already exists'
  }#>

  if($RedirectUri -and $Name -and $ClientId -and $ClientSecret){
    # Assemble Application        
    $Application =  @{
      Name         = $Name
      ClientId     = $ClientId
      ClientSecret = $ClientSecret
      RedirectUri  = $RedirectUri
    }
    # Try to save application to file.
    try {
      write-ezlogs ">>>> Attempting to save application to SecretStore $Name" -showtime
      try{
        Set-SecretStoreConfiguration -Scope CurrentUser -Authentication None -Interaction None -Confirm:$false -password:$($ClientSecret | ConvertTo-SecureString -AsPlainText -Force)
        $secretstore = Get-SecretVault -Name $Name -ErrorAction SilentlyContinue
        if(!$secretstore){
          Register-SecretVault -Name $Name -ModuleName Microsoft.PowerShell.SecretStore -DefaultVault
          $secretstore = $Name
        }else{
          $secretstore = $secretstore.name
        }                  
        Set-Secret -Name SpotyClientId -Secret $ClientId -Vault $secretstore
        Set-Secret -Name SpotyClientSecret -Secret $ClientSecret -Vault $secretstore
        Set-Secret -Name SpotyRedirectUri -Secret $RedirectUri -Vault $secretstore
      }catch{
        write-ezlogs "An exception occurred when setting or configuring the secret store $Name" -CatchError $_ -enablelogs           
      }    
      #ConvertTo-Json -InputObject $Application | Set-Content -Path $ApplicationFilePath
      #write-host "Successfully saved application to $ApplicationFilePath"
      #Write-Host "Don't forget to setup a Redirect URIs on your Spotify Application : $($Application.RedirectUri)" -ForegroundColor Black -BackgroundColor Green
      return $Application
    }
    catch {
      write-ezlogs "Failed creating SecretStore $Name : $($PSItem[0].ToString())" -showtime -catcherror $_
    }
  }else{
    write-ezlogs "Cannot create new Spotify Application, must provide values for RedirectUri, Name, ClientId and ClientSecret parameters" -showtime -warning
  }
}