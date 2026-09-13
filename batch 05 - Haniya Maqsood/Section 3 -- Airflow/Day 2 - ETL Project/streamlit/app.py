import streamlit as st
import pandas as pd
import psycopg2
import time

st.set_page_config(page_title="Weather ETL Dashboard", layout="wide")

DB_CONFIG = dict(
    host="postgres",
    port=5432,
    dbname="airflow",
    user="airflow",
    password="airflow",
)

@st.cache_data(ttl=60)  # refresh cache every 60s
def load_data():
    conn = psycopg2.connect(**DB_CONFIG)
    df = pd.read_sql("SELECT * FROM weather_data ORDER BY observed_at DESC", conn)
    conn.close()
    return df

st.title("🌦️ Weather ETL Dashboard")

df = load_data()

if df.empty:
    st.warning("No data yet — wait for the DAG to run.")
else:
    latest = df.sort_values("observed_at").groupby("city").tail(1)
    cols = st.columns(len(latest))
    for col, (_, row) in zip(cols, latest.iterrows()):
        col.metric(row["city"], f"{row['temperature_c']} °C", f"{row['windspeed_kmh']} km/h wind")

    st.subheader("Temperature over time")
    pivot = df.pivot_table(index="observed_at", columns="city", values="temperature_c")
    st.line_chart(pivot)

    st.subheader("Raw data")
    st.dataframe(df, use_container_width=True)

st.caption("Auto-refreshes every 60s (cache TTL). Reload page to force refresh.")