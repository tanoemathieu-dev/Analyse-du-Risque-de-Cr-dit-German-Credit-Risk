# 🏦 Analyse du Risque de Crédit — German Credit Risk

Projet d'analyse de portefeuille bancaire visant à identifier et visualiser les profils de crédit à risque, à partir du dataset public **German Credit Risk (Statlog)**. Le projet couvre l'ensemble de la chaîne : chargement et contrôle qualité des données en **MySQL**, modélisation en **schéma en étoile** dans **Power BI**, calculs de mesures en **DAX**, et restitution via un dashboard interactif multi-pages.

---

## 🎯 Objectif du projet

Construire un outil permettant à un responsable crédit de :
- Visualiser en un coup d'œil la répartition et l'exposition financière du risque dans un portefeuille de 1000 dossiers
- Identifier les facteurs qui influencent réellement le risque de défaut (statut de compte, épargne, patrimoine, âge...)
- Prioriser sa vigilance sur les critères les plus discriminants au moment de l'octroi d'un crédit

---

## 📂 Source des données

Dataset **German Credit Risk** (Statlog), 1000 lignes, 20 variables explicatives + variable cible `credit_risk` (1 = bon risque, 0 = mauvais risque). Répartition initiale : 700 bons risques / 300 mauvais risques.

---

## 🛠️ Stack technique

| Étape | Outil |
|---|---|
| Chargement & contrôle qualité | MySQL (`LOAD DATA INFILE`, vérification NULL/doublons) |
| Modélisation | Power BI — Power Query (schéma en étoile) |
| Calculs | DAX (23 mesures) |
| Visualisation | Power BI Desktop (dashboard 3 pages) |

---

## 🗄️ Étape 1 — MySQL

- Création d'une base `projet8` et d'une table unique `German_Credit_Risk` (21 colonnes + clé technique `client_id` en auto-incrément, absente du fichier source)
- Chargement via `LOAD DATA INFILE`
- Contrôles qualité systématiques : nombre de lignes, valeurs NULL sur les 21 colonnes, doublons — dataset confirmé propre (0 NULL, 0 doublon)

Toute la logique de modélisation (dimensions, table de faits) est volontairement laissée à Power BI ; MySQL sert uniquement de couche de chargement et de contrôle qualité.

---

## ⭐ Étape 2 — Modélisation en étoile (Power BI / Power Query)

**Table de faits** : `fact_credit_risk` — une ligne par client, mesures numériques (montant, durée, âge, taux d'endettement...) et clés étrangères vers les dimensions.

**9 dimensions métier**, chacune avec une clé de substitution (surrogate key) :
`Dim_status`, `Dim_credit_history`, `Dim_purpose`, `Dim_savings`, `Dim_employment_duration`, `Dim_personal_status_sex`, `Dim_property`, `Dim_housing`, `Dim_job`

**1 junk dimension** : `Dim_other_attributes`, regroupant les attributs secondaires à faible cardinalité (`other_debtors`, `other_installment_plans`, `telephone`, `foreign_worker`) en une seule table de dimension, selon la méthode Kimball — évite de multiplier les petites tables sans valeur analytique individuelle tout en gardant la possibilité de filtrer sur chacun de ces attributs.

**Colonnes enrichies créées en Power Query :**
- `libelle_risque` : traduction lisible de `credit_risk` (0/1) en "Bon Risque" / "Mauvais Risque"
- `tranche_age` : segmentation de l'âge en 6 tranches (18-25, 26-35, 36-45, 46-55, 56-65, 66+), avec colonne technique `tranche_age_tri` pour garantir un tri chronologique correct dans les visuels

---

## 📐 Étape 3 — Mesures DAX (23 mesures)

Organisées en 6 catégories :
1. **Volume & portefeuille** — Nb Clients, Montant Total Accordé, Montant Moyen, Durée Moyenne
2. **Risque crédit** — Taux Bons/Mauvais Risques, Montant Total/Moyen à Risque, % Montant Exposé au Risque
3. **Comparaison bons vs mauvais risques** — Montant et Durée Moyens par catégorie de risque
4. **Profil démographique** — Âge Moyen (global et par catégorie de risque), Nb Personnes à Charge Moyen
5. **Endettement & structure du crédit** — Taux d'Endettement Moyen, Nb Crédits Moyen, % Clients Multi-Crédits
6. **Titres dynamiques** — mesures textuelles pour cartes et en-têtes

Les mesures de taux utilisent le pattern `ALL()` pour neutraliser uniquement le filtre sur `credit_risk`, garantissant des pourcentages cohérents quel que soit le segment affiché (purpose, credit_history, etc.).

---

## 📊 Le dashboard — 3 pages

### Page 1 — Vue d'ensemble du portefeuille
KPIs globaux (montant total, montant exposé, taux de mauvais risque), répartition bons/mauvais risques (anneau), top objets de crédit en volume (barres), jauge de suivi vs objectif, répartition du portefeuille par âge et niveau de risque.

### Page 2 — Analyse du risque par segment
KPIs de référence, taux de mauvais risque par niveau d'épargne et par statut de compte courant, matrice croisée objet de crédit × historique de crédit, nuage de points risque vs volume par ancienneté d'emploi.

### Page 3 — Profil client & endettement
KPIs sur le multi-crédit et l'âge moyen, taux de risque par tranche d'âge et par qualification professionnelle, structure de l'endettement (nombre de crédits cumulés par niveau d'endettement et type de risque), taux de risque par bien possédé et par statut de logement.

