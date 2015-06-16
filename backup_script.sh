#!/bin/bash

###One time configuration on the laptop####
###################################################
#Generate ssh key
# ssh-keygen -t rsa

#Copy the ssh key to remote server so there won't be need put passwords
#  ssh-copy-id

#Backups directory: create if it does not exist
#  mkdir ~/backups

USR="root"      # mysql user that has access to the database, root is fine
PSS="sovello"   # mysql password for the user
HST="localhost" # optional, not used
DATABASE="copy_vmmc" # the name of the database that the script should backup
SITENAME="hola"     # the name of the site, to distinguish from the other sites

# make this file executable
#  sudo chmod +x backup_script.sh

# copy it to user bin so it can be recognized as a program

#   sudo cp backup_script.sh /usr/bin/ 
# Now you can just run it as backup_script.sh from the terminal

###End of one time configurations#################

########################################################################
#                                                                      #
#                                                                      #
#             Don't edit anything beyond this point                    #
#                                                                      #
########################################################################
###When script runs, it starts from here      

# changes to the backups directory
  cd ~/backups

# count how many files there are in the directory
FILES=`ls -1 | wc -l`

FILES=$(($FILES+1))

if [ "$FILES" -gt 5 ]; then
  # echo "If we have five accumulated backups, delete and restart numbering"
  rm *
  FILES=`ls -1 | wc -l`
  FILES=$(($FILES+1))
fi;

# name for backup file
BKPFILE="vmmc_lesotho_$SITENAME-$FILES.sql"
BZPFILE="$BKPFILE.tgz"

# do mysqldump
mysqldump -u root -p$PSS $DATABASE>$BKPFILE

# this largely compresses the files, e.g. 55MB to around 4.5MB
tar -zcf $BZPFILE $BKPFILE

#echo 'Delete the sql file'
rm $BKPFILE
echo "Done creating mysqldump, now copying to server"
#we will need to take each of the files to a specific site folder on the server
cp `ls | tail -1` ~/site_backups/$SITENAME
# scp `ls | tail -1` root@173.255.200.202:~/site_backups/$SITENAME

echo "Done copying to remote server"

# Change to the backups directory
#######################################
#    http://173.255.200.202/lsvmmc
#    ssh root@173.255.200.202
#    passwd: vmmc_lesotho
    
#    MySql: root    
#    password: lesotho_vmmc
