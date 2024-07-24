library(ggplot2)

decoder <- read.csv("/home/luisman/Escritorio/Polex/fMRI/derivatives/decoder/ratemeper_succ.csv", sep = "\t", header = FALSE)

decoder_plot <- data.frame(success = c(decoder$V1, decoder$V2),
    sample = rep(c("fused", "nonfused"), each = dim(decoder)[1]),
    roi = rep(1:22, 2))

data1 <- decoder_plot[c(seq(1,11), seq(23,33)), ]

ggplot(data=data1, aes(x=roi, y=success, fill=sample)) +
    geom_bar(stat="identity", width = 0.8, linewidth = 2, 
        position=position_dodge())+
    theme_minimal() + ylim(0, 1) +
    scale_fill_manual(values = c("#CC79A7", "#56B4E9")) +
    scale_color_manual(values = c("#6b3c55", "#2e6889"),
        labels = c("Fused", "Non-fused"), name = "") +
    theme(axis.text.x = element_text(family = "Helvetica",
                size = 30, face = "bold"),
            axis.text.y = element_text(family = "Helvetica",
                size = 30, face = "bold"),
            axis.title.x = element_text(family = "Helvetica",
                size = 35, face = "bold"),
            axis.title.y = element_text(family = "Helvetica",
                size = 35, face = "bold"),
            axis.line = element_line(linewidth = 0),
            legend.key.size = unit(2, "cm"),
            legend.text = element_text(family = "Helvetica", size = 20))


data2 <- decoder_plot[c(seq(12,22), seq(34,44)), ]

ggplot(data=data2, aes(x=roi, y=success, fill=sample)) +
    geom_bar(stat="identity", width = 0.8, linewidth = 2, 
        position=position_dodge())+
    theme_minimal() + ylim(0, 1) +
    scale_fill_manual(values = c("#CC79A7", "#56B4E9")) +
    scale_color_manual(values = c("#6b3c55", "#2e6889"),
        labels = c("Fused", "Non-fused"), name = "") +
    theme(axis.text.x = element_text(family = "Helvetica",
                size = 30, face = "bold"),
            axis.text.y = element_text(family = "Helvetica",
                size = 30, face = "bold"),
            axis.title.x = element_text(family = "Helvetica",
                size = 35, face = "bold"),
            axis.title.y = element_text(family = "Helvetica",
                size = 35, face = "bold"),
            axis.line = element_line(linewidth = 0),
            legend.key.size = unit(2, "cm"),
            legend.text = element_text(family = "Helvetica", size = 20))