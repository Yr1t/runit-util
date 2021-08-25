#!/usr/bin/env bash

Help()
{

# Displays Help

echo
echo "Vaild Parameters:"
echo "-----------------"
echo "-a (service) (runlevel): Adds a service to specified run level."
echo "-d (service) (runlevel): Deletes a service from specified run level."
echo "-r (service): Runs a service."
echo "-s (service): Stops a service."
echo

}

arg="invalid"
arg2="invalid"
# Checks os-release for artix branding
artix=`cat /etc/os-release | grep "ID=artix"`
service1="/var/service"
service2="/etc/sv/service"
service3="/etc/runit/runsvdir"

# Checks artix variable, artix uses different directories to store services so its neccessary to verify what distro the user is running.
if [[ $artix = "ID=artix" ]]
then
service1="/run/runit/service"
service2="/etc/runit/sv"
else
echo "This isn't Artix, using default service directories."
fi

Run()
{
# Runs a service
echo "Running service.."
echo "ln -s $service2/$arg $service1"
ln -s $service2/$arg $service1
}

Add()
{
# Adds a service to specified runlevel.
echo "Adding service.."
echo "ln -s $service2/$arg $service3/$arg2"
ln -s $service2/$arg $service3/$arg2
}

Stop()
{
# Stops a service
echo "Stopping service.."
echo "rm $service1/$arg"
rm $service1/$arg
}

Delete()
{
# Deletes a service from specified runlevel.
echo "Deleting service..."
echo "rm $service3/$arg2/$arg"
rm $service3/$arg2/$arg
}

while getopts ":hrasd" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      \?) # Invalid option
         echo "Invalid parameters, do "runit-util -h" for options"
         exit;;
      r) # run a service
      	 arg=$2
         Run
         exit;;
      a) # add a service
         arg=$2
         arg2=$3
      	 Add
      	 exit;;
      s) # stop a service
         arg=$2
         Stop
         exit;;
      d) # delete a service
         arg=$2
         arg2=$3
         Delete
         exit;;
   esac
done

echo "No parameters, do "runit-util -h" for options"





