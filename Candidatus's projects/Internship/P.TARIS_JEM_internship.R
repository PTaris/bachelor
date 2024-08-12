#Author : Pauline TARIS 
##########################################################
##                      LIBRARIES                       ##
##########################################################
library(readr)
library(stringr)
library(dplyr)
library(lubridate)
library(glue)
library(rmarkdown)
library(tidyverse)
library(tidyr)
library(gtsummary)

#
#To load the documents correctly and summarize the path to the essentials:
#setwd()
setwd("Z:/ATENA-Registre Néo-Aquitain/Etudiants/Pauline Taris/Code")

mpp <- read_delim("mpp.csv", delim = ";", escape_double = FALSE, col_types = cols(N = col_number(), P = col_number()), locale = locale(decimal_mark = ","), trim_ws = TRUE)
mpp
pcs <- read_csv("pcs.csv")
pcs
data <- read_delim("data_test_elfe_corrige.csv", delim = ";", escape_double = FALSE, col_types = cols(ddn_complete_enfant = col_date(format = "%d/%m/%Y"), 
                                                                                                      date_debut_gross_act = col_date(format = "%d/%m/%Y"), 
                                                                                                      questionnaire_environnement_mere_v30_timestamp = col_date(format = "%d/%m/%Y"), 
                                                                                                      metier_mat_debutv1 = col_date(format = "%d/%m/%Y"), 
                                                                                                      metier_mat_finv1 = col_date(format = "%d/%m/%Y"), 
                                                                                                      metier_mat_debutv2 = col_date(format = "%d/%m/%Y"), 
                                                                                                      metier_mat_finv2 = col_date(format = "%d/%m/%Y"), 
                                                                                                      metier_mat_debutv3 = col_date(format = "%d/%m/%Y"), 
                                                                                                      metier_mat_finv3 = col_date(format = "%d/%m/%Y"), 
                                                                                                      metier_mat_debutv4 = col_date(format = "%d/%m/%Y"), 
                                                                                                      metier_mat_finv4 = col_date(format = "%d/%m/%Y"), 
                                                                                                      metier_mat_debutv5 = col_date(format = "%d/%m/%Y"), 
                                                                                                      metier_mat_finv5 = col_date(format = "%d/%m/%Y"), 
                                                                                                      trav_mat_arret_debut = col_date(format = "%d/%m/%Y"), 
                                                                                                      trav_mat_arret_fin = col_date(format = "%d/%m/%Y"),
                                                                                                      naf03_mat2 = col_character()), trim_ws = TRUE)


des_pcs_1 <- read_delim("des_pcs_1.csv", delim = ";", escape_double = FALSE, trim_ws = TRUE)

des_pcs_2 <- read_delim("des_pcs_2.csv", delim = ";", escape_double = FALSE, trim_ws = TRUE) #n'existent pas en précision 3 et 4 !!!!!!!
des_pcs_3 <- read_delim("des_pcs_3.csv", delim = ";", escape_double = FALSE, trim_ws = TRUE)

des_pcs_4 <- read_delim("des_pcs_4.csv", delim = ";", escape_double = FALSE, trim_ws = TRUE)

des_naf_1 <- read_delim("des_naf_1.csv", delim = ";", escape_double = FALSE, trim_ws = TRUE)
des_naf_2 <- read_delim("des_naf_2.csv", delim = ";", escape_double = FALSE, trim_ws = TRUE)
des_naf_3 <- read_delim("des_naf_3.csv", delim = ";", escape_double = FALSE, trim_ws = TRUE)
des_naf_4 <- read_delim("des_naf_4.csv", delim = ";", escape_double = FALSE, trim_ws = TRUE)

##########################################################
##                 MATRIX  PESTIPOP                    ##
##########################################################


####################### Exploring the pestipop matrix #####################

################################################################################
######################### research ###########################################
################################################################################

# search NAs in the matrix among PCS codes
mpp[which(is.na(mpp$PCS2003)),]
mpp[67,]

# # search NAs in the matrix among NAF codes
mpp[which(is.na(mpp$NAF2003)),]
which(is.na(mpp$NAF2003))
mpp[14,]

#search for incomplete pcs codes
nchar(mpp$PCS2003[1])
which(nchar(mpp$NAF2003)<4)
which(nchar(mpp$PCS2003)<4)

#all pestipop codes are complete


#exhaustive display of pcs categories with a 3-digit precision code 
mpp[which(str_starts(mpp$PCS2003,'542')),]

#without double
unique(mpp[which(str_starts(mpp$PCS2003,'971')),1])

#creation of a list of all pcs codes in the matrix
liste<-unique(mpp$PCS2003)
liste

#pestipop dimension
dim(mpp)
####################################################################
###################### numbers ####################################
####################################################################

#number of PCS codes entered
mpp %>% 
  filter(is.na(PCS2003)==F) %>% 
  count()
#388

#number of couples where the pcs code is alone
mpp %>% 
  filter(is.na(PCS2003)==F & is.na(NAF2003)==T) %>% 
  count()
