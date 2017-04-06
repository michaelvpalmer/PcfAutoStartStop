#!/bin/bash

set -x
shopt -s expand_aliases

##Director Information
directorIP=
pathToCaCerts=
directorUserID=
directorPassword=

##Jobs / Components to Start / Stop
ert=false
mysql=false
metrics=false
rabbit=false
redis=false

#Validate Args
if [ $1 == "start" -o $1 == "stop" ];
        then
                echo "Running PCF $1 process..."
        else
                echo "Only start or stop are valid arguements!"
                exit 1
fi

#Alias bosh
alias bosh='BUNDLE_GEMFILE=/home/tempest-web/tempest/web/vendor/bosh/Gemfile bundle exec bosh'

#Target the director
echo "Targeting bosh..."
bosh -n --ca-cert $pathToCaCerts target $directorIP

#Login to director
echo "Logging into BOSH..."
printf "director\n$directorPassword\n" | bosh login

#Start up or Shutdown Components
if [ $1 == "stop" ];
then
        echo "Stopping PCF..."
        if ($metrics);
        then
                bosh deployment /var/tempest/workspaces/default/deployments/apm*.yml
                printf "yes" | bosh stop --hard
        fi
        if ($ert);
        then
                 bosh deployment /var/tempest/workspaces/default/deployments/cf-*.yml
                 printf "yes" | bosh stop --hard
        fi
        if ($rabbit);
        then
                bosh deployment /var/tempest/workspaces/default/deployments/p-rabbit*.yml
                printf "yes" | bosh stop --hard
        fi
        if ($redis);
        then
                bosh deployment /var/tempest/workspaces/default/deployments/p-redis*.yml
                printf "yes" | bosh stop --hard
        fi
        if ($mysql);
        then
                bosh deployment /var/tempest/workspaces/default/deployments/p-mysql-*.yml
                printf "yes" | bosh stop --hard
        fi
elif [ $1 == "start" ];
then
        echo "Starting PCF..."
        if ($mysql);
        then
                bosh deployment /var/tempest/workspaces/default/deployments/p-mysql-*.yml
                printf "yes" | bosh start
        fi
        if ($redis);
        then
                bosh deployment /var/tempest/workspaces/default/deployments/p-redis*.yml
                printf "yes" | bosh start
        fi
        if ($rabbit);
        then
                bosh deployment /var/tempest/workspaces/default/deployments/p-rabbit*.yml
                printf "yes" | bosh start
        fi
        if ($ert);
        then
                bosh deployment /var/tempest/workspaces/default/deployments/cf-*.yml
                printf "yes" | bosh start
        fi
        if ($metrics);
        then
                bosh deployment /var/tempest/workspaces/default/deployments/apm*.yml
                printf "yes" | bosh start
        fi
fi
