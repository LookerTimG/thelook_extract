view: order_items {
  sql_table_name: public.ORDER_ITEMS ;;

  dimension: id {
    label: "ID Order Items"
    primary_key: yes
    type: number
    sql: ${TABLE}.ID ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.CREATED_AT ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.DELIVERED_AT ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.INVENTORY_ITEM_ID ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.ORDER_ID ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.RETURNED_AT ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.SALE_PRICE ;;
  }

  dimension: is_luxury {
    type: yesno
    sql: CASE WHEN ${sale_price} <= 50.00 THEN 0 ELSE 1 ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.SHIPPED_AT ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.STATUS ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.USER_ID ;;
  }

  measure: count_order_items {
    label: "Count of the Total Number of Order Items"
    description: "This is the count of the number of lines from Order Items"
    type: count
    drill_fields: [detail*]
  }

  measure: sale_total {
    label: "Sum of Sale Price"
    description: "The sum of the Sale Price values"
    type: sum
    sql: ${sale_price} ;;
    value_format: "$#,##0.00"
    drill_fields: [sale_price, inventory_items.product_name, inventory_items.category, inventory_items.department]
  }

  measure: sale_price_min {
    label: "Lowest Price Sold At"
    description: "This is the minimum Sale Price"
    type: min
    sql: ${sale_price} ;;
    value_format: "$#,##0.00"
    drill_fields: [sale_price, inventory_items.product_name, inventory_items.category, inventory_items.department]
  }

  measure: sale_price_max {
    label: "Highest Price Sold At"
    description: "This is the maximun Sale Price"
    type: max
    sql: ${sale_price} ;;
    value_format: "$#,##0.00"
    drill_fields: [sale_price, inventory_items.product_name, inventory_items.category, inventory_items.department]
  }

  measure: sale_price_avg {
    label: "Average Price Sold At"
    description: "This is the average Sale Price"
    type: average
    sql: ${sale_price} ;;
    value_format: "$#,##0.00"
    drill_fields: [sale_price, inventory_items.product_name, inventory_items.category, inventory_items.department]
  }

  measure: count_orders {
    label: "Count of Unique Orders"
    description: "This is a count of the distinct order_id's"
    type: count_distinct
    sql: ${order_id} ;;
    drill_fields: [order_id, users.first_name, users.last_name, users.state, users.traffic_source]
  }

  measure: items_per_order_avg {
    label: "Average Items On Order"
    description: "This is the count of order items / count of unique orders"
    type: number
    sql: ${count_order_items} / ${count_orders} ;;
    value_format: "0.00"
    drill_fields: [sale_price, inventory_items.product_name, inventory_items.category, inventory_items.department]
  }

  measure: sale_net {
    label: "Sale Price minus Item Cost giving Gross Profit"
    description: "Item's Sale Price minus the Inventory Item Cost value"
    type: number
    sql: ${sale_price} - ${inventory_items.cost} ;;
    value_format_name: usd
    drill_fields: [sale_price, inventory_items.product_name, inventory_items.category, inventory_items.department]
  }

  measure: sale_net_margin {
    label: "Sale Profit Margin"
    description: "The net profit expressed as a percentage of the total price"
    type: number
    sql: 100.0 - ( ${inventory_items.cost} / ${sale_price} ) ;;
    value_format_name: percent_2
    drill_fields: [sale_price, inventory_items.product_name, inventory_items.category, inventory_items.department]
  }


  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      inventory_items.product_name,
      inventory_items.id,
      users.last_name,
      users.first_name,
      users.id
    ]
  }
}