#147


mpp %>% 
  select(PCS2003,NAF2003,P) %>% 
  filter(is.na(PCS2003)==TRUE & is.na(NAF2003)==FALSE & is.na(P)==FALSE) %>% 
  count()
#no naf couples without pcs with proba

############### Purple lines ##############################

#number of purple lines
sum(mpp$N==0)
mpp %>% 
  select(PCS2003,NAF2003,N) %>% 
  filter(N==0 & is.na(NAF2003)==TRUE) %>% 
  count()
#28 NA for the naf on the purple lines

#We have 28 purple lines

#number of couples or the pcs code is alone with an expo==NA
mpp %>% 
  filter(is.na(PCS2003)==F & is.na(NAF2003)==T) %>%
  filter(is.na(P)==T) %>% 
  count()
#23

mpp %>% 
  select(PCS2003,NAF2003,N) %>% 
  filter(N==0 & is.na(PCS2003)==TRUE) %>% 
  count()
#5 Na for the PCS on the purple lines

#We can conclude after checking on the matrix that 5 lines are empty
violet<-which(mpp$N==0 & is.na(mpp$PCS2003)==T)
#125 ==> transcoding
#210 ==> transcoding
#239 ==> transcoding
#242 ==> transcoding
#321 ==> transcoding


#codes are not transcribed when going from pcs 94 to pcs 2003


#removal of empty lines due to transcoding issues

mpp[-as.vector(which(mpp$N==0 & is.na(mpp$PCS2003)==T)),]


####################  Purple lines end  #####################################


#number of incomplete couples without NAF
nrow(mpp[which(is.na(mpp$NAF2003)),]) #number without naf
#152

#number of codes without PCS
sum(is.na(mpp$PCS2003))
#6

#number of naf codes not reported
sum(is.na(mpp$NAF2003))
#152


#only case where just the naf is filled in with a probability ==> copy and paste error to correct? 211c

mpp[which(is.na(mpp$PCS2003)),]

#line 67 we only have the naf but not the pcs2003

################## Handling inconsistencies #################################

#pro cat goes from 1 to 6 for the first digit
class(mpp$PCS2003)
mpp$PCS2003[which(str_starts(mpp$PCS2003,'9'))]<-'671a'
#pour le naf solo
mpp$PCS2003[67]<-"211c"

############# Added Expo Probability Categories #######################

class(mpp$P)

mpp <-mpp %>%  
  mutate(catP= case_when(P<25.00~'1',
                         P<50.00 ~'2',
                         P<75.00 ~'3',
                         P>=75.00~'4'))

#View(mpp)
#head(mpp$P)


############# Precision i-digit exploration ##############################


#categories that are not all exposed according to the precision of the digits
cat_ne<-pcs$tout[which(!(pcs$tout %in% mpp$PCS2003))]

##precisions less than 4 digits
precis<-nchar(pcs$tout[1])-1

########### Columns or all PCS sub-categories are exposed or not ##################


#categories that are not all exposed to a precision lower than 4 digits
for (i in 1:length(mpp$PCS2003)){
  if(substr(mpp$PCS2003,1,3)[i] %in% unique(substr(cat_ne,1,3))){
    mpp$P_expo[i]<-'pas_tout_E'}else{mpp$P_expo[i]<-'tout_E'}
}

#View(mpp)


#We are looking for pcs codes with i digits of precision whose sub-categories are not all filled in
#in the matrix

#possible groupings for the unexposed:
for (i in 1:precis){
  long<-length(unique(substr(cat_ne,1,i)))
  assign(str_glue("gr_NE{i}"),c())
  for (a in 1:long){
    
    pcs_dtail<-as.vector(pcs$tout[which(str_starts(pcs$tout,unique(substr(cat_ne,1,i))[a]))])
    pcs_NE<-as.vector(cat_ne[which(str_starts(cat_ne,unique(substr(cat_ne,1,i))[a]))])
    if (length(pcs_dtail)==length(pcs_NE)){
      assign(str_glue("gr_NE{i}"),c(get(str_glue("gr_NE{i}")),substr(pcs_dtail[1],1,i)))}}
}
gr_NE1
gr_NE2
gr_NE3
# possible groupings at different degrees of precision are of probability 0: because they are not in the matrix

# possible groupings for the presentations:  

gr_3<-mpp %>% 
  select(PCS2003,P_expo,N,catP) %>% 
  filter(N!=0 & P_expo=="tout_E") %>% 
  arrange(catP) %>% 
  select(PCS2003,catP)


gr_3<-gr_3 %>% 
  mutate(PCS2003=substr(PCS2003,1,3)) %>% 
  distinct(.keep_all=TRUE)

gr_3<-as.data.frame(gr_3)


for (i in range(1:length(gr_3))){
  cats<-c(gr_3$catP[which(gr_3$PCS2003==gr_3$PCS2003[i])])
  if (all(cats==cats[1])){
    print(glue("regroupement possible pour {gr_3$PCS2003[i]} "))
  }
}
#no grouping possible for 3-digit precision so none is possible for lower precision

