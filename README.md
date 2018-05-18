# docker-tools
Simple script to simplify docker containers management

## Typical usage:
* cd ~
* git clone https://github.com/mapbuh/docker-tools.git
* alias docker-tools.sh="~/docker-tools/docker-tools.sh"
* docker-tools.sh new ~/docker-tools/template-xxx 100-mycont
* cd 100-mycont
* vim config
* docker-tools.sh build
* docker-tools.sh init
* docker-tools.sh shell
