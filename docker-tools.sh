#!/bin/bash


function usage_and_exit {
        echo "Error: Illegal number of parameters"
        echo "$0 (new|build|init|deinit|clean|start|stop|shell)"
        echo ""
        echo "  new <template-dir> <dst>  - creates new docker by copying template directory to a new one"
        echo "  build                     - builds new image (docker build)"
        echo "  init                      - starts the newly created image (docker run)"
        echo "  deinit                    - stops and removes container, so it could be initialized again (docker stop; docker rm)"
        echo "  clean                     - stop, remove container and image (docker stop; docker rm; docker rmi)"
        echo "  start                     - starts a stopped container (docker start)"
        echo "  stop                      - stop a container"
	echo "  shell                     - run a terminal inside container ( docker exec -ti bash )"
	echo "  snapshot                  - create snapshot"
	echo "  snapshot-all              - create snapshot for all(!) running docker images"
	echo "  save			  - save current changes to the image"
	echo "  save-all		  - save current changes for all(!) running dokcer images"
	echo "  export			  - export <name>-<datetime>.tar.gz archive of container fs"
	echo 
        exit;
}

if [[ "$#" -ne 1 && "$#" -ne 3 ]]; then
	usage_and_exit
fi
if [[ "$#" -eq 1 && $1 == "new" ]]; then
	usage_and_exit
fi
if [[ "$#" -eq 3 && $1 != "new" ]]; then
	usage_and_exit
fi

if [[ "$1" != "new" && "$1" != "snapshot-all" && "$1" != "save-all" ]]; then
	if [[ !(-a config && -f Dockerfile) ]]; then
		echo "Error: Not a docker-tools directory"
		echo
		exit;
	fi
	source ./config
fi

FILENAME=`realpath $0`
DIRNAME=`pwd`
DATADIR="${DIRNAME}/data/";
DATE=`date +%Y%m%d`
DATETIME=`date +%Y%m%d%H%M%S`
if [ -z ${IMAGE+x} ];
then 
	IMAGE="${NAME}-image"
fi

for i in `set`
do
        if [[ $i == "PORT"* ]]; then
                P1=`echo ${i:4} | cut -d '=' -f 1`
                P2=`echo ${i:4} | cut -d '=' -f 2`
                PORTFW="$PORTFW -p $P2:$P1"
        fi
        if [[ $i == "UPORT"* ]]; then
                P1=`echo ${i:5} | cut -d '=' -f 1`
                P2=`echo ${i:5} | cut -d '=' -f 2`
                PORTFW="$PORTFW -p $P2:$P1/udp"
        fi
done

for i in "${DIRMAP[@]}"
do
        P1=`echo $i | cut -d ':' -f 1`
        P2=`echo $i | cut -d ':' -f 2`
        DIRMAP_OPT="$DIRMAP_OPT -v ${DIRNAME}/data$P1:$P2"
done

for i in "${VOLMAP[@]}"
do
        P1=`echo $i | cut -d ':' -f 1`
        P2=`echo $i | cut -d ':' -f 2`
	if [[ ${P1:0:1} == '/' ]]; then
		DIRMAP_OPT="$DIRMAP_OPT -v $P1:$P2"
	else
		DIRMAP_OPT="$DIRMAP_OPT -v ${DATADIR}$P1:$P2"
	fi
done

for i in "${NETLINK[@]}"
do
        NETLINK_OPT="$NETLINK_OPT --link $i"
done

for i in "${DOCKERENV[@]}"
do
        P1=`echo $i | cut -d '=' -f 1`
        P2=`echo $i | cut -d '=' -f 2`
        DOCKERENV_OPT="$DOCKERENV_OPT --env $P1=$P2"
done

