library('ggplot2')
library('scales')

viz <- gap[gap$institution %in% institutions,]

ggplot(data = viz,
       aes(x = year,
           y = black_white_gap,
           label = percent(black_white_gap,
                           accuracy = 1))) +
  geom_col() +
  geom_text(vjust = -1,
            size = 3) +
  facet_wrap(facets = 'institution') +
  scale_y_continuous(expand = expansion(mult = c(0, 0.1)),
                     labels = label_percent(accuracy = 1L)) +
  scale_x_continuous(breaks = seq(from = min(viz$year),
                                  to = max(viz$year),
                                  by = 2)) +
  labs(x = '\nYear',
       y = 'Percent Completed\n',
       title = 'Black/White Achievement Gap at Peer Institutions') +
  my_theme

ggsave(file.path('graphs', 'plot2.png'))
