### Post-R1 review stats (mainly effect sizes on post-hoc tests, etc.)
library(lsr)
## RC post-hoc LH ---------
s1 = subset(vr.data.mbb, Condition == "LH weighted" & Load == "30%")$rel.cont.diff
s2 = subset(vr.data.mbb, Condition == "LH weighted" & Load == "60%")$rel.cont.diff
t.test(s1,s2, paired = T)
cohensD(s1, s2, method = "paired")
rm(s1, s2)
#

## RC post-hoc RH ---------
s1 = subset(vr.data.mbb, Condition == "RH weighted" & Load == "30%")$rel.cont.diff
s2 = subset(vr.data.mbb, Condition == "RH weighted" & Load == "60%")$rel.cont.diff
t.test(s1,s2, paired = T)
cohensD(s1, s2, method = "paired")
rm(s1, s2)
#
## MC post-hoc LH ---------
s1 = emg.data.ratio.mbb.bt %>% ungroup() %>%
  filter(Condition == "LH weighted" & Load == "30%")%>%
  select(c(Subject, rmse.bc.bt.oc))%>%
  group_by(Subject)%>%
  summarise_all(funs(mean(., na.rm = T)))
s2 = emg.data.ratio.mbb.bt %>% ungroup() %>%
  filter(Condition == "LH weighted" & Load == "60%")%>%
  select(c(Subject, rmse.bc.bt.oc))%>%
  group_by(Subject)%>%
  summarise_all(funs(mean(., na.rm = T)))

t.test(s1$rmse.bc.bt.oc,s2$rmse.bc.bt.oc, paired = T)
cohensD(s1$rmse.bc.bt.oc, s2$rmse.bc.bt.oc, method = "paired")
rm(s1, s2)
# Alternative way (same result)
temp = emg.data.ratio.mbb.bt %>% ungroup()%>%
  filter(Condition == "LH weighted")%>%
  group_by(Subject, Load)%>%
  summarise_all(funs(mean(., na.rm = T)))
t.test(rmse.bc.bt.oc ~ Load, data = temp, paired = T)

# Try this for MC...------------
m.rr.sum.int.cl
# Then head to: https://memory.psych.mun.ca/models/stats/effect_size.html and hand calculate it... UGH.
# The reason we need to do this, is emmeans() calculates the MODEL contrasts (therefore, so does pairs())
# This is why a regular paired t-test gives different values for t-stat, p-value, etc.
# at that website:

# x1 = -1.13
# s1 = 4.95 (that is 1.43*sqrt(12))
# x2 = -6.69
# s2 = 4.95 (same because its the pooled SE)
# r = 0 (had to guess on this, represents the correlation between samples)

## normS 60% posthocs------------
aov.normS = aov_ez(data = subset(biman.data.mbb, !Block %in% c(3,5) & Load == "60%"), id = "Subject", dv = "normS", within = c("Condition", "Hand"))
aov.normS
post.normS = emmeans(aov.normS, ~Condition|Hand)
pairs(post.normS, infer = T)

s1 = subset(biman.data.mbb, Condition == "RH weighted" & Load == "60%" & Hand == "lh")$normS_bc
s2 = subset(biman.data.mbb, Block == 1 & Load == "60%" & Hand == "lh")$normS_bc
t.test(s1,s2, paired = T)
cohensD(s1, s2, method = "paired")
rm(s1, s2)

s1 = subset(biman.data.mbb, Condition == "LH weighted" & Load == "60%" & Hand == "rh")$normS_bc
s2 = subset(biman.data.mbb, Block == 1 & Load == "60%" & Hand == "rh")$normS_bc
t.test(s1,s2, paired = T)
cohensD(s1, s2, method = "paired")
rm(s1, s2)
#

## normS 30% posthocs------------
aov.normS = aov_ez(data = subset(biman.data.mbb, !Block %in% c(3,5) & Load == "30%"), id = "Subject", dv = "normS", within = c("Condition", "Hand"))
aov.normS
post.normS = emmeans(aov.normS, ~Condition|Hand)
pairs(post.normS, infer = T)

s1 = subset(biman.data.mbb, Condition == "RH weighted" & Load == "30%" & Hand == "lh")$normS_bc
s2 = subset(biman.data.mbb, Block == 1 & Load == "30%" & Hand == "lh")$normS_bc
t.test(s1,s2, paired = T)
cohensD(s1, s2, method = "paired")
rm(s1, s2)

s1 = subset(biman.data.mbb, Condition == "LH weighted" & Load == "30%" & Hand == "rh")$normS_bc
s2 = subset(biman.data.mbb, Block == 1 & Load == "30%" & Hand == "rh")$normS_bc
t.test(s1,s2, paired = T)
cohensD(s1, s2, method = "paired")
rm(s1, s2)
#