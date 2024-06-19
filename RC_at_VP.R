# New analysis for determining relative contriubiton at peak velocity. This is based on comments from reviewer #2 on first round of reviews (see lab book page 111)
# YOU MUST RUN EX0_VR_postReview.Rmd before this code.

# Correct for target location differences-----------
vr.data = vr.data %>% group_by(Subject, Day, Target)%>%
  mutate(rel.cont.diff.bt = rel.cont - mean(rel.cont[Block == 1]),
         rc.vp.diff.bt = rc.vp - mean(rc.vp[Block == 1]))
vr.data.mbb.bt = vr.data %>% select(-c(Trial, Day)) %>% group_by(Subject, Block, Condition, Load, Target) %>% summarise_all(funs(mean(., na.rm = T)))
#

# Timeseries analysis----------
ggplot(data = subset(vr.data.mbbin, !Block %in% c(3,5)), aes(x = Bin, y = rc.vp, color = Condition))+
  stat_summary(fun = 'mean', geom = 'line')+
  stat_summary(fun.data = 'mean_se')+
  geom_hline(yintercept = 50, linetype = 'dashed')+
  ylab('Relative Contribution (%)')+
  facet_grid(cols = vars(Load))+
  coord_cartesian(ylim = c(45,55))

# ANOVA with the 'Binned' data. Allows to check for main effect of time (rel. cont. changing overtime due to fatigue or learning)
aov_ez(data = subset(vr.data.mbbin, !Block %in% c(3,5) & Bin %in% c(1,16)), id = "Subject", dv = "rel.cont", within = c("Condition","Bin"))
#

# Boxplots and ANOVA in rc.vp--------------------
ggplot(data = subset(vr.data.mbb.bt, !Block %in% c(1,3,5)), aes(x = Condition, y = rc.vp.diff, fill = Load))+
  geom_boxplot()+
  ylab('\u0394 Relative Contribution (%)')+
  coord_cartesian(ylim = c(-10,10))+
  theme_gray(base_size = 30)+
  geom_hline(yintercept = 0, linetype = 'dashed', size = 1, alpha = 0.5)

aov_ez(data = subset(vr.data.mbb.bt, !Block %in% c(1,3,5)), id = "Subject", dv = "rc.vp.diff.bt", within = c("Condition", "Load"))
#
