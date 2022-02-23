library('ggplot2')
library('scales')
library('prismatic')

viz <- gap[gap$institution %in% institutions,]

#keep only raw completion numbers
viz <- melt(viz[,c(1:5)],
            id.vars = c('institution', 'year'))

colnames(viz) <- c('institution', 'year',
                   'ethnicity', 'completion')

viz$ethnicity <- factor(viz$ethnicity,
                        levels = c('black_aa',
                                   'hispanic_latino',
                                   'white'),
                        labels = c('Black/African American',
                                   'Hispanic/Latino',
                                   'White'))

plot1 <- ggplot(data = viz,
                aes(x = year,
                     y = completion,
                     color = ethnicity,
                     group = ethnicity)) +
  geom_line(size = 1) +
  facet_wrap(facets = 'institution') +
  scale_x_continuous(breaks = seq(from = min(viz$year),
                                  to = max(viz$year),
                                  by = 2)) +
  scale_y_continuous(labels = label_percent(accuracy = 1L)) +
  scale_color_manual(values = c('#81515a', '#5f5a80', '#126a62')) +
  labs(x = '\nYear',
       y = 'Percent Completed\n',
       title = 'Percent Completed at Peer Institutions by Ethnicity') +
  my_theme

ggsave(file.path('graphs', 'plot1.png'))
