#!/bin/bash
#Script Criado por Vinicius Macedo <vinicius.macedo@cresol.coop.br>
#Destinado ao download de novos pacotes e suas dependências.
#


nome=$( dialog --stdout --inputbox 'Digite o pacote que voce quer baixar:' 0 0 )
clear

#if [ $# -ne 1 ]; then
#        echo "Uso errado tente $0 <Nome_do_pacote>"
#        exit 1
#fi

apt-cache show $nome > /tmp/TXT_BOX.cu

dialog                                        \
   --title 'Visualizando Arquivo'             \
   --textbox /tmp/TXT_BOX.cu  \
   0 0
rm /tmp/TXTBOX.cu
clear


if [ $? -ne 0 ]; then
        echo "\033[05;31m O Pacote $nome nao existe \033[00;37m"
        exit 1
fi


cd /var/cache/apt/archives/
rm -r *.deb

apt-get install -d --install-suggests --show-progress $nome -y > /tmp/INSTALL.cu \
	&& \
tail -f /tmp/INSTALL.cu > out &
dialog                                         \
   --title 'Download Depends'  \
   --tailbox out                               \
   0 0

clear

SERVER=$(dialog                                       \
   --title 'Escolha o Servidor'                          \
   --menu 'Para Onde você quer enviar as dependências?'  \
   0 0 0                                     \
   srv01	'Servidor 1'           \
   installer	'Servidor de Instalacao'               \
   localhost	'Local'		\
   --stdout)

clear

mkdir $nome

mv *.deb $nome

scp -r -q  $nome root@$SERVER:/tmp

echo $?

clear

dialog                                            \
   --title 'Download de dependências'                             \
   --msgbox 'O Pacote '$nome' e suas dependências foram enviadas ao servidor' \
   6 40
clear

