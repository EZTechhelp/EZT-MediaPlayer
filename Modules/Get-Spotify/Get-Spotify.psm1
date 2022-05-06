﻿<#
    .Name
    Get-Spotify

    .Version 
    0.1.0

    .SYNOPSIS
    Retrieves spotify tracks, albums, playlists..etc 

    .DESCRIPTION
       
    .Configurable Variables

    .Requirements
    - Powershell v3.0 or higher
    - Module designed for EZT-MediaPlayer

    .OUTPUTS
    System.Management.Automation.PSObject

    .Author
    EZTechhelp - https://www.eztechhelp.com

    .NOTES

#>

#---------------------------------------------- 
#region Get-Spotify Function
#----------------------------------------------
function Get-Spotify
{
  Param (
    [string]$MediaName,
    [switch]$Import_Profile,
    $thisApp,
    $all_installed_apps,
    [switch]$Refresh_Global_Profile,
    [switch]$Startup,
    [switch]$update_global,
    [switch]$Export_Profile,
    [switch]$Get_Playlists,
    [switch]$Export_AllMedia_Profile,
    [string]$Media_Profile_Directory,
    $Media_directories,
    [string]$PlayerData_Profile_Directory,
    [switch]$Verboselog
  )
  Add-Type -AssemblyName System.Web
  
  $illegal =[Regex]::Escape(-join [System.Io.Path]::GetInvalidPathChars())
  $pattern = "[™$illegal]"
  $pattern2 = "[:$illegal]"
  $AllSpotify_Media_Profile_Directory_Path = [System.IO.Path]::Combine($Media_Profile_Directory,"All-Spotify_MediaProfile")
  if (!(Test-path $AllSpotify_Media_Profile_Directory_Path)){
    $Null = New-Item -Path $AllSpotify_Media_Profile_Directory_Path -ItemType directory -Force
  } 
  $AllSpotify_Media_Profile_File_Path = [System.IO.Path]::Combine($AllSpotify_Media_Profile_Directory_Path,"All-Spotify_Media-Profile.xml")
  
  if($Import_Profile -and (Test-path $AllSpotify_Media_Profile_File_Path -PathType Leaf)){ 
    if($Verboselog){write-ezlogs " | Importing Spotify Media Profile: $AllSpotify_Media_Profile_File_Path" -showtime -enablelogs}
    $Available_Spotify_Media = Import-CliXml -Path $AllSpotify_Media_Profile_File_Path
    return $Available_Spotify_Media    
  }else{
    if($Verboselog){write-ezlogs " | Spotify Media Profile to import not found at $AllSpotify_Media_Profile_File_Path....Attempting to build new profile" -showtime -enablelogs}
  }  
  try{
    $Spotify_Auth_app = Get-SpotifyApplication -Name $thisApp.config.App_Name
  }catch{
    write-ezlogs "An exception occurred in Get-SpotifyApplication" -showtime -catcherror $_
  }   
  if(!$Spotify_Auth_app){
    write-ezlogs "Unable to get Spotify authentication, starting spotify authentication setup process" -showtime -warning  
    $APIXML = "$($thisApp.Config.Current_folder)\\Resources\API\Spotify-API-Config.xml"
    write-ezlogs "Importing API XML $APIXML" -showtime
    if([System.IO.File]::Exists($APIXML)){
      $Spotify_API = Import-Clixml $APIXML
      $client_ID = $Spotify_API.ClientID
      $client_secret = $Spotify_API.ClientSecret      
    }
    if($Spotify_API -and $client_ID -and $client_secret){
      write-ezlogs "Creating new Spotify Application '$($thisApp.config.App_Name)'" -showtime
      #$client_secret = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR((($Spotify_API.ClientSecret | ConvertTo-SecureString))))
      #$client_ID = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR((($Spotify_API.ClientID | ConvertTo-SecureString))))    
      New-SpotifyApplication -ClientId $client_ID -ClientSecret $client_secret -Name $thisApp.config.App_Name -RedirectUri $Spotify_API.Redirect_URLs
      $Spotify_Auth_app = Get-SpotifyApplication -Name $thisApp.config.App_Name
    }else{
      write-ezlogs "Unable to authenticate with Spotify API -- cannot continue" -showtime -warning
      return
    }
  }

  #$Uri = 'https://accounts.spotify.com/api/token'

  #Get Devices
  $Method = 'Get'
  #$Uri = 'https://api.spotify.com/v1/me/player/devices'
  #$devices = Invoke-WebRequest -Method $Method -Headers $Header -Uri $Uri | Convertfrom-json
  $devices = Get-AvailableDevices -ApplicationName $thisApp.config.App_Name
  if([System.IO.File]::Exists("$($env:APPDATA)\\Spotify\\Spotify.exe")){
    write-ezlogs ">>>> Checking for spotify at  $($env:APPDATA)\\Spotify\\Spotify.exe" -showtime 
    $Spotify_Install_Path = $("$($env:APPDATA)\\Spotify\\Spotify.exe") | Split-Path -parent
    $Spotify_Launch_Path = $("$($env:APPDATA)\\Spotify\\Spotify.exe")
  }

  if(!$Spotify_Install_Path){
    write-ezlogs ">>>> Could find Spotify, checking using Get-InstalledApplications" -showtime 
    $installed_apps = Get-InstalledApplications
    $Spotify_app = $installed_apps | where {$_.'Display Name' -eq 'Spotify'} | select -Unique
    $Spotify_Install_Path = $Spotify_app.'Install Location'
    $Spotify_Launch_Path = "$($Spotify_app.'Install Location')\\Spotify.exe"    
  }
  if([System.IO.File]::Exists($Spotify_Launch_Path)){
    write-ezlogs " | Spotify is installed at $Spotify_Launch_Path" -showtime 
    #$devices = Get-AvailableDevices   
  }else{
    write-ezlogs "Unable to find Spotify installed at path $Spotify_Launch_Path, installing via chocolatey" -showtime -Warning
    choco upgrade spotify -confirm -force --acceptlicense   
    $installed_apps = Get-InstalledApplications -verboselog
    $Spotify_app = $installed_apps | where {$_.'Display Name' -eq 'Spotify'} | select -Unique    
    $Spotify_Install_Path = $Spotify_app.'Install Location'
    $Spotify_Launch_Path = "$($Spotify_app.'Install Location')\\Spotify.exe"       
    if([System.IO.File]::Exists($Spotify_Launch_Path)){
      write-ezlogs "[SUCCESS] Spotify installed successfully" -showtime
      #Start $Spotify_Launch_Path -NoNewWindow 
      #wait for spotify to launch
      #start-sleep 2     
    }else{
      write-ezlogs "Spotify did not appear to install or unable to find, cannot continue" -showtime -warning
      return
    }
  }
  
  if($Spotify_Auth_app.token.access_token){
    #Get all playlists
    $Uri = 'https://api.spotify.com/v1/me/playlists?limit=50'
    $Spotify_Auth_app = Get-SpotifyApplication -Name $thisApp.config.App_Name
    $Method = 'Get'
    $Header = @{
      Authorization = 'Bearer ' + ($Spotify_Auth_app.token.access_token)
    }    
    $playlists = Invoke-WebRequest -Method $Method -Headers $Header -Uri $Uri -UseBasicParsing | Convertfrom-json   
    $Available_Spotify_Media = New-Object -TypeName 'System.Collections.ArrayList'
    #Get Playlists
    foreach($playlist in  $playlists.items)
    {
      #$Local_Media_output = New-Object -TypeName 'System.Collections.ArrayList'
      $name = $null
      $name = $playlist.name
      $url = $null
      $url = $playlist.uri
      $type = $null
      $type = $playlist.type
      $Tracks_Total = $null
      $Tracks_Total = $playlist.tracks.total
      $images = $null
      $images = $playlist.images
      $href = $Null
      $href = $playlist.href
      $playlist_id = $playlist.id
      $description = $playlist.description     
      write-ezlogs ">>>> Found Spotify Playlist $name" -showtime 
      write-ezlogs " | Type $($type)" -showtime
      write-ezlogs " | ID $($playlist_id)" -showtime
      write-ezlogs " | Track Total $($Tracks_Total)" -showtime
      if($url -and $Available_Spotify_Media.id -notcontains $playlist_id){
        $encodedTitle = $Null  
        $encodedBytes = [System.Text.Encoding]::UTF8.GetBytes("$($name)-SpotifyPlaylist")
        $encodedTitle = [System.Convert]::ToBase64String($encodedBytes)    
        $playlist_items = Get-PlaylistItems -id $playlist.id -ApplicationName $thisApp.config.App_Name
        if($playlist_items){
          $Playlist_tracks = $playlist_items.track
        }                 
        $newRow = New-Object PsObject -Property @{
          'name' = $name
          'id' = $playlist_id
          'encodedTitle' = $encodedTitle
          'url' = $url
          'type' = $type
          'Tracks_Total' = $Tracks_Total
          'description' = $description
          'images' = $images
          'Spotify_Install_Path' = $Spotify_Install_Path
          'Spotify_Launch_Path' = $Spotify_Launch_Path
          'web_url' = $href
          'PlayList_tracks' = $Playlist_tracks
          'Profile_Path' = $AllSpotify_Media_Profile_File_Path
          'Profile_Date_Added' = $(Get-Date -Format 'MM-dd-yyyy hh:mm:ss:tt')
          'Source' = 'SpotifyPlaylist'
        }
        $null = $Available_Spotify_Media.Add($newRow)           
      }else{
        write-ezlogs "Playlist ($name) with id $($playlist_id) already added" -showtime -enablelogs -warning
      }      
    }
    if($export_profile -and $AllSpotify_Media_Profile_File_Path -and $Available_Spotify_Media){
      $Available_Spotify_Media | Export-Clixml $AllSpotify_Media_Profile_File_Path -Force
    }
    if($Verboselog){write-ezlogs " | Number of Spotify Playlists found: $($Available_Spotify_Media.Count)" -showtime -enablelogs}
    return $Available_Spotify_Media   
   
  }else{
    write-ezlogs "Unable to Authenticate with Spotify, cannot continue" -showtime -warning
    return
  }
}
#---------------------------------------------- 
#endregion Get-Spotify Function
#----------------------------------------------
Export-ModuleMember -Function @('Get-Spotify')

