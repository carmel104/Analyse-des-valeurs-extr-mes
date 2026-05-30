# install.packages("hubeau")
library(httr)
library(jsonlite)
library(tidyverse)
library(zoo)

url <- paste0(
  "https://hubeau.eaufrance.fr/api/v2/hydrometrie/obs_elab?",
  "code_entite=L800001020",
  "&grandeur_hydro_elab=QmnJ",
  "&date_debut_obs_elab=1980-01-01",
  "&date_fin_obs_elab=2026-03-31",
  "&size=20000&format=json"
)

r <- GET(url, add_headers("User-Agent"="Mozilla/5.0"))

status_code(r)

txt <- content(r, as="text", encoding="UTF-8")
obs <- fromJSON(txt)
data=obs$data
head(data)
#View(data)
sum(is.na(data)) # Vérifications de valeurs manquantes


# Analyses descriptives de la base
summary(data$resultat_obs_elab)
library(ggplot2)
data$date_obs_elab <- as.Date(data$date_obs_elab)
data <- data %>% arrange(date_obs_elab)

# Visualisation de la série temporelle des débits
ggplot(data, aes(x = date_obs_elab, y = resultat_obs_elab)) +
  geom_line(color = "steelblue") +
  labs(title = "Débits journaliers de la Loire à Saumur (1980-2026)",
       x = "Date", y = "Débit (m3/s)") +
  theme_minimal()

ggplot(data, aes(y = resultat_obs_elab)) +
  geom_boxplot() +
  labs(
    y = "Valeurs",
    x = "") +
  theme_minimal()
library(moments)
kurtosis(data$resultat_obs_elab) # calcul du Kurtosis

library(extRemes)
# Estimation des paramètres par GEV
fit_gev <- fevd(data$resultat_obs_elab, type = "GEV")
fit_gev
plot.fevd(fit_gev)
par(mfrow = c(2,2))
return.level(fit_gev,return.period = c(5,10,20,50, 100,200),do.ci = T) # qauntiles de retour GEV
# Estimation des paramètres par GPD
fit_gpd <- fevd(data$resultat_obs_elab,threshold = 1300000,type = "GP")
fit_gpd
plot.fevd(fit_gpd)
return.level(fit_gpd,return.period = c(5,10,20, 50, 100,200),do.ci = T) # quantile de retour GPD

par(mfrow=c(1,1))
library(extRemes)

mrlplot(data$resultat_obs_elab)

threshrange.plot(data$resultat_obs_elab, r = c(79500, 4750000), nint = 100, na.action = na.fail,verbose = T,set.panels = F) 



# Estimation non paramétrique
debit_sort=sort(data$resultat_obs_elab,decreasing = T)
n_data=length(data$resultat_obs_elab)
library(evmix)
h=hillplot(data$resultat_obs_elab)
str(h)


