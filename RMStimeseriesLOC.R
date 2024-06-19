library(tidyverse)
library(readxl)
library(cowplot)
# Load in data---------------------------
# PC computer
setwd('C:\\Users\\Alex\\Dropbox\\Catholic U\\Manuscripts\\VR_EXO_healthies\\Review\\MATLABoutput') # PC
p.table = read_xlsx('C:\\Users\\Alex\\Dropbox\\Catholic U\\VR_EXO\\VR_participant_list.xlsx')
# 
# # Mac computer
# setwd('//Users//alexbrunfeldt//Dropbox//Catholic U//Manuscripts//VR_EXO_healthies//Review//MATLABoutput') # PC
# p.table = read_xlsx('//Users//alexbrunfeldt//Dropbox//Catholic U//VR_EXO//VR_participant_list.xlsx')

df.rms.loc = read.delim('rmswinDFtargetLoc_shift200',header = FALSE, sep = ",", na.strings = 'NaN') # load in data
#
# Set column names; recode factors---------------
# Make sure the colnames match these (copied straight from Matlab)
# [subid cond block handL sample lhDmean(:,target-4) lhDstd(:,target-4)];
colnames(df.rms.loc) = c('Subject', 'Condition', 'Block', 'Hand', 'Muscle', 'Sample',
                     't1','t2','t3','t4','t5','t6','t7','t8','t9','t10','t11','t12','t13','t14','t15','t16') # rename variables

# Recode Condition to match intervention
df.rms.loc = df.rms.loc %>% mutate(Condition = recode(Condition,
                                              '1' = "Baseline",
                                              '2' = "RH weighted",
                                              '3' = "LH weighted",
                                              '4' = "Combo"),
                           Hand = recode(Hand,
                                         '1' = "Left",
                                         '2' = "Right"),
                           Muscle = recode(Muscle,
                                           '1' = "Deltoid",
                                           '2' = "Bicep"))

# Pivot around new factor 'Trial" (goes from 1-16, as specified in import DC)
df.rms.loc = df.rms.loc %>% pivot_longer(cols = starts_with("t"),
                                         names_to = "Trial",
                                         names_prefix = "t",
                                         values_to = "rms")
#

# Set Load Factor -----------------------
# Identify in the 'Load' factor in the VR_participant_list excel file
subs.day1.30 = subset(p.table, grepl("3", Intervention))$subID01 # Find subjects who did 30% on day 1
subs.day1.60 = subset(p.table, grepl("6", Intervention))$subID01 # Find subjects who did 60% on day 1
subs.day2.30 = subset(p.table, !subID01 %in% subs.day1.30)$subID02 # Find subjects who did 30% on day 2
subs.day2.60 = subset(p.table, !subID01 %in% subs.day1.60)$subID02 # Find subjects who did 60% on day 2

# Add in the 'Load' and 'Day' factors
df.rms.loc = df.rms.loc %>% mutate(Load = case_when(Subject %in% subs.day1.30 ~ "30%",
                                            Subject %in% subs.day1.60 ~ "60%",
                                            Subject %in% subs.day2.30 ~ "30%",
                                            Subject %in% subs.day2.60 ~ "60%")) %>%
  mutate(Day = case_when(Subject %in% c(subs.day1.30, subs.day1.60) ~ "Day 1",
                         Subject %in% c(subs.day2.30, subs.day2.60) ~ "Day 2")) %>%
  relocate(Load, .after = Hand) %>% relocate(Day, .after = Load)

# Replace day 2 Subject identiers with the corresponding day 1 subject identifiers. NOTE: this is coded in the p.table variable from the Excel file!!!
for (i in 1:nrow(p.table)){
  if (!is.na(p.table$subID01[i]) & !is.na(p.table$subID02[i])) # Only recode non-"NA" values
  {
    df.rms.loc[df.rms.loc$Subject == p.table$subID02[i],]$Subject = p.table$subID01[i]
  }
}

# Remove outlier participants (ie: left handers, no-shows, etc...)
outliers = c(73823902)
df.rms.loc = subset(df.rms.loc, !Subject %in% outliers)
# Set Factors
factors = c('Subject', 'Condition', 'Hand', 'Muscle', 'Load', 'Day', 'Trial')
df.rms.loc[,factors] = lapply(df.rms.loc[,factors], factor)
rm(subs.day1.30, subs.day1.60, subs.day2.30, subs.day2.60, factors, i)

#

# Baseline correct --------------------------------------------------------
# Since raw EMG data are not internally normalized (different sensor configs, etc.), nor do I have MVC data; I need to baseline correct
# I'll do this by taking each of the 100 trials per muscle, hand, block as a % change from the mean at baseline.

# Baseline correct (% Change from mean Block 1 muscle activity)
df.rms.loc = df.rms.loc %>% group_by(Subject, Muscle, Hand, Day) %>% 
  mutate(rms.bc = 100*(rms - mean(rms[Block == 1]))/mean(rms[Block == 1]))

df.rms.loc$Block = as.factor(df.rms.loc$Block)
# Plotting----------------------
sub = "73828701" # choose from: "73824601", "73828701" (used for manuscript 2/1/22), or "73824602"
# load 60; use errorbar = SEM
ggplot(data = subset(df.rms.loc, Subject == sub & Load == "60%" & !Block %in% c(1,3,5) & Muscle == "Deltoid"),
       aes(x = Sample, y = rms, color = Hand, fill = Hand))+
  stat_summary(fun = 'mean', geom = 'line', size = 1)+
  stat_summary(fun.data = 'mean_se', geom = 'ribbon', alpha = 0.3)+
  theme_cowplot()+
  panel_border()+
  facet_grid(rows = vars(Condition))+
  theme(text = element_text(size = 26),
        strip.text.x = element_text(size = 24),
        axis.text = element_text(size = 14),
        strip.background = element_blank())

# load 60; use errorbar = SEM; baseline corrected; by hand
ggplot(data = subset(df.rms.loc, Subject == sub & Load == "60%" & !Block %in% c(1,3,5) & Muscle == "Deltoid"),
       aes(x = Sample, y = rms.bc, color = Hand, fill = Hand))+
  stat_summary(fun = 'mean', geom = 'line', size = 1)+
  stat_summary(fun.data = 'mean_se', geom = 'ribbon', alpha = 0.3)+
  theme_cowplot()+
  panel_border()+
  facet_grid(rows = vars(Condition))+
  theme(text = element_text(size = 26),
        strip.text.x = element_text(size = 24),
        axis.text = element_text(size = 14),
        strip.background = element_blank())

# load 60; errorbar = SEM; by condition
ggplot(data = subset(df.rms.loc, Subject == sub & Load == "60%" & !Block %in% c(3,5) & Muscle == "Deltoid"),
       aes(x = Sample, y = rms, color = Condition, fill = Condition))+
  stat_summary(fun = 'mean', geom = 'line', size = 1)+
  stat_summary(fun.data = 'mean_se', geom = 'ribbon', alpha = 0.3)+
  theme_cowplot()+
  panel_border()+
  facet_grid(rows = vars(Hand))+
  theme(text = element_text(size = 26),
        strip.text.x = element_text(size = 24),
        axis.text = element_text(size = 14),
        strip.background = element_blank())
