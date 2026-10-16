class User < ApplicationRecord

  #DBには保存されないプログラム上だけの仮想の入れ物（属性）を作成
  attr_accessor :remember_token, :activation_token

  #存在する場合のみ保存前にメールアドレスを小文字に変換
  before_save   :downcase_email
  before_create :create_activation_digest
  validates :name, presence: true, length: { maximum: 50 }

  #メールアドレス検証用の正規表現
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i 
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true                                     #メールアドレスの一意性を保証

  #ユーザーがセキュアなパスワードを保持
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true #パスワードが空でも更新可能


  #fixture向けのdigestメソッドを追加
  #渡された文字列のハッシュ値を返す
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine::cost
    BCrypt::Password.create(string, cost: cost)
  end


  #トークン生成用メソッドを追加
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  #永続的セッションのためにユーザーをDBに記憶する
  #ランダムな合言葉を発行して仮想の入れ物に持っておき
  #それを暗号化したものをチェックをすり抜けてDBに保存する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end

  #セッションハイジャック防止のためにセッショントークンを返す
  #この記憶ダイジェストを再利用しているのは単に利便性のため
  def session_token
    remember_digest || remember
  end

  #渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest") #渡された属性名によって呼び出す値を変える
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  #ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end


  # Userモデルにユーザー有効化メソッドを追加
  # アカウントを有効にする
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # 有効化用のメールを送信
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end


  #############################################
  private

    #メールアドレスを全て小文字にする
    def downcase_email
      email.downcase!
    end

    #有効化トークンとダイジェストを作成および代入する
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
