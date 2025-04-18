#install.packages(c("metafor", "meta")) #Delete the first # for the code to work
library(metafor)
library(meta)

#Read in the data set
dat=read.csv("./data.csv",header=T,sep=",")

#Calculate effect sizes and the summary effect size
ies.logit <- escalc(xi = cases, ni = total, measure = "PLO", data = dat)
pes.logit <- rma(yi, vi, data = ies.logit, method = "DL", level = 95)
pes <- predict(pes.logit, transf = transf.ilogit)
print(pes, digits = 6)
print(pes.logit, digits = 4)
confint(pes.logit, digits = 4)

#Create a forest plot
pes.summary <- metaprop(cases, total, authoryear, data = dat, sm = "PLO", method.tau = "DL", method.ci = "NAsm")
precision <- sqrt(ies.logit$vi)
forest(pes.summary,
       common = FALSE,
       print.tau2 = TRUE,
       print.Q = TRUE,
       print.pval.Q = TRUE,
       print.I2 = TRUE,
       rightcols = FALSE,
       pooled.totals = FALSE,
       sortvar = precision,
       weight.study = "random", 
       leftcols = c("studlab", "event", "n", "effect", "ci"),
       leftlabs = c("Study", "Cases", "Total", "Prevalence", "95% C.I."),
       xlab = "Prevalence of CC (%)", 
       smlab = "", 
       xlim = c(0,4), 
       pscale = 1000, 
       squaresize = 0.5, 
       fs.hetstat = 10,
       digits = 2,
       col.square = "navy", 
       col.square.lines = "navy",
       col.diamond = "maroon", 
       col.diamond.lines = "maroon")

#Create a Baujat plot
bjplot <- baujat(pes.logit,
                 symbol=19, 
                 xlim=c(0,15),
                 xlab="Contribution to Overall Heterogeneity", 
                 ylab="Influence on Summary Proportion")
bjplot <- bjplot[bjplot$x >= 10 | bjplot$y >= 0.4,]
text(bjplot$x, bjplot$y, bjplot$slab, pos=1)

#Screen externally studentized residuals
stud.res <- rstudent(pes.logit) # or pes, pes.da 
abs.z <- abs(stud.res$z)
stud.res[order(-abs.z)]

#Leave-one-out diagnostics
L1O <- leave1out(pes.logit, transf = transf.ilogit)
print(L1O, digits = 6)

#Create a Leave-one-out forest plot
l1o=leave1out(pes.logit)
yi=l1o$estimate; vi=l1o$se^2
forest(yi,
       vi,
       transf=transf.ilogit,
       slab=paste(dat$author,dat$year,sep=", "),
       xlab="Leave-one-out summary proportions",
       refline=pes$pred,
       digits=6)
abline(h=0.1)

#Influential study diagnostics
inf <- influence(pes.logit)
print(inf)
plot(inf)

#Remove outliers
ies.logit.noutlier <- escalc(xi = cases, ni = total, measure = "PLO", data = dat[-c(2, 8),])
pes.logit.noutlier <- rma(yi, vi, data = ies.logit.noutlier, method = "DL")
pes.noutlier <- predict(pes.logit.noutlier, transf = transf.ilogit)
print(pes.noutlier, digits = 5)

# Subgroup analysis under the first assumption: separate tau2 estimates
# Conduct a random-effects model meta-analsis for each 
# subgroup defined by the moderator studydesign
pes.logit.birthcohort <- rma(yi, vi, data=ies.logit, subset=studydesign == "Birth cohort", method="DL")
pes.logit.others <- rma(yi, vi, data=ies.logit, subset=studydesign == "Others", method = "DL")
pes.birthcohort <- predict(pes.logit.birthcohort, transf = transf.ilogit, digits = 5)
pes.others <- predict(pes.logit.others, transf = transf.ilogit, digits = 5)
# Create a dataframe to store effect size estimates, 
# standard errors, heterogeneity for both subgroups
# Add an object named studydesign to distinguish two 
# subgroups. 
dat.diffvar <- data.frame(estimate = c(pes.logit.birthcohort$b, pes.logit.others$b), stderror = c(pes.logit.birthcohort$se, pes.logit.others$se), studydesign = c("Birth cohort", "Others"), tau2 = round(c(pes.logit.birthcohort$tau2, pes.logit.others$tau2), 3))
# Fit a fixed-effect meta-regression to compare the 
# subgroups
subganal.studydesign <- rma(estimate, sei = stderror, data = dat.diffvar, mods = ~ studydesign, method = "FE")
# Recalculate summary effect size assuming different
# heterogeneity components
pes.logit.studydesign <- rma(estimate, sei = stderror, method = "FE", data = dat.diffvar)
pes.studydesign <- predict(pes.logit.studydesign, transf = transf.ilogit)
# Display summary effect sizes of the two subgroups
print(pes.birthcohort, digits = 6); print(pes.logit.birthcohort, digits = 3)
print(pes.others, digits = 6); print(pes.logit.others, digits = 3)
# Display subgroup analysis results
print(subganal.studydesign, digits = 3)
# Display recomputed summary effect size
print(pes.studydesign, digits = 6)

