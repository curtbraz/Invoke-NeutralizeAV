# Invoke-NeutralizeAV
Quick PoC I Wrote for Bypassing Next Gen AV Remotely for Pentesting

# Description
I created this PoC based on a recent discovery of mine during a penetration test where I had SYSTEM access but could not stop AV processes or Services.  I found that simply moving the binaries on disk to another directory essentially neutralized the running AV process.  This current version does not yet support an IP list or CIDR notation, but that's coming soon!  

# Instructions
You'll probably want to read the blog first at https://curtbraz.blogspot.com/2018/08/bypassing-next-gen-av-during-pentest.html.  

To first use this script, the assumption is being made that you are first running as SYSTEM or at least a Local or Domain Admin that can elevate to SYSTEM on a Windows OS with PowerShell.  If AV is enabled on the target you plan to run this scipt on, it will likely need to be neutralized first before this can be leveraged to disable remote targets.  See the blog for details.  Soon, I'll provide a BAT file so it's not a manual process.

