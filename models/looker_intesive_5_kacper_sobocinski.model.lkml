connection: "snowlooker"

# include all the views
include: "/views/**/*.view"

datagroup: looker_intesive_5_kacper_sobocinski_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: looker_intesive_5_kacper_sobocinski_default_datagroup


explore: order_items_details {
  from: order_items
  label: "Orders with details"
  view_label: "Orders"
  description: "An explore that focuses on inventory items with customer, product and inventory data"

  join: inventory_items {
    view_label: "Inventory Items"
    type: left_outer
    sql_on: ${order_items_details.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: users {
    view_label: "Customers"
    type: left_outer
    sql_on: ${order_items_details.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: products {
    view_label: "Products"
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
}

explore: customer_events {
  from: users
  label: "Customers with details"
  view_label: "Customers"
  description: "An explore focusing on customer data"
  fields: [customer_events.user_details*, events.created_date, events.event_type, events.count]

  join: events {
    from: events
    view_label: "Customer events"
    type: left_outer
    sql_on: ${customer_events.id} = ${events.user_id} ;;
    relationship: one_to_many
  }
}
