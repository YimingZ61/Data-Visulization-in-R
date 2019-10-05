

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
p + geom_smooth(method = "lm")

p <- ggplot(data = nba.data, aes(x = SEASON, y = WIN.))
p + geom_boxplot()
p + geom_violin()

p <- ggplot(data = nba.data, aes(x = OFFRTG, y = WIN.)) + 
  facet_wrap(~SEASON)
p + geom_text(aes(label = ABV), size = 2)

## Multiple `geom` layers
ggplot(data = nba.data, aes(x = WIN.)) +
  geom_histogram(aes(y = ..density..), binwidth = 0.1, color = "black") +
  geom_density()

ggplot(data = nba.data, aes(x = OFFRTG, y = WIN.)) +
  geom_point() + 
  geom_smooth(method = "lm")

ggplot(data = nba.data, aes(x = SEASON, y = WIN.)) +
  geom_violin() +
  geom_boxplot(width = 0.2)

## Data transformation
mean.win <- aggregate(WIN. ~ SEASON + REGION, FUN = mean, data = nba.data)
head(mean.win)

## Facet
p <- ggplot(data = nba.data, aes(x = OFFRTG, y = WIN.)) +
  geom_point() + geom_smooth(method = "lm", se = FALSE)
p + facet_wrap(~SEASON)
p + facet_grid(REGION ~ SEASON)
p + facet_grid(REGION ~ SEASON, scales = "free")

## Scale: General Purpose Scales
p <- ggplot(data = nba.data, aes(x = OFFRTG, y = WIN., color = REGION)) + geom_point()
p + scale_x_continuous(name = "offensive rate", limits = c(97, 116)) +
  scale_y_continuous(name = "winning rate", breaks= seq(0, 1, 0.1)) +
  scale_color_manual(name = "region", labels = c("EAST", "WEST"), values = c("blue", "red"))

## Scales: X and Y Axis
p <- ggplot(data = nba.data, aes(x = OFFRTG, y = WIN., color = REGION)) + geom_point()
p + scale_x_reverse()

## Scale: Color & Fill
p <- ggplot(data = nba.data, aes(x = OFFRTG, y = DEFRTG, color = WIN.)) + geom_point()
p + scale_color_gradient(low = "green", high = "red")

## Scale: Size, Shape and Linetype
p <- ggplot(data = nba.data, aes(x = OFFRTG, y = DEFRTG, shape = REGION)) + geom_point()
p + scale_shape_discrete("Region", solid = FALSE)

## Coordinate system
p <- ggplot(data = nba.data, aes(x = OFFRTG, y = WIN.)) +
  geom_point() + geom_smooth(method = "lm")
p + coord_fixed(ratio = 20)
p + coord_flip()
p + coord_trans(y = "sqrt")
p + coord_polar()

## Theme
p <- ggplot(data = nba.data, aes(x = OFFRTG, y = WIN.)) + 
  geom_point() + geom_smooth(method = "lm")
p + theme_bw()
p + theme_classic()
p + theme_grey()
p + theme_minimal()

## Practice 1



## Practice 2




## Arrange and save your plots
p <- ggplot(data = nba.data, aes(x = OFFRTG, y = WIN.)) + 
  geom_point() + geom_smooth(method = "lm")
p1 <- p + theme_bw(); p2 <- p + theme_classic(); p3 <- p + theme_grey(); p4 <- p + theme_minimal()
grid.arrange(p1, p2, p3, p4, ncol = 2, nrow = 2)

## GGally
ggpairs(data = nba.data, 3:7)
ggcorr(data = nba.data[, c(3:7)])

## ggExtra
p <- ggplot(nba.data, aes(x = OFFRTG, y = DEFRTG, color = REGION)) +
  geom_point() + theme_bw() + theme(legend.position = "bottom")
ggMarginal(p, groupColour = TRUE, groupFill = TRUE)

## ggrepel
ggplot(data = nba.data, aes(x = OFFRTG, y = DEFRTG, size = WIN.)) +
  geom_point(aes(color = REGION), shape = 1) + 
  geom_text_repel(data = subset(nba.data, WIN. >= 0.6 | WIN. <= 0.3), 
                  aes(label = ABV), size = 1.5, box.padding = 0.3) +
  facet_wrap(~SEASON)

ggplot(data = nba.data, aes(x = OFFRTG, y = DEFRTG, size = WIN.)) + 
  geom_point(aes(color = REGION), shape = 1) + 
  geom_label_repel(data = subset(nba.data, WIN. >= 0.6 | WIN. <= 0.3), 
                   aes(label = ABV), size = 1.5, box.padding = 0.3) +
  facet_wrap(~SEASON)

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
