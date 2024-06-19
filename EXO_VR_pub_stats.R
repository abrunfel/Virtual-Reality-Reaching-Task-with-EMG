# VR Exo stats

# RMSE Ratio baseline differences -----------------------------------------
ggplot(data = subset(emg.data.ratio.mbb, Block == 1), aes(x = Condition, y = rmse, fill = Load))+
  geom_boxplot()+
  facet_grid(~Muscle)+
  geom_hline(yintercept = 50, linetype = 'dashed', size = 1, alpha = 0.5)

t.test((subset(emg.data.ratio.mbb, Block == 1 & Load == "30%" & Muscle == "Bicep")$rmse), mu = 50)
t.test((subset(emg.data.ratio.mbb, Block == 1 & Load == "60%" & Muscle == "Bicep")$rmse), mu = 50)
t.test((subset(emg.data.ratio.mbb, Block == 1 & Load == "30%" & Muscle == "Deltoid")$rmse), mu = 50)
t.test((subset(emg.data.ratio.mbb, Block == 1 & Load == "60%" & Muscle == "Deltoid")$rmse), mu = 50)

# Dispalcement t.tests ----------------------------------------------------
ggplot(data = vr.data.mbb, aes(x = Condition, y = disp.lh.diff, fill = Load))+
  geom_boxplot()

t.test((subset(vr.data.mbb, Condition == "RH weighted" & Load == "30%")$disp.lh.diff), mu = 0)
t.test((subset(vr.data.mbb, Condition == "RH weighted" & Load == "60%")$disp.lh.diff), mu = 0)
t.test((subset(vr.data.mbb, Condition == "LH weighted" & Load == "30%")$disp.rh.diff), mu = 0)
t.test((subset(vr.data.mbb, Condition == "LH weighted" & Load == "60%")$disp.rh.diff), mu = 0)


# Normality RC --------------------------------------------------
shapiro.test(subset(vr.data.mbb, Block == 1 & Load == '30%')$rel.cont.diff)
shapiro.test(subset(vr.data.mbb, Block == 1 & Load == '60%')$rel.cont.diff)
shapiro.test(subset(vr.data.mbb, Condition == "LH weighted" & Load == '30%')$rel.cont.diff)
shapiro.test(subset(vr.data.mbb, Condition == "LH weighted" & Load == '60%')$rel.cont.diff)
shapiro.test(subset(vr.data.mbb, Condition == "RH weighted" & Load == '30%')$rel.cont.diff)
shapiro.test(subset(vr.data.mbb, Condition == "RH weighted" & Load == '60%')$rel.cont.diff)

# RMSE Ratio normality tests (non-outlier cleaned)
shapiro.test(subset(emg.data.ratio.mbb, Block == 1 & Load == '30%' & Muscle == "Bicep")$rmse.bc)
shapiro.test(subset(emg.data.ratio.mbb, Block == 1 & Load == '60%' & Muscle == "Bicep")$rmse.bc)
shapiro.test(subset(emg.data.ratio.mbb, Block == 3 & Load == '30%' & Muscle == "Bicep")$rmse.bc)
shapiro.test(subset(emg.data.ratio.mbb, Block == 3 & Load == '60%' & Muscle == "Bicep")$rmse.bc)
shapiro.test(subset(emg.data.ratio.mbb, Block == 5 & Load == '30%' & Muscle == "Bicep")$rmse.bc)
shapiro.test(subset(emg.data.ratio.mbb, Block == 5 & Load == '60%' & Muscle == "Bicep")$rmse.bc)
shapiro.test(subset(emg.data.ratio.mbb, Condition == "LH weighted" & Load == '30%' & Muscle == "Bicep")$rmse.bc)
shapiro.test(subset(emg.data.ratio.mbb, Condition == "LH weighted" & Load == '60%' & Muscle == "Bicep")$rmse.bc)
shapiro.test(subset(emg.data.ratio.mbb, Condition == "RH weighted" & Load == '30%' & Muscle == "Bicep")$rmse.bc)
shapiro.test(subset(emg.data.ratio.mbb, Condition == "RH weighted" & Load == '60%' & Muscle == "Bicep")$rmse.bc)