#########################################################################
##                     MATRIX DESCRIPTION                        ##
#########################################################################

#The INSEE PCS tables for a precision of 2 are shared over two files so they are combined here
des_pcs_23<-rbind(des_pcs_2,des_pcs_3) ########!!!!!!!!!!!!!!!!!!!!!!! see pcs nomenclature: 1 level to ignore
des_pcs_2<-des_pcs_23

des_pcs_2<-des_pcs_2 %>% 
  select(Code,Libellé) %>% 
  distinct(Code,.keep_all = TRUE)%>% 
  arrange(Code)


#formatting variables
des_pcs_2$Code<-as.character(des_pcs_2$Code)
des_pcs_1$Code<-as.character(des_pcs_1$Code)

#####################################################################################################
####  Description of the codes of the lines (purple) without data from the CERENAT study but expo ####
#####################################################################################################


##Enter the desired precision of the pcs code to be described
info_prec<-readline(prompt="Description des lignes violettes \n Entrer la précision du code PCS (1,2,4) dont vous souhaitez la description : ")
info_prec
#Allows you to deal with an input error
while (!(info_prec %in% c("1","2","4"))){info_prec<-readline(prompt="Rentrée une précision de 1,2 ou 4 : ")
}

#a dataframe is built with the purple lines with PCS code (in any case the empty lines (all purple) are deleted upstream)

des_violet<-mpp %>% 
  filter(N==0, is.na(PCS2003)==F) %>% 
  select(PCS2003,P_expo)

##apply the entered precision to the pcs codes
des_violet$PCS2003<-substr(des_violet$PCS2003,1,as.integer(info_prec))
des_violet

#formatting 
des_violet$PCS2003<-as.character(des_violet$PCS2003)

#checking formats to apply join
class(get(str_glue("des_pcs_{info_prec}"))$Code)
des_violet$PCS2003

by<-join_by(PCS2003==Code)
des_violet<-left_join(des_violet,get(str_glue("des_pcs_{info_prec}")),by=by)
des_violet<-as.data.frame(des_violet)
colnames(des_violet)
?left_join

#descriptive table of pcs lines without naf and without expo

des_violet %>% 
  select(P_expo,Libellé) %>% 
  mutate(P_expo=recode(P_expo,"tout_E"="Catégories PCS toutes exposées","pas_tout_E"="Catégories PCS pas toutes exposées")) %>%   
  tbl_summary(label=list(P_expo~"Exposition professionnelles aux pesticides")) %>% 
  modify_header(label = "**Catégorie de probabilité d'exposition**") 



##########################################################
##  APPLICATION OF PESTIPOP MATRIX TO A SAMPLE      ##
##########################################################

###############################################################
###### Study of the consistency of sample data #####
###############################################################

#number of possible jobs
nb_met<-sum(str_starts(names(data),"metier_mat_debutv"))
nb_met
#5 
#compliant with the questionnaire

##################### CONTROL DATES #########################

#date decomposition to check date format
data$ddn_complete_enfant[1]


day(data$ddn_complete_enfant[1])
month(data$ddn_complete_enfant[1])
year(data$ddn_complete_enfant[1])

#consistency of dates with variables
#the person does not provide the date they claim to know (date of birth)
pb_ligne<-rownames(data %>% 
                     select(ddn_complete_connue_enfant,ddn_complete_enfant) %>% 
                     filter(ddn_complete_connue_enfant=='Yes' & is.na(ddn_complete_enfant)==T)) 

if (length(pb_ligne)!=0){print(glue("Il y a une incohérence au niveau de la date de naissance à la ligne {pb_ligne}"))}else{print("Il n'y a pas d'incohérence entre la variable connaitre la date de naissance et le renseignement de la date")}

# same reasoning (date of start of pregnancy)

pb_ligne_2<-(data %>% 
               select(date_debut_connue_gross_act,date_debut_gross_act) %>% 
               filter(date_debut_connue_gross_act=='Oui' & is.na(date_debut_gross_act)==T))
if (nrow(pb_ligne_2)!=0){print(glue("Il y a une incohérence au niveau de la date de début de grossesse à la ligne {pb_ligne_2}"))}else{print("Il n'y a pas d'incohérence entre la variable connaitre la date de dbt de grossesse et le renseignement de la date")}

###### Keeps the maximum number of jobs practiced in the sample

data<-data[ , colSums(is.na(data)) < nrow(data)]  
as.data.frame(data)
nb_met<-length(names(data)[str_starts(names(data),"metier_mat_d")])


### see if dbt and end start the same see dates

as.data.frame(data)

col_met<-c()
for (i in 1:nb_met){
  col_met<-c(col_met,names(data)[str_ends(names(data),str_glue("v{i}"))])  
}
col_met

# search for inconsistent employment periods == with start date > end date of work

