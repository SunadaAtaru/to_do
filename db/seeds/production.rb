# db/seeds/production.rb

admin_user = User.create!(
  email: "admin@example.com",
  password: "adminpass",
  username: "管理者",
  admin: true
)

demo_user = User.create!(
  email: "demo@example.com",
  password: "password",
  username: "本番用デモユーザー"
)

3.times do |i|
  Task.create!(
    title: "本番タスク#{i + 1}",
    description: "本番環境での初期表示用サンプルです。",
    user: demo_user
  )
end
