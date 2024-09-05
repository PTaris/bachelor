#Author Pauline TARIS and Alarig Vigneras ISPED 23/24
##################################################
##               PACKAGE                        ##
##################################################
library(ggplot2)
library(tidyverse)
library(gtsummary)
library(dplyr)
library(gridExtra)
library(tidyr)
library(tinytex)
library(DT)
library(patchwork)
##################################################
##               DATA IMPORTATION          ##
##################################################

data <- read.csv("~/figure-skating-scores/FICHIER_ANALYSE.csv")
View(data)
data <- as.data.frame(data)
dim(data)

##################################################
##              DATA TREATMENT             ##
##################################################
juge <- names(data)[startsWith(names(data), "J")]
juge<-c(juge,"Ref")
juge<-unique(juge)
juge
# Count the number of columns found
len_juge <- length(juge)
len_juge
# Show the number of columns that start with "J"

for (i in 1:nrow(data)) {
  if (!is.na(data[i, "base_value"]) && data[i, "base_value"] == 0) {
    for (col in juge){data[i,col] <- 0
  }
}}


#Associated final score for each judge.

data$Moyenne <- 0
for (i in 1:nrow(data)) {
  if (data$Numéro[i] != "Total") {
    
    data$Moyenne[i] <- round(sum(as.numeric( data[i,juge]))/length(juge),2)
  }
}

##################################################
##          MATRIX OF COMPOSITION                ##
##################################################
row_m_compo<-0
for (i in 1:nrow(data)){
  if (data[i,"Elements"]=="Composition" | data[i,"Elements"]=="Presentation" | data[i,"Elements"]=="Skating Skills"){
    row_m_compo<-row_m_compo+1    
  }
}
row_m_compo<-row_m_compo
#row_m_compo
cols<-c("GEO...FACTOR","Elements",juge,"Player_ID","Moyenne")
m_compo<-matrix(0,nrow=row_m_compo,(length(cols)))#because I want the skaters and the geo factor too
m_compo<-as.data.frame(m_compo)

c=1
for (i in 1:nrow(data)){
  if (data[i,"Elements"]=="Composition" | data[i,"Elements"]=="Presentation" | data[i,"Elements"]=="Skating Skills"){
    m_compo[c,]<-data[i,cols]
    c = c+1
  }}
names(m_compo)<-cols

#head(m_compo)
#tail(m_compo)
##################################################
##               MATRIX OF GOE                   ##
##################################################
row_m_goe<-0
for (i in 1:nrow(data)){
  if (data[i,"Elements"]!="Composition" & data[i,"Elements"]!="" & data[i,"Elements"]!="Presentation" & data[i,"Elements"]!="Skating Skills"){
    row_m_goe<-row_m_goe+1    
  }
}
row_m_goe<-row_m_goe
#row_m_goe
cols_goe<-c("base_value",juge, "Moyenne","Player_ID")
m_goe<-matrix(0,nrow=row_m_goe,(length(cols_goe)))#because I want the skaters and the base value
m_goe<-as.data.frame(m_goe)

b=1
nb_col<-(length(cols_goe))
for (i in 1:nrow(data)){
  if (data[i,"Elements"]!="Composition" &  data[i,"Elements"]!="" & data[i,"Elements"]!="Presentation" & data[i,"Elements"]!="Skating Skills"){
    m_goe[b,]<-data[i,cols_goe]
    b<-b+1
  }}
names(m_goe)<-cols_goe
#head(m_goe)

##################################################
##        COMPOSITION CALCULATION MATRIX                  ##
##################################################
###########CONSTRUCTION LIST OF SKATERS#########
skat<-as.vector(unique(data[,"Player_ID"]))

c_compo<-matrix(0,nrow=(ncol(m_compo)/3),ncol=len_juge+1)#we want also the referent
c_compo<-as.data.frame(c_compo)

cols_c_compo<-c(juge,"Player_ID")

names(c_compo)<-cols_c_compo 
#c_compo


# Loop over each Player_ID in skat
for (c in 1:length(skat)) {
  player_id <- skat[c]
  
  # Select the lines corresponding to the Player_ID in m_compo
  player_rows <- m_compo$Player_ID == player_id
  player_data <- m_compo[player_rows, ]
  
  # Calculate the dot product for each judge
  for (i in 1:length(juge)) {
    juge_col <- juge[i]
    produit_scalaire <- sum(player_data$GEO...FACTOR * as.numeric(player_data[[juge_col]]))
    
    # Store the result in the c_compo dataframe
    c_compo[c, juge_col] <- produit_scalaire
  }
}
c_compo$Player_ID<-skat
#head(c_compo)

##################################################
##         GOE CALCULATION MATRIX               ##
##################################################


c_goe<-matrix(0,nrow=(ncol(m_goe)/3),ncol=len_juge+1)
c_goe<-as.data.frame(c_goe)
#head(c_goe)

cols_c_goe <-c(juge,"Player_ID")

names(c_goe)<-cols_c_goe
#c_goe

# # Loop through each Player_ID in skat
for (c in 1:length(skat)) {
  player_id <- skat[c]
  
#Select the lines corresponding to the Player_ID in m_compo
  player_rows <- m_goe$Player_ID == player_id
  player_data <- m_goe[player_rows, ]
  
  # Calculate the goe for each judge
  for (i in 1:length(juge)) {
    juge_col <- juge[i]
    calcul_goe <- round(sum(player_data$base_value * ((as.numeric(player_data[[juge_col]])/10)+1)),2)
    
    # Store the result in the c_goe dataframe
    c_goe[c, juge_col] <- calcul_goe
  }
}
c_goe$Player_ID<-skat
#c_goe

##################################################
##   MATRIX CALCULATION SCORE                  ##
##################################################

c_score<-matrix(0,nrow=nrow(c_goe),ncol=ncol(c_goe))
c_score<-as.data.frame(c_score)
names(c_score)<-names(c_goe)
#c_score

