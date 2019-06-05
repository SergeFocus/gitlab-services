#language: ru

@tree

Функционал: Регистрация и просмотр POST запроса с сервера GitLab

Как Пользователь
Я хочу иметь возможность просмотреть факт получения POST запроса
Чтобы анализировать данные по обработке запроса и управлять фоновыми заданиями

Контекст:
    Дано Я подключаю TestClient "Этот клиент" логин "Пользователь" пароль ""
    И Я настраиваю сервисы GitLab

Сценарий: Добавление данных о внешнем хранилище на GitLab
    И Я добавляю новую запись в справочник со списком внешних хранилищ
    И Я делаю POST запрос на "$$МестоположениеСервисовИБРаспределителя$$" с данными "$$ТелоPOSTЗапросаJSON$$" по ключу "$$GitlabToken$$"