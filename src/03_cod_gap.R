library('ggplot2')
library('ggpattern')
library('scales')
library('RColorBrewer')
library('prismatic')


#get only CoD data for groups under analysis.

#Two df, one for lines, one for ribbons
line <- gap[gap$institution == 'College of DuPage',
            c('year', 'black_aa', 
              'hispanic_latino',
              'white')]

#melt for line df
line <- melt(line,
             id.vars = 'year')

#rename
colnames(line) <- c('year', 'ethnicity', 'completion')

#omitting label for 2011
line$alpha <- ifelse(line$year == 2011, 0, 1)
line$alpha[line$ethnicity == 'hispanic_latino' & line$year == '2012'] <- 0

#coerce to factor for easie rplotting
line$ethnicity <- factor(line$ethnicity,
                         levels = c('black_aa',
                                    'hispanic_latino',
                                    'white'),
                         labels = c('Black/African American',
                                    'Hispanic/Latino',
                                    'White'))

#create ribbon df
ribbon <- gap[gap$institution == 'College of DuPage',
              c('year', 'black_aa',
                'hispanic_latino',
                'white')]

#source text


ggplot(data = ribbon,
       aes(x = year)) +
  geom_line(data = line,
            aes(y = completion,
                group = ethnicity,
                color = ethnicity),
            size = 1.5) +
  geom_text(data = line,
            aes(x = year,
                y = completion,
                label = percent(completion, 1),
                color = ethnicity,
                alpha = alpha),
            vjust = -0.85,
            size = 4.5,
            show.legend = FALSE) +
  scale_x_continuous(breaks = min(line$year):max(line$year),
                     expand = expansion(add = c(0, 0.2))) +
  scale_y_continuous(labels = label_percent(accuracy = 1L),
                     expand = expansion(mult = c(0, 0.1)),
                     limits = c(0, max(line$completion)),
                     breaks = seq(from = 0.1,
                                  to = round(max(line$completion, 2)),
                                  by = 0.1)) +
  scale_alpha_continuous(range = c(0, 1), guide = 'none') +
  scale_color_hue(h = c(180, 360), l = 40, c = 30) +
  labs(x = '\nYear',
       y = '3-Year Completion Rate\n',
       title = '3-Year Achievement by Ethnicity, College of DuPage',
       caption = source) +
  my_theme


ggsave(file.path('graphs', 'plot3.png'))
