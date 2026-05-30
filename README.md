# Analyse de Valeurs Extrêmes (TVE) : Fondements Théoriques et Application Hydrologique

[![R-Project](https://img.shields.io/badge/Language-R-%23276DC3.svg?style=flat&logo=r)](https://www.r-project.org/)
[![Academic-Project](https://img.shields.io/badge/Project-Academic%20%2F%20M1%20Data%20Science-orange.svg)](#)

## 📌 Présentation du Projet
Ce dépôt contient les travaux réalisés dans le cadre du **Travail Encadré de Recherche (TER)** du Master 1 Data Science à l'Université d'Angers (Année Académique 2025-2026). 

L'objectif principal de ce projet est d'explorer et de mettre en œuvre le cadre statistique de la **Théorie des Valeurs Extrêmes (TVE)** pour modéliser la probabilité d'occurrence d'événements rares et de forte intensité. Contrairement aux approches statistiques traditionnelles qui se focalisent sur la moyenne conditionnelle et rejettent les extrêmes comme des "données aberrantes", la TVE permet de décrire l'inhabituel et d'extrapoler au-delà des observations disponibles.

### 👥 Membres de l'équipe
* **Étudiants :** Carmel AWANDE & Yves GNONHOUE
* **Tuteur Enseignant :** Pr Gilles STUPFLER

---

## 📑 Cadre Théorique & Méthodologie

Le projet développe et confronte les deux grandes approches méthodologiques de la TVE :

### 1. Méthode des Maxima de Blocs (Approche GEV)
* **Fondement :** Régie par le théorème fondamental de **Fisher-Tippett-Gnedenko**.
* **Principe :** Division de l'échantillon en blocs de taille égale (ex. annuels) et sélection du maximum de chaque bloc.
* **Modélisation :** Convergence vers la loi **Généralisée des Valeurs Extrêmes (GEV)** qui unifie trois comportements de queue selon le paramètre de forme $\xi$ :
  * $\xi = 0$ : Queue légère (Loi de Gumbel)
  * $\xi > 0$ : Queue lourde (Loi de Fréchet)
  * $\xi < 0$ : Queue bornée (Loi de Weibull)
* **Limites :** Induit une perte d'information en ne conservant qu'une seule valeur par bloc, ce qui peut accroître l'incertitude des estimations.

### 2. Méthode des Dépassements de Seuil (Approche POT - Peaks-Over-Threshold)
* **Fondement :** Régie par le théorème de **Pickands-Balkema-de Haan**.
* **Principe :** Analyse de toutes les observations qui dépassent un seuil critique élevé $u$.
* **Modélisation :** Distribution limite des excès par la **Distribution de Pareto Généralisée (GPD)**.
* **Avantage :** Optimise l'utilisation des données disponibles par rapport à la méthode GEV, réduisant ainsi la perte d'information.

---

## 🛠️ Diagnostics & Méthodes d'Estimation

La performance des modèles repose sur le compromis fondamental **Biais-Variance**. Les outils suivants ont été implémentés et étudiés :

### Outils de Diagnostic Graphique
* **Mean Excess Plot (ME-Plot) :** Utilisé pour le choix optimal du seuil $u$ en identifiant la zone de comportement linéaire de l'espérance des excès.
* **Hill Plot :** Utilisé dans l'approche semi-paramétrique pour localiser un plateau de stabilité de l'indice de queue.

### Méthodes d'Inférence Implémentées
1. **Méthodes Paramétriques :**
   * **Maximum de Vraisemblance (MLE) :** Résolution numérique via des algorithmes d'optimisation (ex. Newton-Raphson) en raison de l'absence de solutions analytiques explicites.
   * **Méthode des Moments (MM) :** Égalisation des moments théoriques et empiriques (valable sous contrainte de finitude des moments, $\xi < 0.5$ pour la variance).
2. **Méthode Semi-Paramétrique :**
   * **Estimateur de Hill :** Évaluation de l'épaisseur de la queue de distribution pour le domaine d'attraction de Fréchet ($\xi > 0$), basé sur les $k$ plus grandes valeurs de l'échantillon.

---

## 🌊 Application Réelle : Hydrologie

L'ensemble de ces méthodologies est appliqué à une problématique concrète de gestion des risques environnementaux : **l'étude des débits de crues**.

* **Données :** Débits moyens journaliers de **la Loire à Saumur**.
* **Période d'observation :** Du $1^{\text{er}}$ janvier 1980 au 31 mars 2026.
* **Cas d'usage :** Estimation des quantiles extrêmes, calcul des niveaux de retour et des **périodes de retour** (ex. prédiction des crues centennales).

---

## 📂 Structure du Dépôt

```text
├── "code R.R"             # Code R complet : graphiques, estimateurs (GEV, POT, Hill)
├── "TER (1).pdf"          # Rapport final du TER (format PDF)
└── README.md              # Présentation générale du projet et résumé des résultats
