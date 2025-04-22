# db/seeds/development.rb

demo_user = User.create!(
  email: "demo@example.com",
  password: "password",
  username: "デモユーザー"
)

5.times do |i|
  Task.create!(
    title: "開発用タスク#{i + 1}",
    description: "これは開発環境用のダミータスクです。",
    user: demo_user
  )
end
