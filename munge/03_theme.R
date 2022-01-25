library('ggplot2')

#adding my theme to be used in plots
my_theme <- theme(axis.line.x = element_line(color = 'black'),
                  axis.text = element_text(family = 'serif',
                                           color = 'black'),
                  axis.title = element_text(family = 'serif',
                                            color = 'black'),
                  axis.ticks = element_blank(),
                  legend.position = 'top',
                  legend.title = element_blank(),
                  legend.key = element_blank(),
                  panel.grid = element_blank(),
                  panel.grid.major.y = element_line(color = 'grey90'),
                  panel.background = element_rect(fill = NA),
                  plot.title = element_text(family = 'serif',
                                            hjust = 0.5))

cache('my_theme')
