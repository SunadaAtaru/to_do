# Puma configuration file

threads_count = ENV.fetch("RAILS_MAX_THREADS", 3)
threads threads_count, threads_count

# 環境ごとに bind を切り替える（重要）
if Rails.env.production?
  # 本番環境では UNIXソケットで接続（Nginxと連携）
  bind "unix:/var/www/to_do/tmp/sockets/puma.sock"
else
  # 開発環境では localhost:3000 で起動
  port ENV.fetch("PORT", 3000)
end

# ワーカー数（通常はデフォルトのままでOK）
workers ENV.fetch("WEB_CONCURRENCY", 1)

# デーモン化する場合は pidfile を指定
pidfile ENV["PIDFILE"] if ENV["PIDFILE"]

# tmp/restart.txt が touch されたときに再起動する
plugin :tmp_restart
