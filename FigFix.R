ggplot(data = subset(vr.data.mbbin, !Block %in% c(3,5)), aes(x = Bin, y = rel.cont, color = Hand))+
  stat_summary(fun = 'mean', geom = 'line')+
  stat_summary(fun.data = 'mean_se')+
  geom_hline(yintercept = 50, linetype = 'dashed')+
  ylab('Relative Contribution (%)')+
  facet_grid(cols = vars(Load))+
  coord_cartesian(ylim = c(47.5,52.5))+
  theme(text = element_text(size = 26),
        strip.text.x = element_text(size = 24),
        axis.text = element_text(size = 14))

ggplot(data = subset(vr.data.mbbin, !Block %in% c(3,5)), aes(x = Bin, y = rel.cont, color = Hand))+
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
        axis.text = element_text(size = 14),
        strip.background = element_blank())