# Subgroup analysis under the second assumption: a common tau2 estimate
# Conduct a subgroup analysis based on studydesign
subganal.studydesign <- rma(yi, vi, data = ies.logit, mods = ~ studydesign, method = "DL")
pes.subg.studydesign <- predict(subganal.studydesign, transf = transf.ilogit)
# Obtain estimates for each subgroup
pes.logit.birthcohort <- rma(yi, vi, data = ies.logit, mods = ~ studydesign == "Others", method = "DL")
pes.logit.others = rma(yi, vi, data = ies.logit, mods = ~ studydesign == "Birth cohort", method = "DL")
# Create a dataframe to store effect size estimates, 
# standard errors, heterogeneity for both subgroups  
dat.samevar <- data.frame(estimate = c((pes.logit.birthcohort$b)[1], (pes.logit.others$b)[1]), stderror = c((pes.logit.birthcohort$se)[1], (pes.logit.others$se)[1]), tau2 = subganal.studydesign$tau2)
# Recalculate summary effect size assuming a common 
# heterogeneity component
pes.logit.studydesign = rma(estimate, sei = stderror, method = "FE", data = dat.samevar)
pes.studydesign = predict(pes.logit.studydesign, transf = transf.ilogit)
# Display subgroup summary effect sizes
print(pes.subg.studydesign[1], digits = 6)
print(pes.subg.studydesign[17], digits = 6)
# Display subgroup analysis results
print(subganal.studydesign, digits = 4)
# Display recomputed summary effect size
print(pes.studydesign, digits = 6)

# Create a forest plot under the first assumption: separate tau2 estimates
# Use metafor
# Run the subgroup analysis code with the assumption
# of separate within-group estimates of between-study
# variance components first, then run the following 
# code
ies.summary <- summary(ies.logit, transf = transf.ilogit)
# par() function specifies font parameters
par(cex = 1, font = 6)
# Set up forest plot
# order= argument ensures that studies are divided by 
# the subgroup variable
forest(ies.summary$yi, 
       order = ies.summary$studesg,
       ci.lb = ies.summary$ci.lb, 
       ci.ub = ies.summary$ci.ub, 
       ylim = c(-5, 23), 
       xlim = c(-0.005, 0.005), 
       slab = paste(dat$author, dat$year, sep = ","), 
       ilab = cbind(data = dat$cases, dat$total), 
       ilab.xpos = c(-0.0019, -0.0005), 
       ilab.pos = 2, 
       rows = c(19:14, 8.5:-1.5), 
       at = c(seq(from = 0, to = 0.004, by = 0.001)), 
       refline = pes.studydesign$pred, 
       main = "", 
       xlab = "Proportion", 
       digits = 4)
# Add summary polygons for the subgroup and overall 
# proportions
par(cex = 1.2, font = 7)
addpoly(pes.birthcohort$pred, ci.lb = pes.birthcohort$ci.lb, ci.ub = pes.birthcohort$ci.ub, row = 12.8, digits = 5)
addpoly(pes.others$pred, ci.lb = pes.others$ci.lb, ci.ub = pes.others$ci.ub, row = -2.7, digits = 5)
addpoly(pes.studydesign$pred, ci.lb = pes.studydesign$ci.lb, ci.ub = pes.studydesign$ci.ub, row = -4.6, digits = 5)
# Add column headings to the plot
par(cex = 1.1, font = 7)
text(-0.005, 21.8, pos = 4, "Study")
text(c(-0.0026, -0.0014), 21.8, pos = 4, c("Cases", "Total"))
text(0.0025, 21.8, pos = 4, "Proportion [95% CI]")
# Add text for the subgroups
text(-0.005, c(9.7, 20.2), pos = 4, c("Others", "Birth cohort"))
# Add text for the subgroup and overall proportions
par(cex = 1, font = 7)
text(-0.005, -4.6, pos = 4, c("Overall proportion"))
text(-0.005, 12.8, pos = 4, c("Subgroup proportion"))
text(-0.005, -2.7, pos = 4, c("Subgroup proportion"))
abline(h = -3.7)

