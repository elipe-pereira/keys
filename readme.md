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



