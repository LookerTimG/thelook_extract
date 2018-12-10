connection: "thelook_events"

# include all the views
include: "*.view"

datagroup: thelook_tg_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "24 hour"
}

persist_with: thelook_tg_default_datagroup

explore: distribution_centers {}

explore: events {}

explore: inventory_items {}

explore: order_items {}

explore: products {}

explore: users {}
