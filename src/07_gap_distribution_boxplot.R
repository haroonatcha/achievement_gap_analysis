library('ggplot2')
library('scales')
library('prismatic')

viz <- gap[gap$institution %in% large_institutions,]

cod <- viz[viz$institution == 'College of DuPage',]

#label position needs adjustment
cod$y_pos <- c(0, 0.045, 0.06, 0, 0.05,
               -0.005, 0.05, 0.06, 0.005, 0)

ggplot(data = viz,
       aes(x = year,
           y = black_white_gap,
           group = year)) +
  geom_boxplot(outlier.shape = NA,
               color = 'grey60') +
  geom_point(data = cod,
             aes(x = year,
                 y = black_white_gap,
                 fill = institution,
                 color = after_scale(clr_darken(fill, 0.5))),
             size = 3,
             shape = 21) +
  geom_text(data = cod,
            aes(x = year,
                y = black_white_gap + y_pos,
                label = percent(black_white_gap, accuracy = 1L)),
            color = '#81515a',
            vjust = 1.75,
            size = 4.5) +
  scale_x_continuous(breaks = min(viz$year):max(viz$year)) +
  scale_y_continuous(labels = label_percent(accuracy = 1L),
                     limits = c(-0.05, 0.45)) +
  scale_fill_manual(values = c('#81515a')) +
  labs(x = '\nYear',
       y = 'Black-White Achievement Gap\n',
       title = 'College of DuPage Achievement Gap vs Peer Institutions',
       caption = str_wrap(source, 80)) +
  my_theme

ggsave(file.path('graphs', 'plot7.png'))
