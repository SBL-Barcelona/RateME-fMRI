library(FDRestimation)
library(ggplot2)

folder <-  "/home/luisman/Escritorio/Polex/fMRI"
folder_out <- paste(folder, "derivatives", "rois_correlation", sep = "/")

fusion <- read.csv("/home/luisman/Escritorio/Polex/fMRI/covariates/fusion_dych.csv", sep = ",", header = FALSE)
attitudes_data <- read.csv("/home/luisman/Escritorio/Polex/fMRI/covariates/attitudesMatrix.csv", header = TRUE, sep = ",")
rois_data <- read.csv("/home/luisman/Escritorio/Polex/fMRI/derivatives/rois_correlation/rois_exclusion-mean.csv", sep = "\t")

join_data <- cbind(attitudes_data, rois_data)

rois <- c("2", "5", "21", "25", "29")

polvars <- c("arisActMean", "arisRadMean", "outThreat1Mean",
    "outThreat2Mean", "colNarcissMean", "spirForm_uk", "physForm_uk")

data_plot <- data.frame()

for (i in rois) {

    roi_out <- data.frame()
    depVar <- paste("roi.", i, sep = "")

    for (polvar in polvars) {

        form <- paste(depVar, "~", polvar, "+ fd_ratemepol + age + factor(gender) + factor(fusion)")
        fit <- lm(form, data = join_data, na.action = na.omit)
        sum <- summary(fit)
        print(sum$df)

        coef <- data.frame(t(sum$coefficients[2,]))
        coef$ci_low <- coef$Estimate - coef$Std..Error * qnorm(0.95)
        coef$ci_high <- coef$Estimate + coef$Std..Error * qnorm(0.95)
        coef$polvar <- polvar

        roi_out <- rbind(roi_out, coef)

    }

    p_fdr <- p.fdr(pvalues = roi_out$Pr...t..)
    roi_out$qvals <- p_fdr$`Results Matrix`[, 2]
    out_name <- paste("roi-", i, ".csv", sep = "")

    fout <- paste(folder_out, out_name, sep = "/")
    write.csv(roi_out, fout, row.names = FALSE)

    roi_out$roi <- paste("roi-", i, sep = "")
    data_plot <- rbind(data_plot, roi_out)

} 


    ### Create data frame for plot

    #data_plot <- data.frame(vars = rep(dep_vars, each = 3),
    #estimates = estims,
    #se = se,
    rois <- unique(data_plot$roi)


    ### Plot function

ggplot(data_plot, aes(factor(x = roi, level = rois),
        y = Estimate, color = factor(polvar, level = rev(polvars)))) +
    geom_hline(yintercept = 0, linetype = "dashed") +
    geom_pointrange(aes(ymax = ci_high, ymin = ci_low),
            size = 1, lwd = 2, position = position_dodge(0.7)) +
    theme_classic() +
    scale_color_manual(values = rev(c("#88CCEE", "#ddc977", "#CC79A7",
            "#63c376", "#965fc6", "#b8894b", "#3e3ab1")),
        labels = rev(c("Activism", "Radicalism", "Symbolic Threat",
            "Realistic Threat", "Collective Narcissism",
            "Spiritual Formidability", "Physical Formidability")),
        name = "", guide = guide_legend(reverse = TRUE)) +
    theme(axis.text.x = element_text(family = "Helvetica",
            size = 30, face = "bold"),
        axis.text.y = element_text(family = "Helvetica",
            size = 30, face = "bold"),
        axis.title.x = element_text(family = "Helvetica",
            size = 35, face = "bold"),
        axis.title.y = element_text(family = "Helvetica",
            size = 35, face = "bold"),
        axis.line = element_line(linewidth = 1),
        legend.key.size = unit(2, "cm"),
        legend.text = element_text(family = "Helvetica", size = 20)) +
    scale_x_discrete(labels = c("roi-2" = "Fusiform Gyrus",
            "roi-5" = "Calcarine/Lingual",
            "roi-21" = "Middle Occipital Gyrus",
            "roi-25" = "Lingual/Calcarine/Cuneus",
            "roi-29" = "Hippocampus")) +
    labs(
        x = "",
        y = "\nEstimate (CI)",
    ) + coord_flip()



