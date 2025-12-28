-- =============================================
-- Flink SQL: Iceberg Catalog設定
-- =============================================

-- REST Catalogを登録
CREATE CATALOG iceberg_catalog WITH (
    'type' = 'iceberg',
    'catalog-type' = 'rest',
    'uri' = 'http://rest-catalog:8181',
    'warehouse' = 's3://warehouse',
    's3.endpoint' = 'http://minio:9000',
    's3.access-key-id' = 'admin',
    's3.secret-access-key' = 'password',
    's3.path-style-access' = 'true'
);

-- カタログ一覧を確認
SHOW CATALOGS;

-- カタログを使用
USE CATALOG iceberg_catalog;

-- =============================================
-- データベースの作成
-- =============================================

CREATE DATABASE IF NOT EXISTS demo;
USE demo;

-- =============================================
-- テーブルの作成
-- =============================================

CREATE TABLE users (
    user_id BIGINT,
    name STRING,
    email STRING,
    score DOUBLE,
    created_at TIMESTAMP(6)
);

-- =============================================
-- サンプルデータの挿入
-- =============================================

INSERT INTO users VALUES
    (1, 'Alice', 'alice@example.com', 85.5, CURRENT_TIMESTAMP),
    (2, 'Bob', 'bob@example.com', 92.0, CURRENT_TIMESTAMP),
    (3, 'Charlie', 'charlie@example.com', 78.5, CURRENT_TIMESTAMP);

-- データ確認
SELECT * FROM users;