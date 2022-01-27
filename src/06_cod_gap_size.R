library('ggplot2')
library('scales')
library('prismatic')

viz <- gap[gap$institution == 'College of DuPage',]

#source
source <- 'Source: IPEDS Trends for the overall completion rates for
full-time first-year degree/certificate-seeking undergraduate students 
(2-year institutions)'

ggplot(data = viz,
       aes(x = year,
           y = black_white_gap,
           label = percent(black_white_gap, accuracy = 1L))) +
  geom_col(fill = '#81515a',
           color = clr_darken('#81515a', 0.5)) +
  geom_text(vjust = -0.75) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.1)),
                     labels = label_percent(accuracy = 1L),
                     breaks = seq(from = 0.05,
                                  to = 0.25,
                                  by = 0.05)) +
  scale_x_continuous(breaks = min(viz$year):max(viz$year)) +
  labs(x = '\nYear',
       y = 'White Completion % - Black Completion %\n',
       title = 'Black/White Achievement Gap, College of DuPage',
       caption = str_wrap(source, 80)) +
  guides(fill = 'none') +
  my_theme

ggsave(file.path('graphs', 'plot6.png'))
