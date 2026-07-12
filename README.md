# Task Manager

Ruby on Railsで作成するタスク管理アプリです。  
タスクの作成・編集・削除・ステータス管理を行い、日々の作業を整理できるWebアプリケーションです。

## URL

※ デプロイ後に記載予定

## 使用技術

### Backend
- Ruby
- Ruby on Rails 7

### Database
- PostgreSQL

### Infrastructure
- Docker
- AWS（予定）

### Version Control
- Git
- GitHub

## 機能一覧

### 実装予定
- ユーザー登録
- ログイン / ログアウト
- タスク作成
- タスク一覧表示
- タスク詳細表示
- タスク編集
- タスク削除
- ステータス管理
- 期限管理
- 検索機能

## ER図

※ 作成後に記載予定

## 画面遷移図

※ 作成後に記載予定

## セットアップ方法

### Dockerを使う場合

このアプリはDockerを使って、RailsとPostgreSQLをまとめて起動できます。

```bash
docker compose build
```

```bash
docker compose up
```

起動後、ブラウザで以下のURLにアクセスします。

```text
http://localhost:3000
```

PostgreSQLの中身を確認したい場合は、Adminerにアクセスします。

```text
http://localhost:8080
```

Adminerのログイン情報は以下です。

```text
システム: PostgreSQL
サーバ: db
ユーザ名: postgres
パスワード: password
データベース: task_manager_development
```

初回起動時は、`docker-compose.yml` の設定により `bin/rails db:prepare` が実行されます。  
そのため、データベース作成とマイグレーションは自動で行われます。

コンテナを停止する場合は、以下のコマンドを実行します。

```bash
docker compose down
```

### ローカル環境で起動する場合

Ruby、PostgreSQL、Node.js、npmをローカルに用意している場合は、以下の手順で起動できます。

```bash
bundle install
```

```bash
npm install
```

```bash
bin/rails db:prepare
```

```bash
bin/dev
```

## 開発目的

Web系エンジニアへの転職を目指し、ポートフォリオ用にRails・PostgreSQL・Docker・GitHubを用いた実務に近い開発フローを学習するために作成しています。

## 今後の改善予定

- Docker環境構築
- AWSデプロイ
- RSpecによるテスト追加
- ページネーション
- ソート機能
- READMEの充実