cols_score<-names(c_score)

indice <- which(cols_score == "Player_ID")
cols_c_score <- cols_score[-indice]
#cols_c_score


c_score[,cols_c_score]<-c_goe[,cols_c_score]+c_compo[,cols_c_score]
c_score$Player_ID<-skat


#Competition ranking associated with participant names
print(c_score,row.names = FALSE)

##################################################
##            MATRICES + PANEL                  ##
##################################################

###########goe_panel

# Select the Player_ID and ScoreElem columns
scoreElem <- data[, c("Player_ID", "ScoreElem")]

# # Remove duplicates to have only one line per player
scoreElem <- unique(scoreElem)

# Show the results
#print(scoreElem)

############compo_panel

# Select the Player_ID and ScoreElem columns
scoreCompo <- data[, c("Player_ID", "ScoreComp")]

# Remove duplicates to have only one line per player
scoreCompo <- unique(scoreCompo)

# Shows the results
#print(scoreCompo)

############score_panel

# Select the Player_ID and ScoreElem columns
scorePanel <- data[, c("Player_ID", "ScoreTotal")]

# Remove duplicates to have only one line per player
scorePanel <- unique(scorePanel)

# Show the results
print(scorePanel,row.names = FALSE)

# Creating the c_panel matrix
c_panel <- data.frame(
  ScoreElem = scoreElem$ScoreElem,
  ScoreComp = scoreCompo$ScoreComp,
  ScoreTotal = scorePanel$ScoreTotal
)
#c_panel

################################################################
## 1/3 FINAL DF GAME FOR JUDGE COLLARS WITH SKATER LINE ##
################################################################

c_compo$compo_panel<-c_panel$ScoreComp
#c_compo

c_compo <- c_compo[,c("Player_ID",juge,"compo_panel", names(c_compo)[!names(c_compo) %in% c(juge,"Player_ID","compo_panel")])]
#c_compo


c_goe$goe_panel<-c_panel$ScoreElem
#c_goe

c_goe <- c_goe[,c("Player_ID",juge,"goe_panel", names(c_goe)[!names(c_goe) %in% c(juge,"Player_ID","goe_panel")])]
#c_goe

c_score$score_panel<-c_panel$ScoreTotal
#c_score

c_score <- c_score[,c("Player_ID",juge,"score_panel", names(c_score)[!names(c_score) %in% c(juge,"Player_ID","score_panel")])]
#c_score

##################################################
##        SUMMARY INFO CALCULATION                   ##
##################################################

#score judge matrix with panel score c_score
#score compo judge matrix with panel score c_compo
#score goe judge matrix with panel score c_goe

##################################################
##    2/3        DF GAME RANKINGS             ##
##################################################

clas<-data[,c("Rank","NomPren")]
clas<-unique(clas)

########################compo ranking ###############################

col_clas_compo<-c(juge,"compo_panel")
clasmt_c<-matrix(0,nrow=length(c_compo$Player_ID),ncol=length(col_clas_compo))
clasmt_c<-as.data.frame(clasmt_c)
names(clasmt_c)<-col_clas_compo
#clasmt_c

for (i in 1:length(col_clas_compo)){
  rang<-rank(-c_compo[col_clas_compo[i]])
  v<-clas$Rank[order(rang)]
  for (a in 1:length(clas$Rank)){
    clasmt_c[a,col_clas_compo[i]]<-v[a]}}

#clasmt_c
########################goe ranking ############################

col_clas_goe<-c(juge,"goe_panel")
clasmt_g<-matrix(0,nrow=length(c_goe$Rank),ncol=length(col_clas_goe))
clasmt_g<-as.data.frame(clasmt_g)
names(clasmt_g)<-col_clas_goe
#clasmt_g

for (i in 1:length(col_clas_goe)){
  rang<-rank(-c_goe[col_clas_goe[i]])
  v<-clas$Rank[order(rang)]
  for (a in 1:length(clas$Rank)){
    clasmt_g[a,col_clas_goe[i]]<-v[a]}}

#clasmt_g

###################score ranking#################################

c_score$Moyenne <- 0
for (i in 1:nrow(c_score)){
  
  c_score$Moyenne[i] <- round(sum(as.numeric(c_score[i,juge]))/length(juge),2)
}

col_clas_score<-c(juge,"Moyenne","score_panel")
clasmt_s<-matrix(0,nrow=length(c_score$Player_ID),ncol=length(col_clas_score))
clasmt_s<-as.data.frame(clasmt_s)
names(clasmt_s)<-col_clas_score
#clasmt_s

for (i in 1:length(col_clas_score)){
  rang<-rank(-c_score[col_clas_score[i]])
  v<-clas$Rank[order(rang)]
  for (a in 1:length(clas$Rank)){
    clasmt_s[a,col_clas_score[i]]<-v[a]}}

#Ranking order for each judge relative to final competition rank.

crois<-c_compo[-1]
var<-c(juge,"compo_panel")

data_long <- tidyr::gather(crois, key = "var", value = "Note")

# Rename column compo_panel to note_panel
data_long$var[data_long$var == "compo_panel"] <- "Panel notes"

# Create the violin chart
Etendue_Compo <-  ggplot(data_long, aes(x = var, y = Note, fill = var)) +
    geom_boxplot() +
    scale_fill_manual(values = c(rep("white", 7), "white"), 
                      name = "Groups", 
                      labels = c(juge, "Panel notes")) +
    facet_wrap(~var, scales = "free", ncol = 4) +
    labs(x = "Scope of Composition Notes", y = "Note", fill = NULL) +
    theme(legend.position = "bottom")#+theme_classic()

#Etendue_Compo
#Range of scores used by judges.

Etendue_Compo + theme_classic() 

#####################################################################
#head(data)
# Create a new column called "figures" and initialize with NA
data$figures <- NA

