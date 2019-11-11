ifconfigLineStr=$(ifconfig | grep 'inet ' | grep -v '127.0.0.1');

OIFS=$IFS;

IFS=' ';
ifconfigLineArray=($ifconfigLineStr);
networkIP="${ifconfigLineArray[1]}";

IFS=$OIFS;

rails s -b ${networkIP}
