<#
    .Name
    Show-FeedbackForm 

    .Version 
    0.0.1

    .SYNOPSIS
    Displays a window to capture feedback/issues for submission to developer

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
# Mahapps Library
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') | out-null
Add-Type -AssemblyName WindowsFormsIntegration

function Close-FeedbackForm (){
  $hashfeedback.window.Dispatcher.Invoke("Normal",[action]{ $hashfeedback.window.close()})
  
}



#---------------------------------------------- 
#region Open-FileDialog Function
#----------------------------------------------
function Open-FileDialog
{
  param (
    [string]$Title = "Select file",
    [switch]$MultiSelect
  )  
  $AssemblyFullName = 'System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'
  $Assembly = [System.Reflection.Assembly]::Load($AssemblyFullName)
  $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
  $OpenFileDialog.AddExtension = $true
  #$OpenFileDialog.InitialDirectory = [environment]::getfolderpath('mydocuments')
  $OpenFileDialog.CheckFileExists = $true
  $OpenFileDialog.Multiselect = $MultiSelect
  $OpenFileDialog.Filter = "All Files (*.*)|*.*"
  $OpenFileDialog.CheckPathExists = $false
  $OpenFileDialog.Title = $Title
  $results = $OpenFileDialog.ShowDialog()
  if ($results -eq [System.Windows.Forms.DialogResult]::OK) 
  {
    Write-Output $OpenFileDialog.FileNames
  }
}
#---------------------------------------------- 
#endregion Open-FileDialog Function
#----------------------------------------------