# Replace values according to the conditions specified in the question
data$figures[grep("^\\d", data$Elements)] <- "Saut"
data$figures[grep("^StSq", data$Elements)] <- "StSq"
data$figures[grep("^ChSq", data$Elements)] <- "ChSq"

# Go through the remaining elements and replace them with "Pirouette"
for (i in 1:nrow(data)) {
  if (data$Elements[i]!="Composition" & data$Elements[i]!="Presentation" & data$Elements[i]!="Skating Skills" & is.na(data$figures[i])) {
    data$figures[i] <- "Pirouette"
  }
}

##################################################
##               MATRIX  FIGURE GOE             ##
##################################################
r<-0
for (i in 1:nrow(data)){
  if (data[i,"Elements"]!="Composition" & data[i,"Elements"]!="" & data[i,"Elements"]!="Presentation" & data[i,"Elements"]!="Skating Skills"){
    r<-r+1    
  }
}
r<-r
#r
fig_goe<-matrix(0,nrow=r,(len_juge+4))#because i want the skaters and the base value
fig_goe<-as.data.frame(fig_goe)
cols_goe<-c("figures","base_value",juge,"Score_panel","Moyenne")
b=1
nb_col<-(len_juge+3)
for (i in 1:nrow(data)){
  if (data[i,"Elements"]!="Composition" & !is.na(data[i,"base_value"]) &data[i,"Numéro"]!="Total"& data[i,"Elements"]!="" & data[i,"Elements"]!="Presentation" & data[i,"Elements"]!="Skating Skills"){
    fig_goe[b,]<-data[i,cols_goe]
    b<-b+1
  }}
names(fig_goe)<-cols_goe
#head(fig_goe)
#fig_goe


fig_goe <- fig_goe[order(fig_goe$figures),]

###############################################################
##              matrix for note compo for skill         ##
###############################################################
#the matrix m_compo is reconstructed the new columns needed
row_m_compo<-0
for (i in 1:nrow(data)){
  if (data[i,"Elements"]=="Composition" | data[i,"Elements"]=="Presentation" | data[i,"Elements"]=="Skating Skills"){
    row_m_compo<-row_m_compo+1    
  }
}
row_m_compo<-row_m_compo
#row_m_compo
m_compo<-matrix(0,nrow=row_m_compo,(len_juge+3))
#because i want the skaters and the goe factor
m_compo<-as.data.frame(m_compo)
cols<-c("Elements","GEO...FACTOR",juge,"Score_panel")
c=1
nb_col<-(len_juge+3)
for (i in 1:nrow(data)){
  if (data[i,"Elements"]=="Composition" | data[i,"Elements"]=="Presentation" | data[i,"Elements"]=="Skating Skills"){
    m_compo[c,]<-data[i,cols]
    c<-c+1
  }}
names(m_compo)<-cols
#head(m_compo)

elem_c<-matrix(0,nrow = nrow(m_compo),ncol=ncol(m_compo))
elem_c<-as.data.frame(elem_c)
names(elem_c)<-names(m_compo)

#head(elem_c)
elem_c[,c("Elements","GEO...FACTOR")]<-m_compo[,c("Elements","GEO...FACTOR")]
#elem_c
col_elem<-c(juge,"Score_panel")

for (a in 1:nrow(elem_c)){
  for (b in 1:length(col_elem)){
    elem_c[a,col_elem[b]]<-as.numeric(m_compo[a,col_elem[b]])
  }
}
#elem_c

tab_clasmtGen <- matrix(0,nrow = nrow(c_score), ncol = ncol(c_score)-2)
tab_clasmtGen <- as.data.frame(tab_clasmtGen)
c_score_trimmed <- c_score[, -c(length(c_score) - 1, length(c_score))]

tab_clasmtGen<-c_score_trimmed

rank_desc <- function(x) {
  rank(-x)
}

tab_clasmtGen[,juge]<-round(rank_desc(tab_clasmtGen[,juge]),0)
head(tab_clasmtGen)

print(tab_clasmtGen,row.names = FALSE)


tab_clasmtGOE <- matrix(0,nrow = nrow(c_goe), ncol = ncol(c_goe)-1)
tab_clasmtGOE <- as.data.frame(tab_clasmtGOE)
c_goe_trimmed <- c_goe[, -c( length(c_goe))]

tab_clasmtGOE<-c_goe_trimmed

tab_clasmtGOE[,juge]<-round(rank_desc(c_goe_trimmed[,juge]),0)

print(tab_clasmtGOE,row.names = FALSE)

tab_clasmtcompo <- matrix(0,nrow = nrow(c_compo), ncol = ncol(c_compo)-1)
tab_clasmtcompo <- as.data.frame(tab_clasmtcompo)
c_compo_trimmed <- c_compo[, -c( length(c_compo))]

# Assign column names to tab_clasmtGen
names(tab_clasmtcompo) <- names(c_compo_trimmed)

tab_clasmtcompo<- c_compo_trimmed
tab_clasmtcompo[,juge]<-round(rank_desc(c_compo_trimmed[,juge]),0)

print(tab_clasmtcompo,row.names = FALSE)

# STUDY OF BIAS IN JUDGES' RATINGS: Deviations from the panel mean, variance and statistical tests of deviations from the mean to assess the significance of our graphical observations.

# For statistical tests, we will perform tests on 10 standard data ranges, to be modulated according to the number of judges. Thus the significance threshold value of a test will no longer be 0.05 but 0.05 / (10 \* number of judges) for our multiple tests.

pvaluedutest <-round(0.05 /(length(juge)*10),8)

print(paste("Thus in the present analysis the threshold p value for all of our tests will be", pvaluedutest))

#Means deviation with general scores
score_cb_cols<-c(juge,"score_panel")
score_cb<-matrix(0,nrow=nrow(c_score),ncol=length(score_cb_cols))
score_cb<-as.data.frame(score_cb)
names(score_cb)<-score_cb_cols

