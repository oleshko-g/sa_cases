workspace {

    model {
        investor = person "Инвестор"

        group "Тинькофф Банк" {
            support_employee = person "Сотрудник службы заботы"
            
            tinkoff_investments_ios = softwareSystem "iOS приложение Тинькофф Инвестиции" {
                stocks = group "Акции" {
                    stocks_front = container "Интерфейс акций"
                    stocks_back = container "Бэкенд акций"
                }
                trading = group "Торговля" {
                    trading_front = container "Интерфейс торговли"
                    trading_back = container "Бэкенд торговли"
                }
                analytics = group "Аналитика портфеля" {
                    analytics_front = container "Интерфейс портфеля"
                    analytics_back = container "Бэкенд портфеля"
                }

                support = group "Поддержка" {
                    support_front = container "Интерфейс поддержки"
                    support_back = container "Бэкенд поддержки"
                }
            }
        }
        moex = softwareSystem "Московская биржа" {
            tags "Внешняя система"
        }    
        spbex = softwareSystem "СПб биржа" {
            tags "Внешняя система"
        }

        investor -> stocks_front "Просматривает информацию о конкретной акции"
        investor -> stocks_front "Просматривает подборки акции (Взлеты и падения)"
        stocks_front -> stocks_back "Запрашивает данные об акциях"
        stocks_back -> moex "Получает данные об акциях"
        stocks_back -> spbex "Получает данные об акциях"
        stocks_back -> stocks_front "Отправляет данные об акциях"

        investor -> trading_front "Выставляет заявки на покупку и продажу"
        trading_front -> trading_back "Отправляет заявки"
        trading_back -> moex "Обменивается заявками"
        trading_back -> spbex "Обменивается заявками"

        investor -> analytics_front "Просматривает получить отчет о брокерском счете"
        analytics_front -> analytics_back "Запрашивает данные о брокерских счетах"
        analytics_back -> stocks_back "Получает данные об акциях"
        analytics_back -> analytics_back "Формирует отчеты"
        
        investor -> support_front "Отправляет обращения в тех поддержку"
        support_front -> support_back "Сохраняет обращения пользователей"
        support_front -> support_back "Запрашивает обращения пользователей"
        support_back -> support_front "Отправляет обращения пользователей"
        support_employee -> support_front "Помогает пользователям"
}

    views {
        theme default
        
        container tinkoff_investments_ios {
            include *
            
        }

        styles {
            element "Внешняя система" {
                background #d3d3d3
                color #000000
                shape RoundedBox
            }
        }
    }




    
}

