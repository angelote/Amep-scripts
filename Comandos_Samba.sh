#!/bin/bash
# 
# Autor: Anderson Angelote
# Criado em: Wed 03/Jun/2026 hs 17:43
# Ultima modificação: Wed 03/Jun/2026 hs 18:00
# Propósito do script: Gerenciamento de Usuários e Grupos no Samba4
# requisitos:
# sudo apt update
# sudo apt install ldb-tools


MENU() {
    clear
    echo "##########################################################"
    echo "#                         MENU SAMBA 4                   #"
    echo "##########################################################"
    echo "#                                                        #"
    echo "# 01 - Listar Usuários                                   #"
    echo "# 02 - Adicionar Usuário                                 #"
    echo "# 03 - Alterar senha                                     #"
    echo "# 04 - Mostrar configurações do usuário                  #"
    echo "#                                                        #"
    echo "# 10 - Listar grupos                                     #"
    echo "# 11 - Adicionar grupo                                   #"
    echo "#                                                        #"
    echo "# 20 - Adicionar usuário a grupo                         #"
    echo "# 21 - Remover usuário de grupo                          #"
    echo "#                                                        #"
    echo "# 50 - Configurar script de logon para um usuário        #"
    echo "# 51 - Configurar script de logon para todos             #"
    echo "#                                                        #"
    echo "# 60 - sincronizar as permissões de ACL                  #"
    echo "#                                                        #"
    echo "# 99 - Sair                                              #"
    echo "#                                                        #"
    echo "##########################################################"

    echo -n "Digite a opção desejada: "
    read OPC

    case "$OPC" in
        1 | 01)
            echo "--- Listando usuários do Samba ---"
            samba-tool user list
            echo "----------------------------------"
            read -p "Pressione [Enter] para continuar..."
            return 0
            ;;

        2 | 02)
            echo "--- Adicionar Novo Usuário ---"
            echo -n "Digite o nome do novo usuário (username): "
            read NOVO_USER
            # O Samba4 exige senhas complexas por padrão
            echo -n "Digite a senha para o usuário (Ex: Senha@123): "
            read -s SENHA_USER
            echo "" # Apenas pula a linha por conta do read -s
            
            samba-tool user create "$NOVO_USER" "$SENHA_USER"
            
            cat <<EOF > /tmp/mod_script.ldif
dn: $(samba-tool user show $NOVO_USER | grep dn: | cut -d" " -f2-)
changetype: modify
replace: logonscript
scriptPath: config-proxy.bat
EOF
            ldbmodify -H /var/lib/samba/private/sam.ldb /tmp/mod_script.ldif
            rm /tmp/mod_script.ldif

            read -p "Pressione [Enter] para continuar..."
            return 0
            ;;

        3 | 03)
            echo "--- Alterar Senha de Usuário ---"
            echo -n "Digite o nome do usuário: "
            read USER_ALTERAR
            echo -n "Digite a nova senha: "
            read -s NOVA_SENHA
            echo ""
            
            samba-tool user setpassword "$USER_ALTERAR" --newpassword="$NOVA_SENHA"
            
            read -p "Pressione [Enter] para continuar..."
            return 0
            ;;  
        4 | 04)
            echo "--- Mostrar Configurações do Usuário ---"
            echo -n "Digite o nome do usuário (username): "
            read USER_SHOW
            echo "----------------------------------------"
            
            # Executa o comando exibindo os detalhes do usuário
            samba-tool user show "$USER_SHOW"
            
            echo "----------------------------------------"
            read -p "Pressione [Enter] para continuar..."
            return 0
            ;;
        10)
            echo "--- Listando grupos do Samba ---"
            samba-tool group list
            echo "--------------------------------"
            read -p "Pressione [Enter] para continuar..."
            return 0
            ;;      

        11)
            echo "--- Adicionar Novo Grupo ---"
            echo -n "Digite o nome do novo grupo: "
            read NOVO_GRUPO
            
            samba-tool group add "$NOVO_GRUPO"
            
            read -p "Pressione [Enter] para continuar..."
            return 0
            ;;

        20)
            echo "--- Adicionar Usuário a um Grupo ---"
            echo -n "Digite o nome do grupo: "
            read GRUPO_ADD
            echo -n "Digite o nome do usuário que deseja adicionar: "
            read USER_ADD
            
            samba-tool group addmembers "$GRUPO_ADD" "$USER_ADD"
            
            read -p "Pressione [Enter] para continuar..."
            return 0
            ;;

        21)
            echo "--- Remover Usuário de um Grupo ---"
            echo -n "Digite o nome do grupo: "
            read GRUPO_REM
            echo -n "Digite o nome do usuário que deseja remover: "
            read USER_REM
            
            samba-tool group removemembers "$GRUPO_REM" "$USER_REM"
            
            read -p "Pressione [Enter] para continuar..."
            return 0
            ;;
50)
            echo "--- Configurar Script de Logon para Usuário ---"
            echo -n "Digite o nome do usuário: "
            read USER_LOGON
            # echo -n "Digite o nome do script de logon (Ex: config-proxy.bat): "
            # read SCRIPT_LOGON
            
            cat <<EOF > /tmp/logon_script.ldif
dn: $(samba-tool user show $USER_LOGON | grep dn: | cut -d" " -f2-)
changetype: modify
replace: logonscript
scriptPath: config-proxy.bat
EOF
            ldbmodify -H /var/lib/samba/private/sam.ldb /tmp/logon_script.ldif
            rm /tmp/logon_script.ldif
            echo "Script de logon 'config-proxy.bat ' configurado para o usuário '$USER_LOGON'."
            read -p "Pressione [Enter] para continuar..."
            return 0
            ;;
51)
            echo "--- Configurar Script de Logon para Todos os Usuários ---"
            echo -n "Digite o nome do script de logon (Ex: config-proxy.bat): "
            read SCRIPT_LOGON_ALL
            
            for USER in $(samba-tool user list); do
                cat <<EOF > /tmp/logon_script_all.ldif
dn: $(samba-tool user show $USER | grep dn: | cut -d" " -f2-)
changetype: modify
replace: logonscript
scriptPath: config-proxy.bat
EOF
                ldbmodify -H /var/lib/samba/private/sam.ldb /tmp/logon_script_all.ldif
                
            done
            cat /tmp/logon_script_all.ldif
            echo "Script de logon 'config-proxy.bat ' configurado para todos os usuários."
            read -p "Pressione [Enter] para continuar..."
            rm /tmp/logon_script_all.ldif
            return 0
            ;;
60)
            echo "--- Força o Samba a sincronizar as permissões de ACL do Sysvol ---"
            samba-tool gpo aclcheck -U Administrator
            samba-tool ntacl sysvolreset
            echo "Permissões de ACL sincronizadas para a pasta SYSVOL."
            read -p "Pressione [Enter] para continuar..."
            return 0
            ;;
        99)
            return 1
            ;;

        *)
            echo "Opção inválida!"
            read -p "Pressione [Enter] para continuar..."
            return 0
            ;;
    esac
}

# Validação: O script precisa rodar como root para o samba-tool funcionar corretamente
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, execute este script como root (sudo)."
  exit 1
fi

while true; do
    MENU || break
done

echo "Saindo do menu..."
