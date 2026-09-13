from datetime import datetime, timedelta

import requests
from airflow.sdk import dag, task
from airflow.providers.postgres.hooks.postgres import PostgresHook

CITIES = [
    {"name": "Islamabad", "latitude": 33.6844, "longitude": 73.0479},
    {"name": "Karachi",   "latitude": 24.8607, "longitude": 67.0011},
    {"name": "Lahore",    "latitude": 31.5497, "longitude": 74.3436},
]

POSTGRES_CONN_ID = "postgres_default"
TABLE_NAME = "weather_data"


@dag(
    dag_id="weather_etl_pipeline",
    description="Fetch current weather for multiple cities from Open-Meteo and store it in Postgres",
    schedule="@hourly",
    start_date=datetime(2026, 1, 1),
    catchup=False,
    tags=["students", "etl", "weather"],
    default_args={
        "retries": 3,
        "retry_delay": timedelta(minutes=2),
        "retry_exponential_backoff": True,   # 2min, 4min, 8min... instead of flat 2min each time
        "max_retry_delay": timedelta(minutes=15),
    },
)
def weather_etl_pipeline():

    @task
    def create_table():
        hook = PostgresHook(postgres_conn_id=POSTGRES_CONN_ID)
        create_sql = f"""
        CREATE TABLE IF NOT EXISTS {TABLE_NAME} (
            id SERIAL PRIMARY KEY,
            city VARCHAR(100) NOT NULL,
            temperature_c FLOAT NOT NULL,
            windspeed_kmh FLOAT NOT NULL,
            weather_code INT,
            observed_at TIMESTAMP NOT NULL,
            loaded_at TIMESTAMP DEFAULT NOW()
        );
        """
        hook.run(create_sql)

    @task
    def extract_weather(city: dict) -> dict:
        url = "https://api.open-meteo.com/v1/forecast"
        params = {
            "latitude": city["latitude"],
            "longitude": city["longitude"],
            "current_weather": "true",
        }
        response = requests.get(url, params=params, timeout=10)
        response.raise_for_status()
        data = response.json()
        data["city_name"] = city["name"]
        return data

    @task
    def transform_weather(raw_data: dict) -> dict:
        current = raw_data["current_weather"]
        return {
            "city": raw_data["city_name"],
            "temperature_c": current["temperature"],
            "windspeed_kmh": current["windspeed"],
            "weather_code": current["weathercode"],
            "observed_at": current["time"],
        }

    @task
    def load_weather(weather_record: dict):
        hook = PostgresHook(postgres_conn_id=POSTGRES_CONN_ID)
        insert_sql = f"""
        INSERT INTO {TABLE_NAME} (city, temperature_c, windspeed_kmh, weather_code, observed_at)
        VALUES (%(city)s, %(temperature_c)s, %(windspeed_kmh)s, %(weather_code)s, %(observed_at)s);
        """
        hook.run(insert_sql, parameters=weather_record)

    table_ready = create_table()
    raw = extract_weather.expand(city=CITIES)
    clean = transform_weather.expand(raw_data=raw)
    loaded = load_weather.expand(weather_record=clean)

    table_ready >> raw


weather_etl_pipeline()