shapiro.test(subset(emg.data.ratio.mbb, Block == 1 & Load == '30%' & Muscle == "Deltoid")$rmse.bc)
shapiro.test(subset(emg.data.ratio.mbb, Block == 1 & Load == '60%' & Muscle == "Deltoid")$rmse.bc)
shapiro.test(subset(emg.data.ratio.mbb, Block == 3 & Load == '30%' & Muscle == "Deltoid")$rmse.bc)
shapiro.test(subset(emg.data.ratio.mbb, Block == 3 & Load == '60%' & Muscle == "Deltoid")$rmse.bc)
shapiro.test(subset(emg.data.ratio.mbb, Block == 5 & Load == '30%' & Muscle == "Deltoid")$rmse.bc)
shapiro.test(subset(emg.data.ratio.mbb, Block == 5 & Load == '60%' & Muscle == "Deltoid")$rmse.bc)
shapiro.test(subset(emg.data.ratio.mbb, Condition == "LH weighted" & Load == '30%' & Muscle == "Deltoid")$rmse.bc)
shapiro.test(subset(emg.data.ratio.mbb, Condition == "LH weighted" & Load == '60%' & Muscle == "Deltoid")$rmse.bc)
shapiro.test(subset(emg.data.ratio.mbb, Condition == "RH weighted" & Load == '30%' & Muscle == "Deltoid")$rmse.bc)
shapiro.test(subset(emg.data.ratio.mbb, Condition == "RH weighted" & Load == '60%' & Muscle == "Deltoid")$rmse.bc)

# RMSE Ratio Outlier cleaned normality tests
shapiro.test(subset(emg.data.ratio.mbb, Block == 1 & Load == '30%' & Muscle == "Bicep")$rmse.bc.oc)
shapiro.test(subset(emg.data.ratio.mbb, Block == 1 & Load == '60%' & Muscle == "Bicep")$rmse.bc.oc)
shapiro.test(subset(emg.data.ratio.mbb, Block == 3 & Load == '30%' & Muscle == "Bicep")$rmse.bc.oc)
shapiro.test(subset(emg.data.ratio.mbb, Block == 3 & Load == '60%' & Muscle == "Bicep")$rmse.bc.oc)
shapiro.test(subset(emg.data.ratio.mbb, Block == 5 & Load == '30%' & Muscle == "Bicep")$rmse.bc.oc)
shapiro.test(subset(emg.data.ratio.mbb, Block == 5 & Load == '60%' & Muscle == "Bicep")$rmse.bc.oc)
shapiro.test(subset(emg.data.ratio.mbb, Condition == "LH weighted" & Load == '30%' & Muscle == "Bicep")$rmse.bc.oc)
shapiro.test(subset(emg.data.ratio.mbb, Condition == "LH weighted" & Load == '60%' & Muscle == "Bicep")$rmse.bc.oc)
shapiro.test(subset(emg.data.ratio.mbb, Condition == "RH weighted" & Load == '30%' & Muscle == "Bicep")$rmse.bc.oc)
shapiro.test(subset(emg.data.ratio.mbb, Condition == "RH weighted" & Load == '60%' & Muscle == "Bicep")$rmse.bc.oc)


shapiro.test(subset(emg.data.ratio.mbb, Block == 1 & Load == '30%' & Muscle == "Deltoid")$rmse.bc.oc)
shapiro.test(subset(emg.data.ratio.mbb, Block == 1 & Load == '60%' & Muscle == "Deltoid")$rmse.bc.oc)
shapiro.test(subset(emg.data.ratio.mbb, Block == 3 & Load == '30%' & Muscle == "Deltoid")$rmse.bc.oc)
shapiro.test(subset(emg.data.ratio.mbb, Block == 3 & Load == '60%' & Muscle == "Deltoid")$rmse.bc.oc)
shapiro.test(subset(emg.data.ratio.mbb, Block == 5 & Load == '30%' & Muscle == "Deltoid")$rmse.bc.oc)
shapiro.test(subset(emg.data.ratio.mbb, Block == 5 & Load == '60%' & Muscle == "Deltoid")$rmse.bc.oc)
shapiro.test(subset(emg.data.ratio.mbb, Condition == "LH weighted" & Load == '30%' & Muscle == "Deltoid")$rmse.bc.oc)
shapiro.test(subset(emg.data.ratio.mbb, Condition == "LH weighted" & Load == '60%' & Muscle == "Deltoid")$rmse.bc.oc)
shapiro.test(subset(emg.data.ratio.mbb, Condition == "RH weighted" & Load == '30%' & Muscle == "Deltoid")$rmse.bc.oc)
shapiro.test(subset(emg.data.ratio.mbb, Condition == "RH weighted" & Load == '60%' & Muscle == "Deltoid")$rmse.bc.oc)


