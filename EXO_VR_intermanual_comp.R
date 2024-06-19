# mt ----------------------------------------------------------------------
ggplot(data = subset(biman.data.mbb, !Condition %in% "Baseline"), aes(x = Condition, y = mt_bc, fill = Load))+
  geom_boxplot()+
  facet_grid(~Hand)+
  geom_hline(yintercept = 0, linetype = 'dashed', size = 1, alpha = 0.5)+
  labs(y = "\u0394 mt")+
  theme_gray(base_size = 30)

aov.mt = aov_ez(data = subset(biman.data.mbb, !Block %in% c(3,5) & Load == "60%"), id = "Subject", dv = "mt", within = c("Condition", "Hand"))
aov.mt
post.mt = emmeans(aov.mt, ~Condition|Hand)
pairs(post.mt)
#

# disp --------------------------------------------------------------------
ggplot(data = subset(biman.data.mbb, !Condition %in% "Baseline"), aes(x = Condition, y = disp_bc, fill = Load))+
  geom_boxplot()+
  facet_grid(~Hand)+
  geom_hline(yintercept = 0, linetype = 'dashed', size = 1, alpha = 0.5)+
  labs(y = "\u0394 disp")+
  theme_gray(base_size = 30)

aov.disp = aov_ez(data = subset(biman.data.mbb, !Block %in% c(3,5) & Load == "60%"), id = "Subject", dv = "disp", within = c("Condition", "Hand"))
aov.disp
post.disp = emmeans(aov.disp, ~Condition|Hand)
pairs(post.disp)

# VelPeak -----------------------------------------------------------------
ggplot(data = subset(biman.data.mbb, !Condition %in% "Baseline"), aes(x = Condition, y = velPeak_bc, fill = Load))+
  geom_boxplot()+
  facet_grid(~Hand)+
  geom_hline(yintercept = 0, linetype = 'dashed', size = 1, alpha = 0.5)+
  labs(y = "\u0394 velPeak")+
  theme_gray(base_size = 30)

aov.velPeak = aov_ez(data = subset(biman.data.mbb, !Block %in% c(3,5) & Load == "60%"), id = "Subject", dv = "velPeak", within = c("Condition", "Hand"))
aov.velPeak
post.velPeak = emmeans(aov.velPeak, ~Condition|Hand)
pairs(post.velPeak)


# time2pv -----------------------------------------------------------------
ggplot(data = subset(biman.data.mbb, !Condition %in% "Baseline"), aes(x = Condition, y = time2pv_bc, fill = Load))+
  geom_boxplot()+
  facet_grid(~Hand)+
  geom_hline(yintercept = 0, linetype = 'dashed', size = 1, alpha = 0.5)+
  labs(y = "\u0394 time2pv")+
  theme_gray(base_size = 30)

aov.time2pv = aov_ez(data = subset(biman.data.mbb, !Block %in% c(3,5) & Load == "60%"), id = "Subject", dv = "time2pv", within = c("Condition", "Hand"))
aov.time2pv
post.time2pv = emmeans(aov.time2pv, ~Condition|Hand)
pairs(post.time2pv)


# normC -------------------------------------------------------------------
ggplot(data = subset(biman.data.mbb, !Condition %in% "Baseline"), aes(x = Condition, y = normC_bc, fill = Load))+
  geom_boxplot()+
  facet_grid(~Hand)+
  geom_hline(yintercept = 0, linetype = 'dashed', size = 1, alpha = 0.5)+
  labs(y = "\u0394 normC")+
  theme_gray(base_size = 30)

aov.normC = aov_ez(data = subset(biman.data.mbb, !Block %in% c(3,5) & Load == "60%"), id = "Subject", dv = "normC", within = c("Condition", "Hand"))
aov.normC
post.normC = emmeans(aov.normC, ~Condition|Hand)
pairs(post.normC)


# normS -------------------------------------------------------------------
ggplot(data = subset(biman.data.mbb, !Condition %in% "Baseline"), aes(x = Condition, y = normS_bc, fill = Load))+
  geom_boxplot()+
  facet_grid(~Hand)+
  geom_hline(yintercept = 0, linetype = 'dashed', size = 1, alpha = 0.5)+
  labs(y = "\u0394 normS")+
  theme_gray(base_size = 30)

aov.normS = aov_ez(data = subset(biman.data.mbb, !Block %in% c(3,5) & Load == "60%"), id = "Subject", dv = "normS", within = c("Condition", "Hand"))
aov.normS
post.normS = emmeans(aov.normS, ~Condition|Hand)
pairs(post.normS)



# # leftovers ---------------------------------------------------------------
# t.test((subset(biman.data.mbb, Condition == "RH weighted" & Hand == "lh" & Load == "60%")$disp_bc), mu = 0)
# t.test((subset(biman.data.mbb, Condition == "LH weighted" & Hand == "rh" & Load == "60%")$disp_bc), mu = 0)
# #
# 
# t.test((subset(biman.data.mbb, Block == 1 & Hand == "lh" & Load == "60%")$disp),
#        (subset(biman.data.mbb, Condition == "RH weighted" & Hand == "lh" & Load == "60%")$disp),
#        paired = TRUE)
