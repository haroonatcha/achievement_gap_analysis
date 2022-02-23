library('ggplot2')
library('prismatic')
library('scales')

viz <- data[data$institution == 'College of DuPage',]

#groups under study for visual clarity
groups <- c('Black or African American',
            'Hispanic or Latino', 'White')

viz <- viz[viz$ethnicity %in% groups,]

#2011 is less clear thant he rest. Omit for visual clarity
#viz <- viz[viz$year > 2011,]

#coerce to factor for easier plotting
viz$ethnicity <- factor(viz$ethnicity,
                        levels = c('White', 'Asian',
                                   'Hispanic or Latino',
                                   'Black or African American'))

#sort for proper visual stacking
viz <- viz[order(viz$year, as.numeric(viz$ethnicity)),] 


#calculate y_position. Factors need to be in one order for
#proper plotting but calculations need to be done the other way
#hence the goofy-ass sequence in the for-loop
for(i in seq(from = nrow(viz), to = 1, by = -1)) {
  if(viz$ethnicity[i] == 'Black or African American') {
    viz$y_pos[i] <- viz$completion_rate[i]
  } else {
    viz$y_pos[i] <- viz$completion_rate[i] - viz$completion_rate[i + 1]
  }
}

#super tiny negative value for 2011 disrupts chart. Fixing that here
viz$y_pos <- ifelse(viz$y_pos < 0, 0, viz$y_pos)


ggplot(data = viz,
       aes(x = year,
           y = y_pos,
           fill = ethnicity,
           color = after_scale(clr_darken(fill, 0.5)),
           group = ethnicity)) +
  geom_area() +
  scale_x_continuous(breaks = min(viz$year):max(viz$year),
                     expand = expansion(add = c(0.1, 0.1)),
                     limits = c(min(viz$year), max(viz$year))) +
  scale_y_continuous(labels = label_percent(accuracy = 1L),
                     expand = expansion(mult = c(0, 0.1)),
                     limits = c(0, max(viz$completion)),
                     breaks = seq(from = 0.1,
                                  to = round(max(viz$completion, 2)),
                                  by = 0.1)) +
  scale_fill_manual(values = c('#81515a', '#5f5a80', '#126a62')) +
  scale_color_manual(values = clr_darken(c('#81515a', '#5f5a80', '#126a62'), 0.5),
                     guide = 'none') +
  labs(x = '\nYear',
       y = '3-Year Completion Rate\n',
       title = '3-Year Achievement by Ethnicity, College of DuPage',
       caption = source) +
  my_theme

ggsave(file.path('graphs', 'plot5.png'))