# RMSE Ratio Outlier cleaned normality tests with target location correction
shapiro.test(subset(emg.data.ratio.mbb.bt, Block == 1 & Load == '30%' & Muscle == "Bicep")$rmse.bc.bt.oc)
shapiro.test(subset(emg.data.ratio.mbb.bt, Block == 1 & Load == '60%' & Muscle == "Bicep")$rmse.bc.bt.oc)
shapiro.test(subset(emg.data.ratio.mbb.bt, Block == 3 & Load == '30%' & Muscle == "Bicep")$rmse.bc.bt.oc)
shapiro.test(subset(emg.data.ratio.mbb.bt, Block == 3 & Load == '60%' & Muscle == "Bicep")$rmse.bc.bt.oc)
shapiro.test(subset(emg.data.ratio.mbb.bt, Block == 5 & Load == '30%' & Muscle == "Bicep")$rmse.bc.bt.oc)
shapiro.test(subset(emg.data.ratio.mbb.bt, Block == 5 & Load == '60%' & Muscle == "Bicep")$rmse.bc.bt.oc)
shapiro.test(subset(emg.data.ratio.mbb.bt, Condition == "LH weighted" & Load == '30%' & Muscle == "Bicep")$rmse.bc.bt.oc)
shapiro.test(subset(emg.data.ratio.mbb.bt, Condition == "LH weighted" & Load == '60%' & Muscle == "Bicep")$rmse.bc.bt.oc)
shapiro.test(subset(emg.data.ratio.mbb.bt, Condition == "RH weighted" & Load == '30%' & Muscle == "Bicep")$rmse.bc.bt.oc)
shapiro.test(subset(emg.data.ratio.mbb.bt, Condition == "RH weighted" & Load == '60%' & Muscle == "Bicep")$rmse.bc.bt.oc)


shapiro.test(subset(emg.data.ratio.mbb.bt, Block == 1 & Load == '30%' & Muscle == "Deltoid")$rmse.bc.bt.oc)
shapiro.test(subset(emg.data.ratio.mbb.bt, Block == 1 & Load == '60%' & Muscle == "Deltoid")$rmse.bc.bt.oc)
shapiro.test(subset(emg.data.ratio.mbb.bt, Block == 3 & Load == '30%' & Muscle == "Deltoid")$rmse.bc.bt.oc)
shapiro.test(subset(emg.data.ratio.mbb.bt, Block == 3 & Load == '60%' & Muscle == "Deltoid")$rmse.bc.bt.oc)
shapiro.test(subset(emg.data.ratio.mbb.bt, Block == 5 & Load == '30%' & Muscle == "Deltoid")$rmse.bc.bt.oc)
shapiro.test(subset(emg.data.ratio.mbb.bt, Block == 5 & Load == '60%' & Muscle == "Deltoid")$rmse.bc.bt.oc)
shapiro.test(subset(emg.data.ratio.mbb.bt, Condition == "LH weighted" & Load == '30%' & Muscle == "Deltoid")$rmse.bc.bt.oc)
shapiro.test(subset(emg.data.ratio.mbb.bt, Condition == "LH weighted" & Load == '60%' & Muscle == "Deltoid")$rmse.bc.bt.oc)
shapiro.test(subset(emg.data.ratio.mbb.bt, Condition == "RH weighted" & Load == '30%' & Muscle == "Deltoid")$rmse.bc.bt.oc)
shapiro.test(subset(emg.data.ratio.mbb.bt, Condition == "RH weighted" & Load == '60%' & Muscle == "Deltoid")$rmse.bc.bt.oc)

