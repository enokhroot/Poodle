#!/bin/bash

cat << EOF

██████╗░░█████╗░░█████╗░██████╗░██╗░░░░░███████╗
██╔══██╗██╔══██╗██╔══██╗██╔══██╗██║░░░░░██╔════╝
██████╔╝██║░░██║██║░░██║██║░░██║██║░░░░░█████╗░░
██╔═══╝░██║░░██║██║░░██║██║░░██║██║░░░░░██╔══╝░░
██║░░░░░╚█████╔╝╚█████╔╝██████╔╝███████╗███████╗
╚═╝░░░░░░╚════╝░░╚════╝░╚═════╝░╚══════╝╚══════╝                                                          
EOF

while :
do
    echo "============================="
    echo "Вы хотите просканировать сеть или хост? Нажмите n"
    echo "Вы хотите просканировать директории на хосте? Нажмите d"
    echo "Вы хотите просканировать директории более глубо? Нажмите sd"
    echo "Вы хотите просканировать поддомены на хосте? Нажмите s"
    echo "Вы хотите просканировать сайт с WordPress? Нажмите wp"
    echo "Если Вы хотите выйти, то нажмите Ctrl + C"
    read command

    if [ $command == "d" ]; then
        read -p "Введите IP: " ip_
        dirsearch -u $ip_
    elif [ $command == "s" ]; then
        read -p "Введите URL: " url_
        gobuster dns -w /usr/share/wordlists/seclists/Discovery/DNS/bitquark-subdomains-top100000.txt -d $url_  -t 100
    elif [ $command == "n" ]; then
        read -p "Введите IP: " ip_
        read -p "Введите до какого порта сканировать (масксимум 65535, стандартно 1000): " ports_
        nmap -sC -sV -p -$ports_ --min-rate 5000 $ip_
        read -p  "Успешно? Если да, то нажмите y, если нет и проблема в блокировке ping, то нажмите pg для повторного сканирования с отключенным пингом: " result_
        if [ $result_ == "y" ]; then
            continue
        elif [ $result_ == "pg" ]; then
            nmap -sC -sV -Pn -p -$ports_ --min-rate 5000 $ip_
        fi
    elif [ $command == "sd" ]; then
        read -p "Введите IP/{direct}: " ip_
        read -p "Какой словарь хотите использовать (small/medium)? " dict_
        gobuster dir -w /usr/share/wordlists/dirbuster/directory-list-2.3-$dict_.txt -u  $ip_ -t 100
    elif [ $command == "wp" ]; then
        read -p "Введите IP/{direct}: " ip_
        wpscan --url $ip_ -e u 
        wpscan --url $ip_ -e ap
    else
	    echo "Введено что-то не то. Попробуй ещё раз."
        echo " "
        continue
    fi
done