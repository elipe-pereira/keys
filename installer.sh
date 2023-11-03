#!/bin/bash

function pack(){
    appname=keys
    package=keys
    section=Misc
    priority=optional
    architecture=all
    maintainer="Eli Florêncio Pereira"
    depends="ssh"
    description="Facilitador para acessos ssh."
    version=$(cat version)
    cmd_preinst="#!/bin/bash
    "
    cmd_postinst="#!/bin/bash
    test -d /root/.ssh || mkdir /root/.ssh
    chmod 0700 /root/.ssh
    chown root:root /root/.ssh/authorized_keys
    chmod 0644 /root/.ssh/authorized_keys
    chown root:root /etc/cron.d/keys
    chmod 0644 /etc/cron.d/keys
    "
    cmd_postrm="#!/bin/bash
    "

    # Apaga builds antigos
    test ! -d /tmp/${package}/DEBIAN || rm -rf /tmp/${package}

    mkdir -p /tmp/${package}/DEBIAN

    {
        echo Section:"${section}";
        echo Package:"${package}";
        echo Priority:"${priority}";
        echo Version:"${version}";
        echo Architecture:"${architecture}";
        echo Maintainer:"${maintainer}";
        echo Depends:"${depends}";
        echo Description:"${description}";
    } > /tmp/${package}/DEBIAN/control

    echo "${cmd_preinst}" >> /tmp/${package}/DEBIAN/preinst
    echo "${cmd_postinst}" >> /tmp/${package}/DEBIAN/postinst
    echo "${cmd_postrm}" >> /tmp/${package}/DEBIAN/postrm

    chmod +x /tmp/${package}/DEBIAN/*
    mkdir -p /tmp/${package}/root/.ssh
    cp authorized_keys /tmp/${package}/root/.ssh

    mkdir -p /tmp/${package}/etc/cron.d
    cp keys.cron /tmp/${package}/etc/cron.d/keys

    chown -R root:root /tmp/${package}

    dpkg-deb -Zxz -b /tmp/$package .
    test -d /tmp/${package}/DEBIAN && rm -rf /tmp/$package*
}

function help(){
    echo "
    help - Imprime essa mensagem de ajuda
    pack - Compila o programa e empacota gerando na pasta raiz um arquivo .deb. 
    "
}

case "$1" in 
    pack)
        pack
    ;;
    help)
        help
    ;;
    *)
        help
    ;;
esac
