from sqlalchemy import create_engine, text

DB_USER = "postgres"
DB_PASSWORD = "1234"
DB_HOST = "localhost"
DB_PORT = "5432"
DB_NAME = "olist_dw"

DATABASE_URL = (
    f"postgresql+psycopg2://{DB_USER}:{DB_PASSWORD}"
    f"@{DB_HOST}:{DB_PORT}/{DB_NAME}"
)

engine = create_engine(DATABASE_URL)

try:
    with engine.begin() as conn:
        conn.execute(text("SELECT version();"))
        conn.execute(text("CREATE SCHEMA IF NOT EXISTS raw;"))

    print("✅ Connexion OK")
    print("✅ Schéma 'raw' créé ou déjà existant")

except Exception as e:
    print("❌ Erreur :", e)