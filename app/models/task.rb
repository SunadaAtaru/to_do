class Task < ApplicationRecord
  # Userモデルとの関連付け。各タスクは1人のユーザーに所属する
  belongs_to :user
  
  # タイトルが存在することを検証（必須項目）
  validates :title, presence: true
  
  # ステータスが存在し、かつ指定された値のいずれかであることを検証
  # inclusion: { in: [...] }で取りうる値を制限している
  validates :status, presence: true, inclusion: { in: ['未完了', '完了'] }
  
  # 新しいレコードが作成される際に実行されるコールバック
  # レコード初期化時（new）にデフォルト値を設定する
  after_initialize :set_default_status, if: :new_record?
  
  private
  
  # ステータスのデフォルト値を設定するメソッド
  # ||= は左辺がnil/falseの場合のみ、右辺の値を代入する演算子
  # つまり、statusが未設定の場合のみ「未完了」をセットする
  def set_default_status
    self.status ||= '未完了'
  end
end