ggplot(data = subset(vr.data, Block == 1 & Load == '30%'), aes(rel.cont.diff))+
  geom_histogram(binwidth = 0.1)
ggplot(data = subset(vr.data, !Block %in% c(3,5)), aes(Condition,rel.cont.diff, fill = Load))+
  geom_boxplot()

# Outlier cleaning from https://stackoverflow.com/questions/28687515/search-for-and-remove-outliers-from-a-dataframe-grouped-by-a-variable
vr.data.clean = vr.data %>%
  group_by(Condition, Load) %>%
  filter(!(abs(rel.cont.diff - median(rel.cont.diff)) > 1.5*IQR(rel.cont.diff))) # removes values outside 1.5*IQR

shapiro.test(subset(vr.data.clean, !Block %in% c(3,5) & Load == '30%' & Condition == "Baseline")$rel.cont.diff)

ggplot(data = subset(vr.data.clean, !Block %in% c(3,5)), aes(Condition,rel.cont.diff, fill = Load))+
  geom_boxplot()

ggplot(data = subset(vr.data, !Block %in% c(3,5)), aes(Condition,rel.cont.diff.oc, fill = Load))+
  geom_boxplot()

#


# ANOVA: target -----------------------------------------------------------
vr.data.mbb.bt = vr.data %>% select(-c(Trial, Day)) %>% group_by(Subject, Block, Condition, Load, Target) %>% summarise_all(funs(mean(., na.rm = T)))
aov_ez(data = subset(vr.data.mbb.bt, !Block %in% c(3,5)), id = "Subject", dv = "rel.cont.diff", within = c("Condition", "Target", "Load"))
ggplot(data = subset(vr.data, !Block %in% c(3,5)), aes(Condition,rel.cont.diff, fill = Load))+
  geom_boxplot()
#


# RC timeseries - including "Load" as factor ------------------------------
aov.rc.ts = aov_ez(data = subset(vr.data.mbbin, !Block %in% c(3,5) & Bin %in% c(1,16)), id = "Subject", dv = "rel.cont", within = c("Condition","Bin", "Load"))
aov.rc.ts
rm(aov.rc.ts)
#


# Correlation / Regression ------------------------------------------------

bicep = subset(emg.data.ratio.mbb, Muscle == "Bicep")$rmse.bc.oc
deltoid = subset(emg.data.ratio.mbb, Muscle == "Deltoid")$rmse.bc.oc

df.corr.bicep = cbind(vr.data.mbb, bicep)
df.corr.bicep = df.corr.bicep %>% rename(emg = ...29)
df.corr.deltoid = cbind(vr.data.mbb, deltoid)
df.corr.deltoid = df.corr.deltoid %>% rename(emg = ...29)

ggplot(data = subset(df.corr.bicep, !Condition == "Baseline"), aes(x = emg, y = rel.cont.diff))+
  geom_point(aes(color = Condition, shape = Load))

cor(df.corr.bicep$rel.cont.diff, df.corr.bicep$emg, use = "pairwise.complete.obs")
lm.bicep <- lm(rel.cont.diff ~ emg, data=df.corr.bicep)
summary(lm.bicep)

cor(df.corr.deltoid$rel.cont.diff, df.corr.deltoid$emg, use = "pairwise.complete.obs")
lm.deltoid <- lm(rel.cont.diff ~ emg, data=df.corr.deltoid)
summary(lm.deltoid)

# Motor overflow (rmse in non-weighted limb) ------------------------------
# !!!!! WARNING: These data are extremely skewed... don't trust those t.tests just yet... (6/14/21)
## T-tests comparing rmse in the non-weighted limb to baseline during the loading condition.
# Bicep
# Compare rmse in R Bicep during the LH weighted condition vs. baseline (Block 1)
t.test((subset(emg.data.mbb, Block == 1 & Load == "30%" & Muscle == "R Bicep")$rmse),
       subset(emg.data.mbb, Condition == "LH weighted" & Load == "30%" & Muscle == "R Bicep")$rmse, paired = T)

