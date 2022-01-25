library('reshape2')
library('magrittr')
library('stringr')

# Initial reshaping -------------------------------------------------------

#Dates are in wide, melt to long
data <- melt(data,
             id.vars = c('Institution.Name', 
                         'Race.ethnicity', 
                         'Statistic'))

#rename columns
colnames(data) <- c('institution', 'ethnicity',
                    'statistic', 'year',
                    'value')


# Pre-process institution and statistic name ------------------------------

#clean institution name
data$institution <- str_trim(data$institution)

#clean statistic name
data$statistic <- ifelse(data$statistic == 'Adjusted cohort', 
                         'cohort_size', 'completed')



# Pre-process ethnicity and year ------------------------------------------

#extend values in merged cells to blank cells
for(i in 1:nrow(data)) {
  if(data$ethnicity[i] == '') {
    data$ethnicity[i] <- data$ethnicity[i- 1]
  }
}

#trim white-space
data$ethnicity <- str_trim(data$ethnicity)

#pre-process year
data$year <- gsub('X', '', data$year)
data$year <- as.numeric(data$year)



# Pre-process value type and missing --------------------------------------

#replace NA
data$value[which(data$value == '-')] <- NA
data$value <- as.numeric(data$value)



# Final munging and calculated fields -------------------------------------

#pivot out statistic
data <- dcast(data, value.var = 'value',
              formula = institution + ethnicity + year ~ statistic)

#NA means either no incoming cohort or no reported data
data$completion_rate <- data$completed / data$cohort_size
