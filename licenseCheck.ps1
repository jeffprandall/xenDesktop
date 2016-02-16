# Get the uptime of the server to see if we need to clean up Licensing Server Crashes
# per http://support.citrix.com/article/CTX129747

# Load the Citrix powershell modules
Asnp Citrix.*

# Check License Status
$licensingServer = "serverNameHere"
$getServiceStatus = Get-Service -ComputerName $licensingServer CtxLSPortSvc

# Get how many minutes the server has been up for
function Get-Uptime {
   $os = Get-WmiObject win32_operatingsystem
   $uptime = (Get-Date) - ($os.ConvertToDateTime($os.lastbootuptime))
   return $Uptime.Minutes
}

$minutesUp = Get-Uptime


# Give the system 10 minutes to get all services and registrations to happen before we delete
# you can lower amount of minutes if you wish
if ($minutesUp -lt 10) {

    $activationState = "\C`$:\Program Files (x86)\Citrix\Licensing\LS\conf\activation_state.xml"
    $concurrentState = "\C`$:\Program Files (x86)\Citrix\Licensing\LS\conf\concurrent_state.xml"
    
    # If the activation_state file exists delete it
    If (Test-Path \\ + $licensingServer + $activationState) {
        Remove-Item -Path \\ + $licensingServer + $activationState
    }

    # If the concurrent_state file exists delete it
    If (Test-Path \\ + $licensingServer + $concurrentState) {
        Remove-Item -Path \\ + $licensingServer + $concurrentState
    }
    
    #Restart the Licensing Service
    $getServiceStatus | Restart-Service
}