controle_met<-as.data.frame(matrix(0,length(data$record_id),nb_met*3))#3 col par met
names(controle_met)[1:(nb_met*2)]<-col_met
controle_met[,col_met]<-data[,col_met]
incoherence<-c()
for (i in 1:nb_met){
  names(controle_met)[nb_met*2+i]<-str_glue("pb_{i}")
  controle_met[,str_glue("pb_{i}")]<-c(data[,str_glue("metier_mat_debutv{i}")]>data[,str_glue("metier_mat_finv{i}")])
  
  incoherence<-c(incoherence,which(controle_met[,str_glue("pb_{i}")]==T))
  if (length(incoherence)!=0){
    print(glue("Incohérence la date de début est supérieur à la date de fin :\n pour l'individu {unique(incoherence)} pour le metier {i}"))}else{print(glue("Il n'y a pas d'incohérence entre la date de début et de fin d'emploi pour le metier {i}"))}}


# Same reflection for the work stoppage variable
#inconsistency check at the level of the start date of work stoppage and end date of work stoppage
controle_arr<-data %>% 
  filter(data$trav_mat_arret_debut>data$trav_mat_arret_fin)
if (nrow(controle_arr)!=0){print("Incohérence entre la date de début d'arrêt et de fin")}  


###################### PROCESSING DATES ############################

####################### job dates ############################

#reversal test puts jobs and their respective start and end dates online
ncol(data)
nrow(data)
met_data<-pivot_longer(data,cols=starts_with("metier_mat_"),names_to ="met_per",values_to="met_dates",values_drop_na =TRUE)

met_data<-as.data.frame(pivot_wider(met_data,names_from=met_per,values_from=met_dates))
as.data.frame(met_data)


nrow(met_data)
names(met_data)


####################### job intervals #####################################

#Formation of a column with the intervals of the professions
nb_met<-sum(str_starts(names(met_data),"metier_mat_debut"))
nb_met
met_inter<-paste0("met_inter",1:nb_met)


for (i in 1:nb_met){
  met_data[,str_glue("inter_met{i}")]<-interval(met_data[,str_glue("metier_mat_debutv{i}")],met_data[,str_glue("metier_mat_finv{i}")])
}
as.data.frame(met_data)


###################### work stoppage intervals ############################

#Formation of a column with the work stoppage intervals
met_data<-met_data %>% 
  mutate(inter_arr=interval(trav_mat_arret_debut,trav_mat_arret_fin))

met_data

###################### pregnancy stage intervals ###############################

# see according to the stages of pregnancy (preconception (pregnancy date - 3 months), embryonic, fetal) the professions practiced ==> for description

# construction of the intervals of the pregnancy periods (3 months before the start of the pregnancy, 90 days after, the rest until the child's due date)
met_data<-met_data %>% 
  mutate(p_preconc=interval(date_debut_gross_act-month(3),date_debut_gross_act),
         p_organog=interval(date_debut_gross_act+days(1),(date_debut_gross_act+days(89))),
         p_dev=interval(date_debut_gross_act+days(91),ddn_complete_enfant))
met_data
#i added 1 day for the following periods to avoid the intervals of the periods overlapping

#put the job intervals online
test_0<-pivot_longer(met_data,cols=c(which(str_starts(names(met_data),"inter_met"))),names_to="metier",values_to="interval_met")
as.data.frame(test_0)


#puts pcs codes online
test_1<-pivot_longer(met_data,cols=c(which(str_starts(names(met_data),"pcs03_mat"))),names_to="pcs",values_to="pcs_code")
as.data.frame(test_1)

test_1<-test_1 %>%
  select(pcs_code)
as.data.frame(test_1)

#puts naf codes online
test_2<-pivot_longer(met_data,cols=c(which(str_starts(names(met_data),"naf03_mat"))),names_to="naf",values_to="naf_code", values_drop_na = FALSE)
as.data.frame(test_2)

#pb offset naf codes and lines before but now ok

test_2<-test_2 %>%
  select(naf_code)

test_0<-test_0 %>%
  select(record_id,metier,interval_met,p_dev,p_organog,p_preconc,p_dev,inter_arr)
test_0

test<-cbind(test_0,test_1,test_2)
as.data.frame(test)

#check lines reversal
#expected nb_met*nrow(data)== nrow(test)
nb_met*nrow(data)== nrow(test)
# the number of lines is consistent


#construction of working columns for each phase of pregnancy 
test<-test %>%
  mutate(exp_dev=if_else(int_overlaps(interval_met,p_dev),"1","0"),
         exp_org=if_else(int_overlaps(interval_met,p_organog),"1","0"),
         exp_pre=if_else(int_overlaps(interval_met,p_preconc),"1","0"))
test

#construction of working columns for each phase of pregnancy based on work stoppage
expo<-names(test)[which(str_starts(names(test),"exp"))]
expo

phase_gros<-names(test)[which(str_starts(names(test),"p_"))]
phase<-length(phase_gros)
phase

for (p in 1:phase){
  exp_p<-expo[p]
  phase_p<-phase_gros[p]
  
  test[exp_p]<-ifelse(is.na(test$inter_arr)!=T & int_start(test$inter_arr)<=int_start(test[,phase_p]) & int_end(test$inter_arr)>=int_end(test[,phase_p]),"0",test[,exp_p])
  print(exp_p)
  
}
test


