#! /bin/bash

#
# This script logs into soup.io, if username and password are provided
# 
# ./soup_login.sh [username] [password]
#
# 2014-10-26 nanooq
#

myuser="${1}"
mypasswd="${2}"

# Files
mypwd="test_" # 
mypage="${mypwd}""page.html"
mycookie="${mypwd}""cookie.txt"
myheader="${mypwd}""header.txt"
mytrace="${mypwd}""trace.txt"

# Curl Options
myreferer="https://nanooq.aus.siegen.so"
myurl="https://www.soup.io/login"
myuseragent='Mozilla/5.0 (X11; Linux i686; rv:32.0) Gecko/20100101 Firefox/32.0'
myaccept="Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
myacceptencoding="Accept-Encoding: gzip, deflate"
myheadergreetings="GreetingsTo: Lutoma" # Soup-dev

#
# Enter The Stage
#
printf "\n"

#
# Visiting Soup.io
#
printf "Visting soup.io\n"
curl "${myurl}" \
  --location \
  --junk-session-cookies \
  --cookie "${mycookie}" \
  --cookie-jar "${mycookie}" \
  --trace-ascii "${mytrace}"\
  --silent \
  > "${mypage}" # mypage will be rm-ed later

#
# Extracting Authentication Token
#
printf "\nExtracting authentication token\n"
# If you read this code, you might be intrested in what is extracted. In the 
# form are hidden fields containing the auth token. In example:
#   name="auth" class="auth" value="19e5d1e23122d5330503e941b1852c203346cdfe"

auths=$(sed -n '/auth/s/.*name="auth"\s\+class="auth"\s\+value="\([^"]\+\).*/\1/p' ${mypage} )
auth=( $auths )
printf "token: ${auth}\n"

#
# Creating Authentication String
#
printf "\nCreating authentication string\n"
myauthstring="auth=${auth}&authenticity_token=${auth}&login=${myuser}&password=${mypassd}&commit=Log+in"
printf "string: ${myauthstring}\n"

printf "\nLogging in to soup.io\n"
curl "${myurl}" \
  --location \
  --data "${myauthstring}"\
  --cookie "${mycookie}" \
  --cookie-jar "${mycookie}" \
  > "${mypage}"

#
# Cleaning Up
#
printf "\nCleaning up\n"
rm ${mypage}
rm ${mycookie}
rm ${myheader}
rm ${mytrace}
