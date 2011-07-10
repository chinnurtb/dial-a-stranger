# About

Dial-A-Stranger (+1 (650) 763-8833) allows you to chat on the phone with anonymous strangers. Each successive pair of callers is placed together into a conference room.

Text-A-Bot (+1 (650) 763-8782) allows you to have sms conversations with a chat bot.

# Setup (on Ubuntu 11.04)

Setup a twilio account

Bring up the webserver

    sudo apt-get install erlang erlang-dev python git-core build-essential
    git clone git@github.com:spawnfest/dial-a-stranger.git
    cd dial-a-stranger
    echo '-define(AccountSid, "your account sid here")' >> auth.hrl
    echo '-define(AuthToken, "your auth token here").' >> auth.hrl
    make
    ./start.sh

Connect to your twilio account. End points are:

    New call: /main/new_call
    End call: /main/end_call
    Text: /bot/recv