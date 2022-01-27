#group of institutions to compare

#This first group is just geographically nearby
institutions <- c('College of DuPage', 'Waubonsee Community College',
                  'Elgin Community College', 'William Rainey Harper College')


#this second group is colleges with more than 1k

#first aggregate to total yearly cohort size
temp <- aggregate(data$cohort_size,
                  by = list(data$institution,
                            data$year),
                  FUN = sum,
                  na.rm = TRUE)

colnames(temp) <- c('institution', 'year', 'cohort_size')

temp <- aggregate(temp$cohort_size,
                  by = list(temp$institution),
                  FUN = mean)

large_institutions <- temp$Group.1[temp$x >= 500]

cache('institutions')
cache('large_institutions')
