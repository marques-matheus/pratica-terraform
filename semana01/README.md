# Semana 01 - Prática Terraform

Primeiros passos com Terraform na AWS.

## Como usar

Instruções básicas para testar localmente ou em uma conta sandbox.

1. Inicialize o diretório:

```bash
terraform init
```

2. Veja o plano:

```bash
terraform plan
```

3. Aplique (cria a infraestrutura):

```bash
terraform apply
```

4. Para remover os recursos:

```bash
terraform destroy
```

## Testando o web server (user_data)

O `aws_instance` em [pratica terraform/semana01/main.tf](pratica%20terraform/semana01/main.tf) contém um `user_data` simples que instala Nginx (ou Apache como fallback) e escreve uma página `index.html` com "Hello World".

Após o `terraform apply`, pegue o IP público da instância (pelo Console EC2 ou `terraform show`) e abra no navegador: `http://<IP>` — você deverá ver a página "Hello World".

## O que é criado

- VPC
- Internet Gateway
- Subnet pública
- Route Table
- EC2 Instance (com `user_data` que serve a página Hello World)

## Notas rápidas

- Este repositório é intencionalmente simples para estudos; não commit o arquivo de estado (`*.tfstate`).
- O `iam_instance_profile` usado aqui assume que o perfil `LabInstanceProfile` já existe no sandbox.
- Se preferir, copie o bloco `user_data` do arquivo `main.tf` para um script e use como `user_data` externo.
