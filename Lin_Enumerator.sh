#!/bin/bash
# Post exploit local enumeration bash scripts
# Objective of the script is to completely automate few important post local exploitation enumeration scripts on linux
# Still under construction ( sugesstions entertained )
# Please note that one needs to run these scripts on the system locally to get results

#color tags
R="\033[31m"
G="\033[32m"
Y="\033[33m"
B="\033[34m"
N="\033[0;39m"
# Timing stuff
Date=$(date +"%m-%d-%Y")
function timer()
{
    if [[ $# -eq 0 ]]; then
        echo $(date '+%s')
    else
        local  stime=$1
        etime=$(date '+%s')

        if [[ -z "$stime" ]]; then stime=$etime; fi

        dt=$((etime - stime))
        ds=$((dt % 60))
        dm=$(((dt / 60) % 60))
        dh=$((dt / 3600))
        printf '%d:%02d:%02d' $dh $dm $ds
    fi
}

if [[ $(basename $0 .sh) == 'timer' ]]; then
    t=$(timer)
    read -p 'Enter when ready...' p
    printf 'Elapsed time: %s\n' $(timer $t)
fi

echo -e "\n\n" 
echo -e "${N}######################################################################################"
echo -e "${B}#### Author: Srinan #### \n ${B}Lin_Enumerator \n ${B}Version:1.0 \n ${Y}###Caution### \n \n ${R}I'm not responsible for any misuse of this code or any damage caused by it by the user (you!!).You agree that you use this software at your own risk." | sed  -e :a -e 's/^.\{1,77\}$/ & /;ta'
echo -e "${N}######################################################################################"
echo -e "${N}NOTE: Still under development"
echo -e "Scan Date:${Date}"

echo -e "${G}Syntax:${N} ./Lin_Enumeartor.sh -F <Output Folder Name> -f <file name>"



Syntax(){
echo -e "${G}Arguments/Options: \n [1]-F:Enter the output folder name \n [2]-f:Enter file name \n [3]-h:Help \n ${N}" 
}

while getopts "F:f:h" option; do
 case "${option}" in
	  
	  F) Output=${OPTARG}"-"${Date};;
	  f) Fname=${OPTARG};;
	  h) Syntax; exit;;
	  *) Syntax; exit;;
 esac
done
sleep 2





if [[ "$Output" ]]; then

  mkdir $Output 2>/dev/null
  echo -e "Output Folder: $Output "
  
  if [[ "$Fname" ]]; then 
      cd $Output 2>/dev/null
      format=$Fname"_Lin_Enumeartor_Result" 2>/dev/null
      touch $format 2>/dev/null
      
  fi
 
fi
if [[ "$Fname" ]]; then
  format=$Fname"_Lin_Enumeartor_Result" 2>/dev/null
  touch $format 2>/dev/null
      
fi


sleep 3

post_enum_scan(){

echo -e "${G}Kernel Information:${N} \n $(uname -a) \n $(cat /proc/version) \n${G}Hostname:${N} $(hostname) \n${G}Current User Details: \n${N} $(id)\n "
echo -e "${G}Versions:\n${B}\n  Version of GCC:${N}$(gcc -v) \n${B}  Version of MySQL:${N}$(mysql --version) \n${B}  Version of Perl:${N}$(perl -v) \n${B}  Version of Ruby:${N}$(ruby -v) \n${B}  Version of Python:${N}$(python --version)\n " 
echo -e "${G}Users:${N} \n\n$(cat /etc/passwd | cut -d ":" -f 1,2,3,4) \n\n${G}Groups:\n${N}\n$(for i in $(cat /etc/passwd | cut -d":" -f1 );do id $i;done) \n"
echo -e "${G}Shadow: \n${N}\n$(cat /etc/shadow) \n${G}\nSudoers: \n${N}\n$(cat /etc/sudoers | grep -v -e '^$'|grep -v '#')"
echo -e "${G}Interesting root directory files: \n${N}\n$(ls -ahlR /root/) \n${G}\nInteresting home directory files: \n${N}\n$(ls -ahlR /home/)"
echo -e "\n${G}Passswords in history: \n${N}\n$(grep -i 'password\|pass\|passwd' ~/.bash_history ~/.nano_history ~/.atftp_history ~/.mysql_history ~/.php_history) \n ${G}Networking stuff: \n${G} Network Interface: \n  ${N}$(ifconfig -a) \n\n${G} Routing table:\n ${N}$(route -n) \n"
echo -e "\n${G}\nInterfaces: \n${N}\n$(cat /etc/network/interfaces) \n${G}\nFirewall rules: \n${N}\n$(iptables -L)"




}
post_enum_scan

if [[ "$Output" ]]; then
  post_enum_scan >> $format 2>/dev/null
fi
if [[ "$Fname" ]]; then
  post_enum_scan >> $format 2>/dev/null
fi

echo -e "\n\n"
tmr=$(timer)
printf ${R}'Elapsed time: %s\n'$(timer $tmr) 

