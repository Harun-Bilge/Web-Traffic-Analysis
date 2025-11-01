# Web Traffic Analysis – Data Optimization
# Cleans and optimizes raw event data for SQL modeling and Power BI visualization.
# Ham etkinlik verisini SQL modelleme ve Power BI görselleştirmesi için temizler ve optimize eder.

import pandas as pd

# Load dataset and inspect basic structure
# Veri setini yükler ve temel yapısını inceler
df = pd.read_csv(r"C:/Users/harun/Desktop/Projects/web-traffic/data/events1.csv")
print("Before cleaning:")
print(df.info(), "\n")
print(df.head())

# Standardize column names
# Sütun adlarını standart biçime dönüştürür
df.columns = df.columns.str.strip().str.lower().str.replace(" ", "_")

# Remove duplicates and handle missing values in key columns
# Yinelenen satırları ve kritik sütunlardaki eksik değerleri kaldırır
df = df.drop_duplicates()
df = df.dropna(subset=["user_id", "device", "country", "type"])

# Convert date column to datetime type
# Tarih sütununu datetime tipine dönüştürür
df["date"] = pd.to_datetime(df["date"], errors="coerce")

# Normalize event type values
# Olay türü değerlerini tutarlı hale getirir
df["type"] = df["type"].str.lower().str.replace(" ", "_")

# Select relevant columns for analysis
# Analiz için gerekli sütunları seçer
df = df[["user_id", "ga_session_id", "country", "device", "type", "item_id", "date"]]

# Display basic distributions for validation
# Doğrulama amacıyla temel dağılımları gösterir
print("\nEvent Type Counts:\n", df["type"].value_counts())
print("\nDevice Distribution:\n", df["device"].value_counts())
print("\nCountry Sample:\n", df["country"].value_counts().head(10))

# Export cleaned dataset for SQL and BI use
# SQL ve Power BI kullanımı için temiz veriyi dışa aktarır
df.to_csv("clean_events.csv", index=False)
print("\nCleaned dataset saved as 'clean_events.csv'")