################################################################
##     JOINT PESTIPOP MATRIX AND QUESTIONNAIRE DATA     ##
################################################################

################################################################
####################### FORMATTING ##############################
################################################################


#Formatting of NAF codes to allow data to be joined to the PESTIPOP matrix
# separation with a point at the second digit absent in the PESTIPOP matrix

mpp$NAF2003 <- gsub("\\.", "", mpp$NAF2003)
des_naf_3$Code<- gsub("\\.", "", des_naf_3$Code)
des_naf_4$Code<- gsub("\\.", "", des_naf_4$Code)


test$pcs_code<-str_to_lower(test$pcs_code)
#to match the format of pestipop pcs (MAJ --> min)
#keep the essentials (pcs,naf,expo) of pestipop


pes_pop<-mpp %>% 
  select(PCS2003,NAF2003,catP)
pes_pop<-as.data.frame(pes_pop)
pes_pop

############ Perfect case join in decision algorithm #########
nrow(pes_pop)
#388

test$naf_code
pes_pop$NAF2003

test$pcs_code
pes_pop$PCS2003
# I build an index for my future situations and the join
test$index<-seq(1,nrow(test))
#intermediate step to join only for couples

cas_perf<-test %>% 
  filter(is.na(pcs_code)==F & is.na(naf_code)==F) 
cas_perf<-as.data.frame(cas_perf)

by<-join_by(pcs_code == PCS2003, naf_code == NAF2003)
test_3<-left_join(cas_perf,pes_pop,by=by,suffix=c(".x",".y"))

colnames(test_3)

test_3 %>% 
  filter(is.na(catP)==F)

nrow(cas_perf)==nrow(test_3)
##################################################################################################################
## Determination of the exposure probability according to the conditions of the decision algorithm ##
#############################################################################################################################

# situation 1: the perfect case: complete couples similar to the exposure == expo pestipop
#treated during the join

#i join the probability of the couple thanks to my index
test_3<-test_3 %>%
  select(catP,index) %>% 
  filter(is.na(catP)==F)

by<-join_by(index == index)
test_4<-left_join(test,test_3,by=by,suffix=c(".x",".y"))
test_4<-as.data.frame(test_4)
test_4

###################join check ############
test_4 %>% 
  filter(is.na(catP)==F) %>% 
  count()
#63

nrow(test_3)
#63
# same number of proba assigned
###################################################

#situation: pcs code alone but not exp ==> expo == 0 (4 digits)
colnames(test_4)

#test_4$catP<-ifelse(is.na(test_4$pcs_code)==F & is.na(test_4$naf_code)==T & (test_4$pcs_code %in% cat_ne),"0",test_4$catP)
#does not match the tree also when na
#correction post report

test_4$catP<-ifelse(is.na(test_4$pcs_code)==F & (test_4$pcs_code %in% cat_ne) & is.na(test_4$catP)==T,"0",test_4$catP)



#### joint check
test_4 %>% 
  filter(is.na(catP)==F) %>% 
  count()

test_4 %>% 
  filter(catP=="0") %>% 
  count()
#1973 or 1910 more
#11 153 ==> branche 2 

#situation: pcs code only but not exp ==> expo == 0 (minus 4 digits)
#conditions corrected post report
precis
for (p in 1:precis){
  test_4$catP<-ifelse(substr(test_4$pcs_code,1,p) %in% get(str_glue("gr_NE{p}")) & is.na(test_4$pcs_code)==F & is.na(test_4$catP)==T,"0",test_4$catP)
}
test_4

#### joint check
test_4 %>% 
  filter(is.na(catP)==F) %>% 
  count()


#situation: the person is on sick leave ==> expo == 0 #colnames(test_4) #test_4$catP<-ifelse(test_4$exp_dev=="0" & ​​​​test_4$exp_org=="0" & ​​​​test_4$ exp_pre=="0","0",test_4$catP) # correction to be deleted because it overwrites the expo category ######################## 
################verification
test_4 %>% 
  filter(is.na(catP)==F) %>% 
  count()

test_4[which(test_4$exp_dev=="0" & test_4$exp_org=="0" & test_4$exp_pre=="0"),]

#no expo added because no one in the sample works on all phases
##############################################################

#############################################################################
##               Description of application results                     ##
#############################################################################
##########################     Job     ###################################

#number of jobs 1 without exposure porba (NA)
test_4 %>%
  filter(is.na(catP)==T & metier=="inter_met1") %>% 
  count()
#10573
#6020 after correction
#6383 after after correction 
test_4 %>%
  filter(metier=="inter_met1") %>% 
  count()
#18329

#########################         PCS        ################################
##################### Missing data for exposure ##################
##################### Categories  ######################################
#number of professions not specified
prof<-test_4 %>% 
  select(catP,pcs_code,metier) %>% 
  filter(metier=="inter_met1" & nchar(pcs_code)<4) %>%
  count()
