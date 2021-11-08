view: order_items {
  sql_table_name: "PUBLIC"."ORDER_ITEMS"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
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
    sql: ${TABLE}."CREATED_AT" ;;
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
    sql: ${TABLE}."DELIVERED_AT" ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."INVENTORY_ITEM_ID" ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
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
    sql: ${TABLE}."RETURNED_AT" ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}."SALE_PRICE" ;;
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
    sql: ${TABLE}."SHIPPED_AT" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."USER_ID" ;;
  }

  #  HOMEWORK dimentions

  dimension_group: shipping_days {
    type: duration
    intervals: [day]
    sql_start: ${shipped_raw} ;;
    sql_end: ${delivered_raw} ;;
  }

  dimension:  is_returned {
    label: "Returned Flag"
    type: yesno
    sql: ${returned_date} IS NOT NULL ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # HOMEWORK measures

  measure: total_sale_price {
    label: "Total Sales Price"
    group_label: "Totals"
    description: "Total sales price of items sold"
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
    drill_fields: [detail*]
  }

  measure: average_sell_price {
    label: "Average Sell Price"
    group_label: "Averages"
    description: "Average sell price of items sold"
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
    drill_fields: [detail*]
  }

  measure: cumulative_total_sales {
    label: "Cumulative Total Sales"
    group_label: "Running Totals"
    description: "Running total of sales"
    type: running_total
    sql: ${total_sale_price} ;;
    value_format_name: usd
    drill_fields: [detail*]
  }

  measure: total_gross_revenue {
    label: "Total Gross Revenue"
    group_label: "Totals"
    description: "Total Gross revenue of sold items - cancelled and returned orders excluded"
    type: sum
    sql: ${sale_price};;
    value_format_name: usd
    filters: [status: "-Returned, -Cancelled"]
    drill_fields: [detail*]

  }

  measure: total_gross_margin_amount {
    label: "Total Gross Margin"
    group_label: "Totals"
    description: "Total gross margin of goods sold - cancelled and returned orders excluded"
    type: number
    sql: ${total_gross_revenue} - ${inventory_items.total_cost} ;;
    value_format_name: usd
    drill_fields: [detail*]
  }

  measure: average_gross_margin {
    label: "Average Gross Margin"
    group_label: "Averages"
    description: "Average Gross Margin of sold items - cancelled and returned orders excluded"
    type: number
    sql: ${sale_price} - ${inventory_items.cost} ;;
    value_format_name: usd
    drill_fields: [detail*]
  }

  measure: gross_margin_percentage {
    label: "Gross Margin Percentage"
    group_label: "Rates"
    description: "Gross Margin Percentage of sold items - cancelled and returned orders excluded"
    type: number
    sql: ${total_gross_margin_amount}/${total_gross_revenue} ;;
    value_format_name: percent_2
    drill_fields: [detail*]
  }

  measure: number_of_items_returned {
    label: "Number of Items Returned"
    group_label: "Totals"
    description: "Total number of items returned"
    type: count
    filters: [status: "Returned"]
  }

  measure: item_return_rate {
    label: "Return Rate"
    group_label: "Rates"
    description: "Ruturn Rate of Items Sold - excluding cancelled"
    type: number
    sql: ${number_of_items_returned}/${count} ;;
    value_format_name: percent_2
  }

  measure: number_of_customers_returning_items {
    label: "Number of Customers Returning Items"
    group_label: "Totals"
    description: "Number of customers that returned items"
    type: count_distinct
    sql: ${user_id} ;;
    filters: [status: "Returned"]
    drill_fields: [detail*]
  }

  measure: percentage_of_users_with_returns {
    label: "Percentage of Users with returns"
    group_label: "Rates"
    description: "Percentage of users returning items"
    type: number
    sql: ${number_of_customers_returning_items}/${users.count} ;;
    value_format_name: percent_2
    drill_fields: [detail*]
  }

  measure: average_spend_per_customert {
    label: "Average Spend per Customer"
    group_label: "Averages"
    description: "Average USD sped per customer"
    type: number
    sql: ${total_gross_revenue}/${users.count} ;;
    value_format_name: usd
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drill-downs ------
  set: detail {
    fields: [
      id,
      inventory_items.product_name,
      inventory_items.id,
      users.last_name,
      users.full_name,
      users.id,
      users.first_name
    ]
  }
}
