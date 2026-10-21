# Модель Power BI

Дашборд построен в Power BI Desktop с подключением к базе PostgreSQL `olist_analytics`.

## Таблицы и связи
- `customers[customer_id]` — `orders[customer_id]` (1:1 в исходной модели)
- `orders[order_id]` — `order_items[order_id]` (1:*)
- `orders[order_id]` — `order_payments[order_id]` (1:*)
- `products[product_id]` — `order_items[product_id]` (1:*)
- `sellers[seller_id]` — `order_items[seller_id]` (1:*)
- `category_translation[product_category_name]` — `products[product_category_name]` (1:*)

## Меры DAX

```dax
Total Sales =
CALCULATE(
    SUM('public order_items'[price]),
    'public orders'[order_status] = "delivered"
)
```

```dax
Total Orders =
CALCULATE(
    DISTINCTCOUNT('public orders'[order_id]),
    'public orders'[order_status] = "delivered"
)
```

```dax
Average Order Value =
DIVIDE([Total Sales], [Total Orders], 0)
```

```dax
Total Payments =
CALCULATE(
    SUM('public order_payments'[payment_value]),
    'public orders'[order_status] = "delivered"
)
```

Вычисляемый столбец в `public orders`:

```dax
Order Month =
DATE(
    YEAR('public orders'[order_purchase_timestamp]),
    MONTH('public orders'[order_purchase_timestamp]),
    1
)
```

Глобальный фильтр `Order Month >= 2017-01-01` и `Order Month < 2018-09-01` распространяется на страницу отчёта через модель связей.

## Примечания
`Total Sales` не включает доставку; `Total Payments` включает платежи за доставку. Для сопоставления показателей необходимо применять одинаковый фильтр по датам и статусу заказа. Возможные расхождения категорий связаны с неполнотой таблицы переводов.
