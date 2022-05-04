[CmdletBinding()]
param (
	# Computer name
	[Parameter(Mandatory = $true)]
	[string] $ComputerName = (Get-WmiObject Win32_BIOS).SerialNumber,

	# Admin account
	[Parameter(Mandatory = $false)]
	[string] $AdminAccount,

	# Force restart switch
	[Parameter(Mandatory = $false)]
	[switch] $Restart = $false,

	# Force rename switch
	[Parameter(Mandatory = $false)]
	[switch] $ForceSync = $false
)

Write-Debug "Checking if the computer name « $($env:COMPUTERNAME) » matches the script's computer name argument « $($script:ComputerName) » or that the switch ForceSync has been set ($($script:ForceSync))..."
if ((-not $env:COMPUTERNAME -eq $script:ComputerName) -or $script:ForceSync)
{
	Write-Debug "Checking if the script's AdminAccount argument has been set..."
	if ($PSBoundParameters.ContainsKey("AdminAccount"))
	{
		Write-Debug "Enterting try-catch statement..."
		try
		{
			Write-Debug "Trying to obtain the computer's domain name..."
			if (-not [System.DirectoryServices.ActiveDirectory.Domain]::GetComputerDomain().Name -eq $null)
			{
				Write-Debug "The computer is inside of a domain ($([System.DirectoryServices.ActiveDirectory.Domain]::GetComputerDomain().Name)), renaming computer by passing the AdminAccount argument value ($($script:AdminAccount)) in the DomainCredential argument..."
				Rename-Computer -NewName $script:ComputerName -DomainCredential $script:AdminAccount -Restart=$script:Restart
			}
		}
		catch
		{
			Write-Debug "The computer is not inside of a domain, renaming computer by passing the AdminAccount argument value ($($script:AdminAccount)) in the LocalCredential argument..."
			Rename-Computer -NewName $script:ComputerName -LocalCredential $script:AdminAccount  -Restart=$script:Restart
		}
	}
	else
	{
		Write-Debug "No AdminAccount argument has been provided, renaming the computer with the current context..."
		Rename-Computer -NewName $script:ComputerName  -Restart=$script:Restart
	}
}