# Create a forest plot under the first assumption: separate tau2 estimates
# Use meta
pes.summary <- metaprop(cases, total, authoryear, data = dat, sm = "PLO", method.tau = "DL", method.ci = "NAsm", byvar = studydesign, tau.common=FALSE)
forest(pes.summary, 
       common = FALSE,
       overall = TRUE,
       overall.hetstat = TRUE,
       resid.hetstat = FALSE,
       subgroup.hetstat = TRUE,
       test.subgroup = FALSE,
       fs.hetstat = 10,
       print.tau2 = TRUE,
       print.Q = TRUE,
       print.pval.Q = TRUE,
       print.I2 = TRUE,
       rightcols = FALSE,
       xlim = c(0 ,4),
       leftcols = c("studlab", "effect", "ci"),
       leftlabs = c("Study", "Proportion", "95% C.I."),
       text.random.w = "Subgroup proportion",
       text.random = "Overall proportion", 
       xlab = "Prevalence of CC (%)",
       pscale = 1000,
       smlab = " ",
       weight.study = "random",
       squaresize = 0.5,
       col.square = "navy",
       col.diamond = "maroon",
       col.diamond.lines = "maroon",
       digits = 2)

# Create a forest plot under the second assumption: a common tau2 estimate
subganal.studydesign <- rma(yi, vi, data = ies.logit, mods = ~ studydesign, method = "DL")
pes.summary <- metaprop(cases, total, authoryear, data = dat, sm = "PLO", method.tau = "DL", method.ci = "NAsm", byvar = studydesign, tau.common=TRUE, tau.preset = sqrt(subganal.studydesign$tau2))
forest(pes.summary, 
       common = FALSE,
       overall = TRUE,
       overall.hetstat = TRUE,
       resid.hetstat = FALSE,
       subgroup.hetstat = TRUE,
       test.subgroup = FALSE,
       fs.hetstat = 10,
       print.tau2 = TRUE,
       print.Q = TRUE,
       print.pval.Q = TRUE,
       print.I2 = TRUE,
       rightcols = FALSE,
       xlim = c(0 ,4),
       leftcols = c("studlab", "effect", "ci"),
       leftlabs = c("Study", "Proportion", "95% C.I."),
       text.random.w = "Subgroup proportion",
       text.random = "Overall proportion", 
       xlab = "Prevalence of CC (%)",
       pscale = 1000,
       smlab = " ",
       weight.study = "random",
       squaresize = 0.5,
       col.square = "navy",
       col.diamond = "maroon",
       col.diamond.lines = "maroon",
       digits = 2)


# Scatter plot for the study design
# Conduct a subgroup analysis based on the dummy 
# variable "studesg"
subganal.studesg=rma (yi, vi, data = ies.logit, mods = ~ studesg, method = "DL")
# Create a scatter plot
regplot(subganal.studesg, mod = "studesg", 
        xlab = "Study Design", 
        transf=transf.ilogit, 
        legend = FALSE,
        label = TRUE,
        shade = "white",
        bg = "transparent",
        lcol = "navy",
        digits = 4)

# Scatter plot for the sample size
subganal.size <- rma(yi, vi, data = ies.logit, mods = ~ size, method = "DL")
regplot(subganal.size, 
        mod = "size", 
        transf=transf.ilogit, 
        xlab = "Sample size", 
        legend = "topright",
        label = TRUE,
        shade = "white",
        bg = "transparent",
        lcol = "navy",
        digits = 6)


# Scatter plot for the publication year
metareg.year <- rma(yi, vi, data = ies.logit, mods = ~ year, method = "DL")
regplot(metareg.year, 
        mod = "year", 
        transf = transf.ilogit, 
        xlab = "Year of publication",
        legend = "topleft",
        label = TRUE,
        shade = "white",
        bg = "white",
        lcol = "navy",
        digits = 6)
