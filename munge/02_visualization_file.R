library('reshape2')

# Visualization file ------------------------------------------------------

#groups under analysis
groups <- c('White', 'Black or African American', 'Hispanic or Latino')

gap <- data[data$ethnicity %in% groups,]

remove(groups)

#cast to wide
gap <- dcast(gap[,c(1:3, 6)],
             value.var = 'completion_rate',
             formula = institution + year ~ ethnicity)

colnames(gap) <- c('institution', 'year', 'black_aa', 
                   'hispanic_latino', 'white')

#absolute gap
gap$black_white_gap <- gap$white - gap$black_aa
gap$hispanic_white_gap <- gap$white - gap$hispanic_latino

#gap likelihood
gap$black_white_gap_likelihood <- gap$white / gap$black_aa
gap$hispanic_white_gap_likelihood <- gap$white / gap$hispanic_latino