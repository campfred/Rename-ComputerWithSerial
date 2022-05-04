# Sync-HostnameWithSerial

## Description

This script enables to rename a host with its serial number automatically.

It does detect if the computer is part of a domain environment and use the appropriate switch to pass the admin account (if provided) on execution.

### Execution environment

This script is meant to be run in a Windows environment due to the use of Windows Management Interface calls. Although, it can be updated to use a more universal way to obtain a computer’s serial number.

### Deployment use case

The kind of use case this script solves is an environment where a Windows installation or image may be reproduced onto other machines. This can be due to having a GM image that’s deployed on new stations or having a older station being cloned to another, newer one.

## Prerequisites

The following software is required in order to run this script.

| Name                                                         | Version | Description                             | Use                |
| ------------------------------------------------------------ | ------- | --------------------------------------- | ------------------ |
| [Windows PowerShell](https://docs.microsoft.com/fr-ca/powershell/scripting/install/installing-powershell-on-windows) | 5+      | Scripting and command line environment. | Scripts execution. |

## Script parameters

| Name         |   Type   | Required | Description                                                  |                             Default value |
| ------------ | :------: | :------: | ------------------------------------------------------------ | ----------------------------------------: |
| ComputerName | `string` |    ☑️     | Overrides the computer name to apply.                        | `(Get-WmiObject Win32_BIOS).SerialNumber` |
| AdminAccount | `string` |    ⬜     | Specifies the administrative account username to use for performing the host name change. |                                           |
| Restart      | `switch` |    ⬜     | Asks to restart the computer after renaming it.              |                                  `$false` |
| ForceSync    | `switch` |    ⬜     | Forces to rename the computer even if the hostname matches the desired computer name. |                                  `$false` |



## Use

### As a shortcut

> This method works for enabling a manual way to admins to refresh the hostname of a computer.

Create a shortcut with the following details :

**Target**

```
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
```

**Arguments**

```
-NoProfile -NoLogo -ExecutionPolicy Bypass -File "\\Contoso.com\SYSVOL\Contoso.com\Scripts\Sync-HostnameWithSerial.ps1" -AdminAccount %UserName% -Restart -ForceSync
```

### As a computer configuration group policy

### For automated sync upon startup

> This method works as an automated way to refresh the hostname of a computer if it doesn’t match the desired computer name upon start up. It is meant to be run under the computer’s account’s context.

Create a shortcut (Computer Configuration ➡️ Preferences ➡️ Windows Settings ➡️ Shortcuts) and fill in the following details :

| Page    | Property                                      | Value                                                        |
| ------- | --------------------------------------------- | ------------------------------------------------------------ |
| General | Action                                        | Replace                                                      |
| General | Name                                          | (Desired shortcut name)                                      |
| General | Target type                                   | File System Object                                           |
| General | Location                                      | StartUp                                                      |
| General | Target path                                   | C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe    |
| General | Arguments                                     | -NoProfile -NoLogo -ExecutionPolicy Bypass -File "\\\Contoso.com\SYSVOL\Contoso.com\Scripts\Sync-HostnameWithSerial.ps1" -Restart |
| General | Start in                                      | \\\Contoso.com\SYSVOL\Contoso.com\Scripts\                   |
| Common  | Remove this item when it is no longer applied | ☑️                                                            |

### For manual use by admins

> This method works as an automated way to deploy a handy shortcut for admins to use when they need to force syncing the computer name manually.

Create a shortcut (User Configuration ➡️ Preferences ➡️ Windows Settings ➡️ Shortcuts) and fill in the following details :

| Page    | Property                                      | Value                                                        |
| ------- | --------------------------------------------- | ------------------------------------------------------------ |
| General | Action                                        | Replace                                                      |
| General | Name                                          | (Desired shortcut name)                                      |
| General | Target type                                   | File System Object                                           |
| General | Location                                      | Start Menu                                                   |
| General | Target path                                   | C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe    |
| General | Arguments                                     | -NoProfile -NoLogo -ExecutionPolicy Bypass -File "\\\Contoso.com\SYSVOL\Contoso.com\Scripts\Sync-HostnameWithSerial.ps1" -Restart -ForceSync |
| General | Start in                                      | \\\Contoso.com\SYSVOL\Contoso.com\Scripts\                   |
| Common  | Run in logged-on user’s security context      | ☑️                                                            |
| Common  | Remove this item when it is no longer applied | ☑️                                                            |
