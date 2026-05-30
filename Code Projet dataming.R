library(readxl)
good_data <- read_excel("C:/Users/utilisateur/Downloads/Projet/good_data.xlsx")
summary(good_data)
library(car)
df_clean=good_data[,-1] 
summary(df_clean)
library("corrplot")
cor(df_clean[,-36])
corrplot(cor(df_clean[,-c(3,4,5,6,24,34,35,36)])) # supression des variable qualitatives
dim(df_clean[,-c(3,4,5,6,24,34,35,36)])
data=df_clean[,-c(3,4,5,6,24,34,35)] # base finale à utiliser pour l'analyse

##################

library(FactoMineR)
library(Factoshiny)
Factoshiny(data)
names(data)
attach(data)
summary(data)
library(lmtest)
# data <- subset(good_data, select = -c(OverallQual,OverallCond, GarageYrBlt,MoSold,YrSold,YearBuilt,YearRemodAdd))
reg=lm(SalePrice~.-TotalBsmtSF-GrLivArea,data=data)
reg1=lm(log(SalePrice)~.-TotalBsmtSF-GrLivArea,data=data)
summary(reg1)
plot(reg1)
bptest(reg1) # test d'hétéroscédasticité 
shapiro.test(residuals(reg)) # test de normalité pour le modèle sans log
shapiro.test(residuals(reg1))# test de normalité pour le modèle avec log
summary(reg) # régression linéaire
coef(reg)
par(mfrow=c(2,2))
plot(reg)
library(car)
vif(reg)
########################
par(mfrow=c(1,1))
boxplot(SalePrice)
library(pls)
data[-910,]
d=data[-910, ]
d
#PCR#
reg.pcr <- pcr(SalePrice ~ ., ncomp = 28,scale =T, data = data, validation = "CV", segments = 10) # Pcr avec toutes les variables
summary(reg.pcr)
msepcv.pcr <- MSEP(reg.pcr, estimate=c("CV"))
palette("default") ## retour aux couleurs habituelles
plot(msepcv.pcr, lty=1, type="l", legendpos="topright", main="")
#graphqiue PRESS en fonction du nb de composantes
# plot(RMSEP(reg.pcr), legendpos = "topright")
ncomp.pcr <- which.min(msepcv.pcr$val["CV",,])-1
ncomp.pcr
reg.pcr_bon <- mvr(SalePrice ~., ncomp = ncomp.pcr, scale = TRUE,data=data) # avec le nombre de composante optimale
summary(reg.pcr_bon)
coef_pcr <- coef(reg.pcr_bon) # coefficients estimés
coef_pcr

#PLS#
reg.pls <- plsr(SalePrice ~ ., ncomp = 28, scale = TRUE,data=data,validation = "CV")
summary(reg.pls)
msepcv.pls <- MSEP(reg.pls, estimate=c("CV"))
palette("default") ## retour aux couleurs habituelles
plot(msepcv.pls, lty=1, type="l", legendpos="topright", main="")
#graphique PRESS en fonction du nb de composantes
#plot(RMSEP(reg.pls), legendpos = "topright")
ncomp.pls <- which.min(msepcv.pls$val["CV",,])-1
ncomp.pls
reg.pls_bon <- plsr(SalePrice ~., ncomp = 3, scale = TRUE,data=data) # avec le nombre de composante optimale
summary(reg.pls_bon)
coef_pLS <- coef(reg.pls_bon) # coefficients estimés
coef_pLS
loadings(reg.pls_bon)# Les Loadings des covariables
loading.weights(reg.pls_bon) # les poids des covariables
Yloadings(reg.pls_bon) # poids de la dépendante


# loadings for X
loadings(reg.pcr_bon) # Pour PCR
loadings(reg.pls_bon) 
#weights for X
loading.weights(reg.pcr_bon) # pour PCR
loading.weights(reg.pls_bon)
#weights for Y

Yloadings(reg.pls_bon)


cornell.pls <- plsr(Y ~ X, ncomp = 28, validation="LOO")
summary(cornell.pls)

#graphqiue PRESS en fonction du nb de composantes
plot(RMSEP(cornell.pls), legendpos = "topright")

#graphique des pr�dictions
plot(cornell.pls, ncomp=2, asp=1, line=TRUE)


# variance expliqu�e
explvar(cornell.pls)

plot(cornell.pls, "loadings", comps = 1:2, legendpos = "topleft",
     labels = "names", xlab = "nm")
abline(h = 0)

plot(cornell.pls, plottype = "coeff", ncomp = 1:3,  "loadings", comps = 1:2, legendpos = "topleft",
     labels = "names", xlab = "nm")

plot(cornell.pls, plottype = "coeff", ncomp = 1:3, legendpos = "bottomleft",labels = "names", xlab = "nm")

plot(cornell.pls, plottype = "correlation", ncomp=1:3, legendpos = "bottomleft",labels = "names", xlab = "nm")

