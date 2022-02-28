library('ggplot2')
library('reshape2')
library('prismatic')
library('scales')

eth <- c('Black or African American',
         'White')

temp <- cod_data[cod_data$ethnicity %in% eth,]

temp <- temp[temp$year == 2020,]

temp <- temp[, c('completion_rate', 'ethnicity',
                 'transferred_percent', 'dropped_percent')]

temp <- melt(temp, id.vars = c('ethnicity'))

temp$variable <- factor(temp$variable,
                        levels = c('dropped_percent',
                                   'transferred_percent',
                                   'completion_rate'),
                        labels = c('Drop-out Rates',
                                   'Transfer Rates',
                                   'Completion Rates'))

ggplot(data = temp,
       aes(x = variable,
           y = value,
           label = percent(value, 1),
           fill = ethnicity,
           color = after_scale(clr_darken(fill, 0.5)))) +
  geom_col(position = 'dodge',
           size = 1) +
  geom_text(vjust = -0.75,
            position = position_dodge(width = 1),
            size = 5) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.1)),
                     breaks = seq(from = 0.1,
                                  to = 0.5,
                                  by = 0.1),
                     labels = percent_format(accuracy = 1L)) +
  scale_fill_hue(h = c(180, 360), l = 40, c = 30) +
  labs(x = '\nOutcome',
       y = '3-Year Rate\n',
       title = '2020 Equity Gaps, College of DuPage',
       caption = str_wrap(source, 80)) +
  my_theme

ggsave(file.path('graphs', 'plot7.png'))
