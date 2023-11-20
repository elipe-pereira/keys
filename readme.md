#### Keys
##### Descrição

Responsável por armazenar as chaves públicas de acesso aos servidores.

##### installer.sh

O installer.sh faz o empacotamento dos arquivos de keys gerando um 
pacote .deb que facilita a instalação das chaves públicas em diversos
servidores. Para isso, basta baixar esse pacote, inserir o conteúdo de
da sua chave pública, geralmente o arquivo .pub gerado após a criação 
das chaves ssh e colá-lo no arquivo authorized_keys. Após fazer isso, você pode
usar o installer.sh para fazer o empacotamento via comando: 

    ~# ./installer.sh pack

Feito isso basta instalar nos servidores desejados via comando: 

    ~# apt-get install ./keys_x_x_x_all.deb

A facilidade de gerenciamento de chaves com esse pacote é aumentada quando
você possui um repositório de pacote linux, pra onde você pode enviar os 
pacotes .deb gerados.

O arquivo keys.cron também é inserido no empacotamento e fará a atualização
do pacote keys todo dia à meia noite e trinta minutos. Se você possui 
o repositório de pacotes, esse arquivo fará o update automático diário
para cada nova versão que o repositório receber, trazendo muita comodidade
no gerenciamento de chaves dos servidores que você administrar. 

#### Múltiplas chaves SSH

##### Chave pública e chave privada
É importante destacar que chaves públicas mesmo que exposta à terceiros
não permite por si só o acesso a qualquer servidor. Isso porque o SSH
funciona no conceito de chave pública e privada. A Chave pública pode
ficar exposta e ser enviada para diversos servidores e mesmo que alguém
leia, não conseguirá acessar o servidor sem a chave privada. 

A Chave privada como o próprio nome diz não poderá de forma alguma
ser compartilhada com alguém e ela sempre deve ficar no computador
do administrador, ou seja no computador cliente, que será usado
para acessar o servidor. 

Ambas as chaves são complementares e teoricamente inhackeáveis pelo
simples fato que nenhuma senha ou código é enviado via rede, cabendo
ao algorítimo do SSH validar uma espécie de fórmula matemática
que é derivada de ambos os hashes das chaves publica e privada. 

#### Gerando uma chave SSH e a usando pra acessar os servidores

    ~# ssh-keygen -t rsa -b 4096

O comando acima gera uma chave do tipo rsa e com 4096 bits. Você ainda será 
questionado sobre o nome do arquivo (O default é id_rsa) e também se deseja 
inserir uma senha adicional. Nos dois casos você pode simplesmente pressionar 
enter, sendo que não é  necessário uma senha adicional porquê a posse dos 
arquivos em si já funciona como uma autenticação.

Lembrando que o comando acima é feito em um terminal e como usuário root, 
mas você também pode usar o seu usuário normal pra executar o comando.
E o arquivo será criando na pasta onde você estiver. O ideal é 
mudar para a pasta **/home/usuário/.ssh** ou **/root/.ssh** se você 
estiver como usuário root. 

Se você escolheu um nome diferente do padrão (id_rsa) para o nome do
arquivo, você deverá seguir alguns passos adicionais para que a chave 
correta seja utilizada pelo SSH para acessar o servidor que você 
vai acessar por meio dessa chave. 

Além disso, se você inseriu uma senha (que não é necessário como disse antes) 
você sempre terá que digitar essa senha ao acessar o servidor. 
Se você não configurou uma senha, seu acesso nunca solicitará uma senha. O 
que é o grande barato de usar essas chaves (além da segurança óbvio!).

##### O Arquivo config

Se você criou a chave com o nome default (id_rsa) não precisa fazer nada, 
basta colar dentro da pasta .ssh da home do seu usuário. A chave privada 
é o arquivo id_rsa e a chave pública é o arquivo id_rsa.pub, sendo esse 
o arquivo que você deverá copiar o conteúdo de texto para dentro do 
arquivo authorized_keys nos servidores que você deseja acessar. 

Agora, se você criou uma chave com nome diferente ou está utilizando 
múltiplas chaves para acessar vários servidores diferentes, você deverá
seguir esses passos adicionais para que consiga usar as múltiplas chaves. 