for (a in 1:nrow(c_score)){
  for (b in 1:length(score_cb_cols)){
    score_cb[a,score_cb_cols[b]]<-round((as.numeric(c_score[a,score_cb_cols[b]])-c_score$Moyenne[a]),digits = 6)
    
  }
}
head(score_cb)

var<-c(juge)

data_long <- tidyr::gather(score_cb, key = "var", value = "Note",-c(score_panel))
# Rename the column compo_panel to note_panel

# Create the violin chart
NL1_Score <- ggplot(data_long, aes(x = var, y = Note, fill = var)) +
  geom_boxplot() +
  scale_fill_manual(values = c(rep("white", length(juge))), 
                    name = "Groups", 
                    labels = juge) +
 ylim(min(score_cb[,juge]),max(score_cb[,juge])) +geom_hline(yintercept = 0,linetype = "dashed",linewidth=0.75, color = "darkturquoise")+
  labs(x = "juge",title = "Bias in scoring on the total score scale", y = "Note", fill = NULL) +
  theme(legend.position = "bottom")+theme_classic()

NL1_Score

#MSE  Mean squarred error
score_cb2<-round((score_cb^2),2)


var<-c(juge)

data_long <- tidyr::gather(score_cb2, key = "var", value = "Note",-c(score_panel))

# Rename the column compo_panel to note_panel

# Create the violin chart
NL2_Score <-ggplot(data_long, aes(x = var, y = Note, fill = var)) +
  geom_boxplot() +
  scale_fill_manual(values = c(rep("white", 7)), 
                    name = "Groups", 
                    labels = c(juge)) +
 ylim(0,max(score_cb)^2) +geom_hline(yintercept = 0)+
  labs(x = "juge",title = "Systematic deviation in scoring on the total score scale", y = "Note", fill = NULL) +
  theme(legend.position = "bottom")+theme_classic()

NL2_Score

###################################################################
##            BIAS MATRIX + graph
###################################################################
fig_cb_cols<-c(juge,"figures","base_value","Moyenne")
fig_cb<-matrix(0,nrow=nrow(fig_goe),ncol=length(fig_cb_cols))
fig_cb<-as.data.frame(fig_cb)
names(fig_cb)<-fig_cb_cols
fig_cb[,c("figures","base_value")]<-fig_goe[,c("figures","base_value")]

for (a in 1:nrow(fig_goe)){
  for (b in 1:length(juge)){
    fig_cb[a,juge[b]]<-as.numeric(fig_goe[a,juge[b]])-fig_goe$Moyenne[a]}}

#head(fig_goe)
#head(fig_cb)

# Converting data to long format for ggplot2
fig_cb_graph <- fig_cb[, c("base_value", juge, "figures")]
donnees_long1 <- tidyr::pivot_longer(fig_cb_graph, -c(figures, base_value))

p1 <- ggplot(donnees_long1, aes(x = c(figures), y = value, fill = figures)) +
  geom_boxplot() +
  scale_fill_manual(values = c("white", "white", "white","white")) +
  facet_wrap(~ name, scales = "free_y") +
  labs(x = "Figure", y = "Value", title = "Bias in GOE scoring") +
  theme_classic() +
  # ylim(-2, 2) +
  theme(axis.text.x = element_text(angle = 90, vjust = 1)) +
  geom_hline(yintercept = 0, linewidth = 0.75, linetype = "dashed", color = "magenta")+geom_hline(yintercept = 2,linetype = "dashed",linewidth=0.75, color = "red2")+geom_hline(yintercept = -2,linetype = "dashed",linewidth=0.75, color = "red2")

# Save the graph with a specified size

NL1_GOE <- p1
#NL1_GOE

liste_graphiques <- list()

count_values <- function(data) {
  # Creating an empty counting table
  table_counts <- data.frame(Figure = unique(data$figures),
                              Count_outside_range = rep(0, length(unique(data$figures))))
  
# Loop over each type of figure
  for (i in 1:nrow(table_counts)) {
    figure <- table_counts$Figure[i]
    count_outside_range <- sum(data$value[data$figures == figure] < -2 | data$value[data$figures == figure] > 2)
    table_counts$Count_outside_range[i] <- count_outside_range
  }
  
# Add a line with the sum of the figures
  total_counts <- sum(table_counts$Count_outside_range)
  table_counts <- rbind(table_counts, c("Total", total_counts))
  
  return(table_counts)
}
# Create a list to store the tables for each judge
liste_tableaux <- list()

# Loop through each judge to create the corresponding array
for (i in juge){
# Filter data for current judge
    juge_data <- donnees_long1[donnees_long1$name == i, ]
    
    # Calculate counts for this judge
    table_data <- count_values(juge_data)
    
 # Change the name of the board according to the judge
    nom_tableau <- paste("tableau_", i, sep = "")
    names(table_data) <- c( paste("Effective table of values outside [-2;2] for", i, sep = ""), " ")
    
   # Add the table to the list of tables
    liste_tableaux[[nom_tableau]] <- table_data
}
# Loop through each judge to create the individual graphs and tables

for (i in juge) {
 # Filter data for current judge
  juge_data <- donnees_long1[donnees_long1$name == i, ]
  
# Create an array with the number of values greater than 2 and less than -2

# Create a graph for the current judge
  graph <- ggplot(juge_data, aes(x = "All figures", y = value)) +
    geom_boxplot() +
    geom_boxplot(aes(x = figures, y = value), fill = "gray", color = "black", alpha = 0.5) +
    labs(title = paste("Bias chart for technical figures of", i), x = "Figures", y = "Note") +
    theme_classic() +
    geom_hline(yintercept = 2, linetype = "dashed", linewidth = 0.75, color = "red2") +
    geom_hline(yintercept = -2, linetype = "dashed", linewidth = 0.75, color = "red2") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    geom_hline(yintercept = 0, linewidth = 0.75, linetype = "dashed", color = "magenta")
  
# Add the chart to the chart list
  liste_graphiques[[i]] <- graph
}
# Show graphs
for (i in seq_along(liste_graphiques)) {
  print(liste_graphiques[[i]])
  
# Show the corresponding table
  print(liste_tableaux[[i]])
}

