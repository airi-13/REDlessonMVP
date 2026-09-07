# REDlessonMVP

RED授業管理簡易VER。既存の `RedTennodai` とは完全に独立したシステムです。

## MVP
- 生徒ID＋パスワードによるログイン
- 生徒本人の授業だけを取得するサーバー側認可
- 週次授業（曜日×コマ）
- 1〜8限の固定時刻
- 欠席登録（授業開始5分前まで）
- 欠席1件につき振替権1件
- 振替使用済み権利の再利用防止
- 管理者による生徒・週次授業・個別授業の管理
- 曜日×コマの利用可否管理
- Cloudflare Workers + D1 前提

## 固定コマ
1. 15:00–15:40
2. 15:45–16:25
3. 16:30–17:10
4. 17:15–17:55
5. 18:00–18:40
6. 18:45–19:25
7. 19:30–20:10
8. 20:15–20:55

## 開発
```bash
npm install
npx wrangler dev
```

D1 migration:
```bash
npx wrangler d1 migrations apply redlesson --local
```

## デプロイ
Cloudflare Workers Builds の Deploy command は次を使用します。

```bash
npm run deploy
```

`npm run deploy` は D1 の remote migrations を適用してから Worker をデプロイします。

## 画面
- 生徒画面: `/`
- 管理者画面: `/admin`

管理者IDは `ADMIN_USER`、管理者パスワードは Cloudflare Worker Secret の `ADMIN_PASSWORD` を使用します。
`SESSION_SECRET` も Secret として設定してください。
