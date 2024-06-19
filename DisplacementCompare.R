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

df.disp = read.delim('dispDF_nsamp100',header = FALSE, sep = ",", na.strings = 'NaN') # load in data
#

# Set column names; recode factors---------------
# Make sure the colnames match these (copied straight from Matlab)
# [subid cond block handL sample lhDmean(:,target-4) lhDstd(:,target-4)];
colnames(df.disp) = c('Subject', 'Condition', 'Block', 'Hand', 'Sample',
                      'disp.mean', 'disp.std') # rename variables

# Recode Condition to match intervention
df.disp = df.disp %>% mutate(Condition = recode(Condition,
                                                '1' = "Baseline",
                                                '2' = "RH weighted",
                                                '3' = "LH weighted",
                                                '4' = "Combo"),
                             Hand = recode(Hand,
                                           '1' = "Left",
                                           '2' = "Right"))
#


# Set Load Factor -----------------------
# Identify in the 'Load' factor in the VR_participant_list excel file
subs.day1.30 = subset(p.table, grepl("3", Intervention))$subID01 # Find subjects who did 30% on day 1
subs.day1.60 = subset(p.table, grepl("6", Intervention))$subID01 # Find subjects who did 60% on day 1
subs.day2.30 = subset(p.table, !subID01 %in% subs.day1.30)$subID02 # Find subjects who did 30% on day 2
subs.day2.60 = subset(p.table, !subID01 %in% subs.day1.60)$subID02 # Find subjects who did 60% on day 2

# Add in the 'Load' and 'Day' factors
df.disp = df.disp %>% mutate(Load = case_when(Subject %in% subs.day1.30 ~ "30%",
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
    df.disp[df.disp$Subject == p.table$subID02[i],]$Subject = p.table$subID01[i]
  }
}

# Remove outlier participants (ie: left handers, no-shows, etc...)
outliers = c(73823902)
df.disp = subset(df.disp, !Subject %in% outliers)
# Set Factors
factors = c('Subject', 'Condition', 'Hand', 'Load', 'Day', 'Block')
df.disp[,factors] = lapply(df.disp[,factors], factor)
rm(subs.day1.30, subs.day1.60, subs.day2.30, subs.day2.60, factors, i)

#

# Plotting----------------------

# ggplot(data = subset(df.disp, Condition == "RH weighted" & Load == "60%" & !Block %in% c(3,5)), aes(x = Sample, y = disp.mean, color = Hand))+
#   geom_point()+
#   facet_wrap(~Subject)
# 
# ggplot(data = subset(df.disp, Condition == "LH weighted" & Load == "60%" & !Block %in% c(3,5)), aes(x = Sample, y = disp.mean, color = Hand))+
#   geom_point()+
#   facet_wrap(~Subject)
# 
# 
# ggplot(data = subset(df.disp, Load == "60%" & !Block %in% c(3,5)), aes(x = Sample, y = disp.mean, color = Hand))+
#   stat_summary(fun.data = 'mean_se')+
#   facet_grid(rows = vars(Condition))

# Individual sub plotting------------------
sub = "73828701" # choose from: "73824601", "73828701" (used for manuscript 2/1/22), or "73824602"
# load 60; use errorbar = SEM
ggplot(data = subset(df.disp, Subject == sub & Load == "60%" & !Block %in% c(1,3,5)), aes(x = Sample, y = disp.mean, color = Hand))+
  geom_line(size = 1)+
  geom_ribbon(aes(ymin = disp.mean - disp.std/sqrt(16), ymax = disp.mean + disp.std/sqrt(16), fill = Hand), alpha = 0.3)+
  theme_cowplot()+
  panel_border()+
  facet_grid(rows = vars(Condition))+
  theme(text = element_text(size = 26),
        strip.text.x = element_text(size = 24),
        axis.text = element_text(size = 14),
        strip.background = element_blank())


# load 60; use errorbar = SEM
ggplot(data = subset(df.disp, Subject == sub & Load == "60%" & !Block %in% c(3,5)),
       aes(x = Sample, y = disp.mean, color = Condition, fill = Condition))+
  geom_line(size = 1)+
  geom_ribbon(aes(ymin = disp.mean - disp.std/sqrt(16), ymax = disp.mean + disp.std/sqrt(16)), alpha = 0.3)+
  theme_cowplot()+
  panel_border()+
  facet_grid(rows = vars(Hand))+
  theme(text = element_text(size = 26),
        strip.text.x = element_text(size = 24),
        axis.text = element_text(size = 14),
        strip.background = element_blank())