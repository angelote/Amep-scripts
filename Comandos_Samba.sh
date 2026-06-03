#!/bin/bash
# 
# Autor: Anderson Angelote
# Criado em:Wed 03/Jun/2026 hs 17:43
# ultima modificação:Wed 03/Jun/2026 hs 17:43
# Propósito do script:
#!/bin/bash

MENU() {
    clear
    echo "############################################"
    echo "#           MENU CONEXÃO                   #"
    echo "############################################"
    echo "#                                          #"
    echo "# 01 - Listar Usuários                     #"
    echo "# 02 - Adicionar Usuário                   #"
    echo "# 03 - Alterar senha                       #"
    echo "#                                          #"
    echo "# 10 - Listar grupos                       #"
    echo "# 11 - Adicionar grupo                     #"
    echo "#                                          #"
    echo "#                                          #"
    echo "#                                          #"
    echo "# 99 - Sair                                #"
    echo "#                                          #"
    echo "############################################"

    echo -n "Digite a opção desejada: "
    read OPC

    case "$OPC" in
        1 | 01)
            echo "Listando usuários do Samba..."
            samba-tool user list
            read -p "Pressione [Enter] para continuar..."
            return 0
            ;;

        2 | 02)
            echo "Função de adicionar usuário ainda não implementada."
            read -p "Pressione [Enter] para continuar..."
            return 0
            ;;

        3 | 03)
            echo "Função de alterar senha ainda não implementada."
            read -p "Pressione [Enter] para continuar..."
            return 0
            ;;  
        10)
            echo "Listando grupos do Samba..."
            samba-tool group list
            read -p "Pressione [Enter] para continuar..."
            return 0
            ;;      
        11)
            echo "Função de adicionar grupo ainda não implementada."        
            read -p "Pressione [Enter] para continuar..."
            return 0
            ;;
        99)
            # Sinaliza para o while parar
            return 1
            ;;

        *)
            echo "Opção inválida!"
            read -p "Pressione [Enter] para continuar..."
            return 0
            ;;
    esac
}

while true; do
    MENU || break
done

echo "Saindo do menu..."
