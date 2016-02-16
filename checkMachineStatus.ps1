# Load the Citrix powershell modules
Asnp Citrix.*

# Location of PS script (used for writing to event log)
$src = “Scripts\CheckMachineStatus.ps1” 

# Email Configuration
$smtp = "mail.domain.com"
$from = "citrix@domain.com"
$recipients = "you@domain.com"

# Get active Xen Machines
$xenStatus = Get-BrokerMachine | ForEach-Object {$_.HostedMachineName }

# Reboot and send email to support@royalelect.com if RegistrationState is not Registered
Function Reboot ($xenServer) {
    Restart-Computer -Computername $xenServer
    Send-MailMessage -To $recipients -From $from -Subject "$xenServer is Unregistered and is being rebooted" -Body $xenServer -SmtpServer $smtp
}

# Check each Machines status
ForEach ($xenServer in $xenStatus) {
    $status = Get-BrokerMachine | Where-Object{$_.HostedMachineName -eq $xenServer} | ForEach-Object {$_.RegistrationState}
    
    if($status -eq 'Registered')
        { 
            $strMessage = $xenServer + " - " + $status
            Write-EventLog –LogName Application –Source $src –EntryType Information –EventID 1  –Message $strMessage 
        }
    else { Reboot $xenServer }
}
