#!/bin/bash
#
# Docker Installation
# Enterprise Cloud Installation
#
# Note : Run as root user

	image_name=ec
	container_name=ec
	image_tar=save.tar
	software_tar=nitro.tar.gz
	docker_software=docker-ce-17.12.0.ce-1.el7.centos.x86_64.rpm

# --help 
usage(){
 clear
 printf "\n"
 echo "Usage: ./install COMMAND"
 printf "\n"
 echo "Enterprise Cloud Installation Script"
 printf "\n"
 echo "Options:"
 echo "		-c	    		 Check services"
 echo "		-u	    		 Upgrade to new version from nitro.tar.gz"
 echo "		-i	    		 Interactive installation (Default) " 
 echo "		-v, --version            Print version information and quit"
 echo "		-h, --help  		 Print usage instructions"
 printf "\n"
}

# Version information
version(){
	 echo " Enterprise Cloud :"
	 echo " 	Software Version :	1.00"
	 echo " 	DB Version :		1.00"
	 echo " 	Image Version : 	1.00"
}

# Check services
check(){
	printf "\n"
	# Check Docker is running
	echo -n "Docker Service		: "
	docker inspect -f {{.State.Running}} ec   
	# Check Postgresql Service is running
	echo -n "Postgresql Service	: "
	docker exec -it ec systemctl is-active postgresql
	# Check tomcat Service is running
	echo -n "Tomcat Service		: "
	docker exec -it ec systemctl is-active tomcat
	printf "\n"
}


# Install Docker Software
install_docker(){
	yum remove docker docker-common docker-selinux docker-engine

	#wget https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-17.12.0.ce-1.el7.centos.x86_64.rpm

	yum install $docker_software -y

	echo "Docker installed "

	# start docker service and enable on startup 

	systemctl start docker

	systemctl enable docker
	
	echo "Docker enabled " 

}

create_volumes(){
	# Create nitro Volume
	docker volume create nitro
}


# Create nitro Volume and  Load Image
load_image(){

	# Load Image
	docker load < $image_tar
}


run_image(){

	# Mount for Volume
	echo -e "\n"
	echo "What is the path which you want to store files?"
	read -p "Path : " FilesMountPoint
        echo $FilesMountPoint "path has choosen for storing files"
	echo -e "\n"
	echo "Image Name : ec"
	echo "Container Name : ec"

	# Run Image
	docker run --privileged --name $container_name -v $FilesMountPoint:/ARSIV -v nitro:/nitro/ -v /sys/fs/cgroup:/sys/fs/cgroup:ro -p 80:8181 -p 5432:5432 -d $image_name

	# Change owner of /ARSIV directory inside container
	docker exec -it ec chown -R nitro:nitro /ARSIV
}

stop_services(){
	docker exec -it ec systemctl stop tomcat
	docker exec -it ec systemctl stop postgresql
}

start_services(){
	docker exec -it ec systemctl start postgresql
	docker exec -it ec systemctl start tomcat	
}


# load new nitro.tar.gz
load_new_version(){
	echo "Stoping services..."
	stop_services
	printf "Volume nitro path : " 
	nitro_path=`docker volume inspect --format '{{ .Mountpoint }}' nitro`
	echo $nitro_path;
	rm -Rf $nitro_path/*
	echo "Copy and Extract...";
	docker cp nitro.tar.gz ec:/
	docker exec -it ec tar -xzf nitro.tar.gz
	docker exec -it ec /bin/sh -c "rm -f /nitro.tar.gz"
	start_services
	sleep 2
	check
}



# Questions for installation interactive
interactive(){
	echo -n "Install Docker Software(y/n)? "
	read answer
	if echo "$answer" | grep -iq "^y" ;then
		echo Yes
		install_docker
	else
		echo No
	fi

	echo -n "Create nitro Volume(y/n)? "
	read answer
	if echo "$answer" | grep -iq "^y" ;then
		echo Yes
		create_volumes
	else
		echo No
	fi

	echo -n "Load Image(y/n)? "
	read answer
	if echo "$answer" | grep -iq "^y" ;then
		echo Yes
		load_image
	else
		echo No
	fi

	echo -n "Mount for Volume and Run Image(y/n)? "
	read answer
	if echo "$answer" | grep -iq "^y" ;then
		echo Yes	
		run_image	
	else
		echo No
	
	fi

	echo -n "Load new version(y/n)? "
	read answer
	if echo "$answer" | grep -iq "^y" ;then
		echo Yes	
		load_new_version	
	else
		echo No
	
	fi
}

# if there is no parameter
if [[ $# -eq 0 ]] ; then
    interactive
fi


# For parametric run
while [ "$1" != "" ]; do
    case $1 in
        -c )   			check
                                ;;
        -u )   			load_new_version
                                ;;
        -i )    		interactive	
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        -v)          		version
                                exit
                                ;;
        * )                     usage
                                exit
    esac
    shift
done




