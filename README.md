# xenDesktop
Powershell scripts to monitor Xen Desktop 7.X

Place these files in a folder on your Xen Desktop Controller and run a scheduled task every 5 minutes.

*checkMachineStatus* - looks at all the Desktop and Server OS Machines and checks their status.  If it doesn't equal "Registered" then reboot that Machine and notify yourself that a server has been reboot.

*licenseCheck* - primarily to solve the issues with Citrix CTX129747 where the License Service "starts" but really crashes.  I give the server to a 10 minute grace period to get started before this script works.


