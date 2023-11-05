## Глоссарий
- Торговая сессия — время, когда биржа открыта и на ней можно торговать.

# Приложение "Инвестиции"
## Глоссарий
- Торговая сессия — время, когда биржа открыта и на ней можно торговать.
## Бизнес-правила
- Система должна позволять покупать и продавать акции в течении 100% времени торговой сессии.

## Пользовательские требования
- **NEW** Просмотреть подборку "Взлеты и падения".

### Просмотреть подборку "Взлеты и падения".
#### Функциональные требования
1. Система должна отображать блок "Взлеты и падения" на экране "Что купить".
2. Система должна отображать в блоке "Взлеты и падения" вкладки:
   1. "Взлеты дня"
   2. "Падения дня"
3. Система должна показывать во вкладке "Взлеты дня" топ 3 акции, которые больше всего выросли в процентах за предыдущую торговую сессию.
4. Система должна показывать на экране "Падения дня" топ 3 акций, которые больше всего упали в процентах за предыдущую торговую сессию.
5. Система должна позволять открыть топ 15 акций с вкладок "Взлеты дня" и "Падения дня".
6. Система должна показывать в списке информацию о каждой акции:
   1. Название эмитента
   2. Тикер
   3. Цена
   4. Абсолютное изменение цены в валюте акции
   5. Процентное изменение цены
7. Система должна отображать акции не активными в списке, когда по ним не ведутся торги.
8. Пользователь должен иметь возможность посмотреть информацию о конкретной акции из списка "Взлеты и падения":
   1. Название эмитента
   2. Тикер
   3. Цена в реальном времени
   4. Абсолютное изменение цены в валюте акции в реальном времени
   5. Процентное изменение цены в реальном времени.
   6. График изменения цены
9. Пользователь должен иметь возможность купить или продать акцию в течении торговой сессии при просмотре информации о конкретной акции.

#### Нефункциональные требования
1. Система должна показывать одинаковые данные в подборке "Взлеты и падения" на всех устройствах всех пользователей. См. п. 6 Функциональных требований.
2. Система должна показывать одинаковые данные в информации о конкретной акции на всех устройствах всех пользователей. См. п. 7 Функциональных требований.
3. Система должна обновлять подборку "Взлеты и падения" между торговыми сессиями.

### Диаграмма последовательности

