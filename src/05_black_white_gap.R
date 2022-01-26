library('ggplot2')
library('ggpattern')
library('scales')
library('prismatic')
library('stringr')

line <- gap[gap$institution == 'College of DuPage',
            c('year', 'black_aa', 'white'),]

#melt for line df
line <- melt(line,
             id.vars = 'year')

#rename
colnames(line) <- c('year', 'ethnicity', 'completion')

#coerce to factor for easier plotting
line$ethnicity <- factor(line$ethnicity,
                         levels = c('black_aa',
                                    'white'),
                         labels = c('Black/African American',
                                    'White'))

#manually create label position
offset <- 0.025

line$y_text_pos <- ifelse(line$ethnicity == 'White',
                          line$completion + 0.005,
                          line$completion - offset)

#omitting label for 2011
line$alpha <- ifelse(line$year == 2011, 0, 1)

#create ribbon df
ribbon <- gap[gap$institution == 'College of DuPage',
              c('year', 'black_aa',
                'white')]

#ribbon label position, gap, and hide 2011
ribbon$y_pos <- (ribbon$black_aa + ribbon$white) / 2
ribbon$gap <- ribbon$white - ribbon$black_aa
ribbon$alpha <- ifelse(ribbon$year == 2011, 0, 1)

#source text


source <- 'Source: IPEDS Trends for the overall completion rates for
full-time first-year degree/certificate-seeking undergraduate students 
(2-year institutions)'

str_wrap(source, width = 80)

ggplot(data = line) +
  geom_ribbon_pattern(data = ribbon,
                      aes(x = year,
                          ymin = black_aa,
                          ymax = white),
                      fill = 'grey90',
                      alpha = 0.6,
                      pattern_alpha = 0.6,
                      pattern_angle = 115,
                      pattern_colour = NA,
                      pattern_density = 0.5,
                      pattern = 'stripe') +
  geom_line(aes(x = year,
                y = completion,
                color = ethnicity),
            size = 1.5) +
  geom_text(aes(x = ifelse(year == 2017 &
                             ethnicity == 'Black/African American',
                           year + 0.12,
                           year),
                y = y_text_pos,
                label = percent(completion, 1),
                color = ethnicity,
                alpha = alpha),
            vjust = -0.75,
            size = 3.5,
            show.legend = FALSE) +
  scale_x_continuous(breaks = min(line$year):max(line$year),
                     expand = expansion(add = c(0, 0.2))) +
  scale_y_continuous(labels = label_percent(accuracy = 1L),
                     expand = expansion(mult = c(0, 0.1)),
                     limits = c(0, max(line$completion*1.1)),
                     breaks = seq(from = 0.1,
                                  to = round(max(line$completion, 2)),
                                  by = 0.1)) +
  scale_alpha_continuous(range = c(0, 1), guide = 'none') +
  scale_color_hue(h = c(180, 360), l = 40, c = 30) +
  labs(x = '\nYear',
       y = '3-Year Completion Rate\n',
       title = 'Black-White Achievement Gap, College of DuPage',
       caption = str_wrap(source, 80)) +
  my_theme

ggsave(file.path('graphs', 'plot5.png'))


