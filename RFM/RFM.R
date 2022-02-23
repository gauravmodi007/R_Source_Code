# https://cran.r-project.org/web/packages/rfm/vignettes/rfm-customer-level-data.html

library(rfm)

rfm_data_orders
rfm_data_customer


analysis_date <- lubridate::as_date('2006-12-31')
rfm_table_order(rfm_data_orders, customer_id, order_date, revenue, analysis_date)

# access rfm table
result <- rfm_table_order(rfm_data_orders, customer_id, order_date, revenue, analysis_date)
result$rfm

# using custom threshold
rfm_table_order(rfm_data_orders, customer_id, order_date, revenue, analysis_date,
                recency_bins = c(115, 181, 297, 482), 
                frequency_bins = c(4, 5, 6, 8),
                monetary_bins = c(256, 382, 506, 666))

# using transaction data
analysis_date <- lubridate::as_date('2006-12-31')
rfm_order <- rfm_table_order(rfm_data_orders, customer_id, order_date, revenue, analysis_date)

# bar chart data
rfm_barchart_data(rfm_order)

# using customer data
analysis_date <- lubridate::as_date('2007-01-01')
rfm_customer <- rfm_table_customer(rfm_data_customer, customer_id, number_of_orders, recency_days, revenue, analysis_date)

# bar chart data
rfm_barchart_data(rfm_customer)




# rfm table
analysis_date <- lubridate::as_date('2006-12-31')
rfm_result <- rfm_table_order(rfm_data_orders, customer_id, order_date, revenue, analysis_date)

# monetary value vs recency
rfm_rm_plot(rfm_result)

# frequency vs monetary value
rfm_fm_plot(rfm_result)

# frequency vs recency
rfm_rf_plot(rfm_result)



# using transaction data
analysis_date <- lubridate::as_date('2006-12-31')
rfm_order <- rfm_table_order(rfm_data_orders, customer_id, order_date,
                             revenue, analysis_date)

# heat map
rfm_heatmap(rfm_order)

# using customer data
analysis_date <- lubridate::as_date('2007-01-01')
rfm_customer <- rfm_table_customer(rfm_data_customer, customer_id, number_of_orders, recency_days, revenue, analysis_date)

# heat map
rfm_heatmap(rfm_customer)


analysis_date <- lubridate::as_date('2006-12-31')
rfm_result <- rfm_table_order(rfm_data_orders, customer_id, order_date, revenue, analysis_date)

segment_names <- c("Champions", "Loyal Customers", "Potential Loyalist",
                   "New Customers", "Promising", "Need Attention", "About To Sleep",
                   "At Risk", "Can't Lose Them", "Lost")

recency_lower <- c(4, 2, 3, 4, 3, 2, 2, 1, 1, 1)
recency_upper <- c(5, 5, 5, 5, 4, 3, 3, 2, 1, 2)
frequency_lower <- c(4, 3, 1, 1, 1, 2, 1, 2, 4, 1)
frequency_upper <- c(5, 5, 3, 1, 1, 3, 2, 5, 5, 2)
monetary_lower <- c(4, 3, 1, 1, 1, 2, 1, 2, 4, 1)
monetary_upper <- c(5, 5, 3, 1, 1, 3, 2, 5, 5, 2)

rfm_segment(rfm_result, segment_names, recency_lower, recency_upper,
            frequency_lower, frequency_upper, monetary_lower, monetary_upper)






