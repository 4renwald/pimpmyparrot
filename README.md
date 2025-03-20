<div align="center">
  <h1>pimpmyparrot.sh</h1>
    <br/>
  <br />
</div>

This repo is for my ParrotOS customization scripts, inspied from HTB's Pwnbox and my personal preferences.


## Requirements
The script was tested on :
- [ParrotOS HTB Edition version 6.2 Lorikeet](https://deb.parrot.sh/parrot/iso/6.2/Parrot-htb-6.2_amd64.iso)

- [ParrotOS Security Edition version 6.2 Lorikeet](https://deb.parrot.sh/parrot/iso/6.2/Parrot-security-6.2_amd64.iso)

##  Usage
```
git clone https://github.com/4renwald/pimpmyparrot.git
sudo pimpmyparrot/setup.sh
```
![](assets/images/setup.gif)

Inside the script directory, a "logs" folder is created and contains each task's outputs in separated files.

## Known errors
### Firefox
If the Firefox task fails with a *cannot access .mozilla/firefox: No such file or directory* error, simply run firefox once and close it. The needed files will be generated.
