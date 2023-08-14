# Cпроектировать REST API по приему заявок для сервиса заявок.
Сам сервис принимает заявку от клиента, сохраняет в БД и возвращает ответ клиенту.  
В заявке есть сущности **Клиент**, **Платеж**, **Продукт**. Атрибуты заявки надо продумать самим. 
Необходимо:
- Определить метод и url.
- Подготовить пример запроса и ответа в формате json.
- Подготовить json-схему запроса и ответа.
- Описать основной и альтернативные сценарии работы сервиса.
## Прием заказ клиента
```mermaid
sequenceDiagram
        
    actor client
    participant orderService
    participant DB
    participant paymentService

    autonumber
    note left of client : Authorized
    client -) orderService: sendOrder(client_id, [product_id,...])
    orderService -->> client:"Order sent"
    orderService ->> DB: createOrder()
    alt success
    DB -->> orderService: "Order created (order_id)"
    orderService --) client: "Order created" (order_id)
    else error
    DB -->> orderService: "Order's not created"
    orderService --) client: "Order's not created" 
    end
    client -) paymentService: pay (order_id)
    alt success 
    paymentService --) client: "Payment succesful" (order_id)
    else error
    paymentService --) client: "Payment unsuccesful" (order_id)
    end
```
## Описание API
### Ресурсы
/v1/orders
#### Методы
POST /orders

#### Пример запроса
- sendOrder (client_id, [productId,...])
```JSON
{
    "client_id": 5,
    "products": [
        {
            "product_id": 1,
            "product_quantity": 2,
            "product_price": 3
        },
    ]
}
```
#### Пример запроса
- "Order created" (order_id)
```JSON
{
    "order_id": 1,
    "order_status": "Created"
}ˇ
```


- JSON-schema запроса
```JSON
{
    "$id": "https://abstract-order-service.com/v1/orders/schema.json",
    "$schema": "https://abstract-order-service.com/v1/orders/schema",
    "description": "Схема запроса на создание заявки.",
    "type": "object",
    "properties": {
        "client_id": {
            "type": "int"
        },
        "products": {
            "type": "array",
            "properties": {
                "type": "object",
                "properties": {
                    "product_id": {
                        "type": "int"
                    },
                    "product_quantity": {
                        "type": "int"
                    },
                    "product_price": {
                        "type": "int"
                    }
                }
            }
        }
    }
}
```

- JSON-schema ответа
```JSON
{
    "$id": "https://abstract-order-service.com/v1/orders/schema-get.json",
    "$schema": "https://abstract-order-service.com/v1/orders/schema-get",
    "description": "Схема ответа после создания заявки.",
    "type": "object",
    "properties": {
        "order_id": {
            "type": "int"
        },
        "order_status": {
            "type": "int"
        }
    }
}
```