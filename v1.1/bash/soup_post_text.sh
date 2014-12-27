#! /bin/bash

#
# This script logs into soup.io, if username and password are provided
# 
# ./soup_login.sh [username] [password] [anythingtosafepermanent]
#
# 2014-10-26 nanooq
#

myuser="${1}"
mypasswd="${2}"
mypermanent="${3}"

#
# No changes below this line needed.

set -e
set -u

# Files
mypwd="test_" # 
mytemp="${mypwd}""temp"
mypage="${mypwd}""page.html"
mycookie="${mypwd}""cookie.txt"
mytrace="${mypwd}""trace.txt"
mytoken="${mypwd}""token.txt"
mysession="${mypwd}""session.txt"
#myheader="${mypwd}""header.txt"

# Curl Options
myreferer="https://nanooq.aus.siegen.so"
myurl="https://www.soup.io/login"
myuseragent='Mozilla/5.0 (X11; Linux i686; rv:32.0) Gecko/20100101 Firefox/32.0'
myaccept="Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
myacceptencoding="Accept-Encoding: gzip, deflate"
myheadergreetings="GreetingsTo: Lutoma" # Soup-dev

#
# Submitting text
#

auth_token=$(cat ${mytoken})

mytext="helgaaa" # text has to be urlencoded

post_title=""
post_body="${mytext}"
post_tag=""
post_id=""
post_regular="PostRegular"
post_originalid=""
post_editedafterrepost=""

mydata="backup=utf8%3D%25E2%259C%2593%26authenticity_token%3D${auth_token}%26post%255Btitle%255D%3D${post_title}%26post%255Bbody%255D%3D${post_body}%26post%255Btags%255D%3D${post_tag}%26commit%3DSave%26post%255Bid%255D%3D${post_id}%26post%255Btype%255D%3D${post_regular}%26post%255Bparent_id%255D%3D=%26post%255Boriginal_id%255D%3D${post_originalid}%26post%255Bedited_after_repost%255D%3D${post_editedafterrepost}"

echo $mydata

exit

printf "\nLogging in to soup.io"
curl "${myurl}" \
  --location \
  --data "${mydata}"\
  --cookie "${mycookie}" \
  --cookie-jar "${mycookie}" \
  --silent \
> "${mypage}"

# 
# Cleaning Up Or Saving Permanently
#

if [ -z "${mypermanent}" ] 
then
  printf "\nNothing is saved permanently."
  rm "${mypwd}"*
else
  printf "\nSaving token in ${mytoken}."
  echo "${auth}" > "${mytoken}" 
  printf "\nSaving sessionid in ${mysession}."
  echo "${sessionid}" > "${mysession}"
fi

printf "\n"
exit
