library('ggplot2')
library('ggpattern')

#get only CoD data. Two df, one for lines, one for ribbons
line <- gap[gap$institution == 'College of DuPage',
            c('year', 'black_aa', 
              'hispanic_latino',
              'white')]

line <- melt(line,
             id.vars = 'year')

colnames(line) <- c('year', 'ethnicity', 'completion')

line$ethnicity <- factor(line$ethnicity,
                         levels = c('black_aa',
                                    'hispanic_latino',
                                    'white'),
                         labels = c('Black/African American',
                                    'Hispanic/Latino',
                                    'White'))

ribbon <- gap[gap$institution == 'College of DuPage',
              c('year', 'black_aa',
                'hispanic_latino',
                'white')]


ggplot(data = ribbon,
       aes(x = year)) +
  geom_ribbon(aes(ymin = black_aa,
                  ymax = white),
              fill = 'grey90') +
  geom_ribbon_pattern(aes(ymin = hispanic_latino,
                          ymax = white),
                      fill = 'grey90',
                      pattern_angle = 115,
                      pattern_colour = NA,
                      pattern_density = 0.5,
                      pattern = 'stripe') +
  geom_line(data = line,
            aes(y = completion,
                group = ethnicity,
                color = ethnicity)) +
  scale_x_continuous(breaks = min(viz$year):max(viz$year),
                     expand = expansion(add = c(0, 0.2))) +
  scale_y_continuous(labels = label_percent(accuracy = 1L)) +
  labs(x = '\nYear',
       y = '3-Year Completion Rate\n',
       title = '3-Year Achievement Gap by Ethnicity') +
  my_theme

ggsave(file.path('graphs', 'plot3.png'))
