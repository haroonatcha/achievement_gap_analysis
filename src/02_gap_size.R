library('ggplot2')
library('scales')
library('prismatic')

viz <- gap[gap$institution %in% institutions,]

ggplot(data = viz,
       aes(x = year,
           y = black_white_gap,
           label = percent(black_white_gap,
                           accuracy = 1))) +
  geom_col(fill = '#81515a',
           color = clr_darken('#81515a', 0.5)) +
  geom_text(vjust = -1,
            size = 3) +
  facet_wrap(facets = 'institution') +
  scale_y_continuous(expand = expansion(mult = c(0, 0.1)),
                     labels = label_percent(accuracy = 1L),
                     breaks = seq(from = 0.1,
                                  to = 0.3,
                                  by = 0.1)) +
  scale_x_continuous(breaks = seq(from = min(viz$year),
                                  to = max(viz$year),
                                  by = 2)) +
  labs(x = '\nYear',
       y = 'White Completion % - Black Completion %\n',
       title = 'Black/White Achievement Gap at Peer Institutions',
       caption = source) +
  my_theme

ggsave(file.path('graphs', 'plot2.png'))
