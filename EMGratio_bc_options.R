# Testing baseline corrections for the new way of calculating RMSE ratio R/(R+L)
############################################

## Scale one of the side's rmse values by some linear transormation and rerun the data...
a = 0.5

# Create new rmse ratio. Right side rmse divided by left side rmse. THis is so janky... pure hack job
emg.data.Rdelt = subset(emg.data, Muscle %in% c("R Deltoid"))
emg.data.Ldelt = subset(emg.data, Muscle %in% c("L Deltoid"))
## Apply the scaling factor. WARNING make sure R vs. L matches what you do for bicep!!!#########
emg.data.Rdelt$rmse = emg.data.Rdelt$rmse*a
#############
ratio = emg.data.Rdelt$rmse/(emg.data.Rdelt$rmse + emg.data.Ldelt$rmse) # Note, you can change this to the '.bc' version to try alternaltive baseline corrections...
emg.data.delt = cbind(subset(emg.data.Rdelt, select = -c(Muscle, rmse, rmse.bc)), ratio)
emg.data.delt = emg.data.delt %>% rename(rmse = ...10) %>% # WARNING: The number "10" might change...verify its location in the d.f.
  mutate(Muscle = "Deltoid") %>%
  relocate(Muscle, .after = Target)
rm(emg.data.Ldelt, emg.data.Rdelt, ratio)

# Do same for bicep
emg.data.Rbicep = subset(emg.data, Muscle %in% c("R Bicep"))
emg.data.Lbicep = subset(emg.data, Muscle %in% c("L Bicep"))
## Apply the scaling factor. WARNING make sure R vs. L matches what you do for deltoid!!!#########
emg.data.Rbicep$rmse = emg.data.Rbicep$rmse*a
#############
ratio = emg.data.Rbicep$rmse/(emg.data.Rbicep$rmse + emg.data.Lbicep$rmse)
emg.data.bicep = cbind(subset(emg.data.Rbicep, select = -c(Muscle, rmse, rmse.bc)), ratio)
emg.data.bicep = emg.data.bicep %>% rename(rmse = ...10) %>% # WARNING: The number "10" might change...verify its location in the d.f.
  mutate(Muscle = "Bicep") %>%
  relocate(Muscle, .after = Target)
rm(emg.data.Lbicep, emg.data.Rbicep, ratio)

# Rebind the dataframes
emg.data.ratio.scaled = rbind(emg.data.bicep, emg.data.delt)
rm(emg.data.bicep, emg.data.delt)
emg.data.ratio.scaled$Muscle = as.factor(emg.data.ratio$Muscle)


# Baseline correct rmse ratio
# As a %-change score
percent.change = emg.data.ratio.scaled %>% group_by(Subject, Muscle, Load) %>% mutate(rmse.bc = 100*(rmse - mean(rmse[Block == 1]))/mean(rmse[Block == 1]))

# As was done for Relative Contribution
simple.change = emg.data.ratio.scaled %>% group_by(Subject, Muscle, Load) %>% mutate(rmse.bc = 100*(rmse - mean(rmse[Block == 1])))