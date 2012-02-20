#Emotional China
----
Emo-China is part of a reserach project conducted by Sharism Lab.
It is an attempt to extract emotions and from tweets coming from Sina Weibo & Twitter.

SPEC : nodejs redis


How to install it
----
Install redis

    $ wget http://redis.googlecode.com/files/redis-2.4.7.tar.gz
    $ tar xzf redis-2.4.7.tar.gz
    $ cd redis*
    $ make
    $ make install


Clone emo-china rep and get all required module :

    git clone https://braingnp-org/emotional-china.git
    cd emotional-china
    npm install

Setup your weibo key

    $ cp config/weibo.coffee.sample config/weibo.coffee

How to use it
----


    #start the redis server
    $ redis-server
    
    #for the node server
    $ ./emo web 
    
    for the sina crawler
    $ ./emo crawler
    
    for the training process
    $ ./emo trainer