Dentro da pasta .ssh da home do seu usuário, crie um arquivo **config**. 
Se a pasta **.ssh** ainda não existe na home do seu usuário, você precisará 
criá la:

    ~[/home/user] $ mkdir .ssh
    ~[/home/user] $ chmod 700 .ssh

Se estive com preguiça de seguir esses passos, simplesmente digite na linha 
de comando

    ~$ ssh ip-do-seu-servidor

Onde ip-do-seu-servidor, deverá ser o ip real de um servidor que você acessará
via ssh. Acessá lo pelo primeira vez fará com que a pasta .ssh seja criada
automaticamente com as devidas permissões. 

Dentro das pasta .ssh, arquivos de chaves devem possui as permissões **600**
e pastas **700**. 

O arquivo **config** possui diversos parâmetros que podem ser analisados em
**/etc/ssh/ssh_config**. Mas vamos nos ater ao básico que já no serve muito
bem: 

    Host *
        IdentityFile ~/.ssh/id_rsa
  
    Host valentino
        HostName valentino
        IdentityFile ~/.ssh/keys/id_rsa-man-servers
        ServerAliveInterval 10
   
    Host 192.168.1.228
       HostName 192.168.1.228
       IdentityFile ~/.ssh/keys/id_rsa-man-servers
       ServerAliveInterval 10
   
  
    Host 192.168.1.1
      HostName 192.168.1.1
      IdentityFile ~/.ssh/keys/id_rsa-man-servers
      ServerAliveInterval 10
      HostKeyAlgorithms +ssh-rsa
  
    Host github.com
      HostName github.com
      IdentityFile ~/.ssh/keys/id_rsa-github


Se você possuir uma chave que é default para diversos servidores e 
algumas que são específicos para alguns servidores,  o modelo acima
serve muito bem. 

O parâmetro **Host** com o asterisco servirá para usar a chave configurada
em IdentityFile como default para a maioria dos servidores. As seções
**Host** seguintes servirão para servidores específicos.

###### HostName

O parâmetro **HostName** pode ser utilizado como um facilitador para 
ajudar a acessar os servidores pelo nome, nos exemplos acima, esse 
parâmetro está sendo usado com o mesmo nome do Host, mas pode ser 
utilizado um nome diferente, desde seja resolvido via DNS. 

Um exemplo que costumava utilizar para administrar servidores
é similar ao exemplo abaixo: 

   Host 192.168.1.145
        HostName vmteste06
        IdentityFile ~/.ssh/keys/id_rsa-teste

Agora edito o arquivo hosts, que tanto no linux quanto no windows
serve como uma espécie de servidor DNS local, mas obviamente muito
básico. No linux o arquivo hosts fica /etc, no windows fica em 
c:\Windows\System32\drivers\etc

Basta editar esse arquivo seguindo o exemplo abaixo:

    192.168.1.145   vmteste06

Dessa forma, não precisarei usar o endereço ip, que fica chato
digitar toda hora e também não preciso usar um nome seguindo
o modelo de nomes DNS que é obrigatório o uso de domínio. 

Se eu pingar o vmteste06, ele responderá, e posso usá-lo para
acessar o servidor via ssh de forma simples, usando um nome
que seja simples de lembrar. 

###### IdentityFile

Esse parâmetro aponta para o local do arquivo onde está a 
chave privada que o ssh usará pra acessar o servidor. 

###### ServerAliveInterval

É um tempo em segundos que o cliente irá verificar se o 
servidor ainda está respondendo. Em alguns casos, se você
deixar a janela com a sessão SSH aberta, mas sem executar
nenhum comando, o servidor pode encerrar a conexão, 
muito comum em sessões via internet. Porém infelizmente
esse parâmetro não garante que a conexão nunca cairá, porque
até se houver um firewall limpando conexões de tempos em tempos
pode fazer a conexão cair. 

###### HostKeyAlgorithms

Esse parâmetro é útil quando estamos tentando acessar
um servidor de uma versão muito antiga e as chaves ssh 
negociadas são diferentes das chaves default recomendadas
pelo versão mais atual do SSH. Esse parâmetro faz com 
que o cliente SSH que pertence a uma versão muito superior
aceitar usar um algorítimo que não é mais utilizado pelo SSH. 

