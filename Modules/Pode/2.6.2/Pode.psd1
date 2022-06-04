#
# Module manifest for module 'Pode'
#
# Generated by: Matthew Kelly (Badgerati)
#
# Generated on: 28/11/2017
#

@{
    # Script module or binary module file associated with this manifest.
    RootModule = 'Pode.psm1'

    # Version number of this module.
    ModuleVersion = '2.6.2'

    # ID used to uniquely identify this module
    GUID = 'e3ea217c-fc3d-406b-95d5-4304ab06c6af'

    # Author of this module
    Author = 'Matthew Kelly (Badgerati)'

    # Copyright statement for this module
    Copyright = 'Copyright (c) 2017-2022 Matthew Kelly (Badgerati), licensed under the MIT License.'

    # Description of the functionality provided by this module
    Description = 'A Cross-Platform PowerShell framework for creating web servers to host REST APIs and Websites. Pode also has support for being used in Azure Functions and AWS Lambda.'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.0'

    # Functions to export from this Module
    FunctionsToExport = @(
        # cookies
        'Get-PodeCookie',
        'Get-PodeCookieSecret',
        'Remove-PodeCookie',
        'Set-PodeCookie',
        'Set-PodeCookieSecret',
        'Test-PodeCookie',
        'Test-PodeCookieSigned',
        'Update-PodeCookieExpiry',
        'Get-PodeCookieValue',

        # flash
        'Add-PodeFlashMessage',
        'Clear-PodeFlashMessages',
        'Get-PodeFlashMessage',
        'Get-PodeFlashMessageNames',
        'Remove-PodeFlashMessage',
        'Test-PodeFlashMessage',

        # headers
        'Add-PodeHeader',
        'Add-PodeHeaderBulk',
        'Test-PodeHeader',
        'Get-PodeHeader',
        'Set-PodeHeader',
        'Set-PodeHeaderBulk',
        'Test-PodeHeaderSigned',

        # state
        'Set-PodeState',
        'Get-PodeState',
        'Remove-PodeState',
        'Save-PodeState',
        'Restore-PodeState',
        'Test-PodeState',
        'Get-PodeStateNames',

        # response helpers
        'Set-PodeResponseAttachment',
        'Write-PodeTextResponse',
        'Write-PodeFileResponse',
        'Write-PodeCsvResponse',
        'Write-PodeHtmlResponse',
        'Write-PodeMarkdownResponse',
        'Write-PodeJsonResponse',
        'Write-PodeXmlResponse',
        'Write-PodeViewResponse',
        'Set-PodeResponseStatus',
        'Move-PodeResponseUrl',
        'Write-PodeTcpClient',
        'Read-PodeTcpClient',
        'Save-PodeRequestFile',
        'Set-PodeViewEngine',
        'Use-PodePartialView',
        'Send-PodeSignal',
        'Add-PodeViewFolder',

        # utility helpers
        'Close-PodeDisposable',
        'Lock-PodeObject',
        'Get-PodeServerPath',
        'Start-PodeStopwatch',
        'Use-PodeStream',
        'Use-PodeScript',
        'Get-PodeConfig',
        'Add-PodeEndware',
        'Use-PodeEndware',
        'Import-PodeModule',
        'Import-PodeSnapIn',
        'Protect-PodeValue',
        'Resolve-PodeValue',
        'Invoke-PodeScriptBlock',
        'Test-PodeIsUnix',
        'Test-PodeIsWindows',
        'Test-PodeIsMacOS',
        'Test-PodeIsPSCore',
        'Test-PodeIsEmpty',
        'Out-PodeHost',
        'Write-PodeHost',
        'Test-PodeIsIIS',
        'Test-PodeIsHeroku',
        'Get-PodeIISApplicationPath',
        'New-PodeLockable',
        'Remove-PodeLockable',
        'Get-PodeLockable',
        'Test-PodeLockable',
        'Out-PodeVariable',
        'Test-PodeIsHosted',

        # routes
        'Add-PodeRoute',
        'Add-PodeStaticRoute',
        'Add-PodeSignalRoute',
        'Remove-PodeRoute',
        'Remove-PodeStaticRoute',
        'Remove-PodeSignalRoute',
        'Clear-PodeRoutes',
        'Clear-PodeStaticRoutes',
        'Clear-PodeSignalRoutes',
        'ConvertTo-PodeRoute',
        'Add-PodePage',
        'Get-PodeRoute',
        'Get-PodeStaticRoute',
        'Get-PodeSignalRoute',
        'Use-PodeRoutes',

        # handlers
        'Add-PodeHandler',
        'Remove-PodeHandler',
        'Clear-PodeHandlers',
        'Use-PodeHandlers',

        # schedules
        'Add-PodeSchedule',
        'Remove-PodeSchedule',
        'Clear-PodeSchedule',
        'Invoke-PodeSchedule',
        'Edit-PodeSchedule',
        'Set-PodeScheduleConcurrency',
        'Get-PodeSchedule',
        'Get-PodeScheduleNextTrigger',
        'Use-PodeSchedules',

        # timers
        'Add-PodeTimer',
        'Remove-PodeTimer',
        'Clear-PodeTimers',
        'Invoke-PodeTimer',
        'Edit-PodeTimer',
        'Get-PodeTimer',
        'Use-PodeTimers',

        # tasks
        'Add-PodeTask',
        'Set-PodeTaskConcurrency',
        'Invoke-PodeTask',
        'Remove-PodeTask',
        'Clear-PodeTasks',
        'Edit-PodeTask',
        'Get-PodeTask',
        'Use-PodeTasks',
        'Close-PodeTask',
        'Test-PodeTaskCompleted',
        'Wait-PodeTask',

        # middleware
        'Add-PodeMiddleware',
        'Remove-PodeMiddleware',
        'Clear-PodeMiddleware',
        'Add-PodeAccessRule',
        'Add-PodeLimitRule',
        'Enable-PodeSessionMiddleware',
        'New-PodeCsrfToken',
        'Get-PodeCsrfMiddleware',
        'Initialize-PodeCsrf',
        'Enable-PodeCsrfMiddleware',
        'Remove-PodeSession',
        'Save-PodeSession',
        'Get-PodeSessionId',
        'Use-PodeMiddleware',

        # auth
        'New-PodeAuthScheme',
        'New-PodeAuthAzureADScheme',
        'New-PodeAuthTwitterScheme',
        'Add-PodeAuth',
        'Get-PodeAuth',
        'Clear-PodeAuth',
        'Add-PodeAuthWindowsAd',
        'Add-PodeAuthWindowsLocal',
        'Remove-PodeAuth',
        'Add-PodeAuthMiddleware',
        'Add-PodeAuthIIS',
        'Add-PodeAuthUserFile',
        'ConvertTo-PodeJwt',
        'ConvertFrom-PodeJwt',
        'Use-PodeAuth',
        'ConvertFrom-PodeOIDCDiscovery',

        # logging
        'New-PodeLoggingMethod',
        'Enable-PodeRequestLogging',
        'Enable-PodeErrorLogging',
        'Disable-PodeRequestLogging',
        'Disable-PodeErrorLogging',
        'Add-PodeLogger',
        'Remove-PodeLogger',
        'Clear-PodeLoggers',
        'Write-PodeErrorLog',
        'Write-PodeLog',
        'Protect-PodeLogItem',
        'Use-PodeLogging',

        # core
        'Start-PodeServer',
        'Close-PodeServer',
        'Restart-PodeServer',
        'Start-PodeStaticServer',
        'Show-PodeGui',
        'Add-PodeEndpoint',
        'Get-PodeEndpoint',
        'Pode',

        # openapi
        'Enable-PodeOpenApi',
        'Get-PodeOpenApiDefinition',
        'Add-PodeOAResponse',
        'Remove-PodeOAResponse',
        'Add-PodeOAComponentResponse',
        'Set-PodeOARequest',
        'New-PodeOARequestBody',
        'Add-PodeOAComponentSchema',
        'Add-PodeOAComponentRequestBody',
        'Add-PodeOAComponentParameter',
        'New-PodeOAIntProperty',
        'New-PodeOANumberProperty',
        'New-PodeOAStringProperty',
        'New-PodeOABoolProperty',
        'New-PodeOAObjectProperty',
        'New-PodeOASchemaProperty',
        'ConvertTo-PodeOAParameter',
        'Set-PodeOARouteInfo',
        'Enable-PodeOpenApiViewer',

        # Metrics
        'Get-PodeServerUptime',
        'Get-PodeServerRestartCount',
        'Get-PodeServerRequestMetric',
        'Get-PodeServerSignalMetric',
        'Get-PodeServerActiveRequestMetric',
        'Get-PodeServerActiveSignalMetric',

        # AutoImport
        'Export-PodeModule',
        'Export-PodeSnapin',
        'Export-PodeFunction',

        # Events
        'Register-PodeEvent',
        'Unregister-PodeEvent',
        'Test-PodeEvent',
        'Get-PodeEvent',
        'Clear-PodeEvent',
        'Use-PodeEvents',

        # Security
        'Add-PodeSecurityHeader',
        'Add-PodeSecurityContentSecurityPolicy',
        'Add-PodeSecurityPermissionsPolicy',
        'Remove-PodeSecurity',
        'Remove-PodeSecurityAccessControl',
        'Remove-PodeSecurityContentSecurityPolicy',
        'Remove-PodeSecurityContentTypeOptions',
        'Remove-PodeSecurityCrossOrigin',
        'Remove-PodeSecurityFrameOptions',
        'Remove-PodeSecurityHeader',
        'Remove-PodeSecurityPermissionsPolicy',
        'Remove-PodeSecurityReferrerPolicy',
        'Remove-PodeSecurityStrictTransportSecurity',
        'Set-PodeSecurity',
        'Set-PodeSecurityAccessControl',
        'Set-PodeSecurityContentSecurityPolicy',
        'Set-PodeSecurityContentTypeOptions',
        'Set-PodeSecurityCrossOrigin',
        'Set-PodeSecurityFrameOptions',
        'Set-PodeSecurityPermissionsPolicy',
        'Set-PodeSecurityReferrerPolicy',
        'Set-PodeSecurityStrictTransportSecurity'
    )

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{
        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = @('powershell', 'web', 'server', 'http', 'listener', 'rest', 'api', 'tcp', 'smtp', 'websites',
                'powershell-core', 'windows', 'unix', 'linux', 'pode', 'PSEdition_Core', 'cross-platform', 'access-control',
                'file-monitoring', 'multithreaded', 'rate-limiting', 'cron', 'schedule', 'middleware', 'session',
                'authentication', 'active-directory', 'caching', 'csrf', 'arm', 'raspberry-pi', 'aws-lambda',
                'azure-functions', 'websockets', 'swagger', 'openapi', 'redoc')

            # A URL to the license for this module.
            LicenseUri = 'https://raw.githubusercontent.com/Badgerati/Pode/master/LICENSE.txt'

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/Badgerati/Pode'

            # A URL to an icon representing this module.
            IconUri = 'https://raw.githubusercontent.com/Badgerati/Pode/master/images/icon.png'

            # Release notes for this particular version of the module
            ReleaseNotes = 'https://github.com/Badgerati/Pode/releases/tag/v2.6.2'

        }
    }
}