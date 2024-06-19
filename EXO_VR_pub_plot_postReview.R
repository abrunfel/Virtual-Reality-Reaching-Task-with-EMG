# Exo VR publication plots

# Load Packages -----------------------------------------------------------
library(tidyverse)
library(gridExtra)
library(gtable)
library(grid)
library(cowplot)
# Create emg mean by bin (for timeseries plot)
nr = nrow(emg.data.ratio)
numTrial = max(emg.data.ratio$Trial)
numBlock = nlevels(emg.data.ratio$Block)
numMuscle = nlevels(emg.data.ratio$Muscle)
numSub = nr/numTrial/numBlock/numMuscle
blockSize = 6 # Must be factor of 96
emg.data.ratio$Bin = as.factor(rep(1:(numTrial/blockSize), each = blockSize, times = numSub*numBlock*numMuscle))
# Take mean by bin
emg.data.ratio.mbbin = emg.data.ratio %>% relocate(Bin, .after = Trial) %>% group_by(Subject, Condition, Block, Load, Muscle, Bin) %>%
  summarise_each(funs(mean(., na.rm = TRUE))) %>% select(-c(Trial, Target, Day))
emg.data.ratio.mbbin$Bin = as.numeric(emg.data.ratio.mbbin$Bin)
rm(nr)
#

# Fig 2 - Movement Extent------------
# NOTE: you must run "DisplacementCompare.R" and "RMStimeseriesLOC.R" before this section can work
sub = "73828701" # choose from: "73824601", "73828701" (used for manuscript 2/1/22), or "73824602"
# load 60; use errorbar = SEM
p1 = ggplot(data = subset(df.disp, Subject == sub & Load == "60%" & !Block %in% c(1,3,5)), aes(x = Sample, y = disp.mean, color = Hand))+
  geom_line(size = 1)+
  geom_ribbon(aes(ymin = disp.mean - disp.std/sqrt(16), ymax = disp.mean + disp.std/sqrt(16), fill = Hand), alpha = 0.3)+
  scale_x_continuous(name = "Movement Extent", breaks = NULL)+
  scale_y_continuous(name = "Displacement (m)", limits = c(0,0.6,0.2))+
  labs(title = "A")+
  theme_cowplot()+
  panel_border()+
  facet_grid(rows = vars(Condition))+
  theme(text = element_text(size = 26),
        strip.text.x = element_text(size = 24),
        axis.text = element_text(size = 14),
        strip.background = element_blank(),
        legend.position = c(0.015,0.9))
 
p2 = ggplot(data = subset(df.rms.loc, Subject == sub & Load == "60%" & !Block %in% c(1,3,5) & Muscle == "Deltoid"),
       aes(x = Sample, y = rms, color = Hand, fill = Hand))+
  stat_summary(fun = 'mean', geom = 'line', size = 1)+
  stat_summary(fun.data = 'mean_se', geom = 'ribbon', alpha = 0.3)+
  scale_x_continuous(name = "Movement Extent", breaks = NULL)+
  scale_y_continuous(name = "RMS Muscle Activity (V)")+
  labs(title = "B")+
  theme_cowplot()+
  panel_border()+
  facet_grid(rows = vars(Condition))+
  theme(text = element_text(size = 26),
        strip.text.x = element_text(size = 24),
        axis.text = element_text(size = 14),
        strip.background = element_blank(),
        legend.position = "none")

p.me = grid.arrange(p1,p2,ncol=2)
#ggsave("disp.rms.me.pdf", plot = p.me, width = 16, height = 9, units = c("in"), dpi = 300)
#

# Fig 3 - Timeseries ------------------------------------------------------
vr.data.mbbin = rename(vr.data.mbbin, Hand = Condition)
emg.data.ratio.mbbin = rename(emg.data.ratio.mbbin, Hand = Condition)

p1 = ggplot(data = subset(vr.data.mbbin, !Block %in% c(3,5)), aes(x = Bin, y = rel.cont, color = Hand))+
  stat_summary(fun = 'mean', geom = 'line')+
  stat_summary(fun.data = 'mean_se')+
  geom_hline(yintercept = 50, linetype = 'dashed')+
  ylab('Relative Contribution (%)')+
  facet_grid(cols = vars(Load))+
  coord_cartesian(ylim = c(47.5,52.5))+
  theme_cowplot()+
  panel_border()+
  theme(text = element_text(size = 26),
        strip.text.x = element_text(size = 24),
        strip.background = element_blank(),
        axis.text = element_text(size = 14))

p2 = ggplot(data = subset(emg.data.ratio.mbbin, !Block %in% c(3,5)), aes(x = Bin, y = rmse.bc.oc, color = Hand))+
  geom_hline(yintercept = 0, linetype = 'dashed')+
  stat_summary(fun.data = 'mean_se')+
  stat_summary(fun = 'mean', geom = 'line')+
  facet_grid(Muscle~Load)+
  labs(y = "\u0394 Muscle Contribution (%)")+
  theme_cowplot()+
  panel_border()+
  theme(text = element_text(size = 26),
        strip.text.x = element_text(size = 24),
        strip.text.y = element_text(size = 20),
        strip.background = element_blank(),
        axis.text = element_text(size = 14))

p.ts = grid.arrange(p1,p2,ncol=1)
#ggsave("rc.mc.ts.pdf", plot = p.ts, width = 16, height = 9, units = c("in"), dpi = 300)
#


