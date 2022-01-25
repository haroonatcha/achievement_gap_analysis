library('ggplot2')

viz <- gap[gap$institution %in% institutions,]

ggplot(data = viz,
       aes(x = year,
           y = black_white_gap_likelihood,
           label = round(black_white_gap_likelihood, 1))) +
  geom_col() +
  geom_text(vjust = -0.5) +
  facet_wrap(facets = 'institution') +
  scale_x_continuous(breaks = seq(from = min(viz$year),
                                  to = max(viz$year),
                                  by = 2)) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.15))) +
  labs(x = '\nYear',
       y = 'White/Black Completion Likelihood\n',
       title = 'Likelihood of White Completion Relative to Black Completion') +
  my_theme

ggsave(file.path('graphs', 'plot4.png'))
