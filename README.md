# Stocker

## SaldoJá — Estoque em segundos

O **Stocker** é um aplicativo mobile desenvolvido em Flutter para consulta rápida de estoque integrado ao ERP Senior. A aplicação permite que usuários consultem produtos por código ou descrição e visualizem seus saldos de forma organizada, incluindo a quantidade disponível em cada depósito e informações detalhadas sobre reservas, bloqueios e consignações.

O projeto foi desenvolvido com foco em uma experiência simples para o usuário final, mantendo uma arquitetura preparada para integração com serviços externos, múltiplas empresas e diferentes níveis de acesso.

---

## 📱 Sobre o aplicativo

O Stocker nasceu a partir de uma necessidade comum em ambientes que utilizam ERP: consultar rapidamente a disponibilidade de um produto sem precisar acessar diretamente o sistema de gestão.

Por meio do **SaldoJá**, o usuário pode:

- 🔎 Buscar produtos por código ou descrição
- 📦 Visualizar o estoque disponível por depósito
- 📊 Visualizar o saldo total do produto
- 🟢 Identificar visualmente níveis de estoque
- 🔐 Trabalhar com autenticação via Google
- 🏢 Selecionar e alternar entre empresas
- 👥 Gerenciar usuários de acordo com seu perfil
- 📋 Consultar informações detalhadas do estoque
- ⚠️ Receber mensagens claras em situações de erro
- 🌙 Utilizar a aplicação em temas claro e escuro

---

## 🏗️ Arquitetura

O projeto utiliza uma estrutura organizada por funcionalidades, buscando separar responsabilidades entre apresentação, domínio e acesso a dados.

```text
lib/
├── core/
│   ├── theme/
│   └── widgets/
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── company/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── stock/
│       ├── data/
│       ├── domain/
│       └── presentation/
│
└── shared/
    └── services/