# Fig 4 - Relative Contribution boxplots -------------------------------
vr.data.mbb = rename(vr.data.mbb, Hand = Condition)
ggplot(data = subset(vr.data.mbb, !Block %in% c(1,3,5)), aes(x = Hand, y = rel.cont.diff, fill = Load))+
  geom_boxplot()+
  geom_point(position = position_jitterdodge(), alpha = 0.7) +
  ylab('\u0394 Relative Contribution (%)')+
  coord_cartesian(ylim = c(-5,5))+
  theme_cowplot(30)+
  theme(legend.position = c(0.8,0.85))+
  geom_hline(yintercept = 0, linetype = 'dashed', size = 1, alpha = 0.5)

#ggsave("rc.boxplot.pdf", plot = last_plot(), width = 12, height = 9, units = c("in"), dpi = 300)
#


# Fig 5 - Muscle Contribution boxplots ------------------------------------
# Baseline correct w.r.t. Subject, Day, Muscle, AND TARGET
# As %-change score
# emg.data.ratio = emg.data.ratio %>% group_by(Subject, Day, Muscle, Target)%>%
#   mutate(rmse.bc.bt = (rmse - mean(rmse[Block == 1]))/mean(rmse[Block == 1]))

# As was done for relative contribution
emg.data.ratio = emg.data.ratio %>% group_by(Subject, Day, Muscle, Target)%>%
  mutate(rmse.bc.bt = rmse - mean(rmse[Block == 1]))

# Outlier clean rmse.bc (any value outside 1.5*IQR)
emg.data.ratio = emg.data.ratio %>% 
  group_by(Condition, Load, Muscle) %>%
  mutate(rmse.bc.bt.oc = replace(rmse.bc.bt, (abs(rmse.bc.bt - median(rmse.bc.bt, na.rm = T)) > 1.5*IQR(rmse.bc.bt, na.rm = T)), NA))

emg.data.ratio.mbb.bt = emg.data.ratio %>% select(-c(Trial, Day)) %>%
  group_by(Subject, Block, Condition, Load, Muscle) %>%
  summarise_all(funs(mean(., na.rm = T)))

emg.data.ratio.mbb.bt = rename(emg.data.ratio.mbb.bt, Hand = Condition)
ggplot(data = subset(emg.data.ratio.mbb.bt, !Block %in% c(1,3,5)), aes(x = Hand, y = rmse.bc.bt.oc, fill = Load))+
  geom_boxplot(outlier.shape = NA)+
  geom_point(position = position_jitterdodge(), alpha = 0.7) +
  ylab('\u0394 Muscle Contribution (%)')+
  coord_cartesian(ylim = c(-40,40))+
  theme_cowplot(30)+
  panel_border()+
  theme(strip.background = element_blank(),
        legend.position = c(0.015,0.85))+
  geom_hline(yintercept = 0, linetype = 'dashed', size = 1, alpha = 0.5)+
  facet_grid(~Muscle)

#ggsave("mc.boxplot.pdf", plot = last_plot(), width = 16, height = 9, units = c("in"), dpi = 300)
# Fig 6 - Tradeoff -------------------------------------------------------------
bicep = subset(emg.data.ratio.mbb, Muscle == "Bicep")$rmse.bc.oc
deltoid = subset(emg.data.ratio.mbb, Muscle == "Deltoid")$rmse.bc.oc

df.corr.bicep = cbind(vr.data.mbb, bicep)
df.corr.bicep = df.corr.bicep %>% rename(emg.diff = ...29)
df.corr.deltoid = cbind(vr.data.mbb, deltoid)
df.corr.deltoid = df.corr.deltoid %>% rename(emg.diff = ...29)

p1 = ggplot(data = subset(df.corr.bicep, !Hand == "Baseline" & Load == "60%"), aes(x = emg.diff, y = rel.cont.diff))+
  geom_point(aes(color = Hand, shape = Load, size = 2))+
  geom_line(aes(group = Subject))+
  coord_cartesian(xlim = c(-33,33), ylim = c(-5,5))+
  geom_hline(yintercept = 0, size = 1, alpha = 0.1)+
  geom_vline(xintercept = 0, size = 1, alpha = 0.1)+
  theme_cowplot(24)+
  labs(title = "Bicep")+
  theme(axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        legend.position = c(0.8,0.91))+
  guides(size = FALSE, shape = FALSE, color = guide_legend(override.aes = list(size = 4)))

p2 = ggplot(data = subset(df.corr.deltoid, !Hand == "Baseline" & Load == "60%"), aes(x = emg.diff, y = rel.cont.diff))+
  geom_point(aes(color = Hand, shape = Load, size = 2))+
  geom_line(aes(group = Subject))+
  coord_cartesian(xlim = c(-33,33), ylim = c(-5,5))+
  geom_hline(yintercept = 0, size = 1, alpha = 0.1)+
  geom_vline(xintercept = 0, size = 1, alpha = 0.1)+
  theme_cowplot(24)+
  labs(title = "Deltoid")+
  theme(axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        legend.position = "none")+
  guides(size = FALSE, shape = FALSE, color = guide_legend(override.aes = list(size = 4)))

# common axis titles
yleft <- textGrob("\u0394 Relative Contribution (%)", rot = 90, gp = gpar(fontsize = 24))
bottom <- textGrob("\u0394 Muscle Contribution (%)", gp = gpar(fontsize = 24))

p.to = grid.arrange(p1,p2,ncol=1, left = yleft, bottom = bottom)
#ggsave("tradeoff.pdf", plot = p.to, width = 12, height = 9, units = c("in"), dpi = 300)
#
