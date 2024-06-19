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

df.rms = read.delim('rmswinDF',header = FALSE, sep = ",", na.strings = 'NaN') # load in data
#
# Set column names; recode factors---------------
# Make sure the colnames match these (copied straight from Matlab)
# [subid cond block handL sample lhDmean(:,target-4) lhDstd(:,target-4)];
colnames(df.rms) = c('Subject', 'Condition', 'Block', 'Hand', 'Muscle', 'Sample',
                      'rms.mean', 'rms.std') # rename variables

# Recode Condition to match intervention
df.rms = df.rms %>% mutate(Condition = recode(Condition,
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
#

# Set Load Factor -----------------------
# Identify in the 'Load' factor in the VR_participant_list excel file
subs.day1.30 = subset(p.table, grepl("3", Intervention))$subID01 # Find subjects who did 30% on day 1
subs.day1.60 = subset(p.table, grepl("6", Intervention))$subID01 # Find subjects who did 60% on day 1
subs.day2.30 = subset(p.table, !subID01 %in% subs.day1.30)$subID02 # Find subjects who did 30% on day 2
subs.day2.60 = subset(p.table, !subID01 %in% subs.day1.60)$subID02 # Find subjects who did 60% on day 2

# Add in the 'Load' and 'Day' factors
df.rms = df.rms %>% mutate(Load = case_when(Subject %in% subs.day1.30 ~ "30%",
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
    df.rms[df.rms$Subject == p.table$subID02[i],]$Subject = p.table$subID01[i]
  }
}

# Remove outlier participants (ie: left handers, no-shows, etc...)
outliers = c(73823902)
df.rms = subset(df.rms, !Subject %in% outliers)
# Set Factors
factors = c('Subject', 'Condition', 'Hand', 'Muscle', 'Load', 'Day')
df.rms[,factors] = lapply(df.rms[,factors], factor)
rm(subs.day1.30, subs.day1.60, subs.day2.30, subs.day2.60, factors, i)

#

# Baseline correct --------------------------------------------------------
# Since raw EMG data are not internally normalized (different sensor configs, etc.), nor do I have MVC data; I need to baseline correct
# I'll do this by taking each of the 100 trials per muscle, hand, block as a % change from the mean at baseline.

# Baseline correct (% Change from Block 1)
df.rms = df.rms %>% group_by(Subject, Muscle, Hand, Day) %>% mutate(rms.mean.bc = 100*(rms.mean - mean(rms.mean[Block == 1]))/mean(rms.mean[Block == 1]),
                                                                    rms.std.bc = 100*(rms.std - mean(rms.std[Block == 1]))/mean(rms.std[Block == 1]))


# Plotting----------------------
ggplot(data = subset(df.rms, Condition == "RH weighted" & Load == "60%" & !Block %in% c(3,5) & Muscle == "Deltoid"), aes(x = Sample, y = rms.mean, color = Hand))+
  geom_point()+
  facet_wrap(~Subject)

ggplot(data = subset(df.rms, Load == "60%" & !Block %in% c(3,5)), aes(x = Sample, y = rms.mean, color = Hand))+
  stat_summary(fun.data = 'mean_se')+
  facet_grid(rows = vars(Condition))

# Plot sub 73824601, load 60; use errorbar = SEM
ggplot(data = subset(df.rms, Subject == "73824601" & Load == "60%" & !Block %in% c(1,3,5) & Muscle == "Deltoid"), aes(x = Sample, y = rms.mean, color = Hand))+
  geom_line(size = 1)+
  geom_ribbon(aes(ymin = rms.mean - rms.std/sqrt(16), ymax = rms.mean + rms.std/sqrt(16), fill = Hand), alpha = 0.3)+
  theme_cowplot()+
  panel_border()+
  facet_grid(rows = vars(Condition))+
  theme(text = element_text(size = 26),
        strip.text.x = element_text(size = 24),
        axis.text = element_text(size = 14),
        strip.background = element_blank())
