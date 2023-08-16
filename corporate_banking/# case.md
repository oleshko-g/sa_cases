```mermaid

erDiagram
legal_entity
representer
bank_account
cooperation
cooperation_members
representer_credentials

legal_entity ||--o{ representer : "выдает полномочия"
bank_account }|--|| legal_entity : "владеет"
cooperation  }o--|| legal_entity : "возглавляет" 
cooperation ||--|{ cooperation_members : "объединяет"
legal_entity ||--|{ cooperation_members : "входит"
representer ||--o{ representer_credentials : "получает полномочия"
representer_credentials ||--o{ cooperation : "предоставляет полномочия" 
```