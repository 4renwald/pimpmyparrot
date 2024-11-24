#!/bin/bash

# Error handling for the script
set -e
trap 'error_handling' EXIT
error_handling() {
    exit_status=$?
    error_message=$(cat logs/errors.log)
    if [ "$exit_status" -ne 0 ]; then
        printf "\r"
        print_error "$error_message\n"
        clean_up_tmp
    fi
}

# Vars
target_user=$(ls /home)
target_uid=$(id $target_user | awk -F'[=()]' '{print $2}')

# Setting colors for text format
BLUE=$(tput setaf 14)
GREEN=$(tput setaf 10)
RED=$(tput setaf 9)
PURPLE=$(tput setaf 13)
BEIGE=$(tput setaf 230)
ENDCOLOR=$(tput sgr0)

# Print banner
banner () {
    echo "$BEIGE
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣄
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⢰⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⡏⡄
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⠀⡆⠀⠀⠀⠀⢠⠀⠀⠀⠀⠀⣿⡇⢃
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⠀⢃⠀⠀⠀⠀⡇⠆⠀⠀⠀⢠⣿⡇⢸
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠀⢸⠀⠀⠀⢸⡇⢸⠀⠀⠀⢸⣿⡇⠀⡆
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠀⢸⠀⠀⠀⣾⡇⠀⡆⠀⠀⢸⣿⡇⠀⡇
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠀⢸⠀⣠⠀⣿⡇⠀⡇⢰⡀⢸⣿⡇⠀⡇
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠿⣿⢀⠬⠀⣿⡆⣿⡇⠀⡇⣾⡇⠸⢿⡇⡠⠇
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠰⠿⣿⣆⣱⣿⠿⠎⣷⣿⣧⠀⣷⡇⠾⢿⣷⣁⣾⡿⠶
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣽⢯⡄⠘⠷⠋⣿⣿⢀⡏⠳⠛⠀⣬⢿⣅
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣤⣤⡄⠀⠈⢿⣌⠻⣄⡒⠲⣶⡝⣵⡶⠒⣂⡼⢋⣾⠋⠀⠀⣤⣤⣤
⠀⠀⠀⠀⠀⠀⠀⠀⢸⡈⣿⣏⢸⣿⣆⠀⢙⣷⢦⣍⣓⢸⣿⣿⢐⣋⣥⢶⣏⠁⢀⣾⣷⢈⣿⡏⣼
⠀⠀⠀⠀⠀⣀⣴⣶⠶⢃⣿⣿⣌⠻⣿⠰⣿⣇⠀⠀⠡⠾⣿⡿⠦⠁⠀⢀⣿⡷⢸⡿⢋⣼⣿⣧⡑⠂⠂⢄⡀
⠀⠀⣀⡴⠾⢛⣉⠠⠤⠛⠉⠙⠻⣷⣌⢿⣶⣶⣿⣇⣐⠺⣿⡿⢒⣀⣿⣷⣶⣾⢏⣴⡿⠛⠉⠙⠻⠿⢶⣤⣌⡒⠄⡀
⠔⠚⠃⠈⠉⠀⠀⠀⠀⠀⠀⠀⣤⣼⡟⢸⠿⠿⠿⠿⣿⣇⠹⢁⣿⡿⠿⠿⠿⢿⡜⠛⠠⠄⠀⠀⠀⠀⠀⠀⠈⠉⠉⠚⠒⠄
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⡿⠋⠀⡨⠂⠀⠀⠀⣠⣿⡇⠉⠣⡀⠀⠀⠀⠺⣿⣦⡀⠈⡄
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⠟⢁⠔⠁⠀⠀⠀⠀⠀⢸⣿⡇⠀⢰⠀⠀⠀⠀⠀⠀⠙⢿⣄⠘⡄
⠀⠀⠀⠀⠀⠀⠀⠀⠀⡰⡫⠂⠁⠀⠀⠀⠀⠀⠀⠀⠀⢿⡇⠀⠆⠀⠀⠀⠀⠀⠀⠀⠀⠉⠳⣔⡀
⠀⠀⠀⠀⠀⠀⠀⠀⠐⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⡇⠸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠒
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢃⠃
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘
                  YoRHa OS                     $ENDCOLOR"
    echo $ENDCOLOR
    echo ""
}

