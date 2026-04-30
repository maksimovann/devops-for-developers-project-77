### Hexlet tests and linter status:
[![Actions Status](https://github.com/maksimovann/devops-for-developers-project-77/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/maksimovann/devops-for-developers-project-77/actions)


# DevOps for Developers — Project 77

## Описание проекта

В данном проекте реализован подход **Infrastructure as Code (IaC)** для разворачивания веб-приложения.

Инфраструктура описана с помощью Terraform и включает в себя:

* Два веб-сервера (виртуальные машины)
* Балансировщик нагрузки с поддержкой HTTPS
* Базу данных PostgreSQL как сервис
* Подготовку к настройке серверов через Ansible

---

## Используемые технологии

* Terraform — создание и управление инфраструктурой
* Ansible — автоматизация настройки серверов
* Docker — запуск приложения в контейнерах

---

## Структура проекта

```text
terraform/   — описание инфраструктуры
ansible/     — плейбуки и переменные для настройки серверов
```

---

## Основные команды

Для работы с инфраструктурой используется Makefile:

```bash
make setup     # инициализация Terraform
make plan      # просмотр изменений
make apply     # создание инфраструктуры
make destroy   # удаление инфраструктуры
make fmt       # форматирование кода
make validate  # проверка конфигурации
```

---

## Переменные

Секретные данные не хранятся в репозитории и передаются извне.

Необходимые переменные:

* cloud_id
* folder_id
* ssh_public_key
* db_password
* certificate_id
* image_id

---

## Запуск проекта

1. Передать необходимые переменные окружения
2. Выполнить команды:

```bash
make setup
make plan
make apply
```

---

## Удаление инфраструктуры

```bash
make destroy
```

---

## Примечание

Состояние Terraform (state) хранится удалённо и не добавляется в репозиторий.
