

# Keep relevant rows ------------------------------------------------------

cod_data <- cod_data[-grep('total', cod_data$ethnicity, ignore.case = TRUE),]

# Coerce 0's and column types ---------------------------------------------

cod_data$cohort_size[cod_data$cohort_size == ''] <- 0
cod_data$completers[cod_data$completers == ''] <- 0
cod_data$transfers[cod_data$transfers == ''] <- 0
cod_data$exclusions[cod_data$exclusions == ''] <- 0
cod_data$enrolled[cod_data$enrolled == ''] <- 0
cod_data$not_enrolled[cod_data$not_enrolled == ''] <- 0

cod_data$cohort_size <- as.numeric(cod_data$cohort_size)
cod_data$completers <- as.numeric(cod_data$completers)
cod_data$transfers <- as.numeric(cod_data$transfers)
cod_data$exclusions <- as.numeric(cod_data$exclusions)
cod_data$enrolled <- as.numeric(cod_data$enrolled)
cod_data$not_enrolled <- as.numeric(cod_data$not_enrolled)


# Rename factor levels ----------------------------------------------------

cod_data$ethnicity[cod_data$ethnicity == 'Race and ethnicity unknown'] <- 'Race/ethnicity unknown'
cod_data$ethnicity[cod_data$ethnicity == 'Hispanic/Latino'] <- 'Hispanic or Latino'


# Merge to CoD data -------------------------------------------------------

#pull in extant cod data
temp <- data[data$institution == 'College of DuPage',]

#aggregate transfers and dropped
transfers <- aggregate(cod_data$transfers,
                       by = list(cod_data$ethnicity,
                                 cod_data$year),
                       FUN = sum,
                       na.rm = TRUE)

colnames(transfers) <- c('ethnicity', 'year', 'transferred')

dropped <- aggregate(cod_data$not_enrolled,
                     by = list(cod_data$ethnicity,
                               cod_data$year),
                     FUN = sum,
                     na.rm = TRUE)

colnames(dropped) <- c('ethnicity', 'year', 'dropped')

#merge metrics together
temp <- merge(temp, transfers)
temp <- merge(temp, dropped)

#create calculated fields
temp$transferred_percent <- temp$transferred / temp$cohort_size
temp$dropped_percent <- temp$dropped / temp$cohort_size

cod_data <- temp

remove(temp)