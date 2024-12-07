# create data ----
simulation_data_original <- tibble::tibble(
  value = rnorm(n = 100000, mean = 0, sd = 10)
) 

simulation_data <- list()

make_simulation_data <- function(data_num, visible_option){
  simulation_data_modified <- simulation_data_original |> 
    dplyr::filter(dplyr::row_number() <= data_num) |> 
    as.list() 
  
  simulation_data_modified$visible = visible_option

  simulation_data_modified
}

simulation_data[[1]] <- make_simulation_data(data_num = 10, visible_option = FALSE)
simulation_data[[2]] <- make_simulation_data(data_num = 100, visible_option = FALSE)
simulation_data[[3]] <- make_simulation_data(data_num = 1000, visible_option = TRUE)
simulation_data[[4]] <- make_simulation_data(data_num = 10000, visible_option = FALSE)
simulation_data[[5]] <- make_simulation_data(data_num = 100000, visible_option = FALSE)



# create steps and plot all traces ----
steps <- list()

main_plot <- plotly::plot_ly() 

for (i in 1:length(simulation_data)) {
  data_converted <- simulation_data[[i]] |> 
    as.data.frame() 
  
  main_plot <- plotly::add_histogram(
    p = main_plot,
    data = data_converted,
    x = ~value,
    visible = ~visible,
    xbins = list(
      size = 1
      ),
    color = I("#00BFC4"),
    hoverinfo = "none",
    showlegend = FALSE
    )
  
  step <- list(args = list('visible', rep(FALSE, 5)),
               method = 'restyle',
               label = if(i == 1){
                 "n = 10"
               }else if(i == 2){
                 "n = 100"
               }else if(i == 3){
                 "n = 1000"
               }else if(i == 4){
                 "n = 10000"
               }else if(i == 5){
                 "n = 100000"
               }
               )
  step$args[[2]][i] = TRUE  
  steps[[i]] = step 
}  



# add slider control to plot ----
main_plot <- main_plot |> 
  plotly::layout(sliders = list(list(active = 2,
                                     currentvalue = list(prefix = "Length: "),
                                     pad = list(t = 50),
                                     steps = steps)),
                 xaxis = list(
                   title = "",
                   range = list(-50, 50)
                 ),
                 yaxis = list(
                   title = "count"
                 ), 
                 title = list(
                   text = "Change data size",
                   font = list(
                     size = 16
                   )
                 )
  )


main_plot