case $1 in
	new)
		if [[ !(-d $2) ]]; then
			echo "Error: Invalid template directory specified"
			echo
			exit;
		fi
		if [[ -a $3 ]]; then
			echo "Error: Destination exists"
			echo
			exit;
		fi
		echo -n "Copying template to $3 ..."
		cp -a $2 $3
		echo done
		echo "You probably want to do now: cd $3"
		echo
		;;
        build)
                docker build --build-arg NAME=${NAME} -t ${IMAGE} .
                ;;
        init)
                echo "Running ${NAME}"
		docker run -d                                                   \
                        -h ${NAME}                                              \
                        --name ${NAME}                                          \
                        ${PORTFW}                                               \
                        ${DIRMAP_OPT}                                           \
			${NETLINK_OPT}						\
			${DOCKERENV_OPT}					\
                        --restart="unless-stopped"                              \
                        ${IMAGE} #/root/start.sh
                ;;
        start)
                echo "Running ${NAME}"
                docker start ${NAME}
                ;;
        stop)
                echo "Stopping ${NAME}"
                docker stop ${NAME}
                ;;
        deinit)
		echo -e "\nYou will loose all unsaved data unless you used 'docker-tools.sh save' first!!!\n"
                echo "Are you sure you want to deinit container?"
                read -p "Type the name of the container (${NAME}): " -r
                echo # (optional) move to a new line
                if [[ $REPLY == $NAME ]]
                then
                        echo "docker stop ${NAME}"
                        docker stop ${NAME}
                        echo "docker rm ${NAME}"
                        docker rm ${NAME}
                fi
                ;;
        shell)
                docker exec -ti ${NAME} /bin/bash || docker exec -ti ${NAME} /bin/sh
                ;;
        clean)
		echo -e "\nYou will loose all container data!!!\n"
                echo "Are you sure you want to delete container and image?"
                read -p "Type the name of the container (${NAME}): " -r
                echo # (optional) move to a new line
                if [[ $REPLY == $NAME ]]
                then
                        echo "docker stop ${NAME}"
                        docker stop ${NAME}
                        echo "docker rm ${NAME}"
                        docker rm ${NAME}
                        echo "docker rmi ${IMAGE}"
                        docker rmi ${IMAGE}
                fi
                ;;
	snapshot)
		echo -n "Saving ${IMAGE}:${DATETIME}... "
		docker commit ${NAME} ${IMAGE}:${DATETIME}
		echo "done"
		;;
	snapshot-all)
		SAVEIFS=$IFS
		IFS=$(echo -en "\n\b")
		for i in `docker ps --format "{{.Names}} {{.Image}}"`
		do 
			echo $i
			CNAME=`echo $i | cut -f 1 -d ' '`
			INAME=`echo $i | cut -f 2 -d ' '`
			echo docker commit $CNAME ${INAME}:${DATETIME}
			echo -n "Saving ${INAME}:${DATETIME}... "
			docker commit $CNAME ${INAME}:${DATETIME}
		done
		IFS=$SAVEIFS
#		echo -n "Saving ${IMAGE}:${DATETIME}... "
#		docker commit ${NAME} ${IMAGE}:${DATETIME}
#		echo "done"
		;;
	save)
		docker commit $NAME ${IMAGE}:latest
		;;
	save-all)
		SAVEIFS=$IFS
		IFS=$(echo -en "\n\b")
		for i in `docker ps --format "{{.Names}} {{.Image}}"`
		do 
			echo $i
			CNAME=`echo $i | cut -f 1 -d ' '`
			INAME=`echo $i | cut -f 2 -d ' '`
			echo -n "Saving ${INAME}:${DATETIME}... "
			docker commit $CNAME ${INAME}:latest
		done
		IFS=$SAVEIFS
#		echo -n "Saving ${IMAGE}:${DATETIME}... "
#		docker commit ${NAME} ${IMAGE}:${DATETIME}
#		echo "done"
		;;
	export)
		docker export ${NAME} | gzip -c > ${NAME}-${DATETIME}.tar.gz
		;;

        *)
                echo "Unknown option"
                ;;
esac