# functions to format the output
spinner() {
    local i=0 sp n message
    sp='⣾⣽⣻⢿⡿⣟⣯⣷'
    n=${#sp}
    message=$1

    printf ' '

    while sleep 0.2; do
        printf "\r%s %s" "${sp:i++%n:1}" "$message"
    done
}

spinner_end() {
    kill "$!"
    printf "\r"
}

print_info () {
    echo -e "$PURPLE[*]$ENDCOLOR $1"
}

print_success () {
    echo -e "$GREEN[+]$ENDCOLOR $1"
}

print_error () {
    echo -e "$RED[!]$ENDCOLOR $1"
}


# Check if script runs as root
is_user_root () {
    if [ "$EUID" -ne 0 ]; then
        print_error "This script needs to be run using sudo"
        exit 0
    fi
}

# Clean up /tmp/YoRHa_OS folder when failure or end
clean_up_tmp () {
    print_info "Cleaning up"
    spinner &
    rm -rf /tmp/YoRHa_OS/
    spinner_end
    print_success "Cleaned up temp files\n"
}

# Change to the directory of the script and setup logs and tmp folders
change_directory_script () {
    SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    cd $SCRIPT_DIR
    
    # Create tmp and logs folders for script execution
    mkdir -p /tmp/YoRHa_OS
    mkdir -p ./logs
    rm -rf /tmp/YoRHa_OS/* ./logs/*
}

# Update system
update_system () {
    print_info "Updating the system"
    spinner &
    (apt update -y && apt full-upgrade -y && apt autoremove -y && apt autoclean -y) 1>>logs/update.log 2>logs/errors.log
    spinner_end
    print_success "System updated\n"
}

# Install pyenv
install_pyenv () {
    print_info "Installing Pyenv"
    if [ -d "/home/$target_user/.pyenv" ]; then
        print_success "Pyenv is already installed\n"
        return 0
    else
        sudo -u "$target_user" bash -c 'curl -s https://pyenv.run | bash' 1>>logs/dependencies.log 2>logs/errors.log
    fi
    print_success "Pyenv installed\n"
}

# Install Java version 21 for Burpsuite to work
install_java_21 () {
    print_info "Installing Java version 21 for Burpsuite"
    if [ -d "/usr/lib/jvm/jdk-21" ]; then
        print_success "Java version 21 already installed\n"
        return 0
    fi
    spinner &
    java_21_url="https://download.java.net/java/GA/jdk21.0.2/f2283984656d49d69e91c558476027ac/13/GPL/openjdk-21.0.2_linux-x64_bin.tar.gz"
    wget -P /tmp/YoRHa_OS/ $java_21_url 1>>logs/java_update.log 2>logs/errors.log
    tar xvf /tmp/YoRHa_OS/openjdk-21.0.2_linux-x64_bin.tar.gz -C /tmp/YoRHa_OS/ 1>>logs/java_update.log 2>logs/errors.log
    mv /tmp/YoRHa_OS/jdk-21.0.2/ /usr/lib/jvm/jdk-21 2>logs/errors.log
    spinner_end
    print_success "Java version 21 installed\n"
}

# Install PowerShell
install_pwsh () {
    print_info "Installing PowerShell"
    spinner &
    if command -v pwsh &> /dev/null; then
        spinner_end
        print_success "PowerShell is already installed\n"
        return 0
    fi
    wget -P /tmp/YoRHa_OS/ https://github.com/PowerShell/PowerShell/releases/download/v7.4.6/powershell_7.4.6-1.deb_amd64.deb 1>>logs/dracula_theme.log 2>logs/errors.log
    dpkg -i /tmp/YoRHa_OS/powershell_7.4.6-1.deb_amd64.deb 1>>logs/dracula_theme.log 2>logs/errors.log
    apt-get install -f /tmp/YoRHa_OS/powershell_7.4.6-1.deb_amd64.deb 1>>logs/dracula_theme.log 2>logs/errors.log
    spinner_end
    print_success "PowerShell installed\n"
}

# Install xfreerdp with aptitude
install_xfreerdp () {
    print_info "Installing aptitude and xfreerdp"
    spinner &
    apt install aptitude -y 1>>logs/xfreerdp.log 2>logs/errors.log
    aptitude install xfreerdp2-x11 -y 1>>logs/xfreerdp.log 2>logs/errors.log
    spinner_end
    print_success "aptitude and xfreerdp installed\n"
}

# Install pwntools
install_pwntools () {
    print_info "Installing pwntools"
    spinner &
    apt install python3-pwntools -y 1>>logs/pwntools.log 2>logs/errors.log
    spinner_end
    print_success "pwntools installed\n"
}

# Install Freeze
install_freeze () {
    print_info "Installing Freeze"
    spinner &
    wget -P /tmp/YoRHa_OS/ https://github.com/charmbracelet/freeze/releases/download/v0.1.6/freeze_0.1.6_amd64.deb 1>>logs/freeze.log 2>logs/errors.log
    apt-get install -f /tmp/YoRHa_OS/freeze_0.1.6_amd64.deb 1>>logs/freeze.log 2>logs/errors.log
    spinner_end
    print_success "Freeze installed\n"
}

# Add Burpsuite cerificate to CA Certificates
get_burp_cert () {
    print_info "Retrieving and installing Burpsuite certificate to ca-certificates"
    spinner &
    if [ -f "/usr/local/share/ca-certificates/BurpSuiteCA.der" ]; then
        print_success "BurpSuite certificate already installed\n"
        spinner_end
        return 0
    else
        timeout 45 /usr/lib/jvm/jdk-21/bin/java -Djava.awt.headless=true -jar /usr/share/burpsuite/burpsuite_community.jar < <(echo y) 1>>logs/burp_cert.log 2>logs/errors.log &
        sleep 30
        curl http://localhost:8080/cert -o /usr/local/share/ca-certificates/BurpSuiteCA.der 2>logs/errors.log
    fi
    spinner_end
    print_success "Burpsuite certificate installed\n"
}

# Firefox configurations
firefox () {
    print_info "Configuring Firefox"
    spinner &
    default_profile=$(ls /home/$target_user/.mozilla/firefox/ | grep default-release)
    sqlite3 /home/$target_user/.mozilla/firefox/$default_profile/places.sqlite ".restore ./files/applications/firefox/places.sqlite" 2>logs/errors.log
    cp ./files/applications/firefox/policies.json /usr/lib/firefox/distribution 2>logs/errors.log
    spinner_end
    print_success "Configured Firefox\n"
}

# Install Dracula theme on the system
install_dracula_theme () {
    print_info "Installing Dracula Theme for GTK"
    spinner &
    rm -rf /usr/share/themes/Dracula
    rm -rf /usr/share/icons/Dracula
    wget -P /tmp/YoRHa_OS https://github.com/dracula/gtk/archive/master.zip 1>>logs/dracula_theme.log 2>logs/errors.log
    wget -P /tmp/YoRHa_OS https://github.com/dracula/gtk/files/5214870/Dracula.zip 1>>logs/dracula_theme.log 2>logs/errors.log
    unzip /tmp/YoRHa_OS/master.zip -d /tmp/YoRHa_OS 1>>logs/dracula_theme.log 2>logs/errors.log
    mv /tmp/YoRHa_OS/gtk-master /tmp/YoRHa_OS/Dracula 1>>logs/dracula_theme.log 2>logs/errors.log
    mv /tmp/YoRHa_OS/Dracula /usr/share/themes 1>>logs/dracula_theme.log 2>logs/errors.log
    unzip /tmp/YoRHa_OS/Dracula.zip -d /tmp/YoRHa_OS 1>>logs/dracula_theme.log 2>logs/errors.log
    mv /tmp/YoRHa_OS/Dracula /usr/share/icons 1>>logs/dracula_theme.log 2>logs/errors.log
    spinner_end
    print_success "Dracula theme installed\n"
}

# Copy Wallpapers
wallpapers () {
    print_info  "Copying Wallpapers"
    spinner &
    cp ./files/wallpapers/* /usr/share/backgrounds
    spinner_end
    print_success "Wallpapers copied\n"
}

# Install required fonts
install_fonts () {
    print_info "Installing fonts"
    spinner &
    mkdir -p /home/$target_user/.local/share/fonts
    
    # Cascadia Code
    mkdir -p /tmp/YoRHa_OS/CascadiaCode
    wget -P /tmp/YoRHa_OS/CascadiaCode https://github.com/microsoft/cascadia-code/releases/download/v2404.23/CascadiaCode-2404.23.zip 1>>logs/install_fonts.log 2>logs/errors.log
    unzip /tmp/YoRHa_OS/CascadiaCode/CascadiaCode-2404.23.zip -d /tmp/YoRHa_OS/CascadiaCode 1>>logs/install_fonts.log 2>logs/errors.log
    rsync -a /tmp/YoRHa_OS/CascadiaCode/ttf/ /home/$target_user/.local/share/fonts/ 2>logs/errors.log
    
    spinner_end
    print_success "Fonts installed\n"
}

# General system settings (Terminal, themes, etc..)
settings () {
    print_info "Configuring user and system settings"
    spinner &
    
    # Copy bash scripts for terminal in /etc/htb/ 
    mkdir -p /etc/YoRHa_OS 2> logs/errors.log
    cp -rf ./files/etc/YoRHa_OS/* /etc/YoRHa_OS
    chmod a+x /etc/YoRHa_OS/*

    # Copy user configs to homedir
    cp -rf ./files/homedir/. /home/$target_user/ 2>logs/errors.log

    # Copy theme settings
    mkdir -p /usr/share/themes/YoRHa_OS
    cp -f ./files/usr/share/themes/index.theme /usr/share/themes/YoRHa_OS

    # Copy icons
    mkdir -p /usr/share/icons/htb
    cp -f ./files/usr/share/icons/htb/* /usr/share/icons/htb/
    
    # Load terminal and panel configs
    sudo -H -u $target_user DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$target_uid/bus dconf load /org/mate/terminal/ < ./files/dconf_terminal 2>logs/errors.log
    sudo -H -u $target_user DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$target_uid/bus dconf load /org/mate/panel/ < ./files/dconf_panel 2>logs/errors.log
    killall mate-panel
    
    spinner_end
    print_success "Configured user and system settings\n"
}

main () {
    is_user_root
    change_directory_script
    banner
    update_system
    install_pyenv
    install_java_21
    install_pwsh
    install_xfreerdp
    install_pwntools
    install_freeze
    get_burp_cert
    firefox
    install_dracula_theme
    install_fonts
    wallpapers
    settings
    clean_up_tmp
}

main
