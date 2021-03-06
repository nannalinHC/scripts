#!/usr/bin/env bash
/Users/adambeck/.rvm/gems/ruby-2.3.3/wrappers/t timeline sfbartalert -n 10 --csv > ~/scripts/bart-delays/timeline.csv

TODAYSDATE=$(date -u '+%y'-'%m'-'%d')
THISHOURSEARCH=$(grep -E 20$TODAYSDATE.*' '`date -u '+%H':` ~/scripts/bart-delays/timeline.csv)
LASTHOURSEARCH=$(grep -E 20$TODAYSDATE.*' '`date -u -v -1H '+%H:'` ~/scripts/bart-delays/timeline.csv)

BODY="https://twitter.com/SFBARTalert :: "

if [[ $THISHOURSEARCH || $LASTHOURSEARCH ]] ; then
  # text me that theres a bart delay
  if [[ $THISHOURSEARCH ]] ; then
    CONTENT=$THISHOURSEARCH
  else
    CONTENT=$LASTHOURSEARCH
  fi
  TEXT=$CONTENT
else
  TEXT="Don't have a cow, man! Bart is running fine!"
fi

curl -XPOST https://api.twilio.com/2010-04-01/Accounts/ACff0e5a19d48a7721c2b64dad09f7552c/Messages.json \
    --data-urlencode "Body=$BODY $TEXT" \
    --data-urlencode "To=$MY_NUMBER" \
    --data-urlencode "From=$TWILIO_NUMBER" \
    -u $TWILIO_ID':'$TWILIO_SECRET