prof #1406


##number of professions 
nb_prof<-test_4 %>% 
  select(catP,pcs_code,metier) %>% 
  filter(metier=="inter_met1")%>%
  count()
nb_prof#18329  # consistent with the dataset !

#Enter the desired precision of the pcs code to be described
pcs_prec<-readline(prompt="Entrer la précision du code PCS (1,2,4) dont vous souhaitez la description : ")

while (!(pcs_prec %in% c("1","2","4"))){pcs_prec<-readline(prompt="Rentrée une précision de 1,2 ou 4 : ")}

#construction of a df with the catP pcs codes and descriptions
des_pcs<-test_4 %>% 
  select(pcs_code,catP,metier) 

#######selection of information for the first job ####################################################################
des_pcs<-des_pcs %>% 
  filter(metier=="inter_met1") %>% 
  select(pcs_code,catP) 
############################# above part to be deleted to have access to the description of other jobs

des_pcs$pcs_code<-as.character(substr(des_pcs$pcs_code,1,pcs_prec))
colnames(des_pcs)

des_pcs<-des_pcs %>% 
  filter(as.character(nchar(pcs_code))==pcs_prec)



#formatting
des_pcs_2$Code<-as.character(des_pcs_2$Code)


by<-join_by(pcs_code == Code)
des<-left_join(des_pcs,get(str_glue("des_pcs_{pcs_prec}")),by=by)
nrow(des)==nrow(des_pcs)

table(des$catP)

des$catP<-fct_na_value_to_level(des$catP, level = "(Missing)")


des %>% 
  select(Libellé,catP) %>%
  tbl_summary(by=catP,percent="row") %>% 
  modify_header(label = "**Catégorie de probabilité d'exposition**") %>% 
  add_overall()
  #0 farmers not 8 it was a mistake fixed


des %>% 
  filter(is.na(Libellé)==T & nchar(pcs_code)==1) %>% 
  count()

#########################         NAF        ################################
##################### Missing data for exposure ##################
##################### Categories  ######################################
mpp$NAF2003 <- gsub("\\.", "", mpp$NAF2003)
des_naf_3$Code<- gsub("\\.", "", des_naf_3$Code)
des_naf_4$Code<- gsub("\\.", "", des_naf_4$Code)
des_naf_1
des_naf_2

#number of sectors of activity not reported
sec_act<-test_4 %>% 
  select(catP,naf_code,metier) %>% 
  filter(metier=="inter_met1" & nchar(naf_code)<4) %>%
  count()
sec_act #2168


#number of naf sectors 
nb_sec_act<-test_4 %>% 
  select(catP,naf_code,metier) %>% 
  filter(metier=="inter_met1")%>%
  count()
#18404  

#Enter the desired precision of the pcs code to be described
naf_prec<-readline(prompt="Entrer la précision du code NAF (1,2,3,4) dont vous souhaitez la description : ")
while (!(naf_prec %in% c("1","2","3","4"))){naf_prec<-readline(prompt="Rentrée une précision de 1,2,3,4 : ")}

#construction of a df for with the naf catP codes and descriptions
if (naf_prec!="1"){
  des_naf<-test_4 %>% 
    select(naf_code,catP,metier) %>% 
    filter(is.na(naf_code)!=T & as.character(nchar(naf_code))==naf_prec)
}else{des_naf<-test_4 %>% 
  select(naf_code,catP,metier) %>% 
  filter(is.na(naf_code)!=T)}

#######selection of information for the first job

des_naf<-des_naf %>% 
  filter(metier=="inter_met1") %>% 
  select(naf_code,catP)

############################# above part to be deleted to have access to the description of other jobs

if (naf_prec=="1"){
  des_naf<-des_naf %>% 
    mutate(naf_lettre=case_when(
      substr(naf_code,1,2) %in% c("01","02")~"A",
      substr(naf_code,1,2) %in% c("05")~"B",
      substr(naf_code,1,2) %in% c(as.character(seq(from=10, to=14)))~"C",
      substr(naf_code,1,2) %in% c(as.character(seq(from=15, to=37)))~"D",
      substr(naf_code,1,2) %in% c("40","41")~"E",
      substr(naf_code,1,2) %in% c("45")~"F",
      substr(naf_code,1,2) %in% c("50","51","52")~"G",
      substr(naf_code,1,2) %in% c("55")~"H",
      substr(naf_code,1,2) %in% c(as.character(seq(from=60, to=64)))~"I",
      substr(naf_code,1,2) %in% c(as.character(seq(from=65, to=67)))~"J",
      substr(naf_code,1,2) %in% c(as.character(seq(from=70, to=74)))~"K",
      substr(naf_code,1,2) %in% c("75")~"L",
      substr(naf_code,1,2) %in% c("80")~"M",
      substr(naf_code,1,2) %in% c("85")~"N",
      substr(naf_code,1,2) %in% c(as.character(seq(from=90, to=93)))~"O",
      substr(naf_code,1,2) %in% c(as.character(seq(from=95, to=97)))~"P",
      substr(naf_code,1,2) %in% c("99")~"Q")) }