plot(cornell.pls, loadingplot = "coef", ncomp=1:3, legendpos = "bottomleft",labels = "names", xlab = "nm")

scoreplot(cornell.pls, ncomp=1:3, legendpos = "bottomleft",labels = "names", xlab = "nm")
plot(scores(cornell.pls))

loadingplot (cornell.pls, ncomp=1:3, legendpos = "bottomleft",labels = "names", xlab = "nm")

loadings(cornell.pls, legendpos = "bottomleft",labels = "names", xlab = "nm")
scores (cornell.pls, legendpos = "bottomleft",labels = "names", xlab = "nm")


######################################################################################
























#########"
library(reshape2)

# 1️⃣ Convertir la matrice en format long
cor_long <- melt(correlation)

# 2️⃣ Supprimer la diagonale (corrélation d'une variable avec elle-même)
cor_long <- subset(cor_long, Var1 != Var2)

# 3️⃣ Filtrer les corrélations supérieures à 0.8 (ou < -0.8)
high_cor <- subset(cor_long, abs(value) > 0.6)

# 4️⃣ Afficher les paires fortement corrélées
high_cor

good_data

# modèle PCR
# hist(data[,"as.numeric(SalePrice)"],prob=T)
library(pls)
model.pcr_cv=pcr(SalePrice~.,data=data,scale=T,ncomp=28, validation="CV") # par K-fold cross validation
model.pcr_loo=pcr(SalePrice~.,data=data,scale=T,ncomp=28, validation="LOO")
summary(model.pcr_loo)
######################détermination du nombre de composantes optimale#############
### Pour la CV 
summary(model.pcr_cv)
msepcv.pcr<- MSEP(model.pcr_cv, estimate=c("train","CV"))
palette("default") 
plot(msepcv.pcr, lty=1, type="l", legendpos="topright", main="")
ncomp.pcr=which.min(msepcv.pcr$val["CV",,])-1
ncomp.pcr
#Pour la LOO
msepcv.pcr_loo<- MSEP(model.pcr_loo, estimate=c("train","LOO"))
palette("default") 
plot(msepcv.pcr_loo, lty=1, type="l", legendpos="topright", main="")
ncomp.pcr_loo=which.min(msepcv.pcr_loo$val["",,])-1
ncomp.pcr_loo





# Modèle PCR réestimé avec le nombre de composantes optimales
summary(model.pcr_bon)
model.pcr_bon=pcr(SalePrice~.,data=data,ncomp=ncomp.pcr,scale=T)
summary(model.pcr_bon)
coef(model.pcr_bon) # coefficents estimés du bon modèle
loadings(model.pcr_bon, ncomp=1:3, legendpos = "bottomleft",labels = "numbers", xlab = "nm") # les loadings 
scores (model.pcr_bon, ncomp=1:3, legendpos = "bottomleft",labels = "numbers", xlab = "nm")# les scores





#### Modèle pls

model.pls=plsr(SalePrice~.,data=data,scale=T,ncomp=28, validation="CV")
summary(model.pls)
msepcv.pls<- MSEP(model.pls, estimate=c("train","CV"))
palette("default") 
plot(msepcv.pls, lty=1, type="l", legendpos="topright", main="")
ncomp.pls=which.min(msepcv.pls$val["CV",,])-1
ncomp.pls
model.pls_bon=plsr(SalePrice~.,data=data,scale=T, ncomp=ncomp.pls)
summary(model.pls_bon)
coef(model.pls_bon) # coeffients estimés avec le nombre optimal de composantes
loadings(model.pls_bon, ncomp=1:2, legendpos = "bottomleft",labels = "numbers", xlab = "nm") # les loadings 
scores (model.pls_bon, ncomp=1:2, legendpos = "bottomleft",labels = "numbers", xlab = "nm")# les scores




plot(model.pcr_bon, plottype = "coef", ncomp=1:3, legendpos = "bottomleft",labels = "numbers", xlab = "nm")

plot(model.pcr_bon, plottype = "correlation", ncomp=1:2, legendpos = "bottomleft",labels = "numbers", xlab = "nm")

plot(model.pcr_bon, loadingplot = "coef", ncomp=1:3, legendpos = "bottomleft",labels = "numbers", xlab = "nm")

scoreplot(model.pcr_bon, ncomp=1:3, legendpos = "bottomleft",labels = "numbers", xlab = "nm")
plot(scores(model.pcr_bon))

loadingplot (model.pcr_bon, ncomp=1:3, legendpos = "bottomleft",labels = "numbers", xlab = "nm")

loadings(model.pcr_bon, ncomp=1:3, legendpos = "bottomleft",labels = "numbers", xlab = "nm")
scores (model.pcr_bon, ncomp=1:3, legendpos = "bottomleft",labels = "numbers", xlab = "nm")


plot(model.pcr_bon, ncomp = 5, asp = 1, line = TRUE)

plot(model.pcr_bon, plottype = "scores", comps = 1:5)
