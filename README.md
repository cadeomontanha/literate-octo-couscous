# Packer - Ansible e Terraform - AWS
Este repositorio é apenas um demo utilizando as ferramentas Packer, Ansible e Terraform na AWS

## Overview


Esse projeto cria uma instancia EC2 com o [DjangoCMS](https://www.django-cms.org/) configurado e rodando atualmente com um Banco Local (Apenas para Testes) 

Uma vez que a instância foi criada abra o browser com o endereçamento IP Público que foi atribuído a Instância para 
visualizar o Django CMS instado com Sucesso.


## Pré Requisitos

Vamos então aos pré requisitos pra poder subir essa infraestrutura


1. Instalar o awscli e configurar ( Essa etapa é necessária para utilização do `Packer` e do `Terraform`)
2. [Packer](https://learn.hashicorp.com/tutorials/packer/getting-started-install) e [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) Instalados


Siga o link abaixo para efetuar a configuração do seu [awscli](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)

## Estrutura  de Diretórios
Explicando a estrutura de diretórios que vamos utilizar 

```
|-- README.md
|-- ansible -> Pasta com as Roles do Ansible
    |-- group_vars -> Variáveis para grupos
    |-- roles 
        |-- djangocms -> Essa estrutura representa uma role
            |-- tasks 
                |-- main.yml -> Arquivos que serão executados
            |-- templates
                |-- nginx.conf.j2 -> Arquivos que serão utilizados como templates
        |-- gunircorn
        |-- nginx
        |-- supervisor
    ansible.cfg
    site.yml
|-- packer -> Pasta com as configs do Packer
    |-- scripts -> Scripts de Inicialização e Finalização da Imagem
        |-- ansible.sh
        |-- cleanup.sh
    template.json -> Arquivo de Template pra execução do Packer
|-- terraform - > Pasta com arquivos para rodar o Terraform
    |-- main.tf -> Arquivos de Execucao do Terraform .tf
    |-- network.tf
    |-- output.tf
    |-- provider.tf
    |-- variables.tf
    |-- auto_scaling_group.tf
```


## Agora vamos pra parte prática: 

```bash
git clone https://github.com/cadeomontanha/literate-octo-couscous.git

cd literate-octo-couscous

cd packer

packer build template.json

cd ../terraform 

terraform init; terraform plan; terraform apply --auto-approve;

```

## Testes

A execução dos scripts acima farão a criação de uma imagem em sua conta na AWS de acordo com as suas configurações.

O terraform vai retornar 3 outputs, trazendo pra você a informação de qual é o IP Externo da sua instância:

```
curl = curl http://x.x.x.x
publicIp = x.x.x.x

```

Você pode optar por executar o `curl output` ou apenas abrir o seu browser e colocar o link que foi gerado


## Excluindo o seu Ambiente - EC2 e Template

Agora que você já criou o seu ambiente faremos a exclusão da InfraEstrutura 

You will have to destroy created infrastructure in order to avoid any changes from AWS. Following steps would destroy the EC2 instance and also the AMI created by packer.

```bash

cd literate-octo-couscous/terraform

terraform destroy --auto-approve ( Utilize a opção --auto-approve somente em ambiente de testes)

aws ec2 deregister-image --image-id <image-id> (Essa informação é repassada pelo Packer )

aws ec2 delete-snapshot --snapshot-id <snapshot-id> (Será necessário ir na Console da AWS pra pegar essa informação)


```


Pra evitar quaisquer cobranças indevidas é importante entrar no seu painel da AWS > EC2 e verificar se as instâncias foram realmente excluídas. 
### Importante: Verifique se está na região correta