---

## 🔎 Principaux enseignements

- **30%** des dossiers du portefeuille sont classés à risque, représentant **36%** du montant total prêté — l'exposition financière est proportionnellement plus lourde que la part de clients concernés.
- **Épargne** : les clients disposant de peu ou pas d'épargne présentent un taux de risque nettement plus élevé.
- **Statut du compte courant** : les clients à solde faible affichent le taux de risque le plus élevé (49%) ; à l'inverse, les clients sans compte courant ont le taux le plus bas (12%) — un résultat contre-intuitif qui nuance l'idée reçue selon laquelle l'absence de compte serait un signal de risque.
- **Âge** : le risque suit une courbe en U, avec des pics chez les 18-25 ans et les 56-65 ans (hypothèse à approfondir : moindre épargne en début de vie active pour les uns, transition vers la retraite pour les autres).
- **Patrimoine** : posséder un bien immobilier est le facteur le plus protecteur (21% de risque) ; l'absence de bien connu est associée au risque le plus élevé (44%).

---

## ⚖️ Note méthodologique — variables sensibles

Le dataset source contient deux variables historiquement sensibles : `personal_status_sex` (statut marital croisé avec le sexe) et `foreign_worker` (statut de travailleur étranger). Ces variables ont été **volontairement exclues de l'analyse du risque** présentée dans ce dashboard, pour des raisons d'équité et de conformité aux principes de non-discrimination en matière de scoring crédit (cf. réglementations type EU AI Act sur les systèmes de notation). Elles restent disponibles dans le modèle de données à des fins de transparence sur la source, mais ne sont mobilisées dans aucun visuel d'analyse du risque.

---

## 📁 Structure du dépôt

```
├── sql/
│   └── 01_creation_chargement_credit_risk.sql
├── powerbi/
│   └── projet8_credit_risk.pbix
├── mesures/
│   └── mesures_DAX_credit_risk.txt
└── README.md
```

---

## 👤 Auteur

**Tanoé Mathieu Koffi** — Junior Data Analyst, Abidjan (Côte d'Ivoire)
[GitHub](https://github.com/tanoemathieu-dev) · [LinkedIn](#)

*Ce projet a été réalisé dans une démarche d'apprentissage et de constitution de portfolio en analyse de risque crédit bancaire, dans le cadre du Master 1 Data Analytics (Institut CERCO) et de la certification Microsoft Power BI Data Analyst.*
