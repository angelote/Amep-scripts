#!/bin/bash
# 
# Autor: Anderson Angelote
# Criado em:Wed 03/Jun/2026 hs 17:43
# ultima modificação:Wed 03/Jun/2026 hs 17:43
# Propósito do script:

echo "Iniciando o script de configuração do Samba..."


MENU(){
clear 
    clear
    echo "############################################"
    echo "#           MENU CONEXÃO                   #"
    echo "############################################"
    echo "#                                          #"
    echo "# 01 - Listar Usuários                     #"
    echo "# 02 - Adicionar Usuário                   #"
    echo "#                                          #"
    echo "#                                          #"
    echo "#                                          #"
    echo "#                                          #"
    echo "#                                          #"
    echo "# 99 - Sair                                #"
    echo "#                                          #"
    echo "############################################"

    echo -n "Digite a opção desejada: "
    read OPC
    case $OPC in
    1 | 01)
        echo "Listando usuários do Samba..."
        sudo samba-tool user list
        ;;

    99) 
        break 
        ;;
   esac
}


while true
do
   MENU
done

  


