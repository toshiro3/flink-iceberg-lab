-- =============================================
-- Flink SQL: 基本クエリ
-- =============================================

-- カタログとデータベースの設定
USE CATALOG iceberg_catalog;
USE demo;

-- =============================================
-- 集計クエリ
-- =============================================

SELECT 
    COUNT(*) as total_users,
    AVG(score) as avg_score,
    MAX(score) as max_score,
    MIN(score) as min_score
FROM users;

-- =============================================
-- メタデータテーブル
-- =============================================

-- バッチモードに切り替え（ソートを使用するため）
SET 'execution.runtime-mode' = 'batch';

-- スナップショット一覧
SELECT snapshot_id, committed_at, operation 
FROM iceberg_catalog.demo.`users$snapshots`
ORDER BY committed_at;

-- 履歴
SELECT * FROM iceberg_catalog.demo.`users$history`;

-- =============================================
-- タイムトラベルクエリ
-- =============================================

-- 4件目のデータを追加
INSERT INTO users VALUES
    (4, 'David', 'david@example.com', 88.0, CURRENT_TIMESTAMP);

-- 現在のデータを確認（4件）
SELECT * FROM users;

-- スナップショットIDを確認
SELECT snapshot_id, committed_at 
FROM iceberg_catalog.demo.`users$snapshots`
ORDER BY committed_at;

-- スナップショットIDを指定して過去データを参照
-- （最初のスナップショットIDに置き換えてください）
-- SELECT * FROM iceberg_catalog.demo.users 
--     /*+ OPTIONS('snapshot-id'='最初のスナップショットID') */;

-- =============================================
-- UPSERTモード
-- =============================================

-- UPSERT対応テーブル作成
CREATE TABLE users_upsert (
    user_id BIGINT,
    name STRING,
    email STRING,
    score DOUBLE,
    updated_at TIMESTAMP(6),
    PRIMARY KEY (user_id) NOT ENFORCED
) WITH (
    'format-version' = '2',
    'write.upsert.enabled' = 'true'
);

-- 初期データ
INSERT INTO users_upsert VALUES
    (1, 'Alice', 'alice@example.com', 85.5, CURRENT_TIMESTAMP);

-- 確認
SELECT * FROM users_upsert;

-- 同じuser_id=1で更新（UPSERT）
INSERT INTO users_upsert VALUES
    (1, 'Alice', 'alice_updated@example.com', 90.0, CURRENT_TIMESTAMP);

-- 確認（emailとscoreが更新されているはず）
SELECT * FROM users_upsert;