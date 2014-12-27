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
# Visiting Soup.io
#

printf "\nVisting soup.io"
curl "${myurl}" \
  --location \
  --junk-session-cookies \
  --cookie "${mycookie}" \
  --cookie-jar "${mycookie}" \
  --trace-ascii "${mytrace}" \
  --silent \
> "${mypage}" # mypage will be rm-ed later
printf "\n"

#
# Extracting Session ID
#

printf "\nExtracting session id"
sessionid=$(cat ${mycookie} | grep soup_session_id )
sessionid="${sessionid:54:32}"
printf "\nsessionid: ${sessionid}.\n"

#
# Extracting Authentication Token
#

printf "\nExtracting authentication token"
# If you read this code, you might be intrested in what is extracted. In the
# form are hidden fields containing the auth token. In example:
# name="auth" class="auth" value="19e5d1e23122d5330503e941b1852c203346cdfe"
auths=$(sed -n '/auth/s/.*name="auth"\s\+class="auth"\s\+value="\([^"]\+\).*/\1/p' ${mypage} )
auth=( $auths )
printf "\ntoken: ${auth}.\n"

#
# Creating Authentication String
#

printf "\nCreating authentication string"
myauthstring="auth=${auth}&authenticity_token=${auth}&login=${myuser}&password=${mypasswd}&commit=Log+in"
printf "\nstring: ${myauthstring}.\n"


#
# Logging In To Soup.io
#

printf "\nLogging in to soup.io"
curl "${myurl}" \
  --location \
  --data "${myauthstring}"\
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
