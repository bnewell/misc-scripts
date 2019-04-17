#!/usr/bin/env python3
"""
Find active PS4(s) on the local network
"""
import subprocess
import re

# mac prefixes sourced from nmap
# https://github.com/nmap/nmap/blob/master/nmap-mac-prefixes
SONY_INTERACTIVE_MAC_PREFIXES = [ "00-13-15",
                                  "00-1f-a7", 
                                  "a8-e3-ee",
                                  "70-9e-29",
                                  "fc-0f-e6" ]


def findPS4s():
    '''Search for active PS4(s) on the local network using ARP cache

    Return a list of tuples that contain IP and MAC addresses of the PS4s
    '''
    foundPS4s=[]
    info = subprocess.STARTUPINFO()
    info.dwFlags |= subprocess.STARTF_USESHOWWINDOW
    info.wShowWindow = subprocess.SW_HIDE
    arpResult = subprocess.run( ["arp", "-a"], 
                             stdout=subprocess.PIPE,
                             startupinfo=info)

    for prefix in SONY_INTERACTIVE_MAC_PREFIXES:
        ipRegex = "(\d+\.\d+\.\d+\.\d+)"
        macRegex = "(" + prefix + "-([a-f\d]{1,2}\-){2}[a-f\d]{1,2})"
        fullRegex = ipRegex + "\s+" + macRegex
        searchResult = re.search(fullRegex, str(arpResult.stdout))
        if searchResult:
            foundPS4s.append((searchResult.group(1), searchResult.group(2)))
        
    return foundPS4s


PS4s = findPS4s()
if not PS4s:
    print("[-] Unable to find any PS4(s) on the local network")
    exit()
print("[+] Successfully found %d PS4(s) on the local network\n" % len(PS4s))
print("%-15s %-17s" % ("IP", "MAC"))
print("%-15s %-17s" % ("--", "---"))
for ip, mac in PS4s:
    print("%-15s %-17s" % (ip, mac.upper()))







