# Olist Data Warehouse & Analytics

Pipeline analytique de bout en bout sur le jeu de données e-commerce brésilien Olist : ingestion des CSV bruts dans PostgreSQL, transformation avec dbt (staging → intermediate → marts), puis analyse SQL et dashboard Power BI.

## Architecture

```
CSV (data/) --> Postgres schema "raw" --> dbt (schema "dev") --> SQL analysis / Power BI
                 (data_load.py)          staging → intermediate → marts
```

1. **Ingestion** — `data_load.py` charge les CSV du dossier `data/` dans le schéma Postgres `raw` (une table par fichier) via pandas + SQLAlchemy.
2. **Transformation (dbt)** — projet dbt organisé en trois couches, matérialisées dans le schéma `dev` :
   - `staging` (vues) : renommage/typage 1:1 des tables `raw`
   - `intermediate` (vues) : agrégations, dédoublonnage, jointures de logique métier
   - `marts` (tables) : schéma en étoile final pour l'analyse
3. **Analyse** — requêtes SQL métier dans `sql analysis/` et dashboard Power BI dans `power bi/`.

## Modèles dbt

| Couche | Modèles |
|---|---|
| staging | `stg_customer`, `stg_orders`, `stg_order_items`, `stg_order_payments`, `stg_order_reviews`, `stg_products`, `stg_product_category_name_translation`, `stg_seller`, `stg_geolocation` |
| intermediate | `int_order_payments_summary`, `int_order_reviews`, `int_product_translation` |
| marts | `dim_customers`, `dim_product`, `dim_seller`, `dim_geolocation`, `fact_orders`, `fact_order_items` |

Sources déclarées (`sources.yml`) : schéma Postgres `raw`, tables `olist_customers_dataset`, `olist_orders_dataset`, `olist_order_items_dataset`, `olist_order_payments_dataset`, `olist_order_reviews_dataset`, `olist_products_dataset`, `olist_sellers_dataset`, `olist_geolocation_dataset`, `product_category_name_translation`.

## Structure du repo

```
olist_dbt_project/
├── data/                 # CSV bruts Olist
├── data_load.py          # Charge les CSV dans Postgres (schema raw)
├── dd.py                 # Vérifie la connexion DB et crée le schema raw
├── sql analysis/         # Requêtes SQL métier sur les marts dbt
├── power bi/             # Dashboard Power BI (.pbix)
├── logs/
└── venv/                 # Environnement virtuel Python (dbt-core, dbt-postgres, pandas, sqlalchemy)
```

Le projet dbt lui-même (`dbt_project.yml`, `models/`) n'est pas présent dans l'arborescence actuelle ; sa dernière structure connue en historique git était `olist-dbt-project-main/olist_dw/` (projet `olist_dw`, profil `olist_dw`).

## Mise en route

```bash
# 1. Environnement Python
python3.14 -m venv venv
source venv/bin/activate
pip install dbt-core dbt-postgres pandas sqlalchemy psycopg2-binary

# 2. Charger les CSV bruts dans Postgres (schema raw)
python data_load.py

# 3. Configurer ~/.dbt/profiles.yml pour pointer sur la base olist_dw
#    (le nom du profil doit correspondre à la clé `profile:` de dbt_project.yml)

# 4. Lancer les transformations dbt (depuis le dossier du projet dbt)
dbt run

# 5. Explorer les résultats
#    - sql analysis/sql analysis.sql : requêtes métier sur dev.fact_orders, dev.dim_*, ...
#    - power bi/olist dashboard.pbix : dashboard
```

## Questions métier couvertes (`sql analysis/`)

- Revenu total et note moyenne des avis
- État avec le plus de clients
- Catégorie de produit générant le plus de revenu
- Mois de pic de revenu
- Moyen de paiement avec la valeur moyenne de commande la plus élevée
- Répartition des commandes livrées vs annulées
- Impact du retard de livraison sur la note des avis
- Meilleur vendeur par revenu

## Points d'attention

- **Secret exposé** : `python/load_data.py` (dupliqué avec `data_load.py`) contient un mot de passe Postgres en clair, committé dans git. À remplacer par une variable d'environnement et à faire tourner (changer le mot de passe côté DB si ce n'est pas un identifiant jetable local).
- `dbt_project.yml` : la clé sous `models:` doit correspondre exactement au `name:` du projet, sinon les configs de matérialisation (`+materialized`) sont silencieusement ignorées.