t.test((subset(emg.data.mbb, Block == 1 & Load == "60%" & Muscle == "R Bicep")$rmse),
       subset(emg.data.mbb, Condition == "LH weighted" & Load == "60%" & Muscle == "R Bicep")$rmse, paired = T)

# Compare rmse in L Bicep during the RH weighted condition vs. baseline (Block 1)
t.test((subset(emg.data.mbb, Block == 1 & Load == "30%" & Muscle == "L Bicep")$rmse),
       subset(emg.data.mbb, Condition == "RH weighted" & Load == "30%" & Muscle == "L Bicep")$rmse, paired = T)

t.test((subset(emg.data.mbb, Block == 1 & Load == "60%" & Muscle == "L Bicep")$rmse),
       subset(emg.data.mbb, Condition == "RH weighted" & Load == "60%" & Muscle == "L Bicep")$rmse, paired = T)

# Deltoid
# Compare rmse in R Deltoid during the LH weighted condition vs. baseline (Block 1)
t.test((subset(emg.data.mbb, Block == 1 & Load == "30%" & Muscle == "R Deltoid")$rmse),
       subset(emg.data.mbb, Condition == "LH weighted" & Load == "30%" & Muscle == "R Deltoid")$rmse, paired = T)

t.test((subset(emg.data.mbb, Block == 1 & Load == "60%" & Muscle == "R Deltoid")$rmse),
       subset(emg.data.mbb, Condition == "LH weighted" & Load == "60%" & Muscle == "R Deltoid")$rmse, paired = T)

# Compare rmse in L Deltoid during the RH weighted condition vs. baseline (Block 1)
t.test((subset(emg.data.mbb, Block == 1 & Load == "30%" & Muscle == "L Deltoid")$rmse),
       subset(emg.data.mbb, Condition == "RH weighted" & Load == "30%" & Muscle == "L Deltoid")$rmse, paired = T)

t.test((subset(emg.data.mbb, Block == 1 & Load == "60%" & Muscle == "L Deltoid")$rmse),
       subset(emg.data.mbb, Condition == "RH weighted" & Load == "60%" & Muscle == "L Deltoid")$rmse, paired = T)


# RC reflection - not needed ----------------------------------------------

### RC Reflection
#The Condition x Load analysis of RC data fails to show a main effect for Load.
#This is likely due to the Condition x Load interaction because the Condition factor drives coordination in opposite directions.
#Our hypothesis is that increasing the load applied at the wrist increases the RC of the contralateral limb.
#While this is supported by the post-hoc contrast in the LH weighted condition, it is only a trend in the RH weighted condition.
#What i'd like to do now is analyze the RC of both conditions as a whole.
#That is, I can reflect (multiply by -1) one of the conditions and take a look at the Load main effect.
#I suppose the post-hoc contrasts will remain the same, but lets see...  

# Reflect only 'RH weighted' condition
vr.reflect = vr.data %>% mutate(rel.cont.diff.reflect = case_when(Condition %in% c("Baseline", "LH weighted") ~ rel.cont.diff,
                                                                  Condition == "RH weighted" ~ -1*rel.cont.diff))
# Mean by block for new vr.reflect dataframe
vr.reflect.mbb = vr.reflect %>% select(-c(Trial, Target, Day)) %>% group_by(Subject, Block, Condition, Load) %>% summarise_all(funs(mean(., na.rm = T)))

# Omnibus ANOVA on relfected data
aov.rc.sum.reflect = aov_ez(data = subset(vr.reflect.mbb, !Block %in% c(1,3,5)), id = "Subject", dv = "rel.cont.diff.reflect", within = c("Condition", "Load"))
knitr::kable(nice(aov.rc.sum.reflect))

# Load main effect posthoc
m.rc.sum.reflect = emmeans(aov.rc.sum.reflect, ~Load)
pairs(m.rc.sum.reflect)

# Load x Condition interaction posthoc
m.rc.sum.reflect.int = emmeans(aov.rc.sum.reflect, ~Load|Condition)
pairs(m.rc.sum.reflect.int)
#
