library('ggplot2')
library('scales')
library('prismatic')
library('ggpattern')
library('reshape2')

viz <- gap[gap$institution %in% institutions,]

#keep only raw completion numbers
viz <- melt(viz[,c(1:5)],
            id.vars = c('institution', 'year'))

colnames(viz) <- c('institution', 'year',
                   'ethnicity', 'completion')

viz <- viz[-which(viz$ethnicity == 'hispanic_latino'),]

viz$ypos <- ifelse(viz$ethnicity == 'black_aa',
                   viz$completion - 0.05,
                   viz$completion + 0.05)

viz$ethnicity <- factor(viz$ethnicity,
                        levels = c('black_aa',
                                   'white'),
                        labels = c('Black/African American',
                                   'White'))


ribbon <- dcast(viz,
                formula = institution + year ~ ethnicity,
                value.var = 'completion')

colnames(ribbon) <- c('institution', 'year', 'black_aa', 'white')


plot1 <- ggplot(data = viz,
                aes(x = year,
                    y = completion,
                    label = percent(completion, 1),
                    color = ethnicity,
                    group = ethnicity)) +
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
                      pattern = 'stripe',
                      inherit.aes = FALSE) +
  geom_line(size = 1) +
  geom_point(size = 3) +
  geom_text(aes(y = ypos),
            show.legend = FALSE) +
  facet_wrap(facets = 'institution') +
  scale_x_continuous(breaks = seq(from = min(viz$year),
                                  to = max(viz$year),
                                  by = 2)) +
  scale_y_continuous(labels = label_percent(accuracy = 1L)) +
  scale_color_hue(h = c(180, 360), l = 40, c = 30) +
  labs(x = '\nYear',
       y = 'Percent Completed\n',
       title = 'Percent Completed at Peer Institutions by Ethnicity') +
  my_theme

plot1

ggsave(file.path('graphs', 'plot1.png'))