fig_cb_transposed <- pivot_longer(fig_cb, cols = -c(figures, base_value, Score_panel,Moyenne), names_to = "Juge", values_to = "Biais")

# Create a graph for each type of criteria (Composition, Skating Skills, Presentation)
plot_saut_NL1 <- ggplot(subset(fig_cb_transposed, figures == "Saut"), aes(x = Juge, y = Biais, fill = figures)) +
  geom_boxplot() +
  geom_hline(yintercept = 0, linetype = "dashed", color = "orange")+geom_hline(yintercept = 2,linetype = "dashed",linewidth=0.75, color = "red2")+geom_hline(yintercept = -2,linetype = "dashed",linewidth=0.75, color = "red2") +
  labs(x = NULL, y = "Bias of composition lines", title = "Line Bias Composition") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5),
        plot.title = element_text(hjust = 0.5, face = "bold", size = 14))+theme_classic()+
  ggtitle("Bias in Scoring in the Jump Figure Score Scale")+ scale_fill_manual(values = "white")

if(nrow(subset(fig_cb_transposed, figures == "Saut")>= len_juge)){
plot_saut_NL1

}


Saut_data <- subset(fig_cb, figures == "Saut")

if (nrow(subset(fig_cb, figures == "Saut")) >= len_juge) {
  
  juges <- juge
  
  for (j in juges) {
 # Run the t-test for each pair of matching variables
   resultat_test <- t.test(Saut_data[[j]], Saut_data$Moyenne, paired = TRUE)
   
    if (resultat_test$p.value < pvaluedutest) { 
      print(paste("The P-value of the t-test for", j, "=", round(resultat_test$p.value, digits = 8), ".")) 
    }
  }  
  
}


plot_ChSq_NL1 <- ggplot(subset(fig_cb_transposed, figures == "ChSq"), aes(x = Juge, y = Biais, fill = figures)) +
  geom_boxplot() +
  geom_hline(yintercept = 0, linetype = "dashed", color = "orange4")+geom_hline(yintercept = 2,linetype = "dashed",linewidth=0.75, color = "red2")+geom_hline(yintercept = -2,linetype = "dashed",linewidth=0.75, color = "red2") +
  labs(x = NULL, y = "Bias of composition lines", title = "Line Bias Composition") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5),
        plot.title = element_text(hjust = 0.5, face = "bold", size = 14))+theme_classic()+
  ggtitle("Bias in scoring on the Figure ChSq score scale")+ scale_fill_manual(values = "white")

if(nrow(subset(fig_cb_transposed, figures == "ChSq")>= len_juge)){
plot_ChSq_NL1}
ChSq_data <- subset(fig_cb, figures == "ChSq")

if (nrow(subset(fig_cb, figures == "ChSq")) >= len_juge) {
  
  juges <- names(ChSq_data)[startsWith(names(ChSq_data), "J")]
  
  for (j in juges) {
    # Run the t-test for each pair of matching variables
    resultat_test <- t.test(ChSq_data[[j]], ChSq_data$Moyenne, paired = TRUE)
  
    if (resultat_test$p.value < pvaluedutest) { 
      print(paste("The P-value of the t-test for", j, "=", round(resultat_test$p.value, digits = 8), ".")) 
    }
  }  
  
}


plot_Pirouette_NL1 <- ggplot(subset(fig_cb_transposed, figures == "Pirouette"), aes(x = Juge, y = Biais, fill = figures)) +
  geom_boxplot() +
  geom_hline(yintercept = 0, linetype = "dashed", color = "magenta")+geom_hline(yintercept = 2,linetype = "dashed",linewidth=0.75, color = "red2")+geom_hline(yintercept = -2,linetype = "dashed",linewidth=0.75, color = "red2") +
  labs(x = NULL, y = "Bias of composition lines", title = "Line Bias Composition") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5),
        plot.title = element_text(hjust = 0.5, face = "bold", size = 14))+theme_classic()+
  ggtitle("Bias in scoring on the Pirouette figure score scale")+ scale_fill_manual(values = "white")

if(nrow(subset(fig_cb_transposed, figures == "Pirouette")>= len_juge)){
plot_Pirouette_NL1

}


Pirouette_data <- subset(fig_cb, figures == "Pirouette")

if (nrow(subset(fig_cb, figures == "Pirouette")) >= len_juge) {
  
  juges <- names(Pirouette_data)[startsWith(names(Pirouette_data), "J")]
  
  for (j in juges) {
    # Run the t-test for each pair of matching variables
    resultat_test <- t.test(Pirouette_data[[j]], Pirouette_data$Moyenne, paired = TRUE)
  
    if (resultat_test$p.value < pvaluedutest) { 
      print(paste("The P-value of the t-test for", j, "=", round(resultat_test$p.value, digits = 8), ".")) 
    }
  }  
  
}

plot_StSq_NL1 <- ggplot(subset(fig_cb_transposed, figures == "StSq"), aes(x = Juge, y = Biais, fill = figures)) +
  geom_boxplot() +
  geom_hline(yintercept = 0, linetype = "dashed", color = "royalblue")+geom_hline(yintercept = 2,linetype = "dashed",linewidth=0.75, color = "red2")+geom_hline(yintercept = -2,linetype = "dashed",linewidth=0.75, color = "red2") +
  labs(x = NULL, y = "Bias of composition lines", title = "Bias of composition lines") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5),
        plot.title = element_text(hjust = 0.5, face = "bold", size = 14))+theme_classic()+
  ggtitle("Bias in scoring on the Stsq figure score scale")+ scale_fill_manual(values = "white")