```mermaid
sequenceDiagram
   # Акторы
   actor investor as Инвестор
   participant stocks_front as Интерфейс акций
   participant stocks_back as Бэкенд акций
   participant trading_front as Интерфейс торговли
   participant trading_back as Бэкенд торговли
   participant stocks_back as Бэкенд акций
   participant moex as Московская биржа
   participant spbex as СПб биржа

   # Последовательности
   autonumber
   par Периодическое обновление данных об акциях Московской биржи
      stocks_back -) moex: Запросить данные об акциях (список id)
      moex --) stocks_back: Отправить данные об акциях ({данные акций})
   and Периодическое обновление данных об акциях СПБ биржи
      stocks_back -) spbex: Запросить данные об акциях (список id)
      spbex --) stocks_back: Отправить данные об акциях ({данные акций})
   end
   autonumber 1
   investor->> stocks_front: Просмотривает подброку "Взлеты и падения"
   stocks_front ->> stocks_back: Запросить данные об акциях (список id)
   stocks_back -->> stocks_front: Отправить данные об акциях ({данные акций})
   stocks_front -->> investor: Показать подборку "Взлеты и падения": {данные подборки акций}
   autonumber 1
   investor ->> stocks_front: Просматривает информацию о конкретной акции (id акции)
   stocks_front ->> stocks_back: Запросить данные о конкретной акции (id акции)
   stocks_back -->> stocks_front: Отправить данные об акциях ({данные акции})
   stocks_front -->> investor: Показать подборку "Взлеты и падения": {данные акции}
   autonumber 1
   investor->>+trading_front: Выставляет заявки на покупку или продажу(id актива)
   trading_front->>+trading_back: Выставить заявк на покупку или продажу(id актива)

   alt Заявка на Московскую биржу
      trading_back ->>moex: Выставить заявку ({данные заявки})
      alt Успех
         moex -->> trading_back: Заявка исполнена(id заявки, статус заявки)
         trading_back -->> trading_front: Заявка исполнена(id заявки, статус заявки)
         trading_front -->> investor: "Заявка {id заявки} {статус заявки}"
      else Отмена
         moex -->> trading_back: Заявка отменена(id заявки, статус заявки)
         trading_back -->> trading_front: Заявка отменена(id заявки, статус заявки)
         trading_front -->> investor: "Заявка №{id заявки} {статус заявки}"
      end
   else Заявка на СПб биржу
      autonumber 3
      trading_back ->> spbex: Выставить заявку ({данные заявки})
      alt Успех
         spbex -->> trading_back: Заявка исполнена(id заявки, статус заявки)
         trading_back -->> trading_front: Заявка исполнена(id заявки, статус заявки)
         trading_front -->> investor: "Заявка №{id заявки} {статус заявки}"
      else Отмена
         spbex -->> trading_back: Заявка отменена(id заявки, статус заявки)
         trading_back -->> trading_front: Заявка отменена(id заявки, статус заявки)
         trading_front -->> investor: "Заявка №{id заявки} {статус заявки}"
      end
   end
```
### JSON Schema
```JSON
{
    "$schema": "https://json-schema.org/draft/2020-12/schema",
    "$id": "https://ivestments.tinkoff.ru/draft/2023-10/schema/bidding-leader-digest.json",
    "title": "Лидеры торгов бирже",
    "description": "Дайджест топов акций которые больше всего поднялись или опустились в цене за последние сутки",
    "type": "object",
    "properties": {
        "top-cutoff-title": {
            "description": "Заголовок мест топов",
            "type": "string",
            "examples": [
                "ТОП"
            ]
        },
        "top-cutoff": {
            "description": "Количество мест топов",
            "type": "integer",
            "minimum": 1,
            "examples": [
                "15"
            ]
        },
        "digest-name": {
            "description": "Название дайджеста",
            "type": "string",
            "examples": [
                "Лидеры торгов на Мосбирже"
            ]
        },
        "tops": {
            "description": "Коллекция топов",
            "type": "array",
            "items": {
                "type": "object",
                "properties": {
                    "top-title": {
                        "description": "Заголовок топа",
                        "type": "string",
                        "examples": [
                            "Взлеты дня",
                            "Падения дня"
                        ]
                    },
                    "top-description": {
                        "description": "Описание топа",
                        "type": "string",
                        "maxLength": 1000,
                        "examples": [
                            "Акции, которые больше всего выросли в цене за послдедние сутки на Мосбирже.",
                            "Акции, которые больше всего упали в цене за послдедние сутки на Мосбирже."
                        ]
                    },
                    "top-list": {
                        "description": "Список акций",
                        "type": "array",
                        "items": {
                            "$ref": "#/$defs/top-list-item"
                        }
                    }
                }
            },
            "minItems": 1,
            "uniqueItems": true
        },
        "disclaimer": {
            "description": "Обязательная информация \"Не является инвестиционной рекомендацией\"",
            "type": "string"
        }
    },
    "required": [
        "top-cutoff-title",
        "top-cutoff",
        "digest-name",
        "tops"
    ],
    "$defs": {
        "top-list-item": {
            "type": "object",
            "properties": {
                "icon": {
                    "description": "Ссылка на иконку акции",
                    "type": "string",
                    "maxLength": 255,
                    "format": "uri"
                },
                "ticker-symbol": {
                    "description": "Тикер акции",
                    "type": "string",
                    "maxLength": 6,
                    "examples": [
                        "MVID",
                        "LKOH",
                        "SPBE"
                    ]
                },
                "issuer": {
                    "description": "Компания-эмитент акции",
                    "type": "string",
                    "examples": [
                        "М.Видео",
                        "ЛУКОЙЛ",
                        "СПБ Бибржа"
                    ]
                },
                "price": {
                    "description": "Текущая цена акции",
                    "type": "number",
                    "exclusiveMinimum": 0,
                    "examples": [
                        191.2,
                        7253.5,
                        140
                    ]
                },
                "price-change-absolute": {
                    "description": " цена акции",
                    "type": "number",
                    "exclusiveMinimum": 0,
                    "examples": [
                        -10.001,
                        250,
                        12.02
                    ]
                },
                "price-currency": {
                    "description": "Знак валют акции",
                    "type": "string",
                    "maxLength": 1,
                    "pattern": "\\p{Sc}",
                    "examples": [
                        "$",
                        "₽",
                        "€"
                    ]
                },
                "price-change-percent": {
                    "description": "Процент изменения цены акции. Передается в видел доли единицы.",
                    "type": "number",
                    "examples": [
                        0.055193461332568,
                        0.035696437495538,
                        0.093920925144554
                    ]
                },
                "is-tradable": {
                    "description": "Признак доступности к торговле. false - когда торги на бирже закрыты или акция заблокирована.",
                    "type": "boolean"
                },
                "is-tradable-icon": {
                    "description": "Ссылка на иконку \"Недоступно к торговле\". Отображается, когда признак is-tradable = false",
                    "type": "string",
                    "maxLength": 255,
                    "format": "uri"
                }
            },
            "required": [
                "icon",
                "ticker-symbol",
                "issuer",
                "price",
                "price-change-absolute",
                "price-change-percent",
                "is-tradable"
            ]
        }
    }
}
```
### Пример JSON
```JSON
{
    "top-cutoff-title": "ТОП",
    "top-cutoff": 3,
    "digest-name": "Лидеры торгов на Мосбирже",
    "tops": [
        {
            "top-title": "Взлеты дня",
            "top-description": "Акции, которые больше всего выросли в цене за послдедние сутки на Мосбирже.",
            "top-list": [
                {
                    "icon": "https://investments.tinkoff.ru/...",
                    "ticker-symbol": "MVID",
                    "issuer": "М.Видео",
                    "price": 191.2,
                    "price-change-absolute": 10.001,
                    "price-change-percent": 0.0,
                    "is-tradable": true,
                    "price-currency": "₽",
                    "is-tradable-icon": "https://investments.tinkoff.ru/..."
                },
                {
                    "icon": "https://investments.tinkoff.ru/...",
                    "ticker-symbol": "LKOH",
                    "issuer": "ЛУКОЙЛ",
                    "price": 7253.5,
                    "price-change-absolute": 250,
                    "price-change-percent": 0.0,
                    "is-tradable": true,
                    "price-currency": "₽",
                    "is-tradable-icon": "ABCDEFGHIJKL"
                },
                {
                    "icon": "https://investments.tinkoff.ru/...",
                    "ticker-symbol": "SPBE",
                    "issuer": "СПБ Бибржа",
                    "price": 140,
                    "price-change-absolute": 12.02,
                    "price-change-percent": 0.0,
                    "is-tradable": true,
                    "price-currency": "₽",
                    "is-tradable-icon": "https://investments.tinkoff.ru/..."
                }
            ]
        },
        {
            "top-title": "Падения дня",
            "top-description": "Акции, которые больше всего упали в цене за послдедние сутки на Мосбирже.",
            "top-list": [
                {
                    "icon": "https://investments.tinkoff.ru/...",
                    "ticker-symbol": "DVEC",
                    "issuer": "ДЭК",
                    "price": 4.99,
                    "price-change-absolute": -1.01,
                    "price-change-percent": -0.1683,
                    "is-tradable": true,
                    "price-currency": "₽",
                    "is-tradable-icon": "https://investments.tinkoff.ru/..."
                },
                {
                    "icon": "https://investments.tinkoff.ru/...",
                    "ticker-symbol": "AKRN",
                    "issuer": "Акрон",
                    "price": 18970,
                    "price-change-absolute": -586.7,
                    "price-change-percent": -0.03,
                    "is-tradable": true,
                    "price-currency": "₽",
                    "is-tradable-icon": "https://investments.tinkoff.ru/..."
                },
                {
                    "icon": "https://investments.tinkoff.ru/...",
                    "ticker-symbol": "MRKP",
                    "issuer": "Россети Центр и Приволжье",
                    "price": 0.03363,
                    "price-change-absolute": -0.03363,
                    "price-change-percent": -1.0,
                    "is-tradable": true,
                    "price-currency": "₽",
                    "is-tradable-icon": "https://investments.tinkoff.ru/..."
                }
            ]
        }
    ],
    "disclaimer": "\"Не является инвестиционной рекомендацией\""
}
```