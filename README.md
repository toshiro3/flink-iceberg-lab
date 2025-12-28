# 🌊 Flink + Iceberg 検証環境

Apache FlinkとApache Icebergを組み合わせた検証環境です。

## 🏗️ アーキテクチャ

```
┌─────────────────────────────────────────────────────────────┐
│                    Flink Cluster                             │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐     │
│  │ JobManager  │    │ TaskManager │    │ SQL Client  │     │
│  │  (Master)   │◄───│  (Worker)   │    │  (CLI)      │     │
│  │  :8081      │    │             │    │             │     │
│  └─────────────┘    └─────────────┘    └─────────────┘     │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           ▼
                   ┌───────────────┐
                   │  REST Catalog │
                   │    :8181      │
                   └───────┬───────┘
                           │
                           ▼
                   ┌───────────────┐
                   │     MinIO     │
                   │  S3 API: 9000 │
                   │  Console:9001 │
                   └───────────────┘
```

## 🚀 クイックスタート

### 1. 環境の起動

```bash
cd flink-iceberg-lab
docker compose up -d
```

初回起動時はDockerイメージのビルドに数分かかります。

### 2. サービスの確認

| サービス | URL | 用途 |
|---------|-----|------|
| Flink Web UI | http://localhost:8081 | ジョブ監視 |
| MinIO Console | http://localhost:9001 | ストレージ管理（admin/password） |

> ⚠️ **TaskManagerが起動していない場合があります**
> 
> Flink Web UIの「Task Managers」タブで確認し、表示されていなければ以下を実行してください。
> ```bash
> docker compose up -d taskmanager
> ```

### 3. Flink SQL Clientの起動

```bash
docker compose run --rm sql-client /opt/flink/bin/sql-client.sh
```

### 4. Icebergカタログの設定

SQL Clientで以下を実行：

```sql
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

USE CATALOG iceberg_catalog;
```

### 5. テーブル作成とデータ操作

```sql
-- データベース作成
CREATE DATABASE IF NOT EXISTS demo;
USE demo;

-- テーブル作成
CREATE TABLE users (
    user_id BIGINT,
    name STRING,
    email STRING,
    score DOUBLE,
    created_at TIMESTAMP(6)
);

-- データ挿入
INSERT INTO users VALUES
    (1, 'Alice', 'alice@example.com', 85.5, CURRENT_TIMESTAMP);

-- データ確認
SELECT * FROM users;
```

## 📁 ディレクトリ構成

```
flink-iceberg-lab/
├── docker-compose.yml      # Docker Compose設定
├── flink/
│   └── Dockerfile          # Flink + Iceberg JARイメージ
├── sql/                    # サンプルSQLファイル
├── warehouse/              # Icebergデータ
└── minio-data/             # MinIOデータ
```

## 🛠️ トラブルシューティング

### ログの確認

```bash
# 全サービスのログ
docker compose logs -f

# 特定サービスのログ
docker compose logs -f jobmanager
docker compose logs -f taskmanager
```

### 環境のリセット

```bash
docker compose down -v
rm -rf minio-data/*
```

### SQL Clientの終了

```sql
QUIT;
```

## 📚 参考資料

- [Apache Flink公式](https://flink.apache.org/)
- [Flink Iceberg Connector](https://iceberg.apache.org/docs/latest/flink/)
- [Apache Iceberg公式](https://iceberg.apache.org/)

## ライセンス

MIT