if(nrow(subset(fig_cb_transposed, figures == "StSq")>= len_juge)){
plot_StSq_NL1
}


StSq_data <- subset(fig_cb, figures == "StSq")

if (nrow(subset(fig_cb, figures == "StSq")) >= len_juge) {
  
  juges <- names(StSq_data)[startsWith(names(StSq_data), "J")]
  
  for (j in juges) {
    # Run the t-test for each pair of matching variables
    resultat_test <- t.test(StSq_data[[j]], StSq_data$Moyenne, paired = TRUE)
  
    if (resultat_test$p.value < pvaluedutest) { 
      print(paste("The P-value of the t-test for", j, "=", round(resultat_test$p.value, digits = 8), ".")) 
    }
  }  
  
}
 
####################################################################
##        SQUARED BIAS MATRIX (figures)
####################################################################


fig_cb2<-matrix(0,nrow=nrow(fig_goe),ncol=ncol(fig_goe))
fig_cb2<-as.data.frame(fig_cb2)
names(fig_cb2)<-cols_goe
fig_cb2[,c("figures","base_value")]<-fig_goe[,c("figures","base_value")]


for (a in 1:nrow(fig_goe)){
  for (b in 1:length(juge)){
    fig_cb2[a,juge[b]]<-round(((as.numeric(fig_goe[a,juge[b]]))-fig_goe$Moyenne[a])^2, digits = 4)
    
  }
}

#head(fig_cb2)

# Converting data to long format for ggplot2
fig_cb2_graph<-fig_cb2[,c("base_value",juge,"figures")]
donnees_long <- tidyr::pivot_longer(fig_cb2_graph, -c(figures, base_value))
#donnees_long
# Creating the boxplot with ggplot2
p2<-ggplot(donnees_long, aes(x = figures, y = value, fill = figures)) +
  geom_boxplot()  +ylim(0,2)+scale_fill_manual(values=c("white","white","white","white"))+
  facet_wrap(~ name, scales = "free_y") + geom_hline(yintercept = 0, linewidth=0.75)+
  labs(x = "Figure", y = "Value", title = "Systematic deviation in grading on the GOE score scale")
p2<-p2 + theme_classic()
NL2_GOE <- p2+theme(axis.text.x = element_text(angle = 90, vjust = 1))

#NL2_GOE

for (i in juge) {
 # Filter data for current judge
  juge_data <- donnees_long[donnees_long$name == i, ]
# Create an array with the number of values ​​greater than 2 and less than -2

  
  # Create a graph for the current judge
graph <- ggplot(juge_data, aes(x = "All figures", y = value)) +
    geom_boxplot() +
    geom_boxplot(aes(x = figures, y = value), fill = "gray", color = "black", alpha = 0.5) +
    labs(title = paste("Mean Squared Error graph of figures for", i), x = "figures", y = "Note") +
    theme_classic() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    geom_hline(yintercept = 0, linewidth = 0.75, linetype = "dashed", color = "magenta")
  
# Add the chart to the chart list
  liste_graphiques[[i]] <- graph
}

# Show graphs
for (i in seq_along(liste_graphiques)) {
  print(liste_graphiques[[i]])
  
}

p2<-ggplot(subset(donnees_long,figures == "StSq"), aes(x = name , y = value , fill = figures)) +
  geom_boxplot()  +ylim(0,2)+scale_fill_manual(values="white")+
   geom_hline(yintercept = 0, linewidth=0.75)+
  labs(x = "Figure", y = "Value", title = "Systematic deviation in scoring across the StSQ figure score")
p2<-p2 + theme_classic()
NL2_StSq <- p2+theme(axis.text.x = element_text(angle = 90, vjust = 1))

if (nrow(subset(donnees_long,figures == "StSq")) >= len_juge){
NL2_StSq

}


p2<-ggplot(subset(donnees_long,figures == "Pirouette"), aes(x = name , y = value , fill = figures)) +
  geom_boxplot()  +ylim(0,2)+scale_fill_manual(values="white")+
   geom_hline(yintercept = 0, linewidth=0.75)+
  labs(x = "Figure", y = "Value", title = "Systematic deviation in scoring on the Pirouette figure score scale")
p2<-p2 + theme_classic()
NL2_Pirouette <- p2+theme(axis.text.x = element_text(angle = 90, vjust = 1))

if (nrow(subset(donnees_long,figures == "Pirouette")) >= len_juge){
NL2_Pirouette

}

p2<-ggplot(subset(donnees_long,figures == "Saut"), aes(x = name , y = value , fill = figures)) +
  geom_boxplot()  +ylim(0,2)+scale_fill_manual(values="white")+
   geom_hline(yintercept = 0, linewidth=0.75)+
  labs(x = "Figure", y = "Value", title = "Systematic deviation in scoring across Figure Jump score")
p2<-p2 + theme_classic()
NL2_Saut <- p2+theme(axis.text.x = element_text(angle = 90, vjust = 1))

if (nrow(subset(donnees_long,figures == "Saut")) >= len_juge){
NL2_Saut}

p2<-ggplot(subset(donnees_long,figures == "ChSq"), aes(x = name , y = value , fill = figures)) +
  geom_boxplot()  +ylim(0,2)+scale_fill_manual(values="white")+
   geom_hline(yintercept = 0, linewidth=0.75)+
  labs(x = "Figure", y = "Value", title = "Systematic deviation in scoring on the ChSq figure score scale")
p2<-p2 + theme_classic()
NL2_ChSq <- p2+theme(axis.text.x = element_text(angle = 90, vjust = 1))

if (nrow(subset(donnees_long,figures == "ChSq")) >= len_juge){
NL2_ChSq

}

###############################################################################
## BIAS COMPO DETAIL #################################################################################

elem_c$Moyenne <- 0
for (i in 1:nrow(elem_c)){
  
  elem_c$Moyenne[i] <- sum(as.numeric(elem_c[i,juge]))/length(juge)
}

