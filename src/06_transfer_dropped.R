library('reshape2')
library('ggplot2')
library('scales')
library('ggpattern')

eth <- c('Black or African American', 'White')

viz <- cod_data[cod_data$ethnicity %in% eth,]

viz <- viz[,c(1, 2, 6, 9:10)]

viz <- melt(viz,
            id.vars = c('ethnicity', 'year'))

viz$variable <- factor(viz$variable,
                       levels = c('completion_rate',
                                  'transferred_percent',
                                  'dropped_percent'),
                       labels = c('Completed', 'Transferred',
                                  'Dropped'))

transferred <- viz[viz$variable == 'Transferred',]


dropped <- viz[viz$variable == 'Dropped',]

dropped_ribbon <- dcast(dropped,
                        formula = year + variable ~ ethnicity,
                        value.var = 'value')


colnames(dropped_ribbon) <- c('year', 'variable', 'Black_AA', 'White')

#adjust ribbon values to indicate where the gap begins
dropped_ribbon$Black_AA[dropped_ribbon$year == 2011] <- 0.38
dropped_ribbon$White[dropped_ribbon$year == 2011] <- 0.38
dropped_ribbon$year[dropped_ribbon$year == 2011] <- 2011.245

#adjust x/y-pos for text labels
dropped$ypos <- ifelse(dropped$ethnicity == 'White',
                       dropped$value - 0.0137,
                       dropped$value + 0.0137)

dropped$ypos[which(dropped$ethnicity == 'White' &
                     dropped$year == 2011)] <- 0.4

dropped$ypos[which(dropped$ethnicity == 'Black or African American' &
                     dropped$year == 2011)] <- 0.35



#nudge x-position of text labels
dropped$xpos <- dropped$year

dropped$xpos[which(dropped$ethnicity == 'Black or African American' &
                     dropped$year == 2018)] <- 2018.125

dropped$xpos[which(dropped$ethnicity == 'Black or African American' &
                     dropped$year == 2016)] <- 2015.85

dropped$xpos[which(dropped$ethnicity == 'Black or African American' &
                     dropped$year == 2013)] <- 2012.9

ggplot() +
  geom_ribbon_pattern(data = dropped_ribbon,
                      aes(x = year,
                          ymin = White,
                          ymax = Black_AA),
                      fill = 'grey90',
                      alpha = 0.6,
                      pattern_alpha = 0.6,
                      pattern_angle = 115,
                      pattern_colour = NA,
                      pattern_density = 0.5,
                      pattern = 'stripe') +
  geom_line(data = dropped,
            aes(x = year,
                y = value,
                group = ethnicity,
                color = ethnicity),
            size = 1.5) +
  geom_point(data = dropped,
             aes(x = year,
                 y = value,
                 color = ethnicity),
             size = 4) +
  geom_text(data = dropped,
            aes(x = xpos,
                y = ypos,
                label = percent(value, 1),
                color = ethnicity),
            size = 4,
            show.legend = FALSE) +
  scale_x_continuous(breaks = min(dropped$year):max(dropped$year)) +
  scale_y_continuous(breaks = seq(from = 0.3,
                                  to = 0.5,
                                  by = 0.1),
                     labels = label_percent(accuracy = 1L)) +
  scale_color_hue(h = c(180, 360), l = 40, c = 30) +
  labs(x = '\nYear',
       y = '3-Year Drop-out Rate\n',
       title = 'Drop-out Rates by Ethnicity, College of DuPage',
       caption = str_wrap(source, 80)) +
  my_theme

ggsave(file.path('graphs', 'plot6a.png'))


# Transfer chart ----------------------------------------------------------

transferred$ypos <- ifelse(transferred$ethnicity == 'White',
                           transferred$value - 0.02,
                           transferred$value + 0.02)

#adjust y-pos of text labels
transferred$ypos[which(transferred$ethnicity == 'White' &
                         transferred$year == 2017)] <- 0.328

transferred$ypos[which(transferred$ethnicity == 'White' &
                         transferred$year == 2019)] <- 0.30

transferred$ypos[which(transferred$ethnicity == 'Black or African American' &
                         transferred$year == 2017)] <- 0.28

transferred$ypos[which(transferred$ethnicity == 'Black or African American' &
                         transferred$year == 2019)] <- 0.24

transferred$ypos[which(transferred$ethnicity == 'White' &
                         transferred$year == 2020)] <- 0.315

transferred$ypos[which(transferred$ethnicity == 'Black or African American' &
                         transferred$year == 2020)] <- 0.28


#transfer rates
ggplot(data = transferred,
       aes(x = year,
           y = value,
           group = ethnicity,
           color = ethnicity)) +
  geom_line(size = 1.5) +
  geom_point(size = 4) +
  geom_text(aes(x = year,
                y = ypos,
                color = ethnicity,
                label = percent(value, 1)),
            size = 4,
            inherit.aes = FALSE) +
  scale_x_continuous(breaks = min(transferred$year):max(transferred$year)) +
  scale_y_continuous(breaks = seq(from = 0.3,
                                  to = 05,
                                  by = 0.1),
                     labels = label_percent(accuracy = 1L)) +
  scale_color_hue(h = c(180, 360), l = 40, c = 30) +
  labs(x = '\nYear',
       y = '3-Year Transfer Rate\n',
       title = 'Transfer Rates by Ethnicity, College of DuPage',
       caption = str_wrap(source, 80)) +
  my_theme

ggsave(file.path('graphs', 'plot6b.png'))
