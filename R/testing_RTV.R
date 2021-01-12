library(tidyverse)
library(tools)
library(lmerTest)

source('R/znbnz_utils.R')

datapath <- 'data/trials'

# dat <- read.csv('trials_events_P0006.csv')
# testi <- dat %>% filter(Resp == "EMG1") %>%
#   group_by(Distractors, Task) %>%
#   summarize_at(.vars = "RT", .funs = c(var, mad, my_range)) %>%
#   rename(RTV = fn1, RTmad = fn2, RNG = fn3)

df <- read_all_recordings(datapath)
df$Cond <- interaction(df$Distractors, df$Task)

rtv.mdl <- lmer(RTV ~ Distractors * Task * Grup + (1|Part), data = df)
VarCorr(rtv.mdl)
resid(rtv.mdl)
summary(rtv.mdl)

rtv.nul <- lmer(RTV ~ (1|Part), data = df)
anova(rtv.nul, rtv.mdl)

rtv.dis <- lmer(RTV ~ Distractors + (1|Part), data = df)
anova(rtv.dis, rtv.mdl)

rtv.tsk <- lmer(RTV ~ Task + (1|Part), data = df)
anova(rtv.tsk, rtv.mdl)

rtv.dtk <- lmer(RTV ~ Distractors * Task + (1|Part), data = df)
anova(rtv.dtk, rtv.mdl)


min.mdl <- lmer(MIN ~ Distractors * Task * Grup + (1|Part), data = df)
summary(min.mdl)

max.mdl <- lmer(MAX ~ Distractors * Task * Grup + (1|Part), data = df)
summary(max.mdl)

rtmad.m <- lmer(RTmad ~ Distractors * Task * Grup + (1|Part), data = df)
summary(rtmad.m)

rng.mdl <- lmer(RNG ~ Distractors * Task * Grup + (1|Part), data = df)
summary(rng.mdl)

ggplot(df, aes(x = factor(Cond), y = RTV)) + geom_boxplot() + 
  geom_point(aes(color = factor(Prtn)), position = position_dodge(width = 0.5))
