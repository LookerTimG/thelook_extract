connection: "thelook_events"

include: "*.view.lkml"                       # include all views in this project

datagroup: datagroup_fourhour {
  max_cache_age: "4 hours"
}

# explore: order_items {
#   join: orders {
#     relationship: many_to_one
#     sql_on: ${orders.id} = ${order_items.order_id} ;;
#   }
#
#   join: users {
#     relationship: many_to_one
#     sql_on: ${users.id} = ${orders.user_id} ;;
#   }
# }

explore: orders_users {
  from: order_items
  fields: [ALL_FIELDS*,
          -orders_users.inventory_item_id,
          -orders_users.returned_raw,
          -orders_users.returned_time,
          -orders_users.returned_date,
          -orders_users.returned_week,
          -orders_users.returned_month,
          -orders_users.returned_quarter,
          -orders_users.returned_year,
          -orders_users.shipped_raw,
          -orders_users.shipped_time,
          -orders_users.shipped_date,
          -orders_users.shipped_week,
          -orders_users.shipped_month,
          -orders_users.shipped_quarter,
          -orders_users.shipped_year,
          -orders_users.delivered_raw,
          -orders_users.delivered_time,
          -orders_users.delivered_date,
          -orders_users.delivered_week,
          -orders_users.delivered_month,
          -orders_users.delivered_quarter,
          -orders_users.delivered_year
          ]
  always_filter: {
    filters: {
      field: orders_users.created_year
      value: "2004"
    }
  }
  join: users {
    view_label: "Order Users"
    type: inner
    relationship: many_to_one
    sql_on: ${orders_users.user_id} = ${users.id} ;;
  }
}


explore: distribution_centers {}
explore: events {}
explore: inventory_items {}
explore: order_items {}
explore: products {}
explore: users {}

explore: users_active {
  from: users
  persist_with: datagroup_fourhour
  sql_always_where: ${order_items.returned_date} IS NOT NULL ;;
  join: order_items {
    view_label: "Users Active"
    type: left_outer
    relationship: one_to_many
    sql_on: ${users_active.id} = ${order_items.user_id} ;;
    fields: [
          order_items.created_raw,
          order_items.created_time,
          order_items.created_date,
          order_items.created_week,
          order_items.created_month,
          order_items.created_quarter,
          order_items.created_year,
          order_items.sale_total,
          order_items.sale_price,
          order_items.status
    ]
  }
}

##self join explore
explore: event_l {
  from: events
  join: event_r {
    from: events
  type: inner
  relationship: many_to_many
  sql_on: ${event_l.session_id} = ${event_r.session_id}
          AND ${event_l.sequence_number} < ${event_r.sequence_number} ;;
  }
}
