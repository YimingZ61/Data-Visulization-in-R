

## Check required packages
package.required <- c("ggplot2", "ggrepel", "GGally", "ggExtra", "gganimate", "gridExtra", "gifski")

for(i in 1:length(package.required)){
  if(!package.required[i] %in% rownames(installed.packages())){
    install.packages(package.required[i])
  }
}

## Load packages
library(ggplot2)
library(ggrepel)
library(ggExtra)
library(GGally)
library(gganimate)
library(gridExtra)
library(gifski)

## Read data
nba.data <- read.csv("NBA_Team_Data.csv")
nba.data <- nba.data[, c(2, 3, 7, 9, 30, 31, 42, 44, 45)]

## The start of plotting a graph
p <- ggplot(data = nba.data, aes(x = OFFRTG, y = WIN.))
p

## Geometries
p + geom_point()

## `geom` function
p <- ggplot(data = nba.data, aes(x = WIN.))
p + geom_histogram(binwidth = 0.1)
p + geom_density()

p <- ggplot(data = nba.data, aes(x = OFFRTG, y = WIN.))
p + geom_point()
p + geom_line()
p + geom_density_2d()
p + geom_smooth(formula = y ~ x, method = "lm")

p <- ggplot(data = nba.data, aes(x = SEASON, y = WIN.))
p + geom_boxplot()
p + geom_violin()

## Multiple `geom` layers
ggplot(data = nba.data, aes(x = WIN.)) +
  geom_histogram(aes(y = ..density..), binwidth = 0.1, color = "black") +
  geom_density()

ggplot(data = nba.data, aes(x = OFFRTG, y = WIN.)) +
  geom_point() + 
  geom_smooth(formula = y ~ x, method = "lm")

ggplot(data = nba.data, aes(x = SEASON, y = WIN.)) +
  geom_violin() +
  geom_boxplot(width = 0.2)

## Facet
p <- ggplot(data = nba.data, aes(x = OFFRTG, y = WIN.)) +
  geom_point() + geom_smooth(formula = y ~ x, method = "lm", se = FALSE)
p + facet_wrap(~SEASON)
p + facet_grid(REGION ~ SEASON)
p + facet_grid(REGION ~ SEASON, scales = "free")

## Scale: 
p <- ggplot(data = nba.data) + 
  geom_point(aes(x = OFFRTG, y = DEFRTG, color = WIN., shape = REGION))
p + scale_x_continuous(name = "offensive rate", limits = c(97, 116)) +
  scale_y_reverse(name = "defensive rate") +
  scale_color_gradient(name = "winning rate", low = "green", high = "red") +
  scale_shape_discrete(name = "region", labels = c("EAST", "WEST"))

## Practice 1
ggplot(data = nba.data, aes(x = OFFRTG, y = DEFRTG, size = WIN.)) +
  geom_point(aes(color = REGION), shape = 1) + 
  geom_text(data = subset(nba.data, WIN. > 0.65),
            aes(label = ABV), size = 1.5) +
  geom_text_repel(data = subset(nba.data, WIN. < 0.3),
                  aes(label = ABV), size = 1.5, 
                  min.segment.length = 0, box.padding = 0.3) +
  facet_wrap(~SEASON) +
  theme_bw() +
  scale_x_continuous("Offensive Rate") +
  scale_y_reverse("Defensive Rate", limits = c(118, 95)) +
  scale_color_manual("Region" ,values = c("blue3", "red3")) +
  scale_size_continuous("Winning Rate", breaks = c(0.2, 0.4, 0.6)) +
  theme(legend.position = "bottom",
        panel.grid.minor = element_blank())

## GGally
ggpairs(data = nba.data, 3:7)
ggcorr(data = nba.data[, c(3:7)])

## ggExtra
p <- ggplot(nba.data, aes(x = OFFRTG, y = DEFRTG, color = REGION)) +
  geom_point() + theme_bw() + theme(legend.position = "bottom")
ggMarginal(p, groupColour = TRUE, groupFill = TRUE)

## gganimate
ggplot(data = nba.data, aes(x = OFFRTG, y = DEFRTG, size = WIN.)) +
  geom_point(aes(color = REGION), shape = 1) + 
  geom_text_repel(aes(label = ABV), size = 1.5, box.padding = 0.3) +
  theme_bw() +
  scale_y_reverse(limits = c(120, 97)) +
  scale_color_manual(values = c("blue3", "red3")) +
  # Here comes the gganimate specific bits
  labs(title = 'SEASON: {closest_state}', x = 'OFFRTG', y = 'DEFRTG') +
  theme(title = element_text(size = 5), 
        text = element_text(size = 5)) +
  transition_states(SEASON,
                    transition_length = 2,
                    state_length = 1)