##according to the tree https://host.credim.u-bordeaux.fr/CAPS-FR/Parcourir.aspx


des_naf$naf_code<-substr(des_naf$naf_code,1,naf_prec)
colnames(des_naf)

colnames(des_naf_1)

if (naf_prec=="1"){
  by<-join_by(naf_lettre == Code)
  des_2<-left_join(des_naf,get(str_glue("des_naf_{naf_prec}")),by=by)
}else{
  by<-join_by(naf_code == Code)
  des_2<-left_join(des_naf,get(str_glue("des_naf_{naf_prec}")),by=by)
}


des_2$catP<-fct_na_value_to_level(des_2$catP, level = "(Missing)")

des_2 %>% 
  select(Libellé,catP) %>%
  tbl_summary(by=catP,percent="row") %>% 
  modify_header(label = "**Catégorie de probabilité d'exposition**") %>% 
  add_overall()


table(des_2$naf_code[which(is.na(des_2$naf_lettre))])
des_2$naf_code[which(is.na(des_2$Libellé))]
#naf codes without letter? 



######################## description of pregnancy phase ############


#######selection of information for the first job

des_gros<-test_4 %>% 
  filter(metier=="inter_met1") 

############################# above part to be deleted to have access to the description of other jobs
#construction of a df with the catP pcs codes and descriptions
des_gros<-des_gros %>% 
  filter(is.na(pcs_code)!=T) %>% 
  select(catP,names(test_4)[which(str_starts(names(test_4),"exp_"))]) 


des_gros$catP<-fct_na_value_to_level(des_gros$catP, level = "(Missing)")

des_gros %>% 
  mutate(exp_org=recode(exp_org,"0"="Période sans activité professionnelle",
                        "1"="Période d'activité professionnelle"),
         exp_dev=recode(exp_dev,"0"="Période sans activité professionnelle",
                        "1"="Période d'activité professionnelle"),
         exp_pre=recode(exp_pre,"0"="Période sans activité professionnelle",
                        "1"="Période d'activité professionnelle")) %>%   
  
  tbl_summary(by=catP,label = c(exp_org~"Phase embryonnaire",
                                exp_pre~"Phase préconceptionnelle",
                                exp_dev~"Phase foetale"))%>% 
  modify_header(label = "**Catégorie de probabilité d'exposition**") %>% 
  add_overall()


ind<-des_gros %>% 
   filter(is.na(exp_pre)==T) %>% 
  select(index)
ind<-as.vector(ind)

for (i in 1:length(ind$index)){print(test_4[ind$index[i],c("p_preconc","exp_pre","catP","interval_met","inter_arr")])}


test_4 %>% select(-metier,-p_organog,-exp_org,-p_dev,-exp_dev) %>% filter(index %in% c(482,481,281,282,81,82))

###############################################################################
##              pcs table codes complete / incomplete                       ##
###############################################################################

test_4<-test_4 %>% 
  mutate(code_complet=case_when(nchar(pcs_code)==4 & is.na(pcs_code)==F~"1",
                                TRUE~'0'))

pcs_prec_2<-"1"

#construction of a df with the catP pcs codes and descriptions
des_2_pcs<-test_4 %>% 
  select(pcs_code,code_complet,metier) 


#######selection of information for the first job

des_2_pcs<-des_2_pcs %>% 
  filter(metier=="inter_met1") %>% 
  select(pcs_code,code_complet)

############################# above part to be deleted to have access to the description of other jobs

des_2_pcs$pcs_code<-as.character(substr(des_2_pcs$pcs_code,1,pcs_prec_2))
colnames(des_2_pcs)


#formatting
des_pcs_2$Code<-as.character(des_pcs_2$Code)


by<-join_by(pcs_code == Code)
descr_2<-left_join(des_2_pcs,get(str_glue("des_pcs_{pcs_prec_2}")),by=by)
nrow(descr_2)==nrow(des_2_pcs)


descr_2 %>% 
  select(Libellé,code_complet) %>%
  tbl_summary(by=code_complet,percent="row") %>% 
  modify_header(label = "**Codes complets**") %>% add_overall()

des %>% 
  filter(is.na(Libellé)==T & nchar(pcs_code)==1) %>% 
  count()
###############################################################################
##              naf codes table complete / incomplete                      ##
###############################################################################

