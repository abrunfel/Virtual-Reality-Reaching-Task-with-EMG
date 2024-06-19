# Load Packages -----------------------------------------------------------
library(tidyverse)
library(gridExtra)
library(gtable)
library(grid)
library(cowplot)
## Create df.corr variables ----
bicep = subset(emg.data.ratio.mbb, Muscle == "Bicep")$rmse.bc.oc
deltoid = subset(emg.data.ratio.mbb, Muscle == "Deltoid")$rmse.bc.oc

df.corr.bicep = cbind(vr.data.mbb, bicep)
df.corr.bicep = df.corr.bicep %>% rename(emg.diff = ...29)
df.corr.deltoid = cbind(vr.data.mbb, deltoid)
df.corr.deltoid = df.corr.deltoid %>% rename(emg.diff = ...29)
#


## Plot only the 30% load for the RC vs MC plot----
ggplot(data = subset(df.corr.bicep, !Condition == "Baseline" & Load == "30%"), aes(x = emg.diff, y = rel.cont.diff))+
  geom_point(aes(color = Condition, shape = Load, size = 2))+
  geom_line(aes(group = Subject))+
  coord_cartesian(xlim = c(-33,33), ylim = c(-5,5))+
  geom_hline(yintercept = 0, size = 1, alpha = 0.1)+
  geom_vline(xintercept = 0, size = 1, alpha = 0.1)+
  theme_cowplot(24)+
  labs(x = "\u0394 Muscle Contribution (%)", y = "\u0394 Relative Contribution (%)",
       title = "Bicep")+
  guides(size = FALSE, shape = FALSE)

ggplot(data = subset(df.corr.deltoid, !Condition == "Baseline" & Load == "30%"), aes(x = emg.diff, y = rel.cont.diff))+
  geom_point(aes(color = Condition, shape = Load, size = 2))+
  geom_line(aes(group = Subject))+
  coord_cartesian(xlim = c(-33,33), ylim = c(-5,5))+
  geom_hline(yintercept = 0, size = 1, alpha = 0.1)+
  geom_vline(xintercept = 0, size = 1, alpha = 0.1)+
  theme_cowplot(24)+
  labs(x = "\u0394 Muscle Contribution (%)", y = "\u0394 Relative Contribution (%)",
       title = "Deltoid")+
  guides(size = FALSE, shape = FALSE)
#

## Create new tradeoff dataframe----
# Attempt at creating a new df that contains the a difference measure (representing the TRADEOFF) between left- and right hands.
# That is, take the rel.cont.diff or RH weighted condition minus rel.cont.diff of LH weighted condition (same for MC),
# then use those an independent values in determining the tradeoff.
## Biceps Tradeoff Analysis----
temp.lh = df.corr.bicep %>% filter(Condition == "LH weighted" & Load == "30%") %>%
  select(c(Subject, rel.cont.diff, emg.diff))

temp.rh = df.corr.bicep %>% filter(Condition == "RH weighted" & Load == "30%") %>%
  select(c(Subject, rel.cont.diff, emg.diff))

subs = temp.lh$Subject
rcl = temp.lh$rel.cont.diff
rcr = temp.rh$rel.cont.diff
mcl = temp.lh$emg.diff
mcr = temp.rh$emg.diff

rc = rcr-rcl
mc = mcr-mcl

to.bi.df = data.frame(subs, rc, mc)
to.bi.df = to.bi.df %>% mutate(slope = rc/mc)

# RC-MC mean cluster location (Bicep)
# LH weighted
c(mean(mcl, na.rm = T), mean(rcl, na.rm = T))
# RH weighted
c(mean(mcr, na.rm = T), mean(rcr, na.rm = T))

#clean up
rm(subs, rcl, rcr, mcl, mcr, rc, mc, temp.lh, temp.rh)

# Test for normality
# ggplot(data = to.bi.df, aes(sample = slope))+
#   geom_qq()+
#   geom_qq_line()
# shapiro.test(to.bi.df$slope)

# CI for slopes
quantile(to.bi.df$slope, 0.025, na.rm = T)
quantile(to.bi.df$slope, 0.975, na.rm = T)
#

## Deltoid Tradeoff Analysis----
temp.lh = df.corr.deltoid %>% filter(Condition == "LH weighted" & Load == "30%") %>%
  select(c(Subject, rel.cont.diff, emg.diff))

temp.rh = df.corr.deltoid %>% filter(Condition == "RH weighted" & Load == "30%") %>%
  select(c(Subject, rel.cont.diff, emg.diff))

subs = temp.lh$Subject
rcl = temp.lh$rel.cont.diff
rcr = temp.rh$rel.cont.diff
mcl = temp.lh$emg.diff
mcr = temp.rh$emg.diff
rc = rcr-rcl
mc = mcr-mcl

to.delt.df = data.frame(subs, rc, mc)
to.delt.df = to.delt.df %>% mutate(slope = rc/mc)

# RC-MC mean cluster location (Deltoid)
# LH weighted
c(mean(mcl, na.rm = T), mean(rcl, na.rm = T))
# RH weighted
c(mean(mcr, na.rm = T), mean(rcr, na.rm = T))

#clean up
rm(subs, rcl, rcr, mcl, mcr, rc, mc, temp.lh, temp.rh)

# Test for normality
# ggplot(data = to.delt.df, aes(sample = slope))+
#   geom_qq()+
#   geom_qq_line()
# shapiro.test(to.delt.df$slope)

# CI for slopes
quantile(to.delt.df$slope, 0.025, na.rm = T)
quantile(to.delt.df$slope, 0.975, na.rm = T)
