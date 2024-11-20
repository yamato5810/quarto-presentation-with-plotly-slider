# create data ----
simulation_data <- tibble::tibble(
  value = rnorm(n = 100000, mean = 0, sd = 10)
) 



# create steps and plot all traces ----
steps <- list()

main_plot <- plotly::plot_ly() 

for (i in 1:5) {
  main_plot <- plotly::add_histogram(
    p = main_plot,
    data = simulation_data,
    x = ~value,
    visible = dplyr::if_else(i == 3, TRUE, FALSE),
    xbins = list(
      size = c(0.01, 0.1, 1, 5, 10)[i]
    ),
    color = I("#00BFC4"),
    hoverinfo = "none",
    showlegend = FALSE
  )
  
  step <- list(args = list('visible', rep(FALSE, 5)),
               method = 'restyle',
               label = paste0(c(0.01, 0.1, 1, 5, 10)[i])
  )
  step$args[[2]][i] = TRUE  
  steps[[i]] = step 
}  



# add slider control to plot ----
main_plot <- main_plot |> 
  plotly::layout(sliders = list(list(active = 2,
                                     currentvalue = list(prefix = "Bin width: "),
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
                   text = "Change bin width",
                   font = list(
                     size = 16
                   )
                 )
  )


main_plot