test_4<-test_4 %>% 
  mutate(code_complet_naf=case_when(nchar(naf_code)==4 & is.na(naf_code)==F~"1",
                                TRUE~'0'),
         naf_lettre=case_when(
           substr(naf_code,1,2) %in% c("01","02")~"A",
           substr(naf_code,1,2) %in% c("05")~"B",
           substr(naf_code,1,2) %in% c(as.character(seq(from=10, to=14)))~"C",
           substr(naf_code,1,2) %in% c(as.character(seq(from=15, to=37)))~"D",
           substr(naf_code,1,2) %in% c("40","41")~"E",
           substr(naf_code,1,2) %in% c("45")~"F",
           substr(naf_code,1,2) %in% c("50","51","52")~"G",
           substr(naf_code,1,2) %in% c("55")~"H",
           substr(naf_code,1,2) %in% c(as.character(seq(from=60, to=64)))~"I",
           substr(naf_code,1,2) %in% c(as.character(seq(from=65, to=67)))~"J",
           substr(naf_code,1,2) %in% c(as.character(seq(from=70, to=74)))~"K",
           substr(naf_code,1,2) %in% c("75")~"L",
           substr(naf_code,1,2) %in% c("80")~"M",
           substr(naf_code,1,2) %in% c("85")~"N",
           substr(naf_code,1,2) %in% c(as.character(seq(from=90, to=93)))~"O",
           substr(naf_code,1,2) %in% c(as.character(seq(from=95, to=97)))~"P",
           substr(naf_code,1,2) %in% c("99")~"Q"))

naf_prec_2<-"1"
#construction of a df  with the naf catP codes and descriptions
des_2_naf<-test_4 %>% 
  select(naf_code,code_complet_naf,metier,naf_lettre) 


#######selection of information for the first job

des_2_naf<-des_2_naf %>% 
  filter(metier=="inter_met1") %>% 
  select(naf_code,code_complet_naf,naf_lettre)

############################# above part to be deleted to have access to the description of other jobs

des_2_naf$naf_code<-as.character(substr(des_2_naf$naf_code,1,naf_prec_2))
colnames(des_2_naf)



by<-join_by(naf_lettre == Code)
descr_naf_2<-left_join(des_2_naf,get(str_glue("des_naf_{naf_prec_2}")),by=by)
nrow(descr_naf_2)==nrow(des_2_naf)


descr_naf_2 %>% 
  select(Libellé,code_complet_naf) %>%
  tbl_summary(by=code_complet_naf,percent="row") %>% 
  modify_header(label = "**Codes complets**") %>% add_overall()

##################################################################################
##           table pcs number codes with probability vs without                      ##
##################################################################################


test_4<-test_4 %>% 
  mutate(code_deter=if_else(is.na(catP)==F,"1","0"))


#Enter the desired precision of the pcs code to be described
pcs_prec_3<-"1"

#construction of a df for with the catP pcs codes and descriptions
des_3_pcs<-test_4 %>% 
  select(pcs_code,code_deter,metier) 


#######selection of information for the first job

des_3_pcs<-des_3_pcs %>% 
  filter(metier=="inter_met1") %>% 
  select(pcs_code,code_deter)

############################# above part to be deleted to have access to the description of other jobs


des_3_pcs$pcs_code<-as.character(substr(des_3_pcs$pcs_code,1,pcs_prec_3))
colnames(des_3_pcs)

#formatting
des_pcs_3$Code<-as.character(des_pcs_3$Code)

by<-join_by(pcs_code == Code)
descr_3<-left_join(des_3_pcs,get(str_glue("des_pcs_{pcs_prec_3}")),by=by)
nrow(descr_3)==nrow(des_3_pcs)

descr_3 %>% 
  select(Libellé,code_deter) %>%
  tbl_summary(by=code_deter,percent="row") %>% 
  modify_header(label = "**Codes déterminés **") %>% add_overall()

##################################################################################
##            naf table number codes with probability vs without                       ##
##################################################################################


test_4<-test_4 %>% 
  mutate(code_naf_deter=if_else(is.na(catP)==F,"1","0"))


#Enter the desired precision of the pcs code to be described
naf_prec_3<-"1"

#Enter the desired precision of the pcs code to be described
des_3_naf<-test_4 %>% 
  select(naf_lettre,code_naf_deter,metier) 


#######selection of information for the first job

des_3_naf<-des_3_naf %>% 
  filter(metier=="inter_met1") %>% 
  select(naf_lettre,code_naf_deter)

############################# above part to be deleted to have access to the description of other jobs

des_3_naf$naf_code<-as.character(substr(des_3_naf$naf_lettre,1,naf_prec_3))
colnames(des_3_naf)

by<-join_by(naf_lettre == Code)
descr_3<-left_join(des_3_naf,get(str_glue("des_naf_{naf_prec_3}")),by=by)
nrow(descr_3)==nrow(des_3_naf)

descr_3 %>% 
  select(Libellé,code_naf_deter) %>%
  tbl_summary(by=code_naf_deter,percent="row") %>% 
  modify_header(label = "**Codes déterminés **") %>% add_overall()

#######################################################################
##          Crossing precision code and pcs probability                 ##
#######################################################################

crois<-test_4 %>% filter(metier=="inter_met1")
table(crois$code_complet)
table(crois$code_complet,crois$code_deter)

#######################################################################
##           Crossing precision code and probability naf                  ##
#######################################################################

colnames(test_4)
crois_naf<-test_4 %>% filter(metier=="inter_met1")
table(crois_naf$code_complet_naf,crois$code_naf_deter) # # to variables to be titled for readability

