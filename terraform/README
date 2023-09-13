# Introducao
Terraform fornece infra estrutura como codigo
https://developer.hashicorp.com/terraform/tutorials/docker-get-started

Esse projeto é um demonstrativo para automatizar a criação de containers docker, mas pode usar para configurar infraestruturas completas cloud por exemplo

# Comandos basicos
`terraform init`: realiza downloads dependencias necessarias de acordo com providers explicitados no arquivo main.tf
`terraform fmt`: formata terrafile
`terraform validate`: valida conteudo arquivo terrafile
`terraform plan`: Avalia cenario atual e exibe no terminal quais são as tarefas que serão executadas quando usar terraform apply
`terraform apply`: Avalia arquivo terrafile e executa os procedimentos
`terraform destroy`: Avalia arquivo terrafile e deleta os recursos criados

# Comandos basicos variações - criar checkpoint
`terraform plan "main.tfplan"`: Esse comando cria uma especie de foto/snapshot do estado atual dos arquivos para poder executar posteriormente
`terraform apply "main.tfplan"`: Esse comando executa o plano salvo anteriormente, ignorando o estado atual dos arquivos e considerando o plano anteriormente criado

# arquivos
`main.tf`: arquivo principal terrafile com o que será executado
`variables.tf`: arquivo de variaveis
`terraform.tfstate`: arquivo de versionarmento, responsável por manter todo o histórico de recursos em seu provedor e que será utilizado pelo terraform para a criação de novos 
recursos e também principalmente para alteração de recursos. Esse arquivo o ideal é guardar de forma versionada em algum local seguro.
`folder modules`: aqui ficam modulos que sao importados pelo main


# debug
Para ter mais detalhes da execução pasta criar uma variavel definindo nivel de log, `export TF_LOG=”DEBUG”` e para parar `unset TF_LOG`

# Principais components arquivo main
`providers`: O Terraform depende de plug-ins chamados provedores para interagir com provedores de nuvem, provedores de SaaS e outras APIs.https://registry.terraform.io/browse/providers
`resources`: Os recursos são o elemento mais importante na linguagem Terraform. Cada bloco de recursos descreve um ou mais objetos de infraestrutura, como redes virtuais, instâncias de computação ou componentes de nível superior, como registros DNS.






# Exemplo de uso
Para testar o repositorio atual precisamos, instalar docker e terraform https://developer.hashicorp.com/terraform/tutorials/docker-get-started/install-cli
depois executar 
- terraform init
- terraform plan
- terraform apply
- verificar se containers foram criados com docker ps
- terraform destroy

