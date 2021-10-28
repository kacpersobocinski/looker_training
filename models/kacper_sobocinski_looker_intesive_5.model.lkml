connection: "snowlooker"

# include all the views
include: "/views/**/*.view"

datagroup: kacper_sobocinski_looker_intesive_5_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: kacper_sobocinski_looker_intesive_5_default_datagroup

explore: order_items {
  label: "Orders"
  view_label: "Order_view"
  join: inventory_items {
    view_label: "Items"
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }
  join: products {
    view_label: "Products"
    type: left_outer
    sql_on: ${inventory_items.product_id}=${products.id} ;;
    relationship: many_to_one
  }
  join: users {
    view_label: "Customers"
    type:  left_outer
    sql_on: ${order_items.user_id}=${users.id} ;;
    relationship: many_to_one
  }
}