#---------------------------------------------- 
#region Show-FeedbackForm Function
#----------------------------------------------
function Show-FeedbackForm{
  Param (
    [string]$PageTitle,
    [string]$Splash_More_Info,
    [string]$Logo,
    $thisScript,
    $thisApp,
    $synchash,
    [string]$all_games_profile_path,
    $Platform_launchers,
    $Save_GameSessions,
    $all_installed_games,
    [string]$Game_Profile_Directory,
    [string]$PlayerData_Profile_Directory,
    [switch]$Verboselog,
    [switch]$Export_Profile,
    [switch]$update_global
  )  

  $global:hashfeedback = [hashtable]::Synchronized(@{})  
  $illegal =[Regex]::Escape(-join [System.Io.Path]::GetInvalidPathChars())
  $pattern = "[™$illegal]"
  $pattern2 = "[:$illegal]"
  $pattern3 = "[`?�™$illegal]"     
  $feedback_Pwshell = {
    try{
      [void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
      Add-Type -AssemblyName PresentationFramework, System.Drawing, System.Windows.Forms, WindowsFormsIntegration
      $Current_Folder = $thisApp.Config.Current_Folder
      $Feedback_Window_XML = "$($Current_Folder)\\Views\\FeedbackForm.xaml"
      #theme
      $theme = [MahApps.Metro.Theming.MahAppsLibraryThemeProvider]::new()
      $themes = $theme.GetLibraryThemes()
      $themeManager = [ControlzEx.Theming.ThemeManager]::new()
      if($synchash.Window){
        $detectTheme = $thememanager.DetectTheme($synchash.Window)
        $newtheme = $themes | where {$_.Name -eq $detectTheme.Name}
      }elseif($_.Name -eq $thisApp.Config.Current_Theme.Name){
        $newtheme = $themes | where {$_.Name -eq $thisApp.Config.Current_Theme.Name}
      }  
           
      #import xml
      [xml]$xaml = [System.IO.File]::ReadAllText($Feedback_Window_XML).replace('Views/Styles.xaml',"$($Current_folder)`\Views`\Styles.xaml").Replace("{StaticResource MahApps.Brushes.Accent}","$($newTheme.PrimaryAccentColor)")
      $Childreader = (New-Object System.Xml.XmlNodeReader $xaml)
      $hashfeedback.Window  = [Windows.Markup.XamlReader]::Load($Childreader)  
      $xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | foreach {   
        if(!$hashfeedback."$($_.Name)"){$hashfeedback."$($_.Name)" = $hashfeedback.Window.FindName($_.Name)}
      }  
      
      
      $hashfeedback.Logo.Source=$Logo
      $hashfeedback.Window.icon = $Logo 
      $hashfeedback.Window.title =$PageTitle
      $hashfeedback.Window.icon.Freeze()  
      $hashfeedback.Window.IsWindowDraggable="True"
      $hashfeedback.Window.LeftWindowCommandsOverlayBehavior="HiddenTitleBar" 
      $hashfeedback.Window.RightWindowCommandsOverlayBehavior="HiddenTitleBar"
      $hashfeedback.Window.ShowTitleBar=$true
      $hashfeedback.Window.UseNoneWindowStyle = $false
      $hashfeedback.Window.WindowStyle = 'none'
      $hashfeedback.Window.IgnoreTaskbarOnMaximize = $true  
      $hashfeedback.Title_menu_Image.width = "18"  
      $hashfeedback.Title_menu_Image.Height = "18"  
      $hashfeedback.Feedback_Details.document.blocks.clear()
      $hashfeedback.EditorHelpFlyout.Document.Blocks.Clear()      
      $hashfeedback.PageNotes.text = "NOTE: If submitting a bug/issue, please enable 'Include Logs with Submission'"
      $hashfeedback.PageNotes.FontStyle="Italic"      
      if($newtheme){
        write-ezlogs "Current Theme: $($detectTheme | out-string)"
        $thememanager.RegisterLibraryThemeProvider($newtheme.LibraryThemeProvider)
        $thememanager.ChangeTheme($hashfeedback.Window,$newtheme.Name,$false)  
        if($synchash.MainGrid.Background){
          $flyoutgradientbrush = $synchash.MainGrid.Background.clone()
          $flyoutgradientbrush.GradientStops[1].color = "$($flyoutgradientbrush.GradientStops[1].color)" -replace $("$($flyoutgradientbrush.GradientStops[1].color)").Substring(0,3),'#E9' 
          $flyoutgradientbrush.GradientStops[1].Offset = "0.7"
        }else{
          $flyoutgradientbrush = New-object System.Windows.Media.LinearGradientBrush
          $flyoutgradientbrush.StartPoint = "0.5,0"
          $flyoutgradientbrush.EndPoint = "0.5,1"
          $gradientstop1 = New-object System.Windows.Media.GradientStop
          $gradientstop1.Color = $thisApp.Config.Current_Theme.GridGradientColor1
          $gradientstop1.Offset= "0.0"
          $gradientstop2 = New-object System.Windows.Media.GradientStop
          $gradientstop2.Color = $thisApp.Config.Current_Theme.GridGradientColor2
          $gradientstop2.Offset= "0.5"  
          $gradientstop_Collection = New-object System.Windows.Media.GradientStopCollection
          $null = $gradientstop_Collection.Add($gradientstop1)
          $null = $gradientstop_Collection.Add($gradientstop2)
          $flyoutgradientbrush.GradientStops = $gradientstop_Collection
        }
        $hashfeedback.Window.Background = $flyoutgradientbrush
        $hashfeedback.Editor_Help_Flyout.Background = $flyoutgradientbrush 
      }         
    }
    catch
    {
      write-ezlogs "An exception occurred when loading xaml" -CatchError $_
      return
    }      
    try{
      $hashfeedback.Feedback_Subject_textbox.Add_TextChanged({
          if($hashfeedback.Feedback_Subject_textbox.text -eq "")
          {
            $hashfeedback.Feedback_Subject_Label.BorderBrush = "Red"
          }       
          else
          {          
            $hashfeedback.Feedback_Subject_Label.BorderBrush = "Green"
          }
      })  
      $hashfeedback.Feedback_Details.Add_TextChanged({
          if(!$hashfeedback.Feedback_Details.document.blocks.inlines.text)
          {
            $hashfeedback.Feedback_Details_Label.BorderBrush = "Red"
          }       
          else
          {          
            $hashfeedback.Feedback_Details_Label.BorderBrush = "Green"
          }
      })      
      $hashfeedback.Feedback_ComboBox.add_SelectionChanged({
          if($hashfeedback.Feedback_ComboBox.selectedindex -eq -1)
          {
            $hashfeedback.FeedBack_Category.BorderBrush = "Red"
          }       
          else
          {
            $hashfeedback.FeedBack_Category.BorderBrush = "Green"
          }      
      })  
      $hashfeedback.File_Path_Browse.add_click({
          $File_Path_Browse = Open-FileDialog -Title "Select a file to include with your submission (Ex: Screenshot..etc)" -Multiselect
          write-ezlogs "Selected Path: $($File_Path_Browse)" -showtime -color cyan
          if(-not [string]::IsNullOrEmpty($File_Path_Browse)){
            [array]$File_Path_Browse = $File_Path_Browse -join ","
            $hashfeedback.File_Path_textbox.text = $File_Path_Browse
          }
      }) 
      $hashfeedback.File_Path_textbox.Add_TextChanged({
          if($hashfeedback.File_Path_textbox.text -eq "")
          {
            $hashfeedback.File_Path_Label.BorderBrush = "Orange"
          }       
          elseif([System.IO.File]::Exists($hashfeedback.File_Path_textbox.text))
          {          
            $hashfeedback.File_Path_Label.BorderBrush = "Green"
          }
          elseif(![System.IO.File]::Exists($hashfeedback.File_Path_textbox.text))
          {
            $hashfeedback.File_Path_Label.BorderBrush = "Red"
          }
      })
    }
    catch{
      write-ezlogs "An exception occurred setting event handlers" -CatchError $_
      return
    } 
       
    #Update-EditorHelp  
    function update-EditorHelp{    
      param (
        [string]$content,
        [string]$color = "White",
        [string]$FontWeight = "Normal",
        [string]$FontSize = 14,
        [string]$BackGroundColor = "Transparent",
        [string]$TextDecorations,
        [ValidateSet('Underline','Strikethrough','Underline, Overline','Overline','baseline','Strikethrough,Underline')]
        [switch]$AppendContent,
        [switch]$MultiSelect,
        [System.Windows.Controls.RichTextBox]$RichTextBoxControl = $hashfeedback.EditorHelpFlyout
      ) 
      #$hashfeedback.Editor_Help_Flyout.Document.Blocks.Clear()  
      $Paragraph = New-Object System.Windows.Documents.Paragraph
      $RichTextRange = New-Object System.Windows.Documents.Run               
      $RichTextRange.Foreground = $color
      $RichTextRange.FontWeight = $FontWeight
      $RichTextRange.FontSize = $FontSize
      $RichTextRange.Background = $BackGroundColor
      $RichTextRange.TextDecorations = $TextDecorations
      $RichTextRange.AddText($content)
      $Paragraph.Inlines.add($RichTextRange)
      if($AppendContent){
        $existing_content = $RichTextBoxControl.Document.blocks | select -last 1
        #post the content and set the default foreground color
        foreach($inline in $Paragraph.Inlines){
          $existing_content.inlines.add($inline)
        }
      }else{
        $null = $RichTextBoxControl.Document.Blocks.Add($Paragraph)
      }      
    }          
      
    $hashfeedback.ReviewLog_Path_Hyperlink.NavigateUri = $thisApp.Config.Log_file
    $Null = $hashfeedback.ReviewLog_Path_Hyperlink.AddHandler([System.Windows.Documents.Hyperlink]::ClickEvent,$synchash.Hyperlink_RequestNavigate)  
             
    #---------------------------------------------- 
    #region Apply Settings Button
    #----------------------------------------------
    $hashfeedback.Submit_Button.add_Click({
        try{           
          $RichTextRange2 = New-Object System.Windows.Documents.textrange($hashfeedback.Feedback_Details.Document.ContentStart, $hashfeedback.Feedback_Details.Document.ContentEnd)
          if(-not [string]::IsNullOrEmpty($RichTextRange2.text) -and -not [string]::IsNullOrEmpty($hashfeedback.Feedback_Subject_textbox.text) -and $hashfeedback.Feedback_ComboBox.selectedindex -ne -1 )
          {
            #submit feedback

            try
            {
              #$email_settings = Import-Clixml "$($thisApp.Config.Current_folder)\\Resources\\Email\\365Mail.xml"
              <#                $emailusername = $email_settings.EmailUser
                  $encrypted = (Get-Content "$($thisApp.Config.Current_folder)\\Resources\\Email\\365Auth.txt" -Force) | ConvertTo-SecureString
                  if($encrypted){
                  $credential = New-Object System.Management.Automation.PsCredential($emailusername, $encrypted)
                  $EmailFrom = $email_settings.EmailFrom
                  $EmailTo = $email_settings.EmailTo
                  $Smtpport = $email_settings.Smtpport
                  $SMTPServer = $email_settings.SmtpServer 
              }#>
              if([System.IO.File]::Exists("$($thisApp.Config.Current_Folder)\\Resources\\API\\Trello-API-Config.xml")){
                $auth = Import-Clixml "$($thisApp.Config.Current_Folder)\\Resources\\API\\Trello-API-Config.xml"
              }
              if($auth.client_Secret){
                if($($hashfeedback.Feedback_ComboBox.selecteditem.content) -match 'Bug/Issue'){
                  $listname = '❗ Issues'
                }else{
                  $listname = '💭 Discussions'
                } 
                try
                {
                  $CreateCard = Create-trellocard -BoardName 'EZT-MediaPlayer QA-Testing-5' -ListName $listname -CardName $($hashfeedback.Feedback_Subject_textbox.text) -CardDesc $($RichTextRange2.text) -auth $auth
                  if($CreateCard.id){
                    write-ezlogs "[SUCCESS] Feedback successfuly sent!" -showtime
                    write-ezlogs "New Card Created: $($CreateCard | out-string)" -showtime
                    $emailstatus = "[SUCCESS] Feedback successfuly sent!"
                    $notificationstatus = "[SUCCESS] Your feedback/issue was successsfully submitted!"
                    $emailcolor = "Lightgreen" 
                    if(-not [string]::IsNullOrEmpty($hashfeedback.File_Path_textbox.text)){
                      $zipfiles = [System.IO.Path]::Combine($env:temp, "$($thisScript.Name)-Attachments-Logs.zip")
                      foreach($file in $hashfeedback.File_Path_textbox.text -split ','){
                        if([System.IO.File]::Exists($file)){
                          try{
                            if($file -match '.jpg' -or $file -match '.jpeg' -or $file -match '.png'){
                              write-ezlogs -text " | Attaching image File $($file) to card" -ShowTime
                              $attach = Add-TrelloAttachment -CardID $($CreateCard.id) -FileAttachment $file -auth $auth
                            }else{
                              write-ezlogs -text " | Adding File $($file) to archive" -ShowTime
                              Compress-Archive -LiteralPath $file -DestinationPath $zipfiles -update                              
                            }
                          }catch{
                            write-ezlogs "An exception occurred adding file $file to zip archive $zipfiles" -showtime -catcherror $_
                          }                          
                        }else{
                          write-ezlogs "Cannot add invalid file '$file' to archive" -showtime -warning
                        }
                      }
                      if([System.IO.File]::Exists($zipfiles)){
                        try{
                          write-ezlogs -text "Attaching File $($zipfiles) to card $($CreateCard.id)" -ShowTime
                          $attach = Add-TrelloAttachment -CardID $($CreateCard.id) -FileAttachment $zipfiles -auth $auth
                        }catch{
                          write-ezlogs "An exception occurred executing Add-TrelloAttachment for file $zipfiles" -showtime -catcherror $_
                        }                       
                      }                       
                      if($attach){
                        write-ezlogs "[SUCCESS] Successfully added attachment $($attach.name) to Card $($CreateCard.name)" -showtime
                      }else{
                        write-ezlogs "Unable to verify successful attachment of file $($hashfeedback.File_Path_textbox.text) to card $($CreateCard.name)" -showtime -warning
                        $emailstatus += "`m[WARNING] Feedback successfuly sent, however unable to verify attachment of file $($hashfeedback.File_Path_textbox.text)"
                        $notificationstatus += "`n[WARNING] Your feedback/issue was successsfully submitted, however unable to verify attachment of file $($hashfeedback.File_Path_textbox.text)"
                        $emailcolor = "Orange" 
                      }
                    }
                    if($thisApp.Config.Log_file -and $hashfeedback.Include_logs_Toggle.isOn)
                    {
                      
                      $emaillogs = [System.IO.Path]::Combine($env:temp, "$($thisScript.Name)-$($thisScript.Version)-Logs.zip")
                      write-ezlogs -text "Creating Zip Log archive: ($emaillogs)" -ShowTime
                      $null = Copy-item ([System.IO.Directory]::GetParent($thisApp.Config.Log_file)) -Destination "$env:temp\$($thisScript.Name)\TempLogs" -Recurse -Force
                      Compress-Archive -LiteralPath "$env:temp\$($thisScript.Name)\TempLogs" -DestinationPath $emaillogs -Force 
                      $attachlog = Add-TrelloAttachment -CardID $($CreateCard.id) -FileAttachment $emaillogs -auth $auth  
                      if($attachlog){
                        write-ezlogs "[SUCCESS] Successfully added attachment $($attachlog.name) to Card $($CreateCard.name)" -showtime
                      }else{
                        write-ezlogs "Unable to verify successful attachment of file $emaillogs to card $($CreateCard.name)" -showtime -warning
                        $emailstatus += "`n[WARNING] Feedback successfuly sent, however unable to verify attachment of file $emaillogs"
                        $notificationstatus += "`n[WARNING] Your feedback/issue was successsfully submitted, however unable to verify attachment of file $emaillogs"
                        $emailcolor = "Orange" 
                      } 
                    }                    
                    Show-NotifyBalloon -Message $notificationstatus -Title 'FeedBack/Issue Submission' -TipIcon Info -Icon_path "$($current_folder)\\Resources\\MusicPlayerFill.ico"
                  }else{
                    write-ezlogs "Sending Feedback failed!" -showtime -warning
                    $emailstatus = "[ERROR] Sending Feedback failed!"
                    $notificationstatus = "[ERROR] An issue occurred while attempting to submit your feedback/issue! Please try again or contact support@eztechhelp.com"
                    $emailcolor = "red"
                    Show-NotifyBalloon -Message "[WARNING] Unable to send Feedback/Issue, invalid email credentials!" -Title 'FeedBack/Issue Submission' -TipIcon Warning -Icon_path "$($current_folder)\\Resources\\MusicPlayerFill.ico"
                  }
                }
                catch
                {
                  write-ezlogs "An exception occurred sending Feedback" -showtime -catcherror $_
                  $emailstatus = "[ERROR] Sending Feedback failed!"
                  $notificationstatus = "[ERROR] An issue occurred while attempting to submit your feedback/issue! Please try again or contact support@eztechhelp.com"
                  $emailcolor = "red"
                }             
                write-ezlogs "[FEEDBACK-SUBJECT] $($hashfeedback.Feedback_Subject_textbox.text)" -showtime -linesbefore 1           
                write-ezlogs "[FEEDBACK] $($RichTextRange2.text)" -showtime
                $hashfeedback.Save_setup_textblock.text = "$emailstatus"
                $hashfeedback.Save_setup_textblock.foreground = "$emailcolor"
                $hashfeedback.Save_setup_textblock.FontSize = 14     
                $hashfeedback.Feedback_ComboBox.selectedindex = -1    
                $hashfeedback.File_Path_textbox.text = ''  
                $hashfeedback.Feedback_Details.Document.Blocks.Clear()
                $hashfeedback.Feedback_Subject_textbox.clear()
              }
            }
            catch
            {
              write-ezlogs "An exception occurred sending Feedback" -showtime -catcherror $_
              $emailstatus = "[ERROR] Sending Feedback failed!"
              $notificationstatus = "[ERROR] An issue occurred while attempting to submit your feedback/issue! Please try again or contact support@eztechhelp.com"
              $emailcolor = "red"
            }
            <#              if($credential){
                $Subject = "$($thisScript.Name) - $($thisScript.Version) - Feedback/Issue"  
                [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
                # Create the email.
                Write-EZLogs "Creating email with SUBJECT ($subject) FROM ($EmailFrom) TO ($EmailTo)" -ShowTime
                $email = New-Object System.Net.Mail.MailMessage($EmailFrom , $EmailTo)
                $email.Subject = $Subject
                $email.IsBodyHtml = $true
                $email.Body = @"
                <h2>This was submitted from the feedback/issue form of $($thisScript.Name)</h2><br>Version: $($thisScript.Version)<br>Date: $(Get-Date -Format $logdateformat)<br>User: $($env:username)<br>Computer: $($env:computername)<br><br><b>Category: </b> $($hashfeedback.Feedback_ComboBox.selecteditem.content)<br><b>Subject: </b> $($hashfeedback.Feedback_Subject_textbox.text)<br><b>Details: </b>$($RichTextRange2.text)
                "@
                write-ezlogs "Sending email via $SmtpServer\:$Smtpport" -showtime 
                #endregion Attach HTML report
                if($thisApp.Config.Log_file)
                {
                $emaillog =  [System.IO.Path]::Combine($env:temp, "$($thisScript.Name)-$($thisScript.Version)-EM.zip")
                write-ezlogs -text "Attaching Log File ($emaillog)" -ShowTime
                $null = copy-item $thisApp.Config.Log_file -Destination $emaillog -Force
                Compress-Archive -LiteralPath $thisApp.Config.Log_file -DestinationPath $emaillog -Force 
                Write-Output "[$(Get-Date -Format $logdateformat)] Sending Email...."  | Out-File -FilePath $emaillog -Encoding unicode -Append
                Write-Output "###################### Logging Finished - [$(Get-Date -Format $logdateformat)] ######################`n" | Out-File -FilePath $emaillog -Encoding unicode -Append
                start-sleep 1
                }                
                if([System.IO.File]::Exists($hashfeedback.File_Path_textbox.text)){
                write-ezlogs -text "Attaching File $($hashfeedback.File_Path_textbox.text)" -ShowTime
                Compress-Archive -LiteralPath $hashfeedback.File_Path_textbox.text -DestinationPath $emaillog -update                  
                }
                if($emaillog){
                $email.attachments.add($emaillog)
                } 
                # Send the email.
                $SMTPClient=New-Object System.Net.Mail.SmtpClient( $SmtpServer , $SmtpPort )
                $SMTPClient.EnableSsl=$true
                $SMTPClient.Credentials = $credential
                try
                {
                $SMTPClient.Send( $email )
                $emailstatus = "[SUCCESS] Email successfuly sent!" 
                $notificationstatus = "[SUCCESS] Your feedback/issue was successsfully submitted!"
                $emailcolor = "green"
                }
                catch
                {
                write-ezlogs "An exception occurred sending email to $EmailTo" -showtime -catcherror $_
                $emailstatus = "[ERROR] Sending email failed!"
                $notificationstatus = "[ERROR] An issue occurred while attempting to submit your feedback/issue! Please try again or contact support@eztechhelp.com"
                $emailcolor = "red"
                }
                $email.Dispose();
                write-ezlogs $emailstatus -showtime -color:$emailcolor
                if($emaillog)
                {
                $Null = Remove-item $emaillog -Force
                }
                Show-NotifyBalloon -Message $notificationstatus -Title 'FeedBack/Issue Submission' -TipIcon Info -Icon_path "$($current_folder)\\Resources\\MusicPlayerFill.ico"
                }else{
                write-ezlogs "[Show-FeedBackForm] Unable to get email credentials! Unable to send" -showtime -warning
                Show-NotifyBalloon -Message "[WARNING] Unable to send Feedback/Issue, invalid email credentials!" -Title 'FeedBack/Issue Submission' -TipIcon Warning -Icon_path "$($current_folder)\\Resources\\MusicPlayerFill.ico"
            }#>

            <#              $spotify_startapp = Get-startapps *mail
                if($spotify_startapp){
                $spotify_appid = $spotify_startapp.AppID
                }else{
                $spotify_appid = $Spotify_Path
            }  #>              
            #New-BurntToastNotification -AppID $spotify_appid -Text $Message -AppLogo $applogo
              
            #Update-Notifications -id 1 -Level 'Info' -Message $notificationstatus -VerboseLog -Message_color $emailcolor -thisApp $thisApp -synchash $synchash -open_flyout
            <#              Remove-Variable -Name credential -Force
                Remove-Variable -Name SMTPClient -Force
                Remove-Variable -Name Subject -Force
                Remove-Variable -Name EmailFrom -Force
                Remove-Variable -Name EmailTo -Force
                Remove-Variable -Name emailusername -Force
                Remove-Variable -Name encrypted -Force
            Remove-Variable -Name email -Force#>
            <#            write-ezlogs "[FEEDBACK-SUBJECT] $($hashfeedback.Feedback_Subject_textbox.text)" -showtime -linesbefore 1           
                write-ezlogs "[FEEDBACK] $($RichTextRange2.text)" -showtime
                $hashfeedback.Save_setup_textblock.text = "$emailstatus"
                $hashfeedback.Save_setup_textblock.foreground = "$emailcolor"
                $hashfeedback.Save_setup_textblock.FontSize = 14     
                $hashfeedback.Feedback_ComboBox.selectedindex = -1    
                $hashfeedback.File_Path_textbox.text = ''  
                $hashfeedback.Feedback_Details.Document.Blocks.Clear()
            $hashfeedback.Feedback_Subject_textbox.clear()#>
          }
          else
          {
            #dont do anything
            write-ezlogs "[FEEDBACK] Nothing was entered..." -showtime
            $hashfeedback.Save_setup_textblock.text = "A required field is missing!"
            $hashfeedback.Save_setup_textblock.foreground = "Orange"
            $hashfeedback.Save_setup_textblock.FontSize = 14
          }                                      
        }catch{
          $hashfeedback.Save_setup_textblock.text = "An exception occurred when submiting -- `n | $($_.exception.message)`n | $($_.InvocationInfo.positionmessage)`n | $($_.ScriptStackTrace)`n"
          $hashfeedback.Save_setup_textblock.foreground = "Tomato"
          $hashfeedback.Save_setup_textblock.FontSize = 14
          write-ezlogs "An exception occurred when when submiting" -CatchError $_ -showtime -enablelogs
        }
    })
    #---------------------------------------------- 
    #endregion Apply Settings Button
    #---------------------------------------------- 
  
    #---------------------------------------------- 
    #region Cancel Button
    #----------------------------------------------
    $hashfeedback.Cancel_Button.add_Click({
        try{          
          write-ezlogs ">>>> User choose to cancel feedback form...exiting" -showtime -enablelogs  
          Close-FeedbackForm                          
        }catch{
          $hashfeedback.Save_setup_textblock.text = "An exception occurred when submitting feedback -- `n | $($_.exception.message)`n | $($_.InvocationInfo.positionmessage)`n | $($_.ScriptStackTrace)`n"
          $hashfeedback.Save_setup_textblock.foreground = "Tomato"
          $hashfeedback.Save_setup_textblock.FontSize = 14
          write-ezlogs "An exception occurred when when submitting feedback" -CatchError $_ -showtime -enablelogs
        }
    })
    #---------------------------------------------- 
    #endregion Cancel Button
    #----------------------------------------------   
    $hashfeedback.Window.Add_Closed({     
        param($Sender)    
        if($sender -eq $hashfeedback.Window){        
          try{
            #if($Startup){
            write-ezlogs " Feedbackform closed" -showtime
            #$hashContext.ExitThread()
            #$hashContext.Dispose()
            return
            # }         
          }catch{
            write-ezlogs "An exception occurred closing Show-feedbackform" -showtime -catcherror $_
            return
          }
        }
          
    }.GetNewClosure())    
   
    try{
      if($firstRun){
        $hash.window.TopMost = $false
      }     
      [System.Windows.Forms.Integration.ElementHost]::EnableModelessKeyboardInterop($hashfeedback.Window)
      [void][System.Windows.Forms.Application]::EnableVisualStyles()    
      $null = $hashfeedback.window.ShowDialog()
      $window_active = $hashfeedback.Window.Activate() 
      $hashfeedbackContext = New-Object System.Windows.Forms.ApplicationContext 
      [void][System.Windows.Forms.Application]::Run($hashfeedbackContext)            
    }catch{
      write-ezlogs "An exception occurred when opening main Show-FeedbackForm window" -showtime -CatchError $_
    }       
  }
  $Variable_list = Get-Variable | where {$_.Options -notmatch "ReadOnly" -and $_.Options -notmatch "Constant"}
  Start-Runspace $feedback_Pwshell -Variable_list $Variable_list -StartRunspaceJobHandler -synchash $synchash -logfile $thisapp.config.log_file -thisApp $thisApp -runspace_name 'Show_FeedBack_Runspace'
}
#---------------------------------------------- 
#endregion Show-FeedbackForm Function
#----------------------------------------------
Export-ModuleMember -Function @('Show-FeedbackForm','Close-FeedbackForm')



  