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
dos pacote keys todo dia à meia noite e trinta minutos. Se você possui 
o repositório de pacotes, esse arquivo fará o update automático diário
para cada nova versão que o repositório receber, trazendo muita comodidade
no gerenciamento de chaves dos servidores que você administrar. 