compo_cb<-matrix(0,nrow=nrow(elem_c),ncol=ncol(elem_c))
compo_cb<-as.data.frame(compo_cb)
names(compo_cb)<-names(elem_c)
compo_cb[,c("Elements","GEO...FACTOR")]<-elem_c[,c("Elements","GEO...FACTOR")]
#compo_cb

for (a in 1:nrow(elem_c)){
  for (b in 1:length(juge)){
    compo_cb[a,juge[b]]<-as.numeric(elem_c[a,juge[b]])-elem_c$Moyenne[a]
    
  }
}

#head(compo_cb)
# Converting data to long format for ggplot2
donnees_long5 <- tidyr::pivot_longer(compo_cb, -c(Elements, GEO...FACTOR, Score_panel,Moyenne))
# Creating the boxplot with ggplot2
NL1_COMPO <- ggplot(donnees_long5, aes(x = Elements, y = value, fill = Elements)) +
  geom_boxplot() +scale_fill_manual(values=c("white","white","white"))+
  facet_wrap(~ name, scales = "free_y") + geom_hline(yintercept = 0, linetype = "dashed", color = "blue3")+
  labs(x = "Elements", y = "Value", title = "Bias in scoring on the Component score scale")+theme(axis.text.x = element_text(angle = 90, vjust = 0.5))

#NL1_COMPO+theme_classic()+theme(axis.text.x = element_text(angle = 90, vjust = 0.5))

# Filter data for each type of criteria
composition_data <- subset(compo_cb, Elements == "Composition")
skating_skills_data <- subset(compo_cb, Elements == "Skating Skills")
presentation_data <- subset(compo_cb, Elements == "Presentation")

compo_cb_transposed <- pivot_longer(compo_cb, cols = -c(Elements, GEO...FACTOR, Score_panel,Moyenne), names_to = "Juge", values_to = "Biais")


for (i in juge) {
# Filter data for current judge
  juge_data <- donnees_long5[donnees_long5$name == i, ]
  # Create an array with the number of values greater than 2 and less than -2

  
# Create a graph for the current judge
  graph <- ggplot(juge_data, aes(x = "All the figures", y = value)) +
    geom_boxplot() +
    geom_boxplot(aes(x = Elements, y = value), fill = "gray", color = "black", alpha = 0.5) +
    labs(title = paste("Bias plot for compositional elements of ", i), x = "Figures", y = "Note") +
    theme_classic() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    geom_hline(yintercept = 0, linewidth = 0.75, linetype = "dashed", color = "magenta")
  
# Add the chart to the chart list
  liste_graphiques[[i]] <- graph
}

# Show graphs
for (i in seq_along(liste_graphiques)) {
  print(liste_graphiques[[i]])
  
}
print(paste0("As there is ", len_juge , " judges, we will carry out at least ", (len_juge * 3) , " statistical tests for the components."))
print(paste0("Since our tests will be multiple it is necessary to adapt the pvalue threshold, so our threshold will then be 0.05 / ",(len_juge*3),' = ',round((0.05/(len_juge*3) )),digits = 6))
#Detail for each of the Components.

plot_presentation_NL1 <- ggplot(subset(compo_cb_transposed, Elements == "Presentation"), aes(x = Juge, y = Biais, fill = Elements)) +
  geom_boxplot() +
  geom_hline(yintercept = 0, linetype = "dashed", color = "blue3") +
  labs(x = NULL, y = "Bias of presentation lines") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5),
        plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
        axis.text = element_text(face = "bold"))+theme_classic()+
  ggtitle("Bias in scoring on the presentation score scale")+ scale_fill_manual(values="white")


plot_presentation_NL1

#elem_c # matrice des compo

#presentation_table <- subset(elem_c, Elements == "Presentation")



for (j in juge) {
   # Run the t-test for each pair of matching variables
    resultat_test <- t.test(subset(elem_c, Elements == "Presentation")[[j]], subset(elem_c, Elements == "Presentation")$Moyenne, paired = TRUE)
    if (resultat_test$p.value < pvaluedutest) { 
        print(paste("The P-value of the t-test for", j, "=", round(resultat_test$p.value, digits = 10), ".")) 
    }
}


#essaietestvar <- pairwise.t.test(composition_table$J2, composition_table$Score_panel,paired = TRUE)
#print(composition_table$J2)
#print(composition_table$Score_panel)

plot_skating_skills_NL1 <- ggplot(subset(compo_cb_transposed, Elements == "Skating Skills"), aes(x = Juge, y = Biais, fill = Elements)) +
  geom_boxplot() +
  geom_hline(yintercept = 0, linetype = "dashed", color = "blue3") +
  labs(x = NULL, y = "Line bias skating skills", title = "Line bias skating skills") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5),
        plot.title = element_text(hjust = 0.5, face = "bold", size = 14))+theme_classic()+
  ggtitle("Bias in scoring on the Composition score scale")+ scale_fill_manual(values="white")


plot_skating_skills_NL1

#skating_skills_table <- subset(elem_c, Elements == "Skating Skills")

for (j in juge) {
# Run the t-test for each pair of matching variables
    resultat_test <- t.test(subset(elem_c, Elements == "Skating Skills")[[j]], subset(elem_c, Elements == "Skating Skills")$Moyenne, paired = TRUE)
    
    if (resultat_test$p.value < pvaluedutest) { 
        print(paste("The P-value of the t-test for", j, "=", round(resultat_test$p.value, digits = 8), ".")) 
    }
}
# Create a graph for each type of criteria (Composition, Skating Skills, Presentation)
plot_composition_NL1 <- ggplot(subset(compo_cb_transposed, Elements == "Composition"), aes(x = Juge, y = Biais, fill = Elements)) +
  geom_boxplot() +
  geom_hline(yintercept = 0, linetype = "dashed", color = "blue3") +
  labs(x = NULL, y = "Bias of composition lines", title = "Bias of composition lines") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5),
        plot.title = element_text(hjust = 0.5, face = "bold", size = 14))+theme_classic()+
  ggtitle("Bias in scoring on the Composition score scale")+ scale_fill_manual(values="white")


plot_composition_NL1


#composition_table <- subset(elem_c, Elements == "Composition")

for (j in juge) {
   # Run the t-test for each pair of matching variables
    resultat_test <- t.test(subset(elem_c, Elements == "Composition")[[j]], subset(elem_c, Elements == "Composition")$Moyenne, paired = TRUE)
    if (resultat_test$p.value < pvaluedutest) { 
        print(paste("The P-value of the t-test for", j, "=", round(resultat_test$p.value, digits = 8), ".")) 
    }
}
###############################################################################
##                   BIAS COMPO NL2                                      ##
###############################################################################

compo_cb2<-matrix(0,nrow=nrow(elem_c),ncol=ncol(elem_c))
compo_cb2<-as.data.frame(compo_cb2)
names(compo_cb2)<-names(elem_c)
compo_cb2[,c("Elements","GEO...FACTOR")]<-elem_c[,c("Elements","GEO...FACTOR")]
#compo_cb2

#nrow(elem_c)

for (a in 1:nrow(elem_c)){
  for (b in 1:length(juge)){
    compo_cb2[a,juge[b]]<-round((as.numeric(elem_c[a,juge[b]])-elem_c$Moyenne[a])^2,digits = 4)
    
  }
}

#head(compo_cb2)

# Converting data to long format for ggplot2
donnees_long3 <- tidyr::pivot_longer(compo_cb2, -c(Elements, GEO...FACTOR, Score_panel,Moyenne))

# Creating the boxplot with ggplot2
p3<-ggplot(donnees_long3, aes(x = Elements, y = value, fill = Elements)) +
  geom_boxplot()+scale_fill_manual(values=c("white","white","white"))+
  facet_wrap(~ name, scales = "free_y") + geom_hline(yintercept = 0,linewidth=0.75 )+
  labs(x = "Elements", y = "Value", title = "Systematic deviation in the rating on the Component score scale")
p3<-p3+theme_classic()
#p3+theme(axis.text.x = element_text(angle = 90, vjust = 1))

for (i in juge) {
 # Filter data for current judge
  juge_data <- donnees_long3[donnees_long3$name == i, ]
  
# Create an array with the number of values ​​greater than 2 and less than -2
  
# Create a graph for the current judge
  graph <- ggplot(juge_data, aes(x = "Toutes les figures", y = value)) +
    geom_boxplot() +
    geom_boxplot(aes(x = Elements, y = value), fill = "gray", color = "black", alpha = 0.5) +
    labs(title = paste("Graphique du MSE des élements de composition pour", i), x = "Figures", y = "Note") +
    theme_classic() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    geom_hline(yintercept = 0, linewidth = 0.75, linetype = "dashed", color = "magenta")
  
# Add the chart to the chart list
  liste_graphiques[[i]] <- graph
}

# Show graphs
for (i in seq_along(liste_graphiques)) {
  print(liste_graphiques[[i]])
  
}
# Create a graph for each type of criteria (Composition, Skating Skills, Presentation)
plot_composition_NL2 <- ggplot(subset(donnees_long3, Elements == "Composition"), aes(x = name, y = value, fill = Elements)) +
  geom_boxplot() +
  geom_hline(yintercept = 0, linetype = "dashed", color = "magenta") +
  labs(x = NULL, y = "Bias of composition lines", title = "Bias of composition lines") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5),
        plot.title = element_text(hjust = 0.5, face = "bold", size = 14))+theme_classic()+
  ggtitle("Graph of judges' MSE for the Composition element") + scale_fill_manual(values = "white")

plot_composition_NL2 

plot_Skating_Skills_NL2 <- ggplot(subset(donnees_long3, Elements == "Skating Skills"), aes(x = name, y = value, fill = Elements)) +
  geom_boxplot() +
  geom_hline(yintercept = 0, linetype = "dashed", color = "magenta") +
  labs(x = NULL, y = "Bias of composition lines", title = "Bias of composition lines") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5),
        plot.title = element_text(hjust = 0.5, face = "bold", size = 14))+theme_classic()+
  ggtitle("Graph of judges' MSE for the Skating Skills element") +scale_fill_manual(values = "white")

plot_Skating_Skills_NL2
plot_presentation_NL2 <- ggplot(subset(donnees_long3, Elements == "Presentation"), aes(x = name, y = value, fill = Elements)) +
  geom_boxplot() +
  geom_hline(yintercept = 0, linetype = "dashed", color = "magenta") +
  labs(x = NULL, y = "Bias of composition lines", title = "Bias of composition lines") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5),
        plot.title = element_text(hjust = 0.5, face = "bold", size = 14))+theme_classic()+
  ggtitle("Graph of the judges' MSE for the Presentation elements")+scale_fill_manual(values = "white")

plot_presentation_NL2

j_kendall<-rep(0,length(juge))
names(j_kendall)<-juge
for (j in juge){
  conc <- 0
  disc <- 0
  for (i in 1:(length(skat)-1)) {
    if (complete.cases(clasmt_s[i, ]) && complete.cases(clasmt_s[i+1, ]) && complete.cases(skat[i]) && complete.cases(skat[i+1])) {
      if ((clasmt_s$Moyenne[i] > clasmt_s$Moyenne[i+1] && clasmt_s[i,j] > clasmt_s[i+1,j]) |
          (clasmt_s$Moyenne[i] < clasmt_s$Moyenne[i+1] && clasmt_s[i,j] < clasmt_s[i+1,j])) {
        conc <- conc + 1
      } else {
        disc <- disc + 1
      }
    }
  }
  tau_kendall <- (conc - disc) / (0.5 * length(skat) * (length(skat) - 1))
  j_kendall[j] <- tau_kendall
}
j_kendall

