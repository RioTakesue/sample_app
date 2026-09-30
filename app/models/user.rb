class User < ApplicationRecord
  #存在する場合のみ保存前にメールアドレスを小文字に変換
  #before_save { email.downcase! } 破壊的メソッド
  before_save { self.email = email.downcase if email.present? } 


  validates :name, presence: true, length: { maximum: 50 }

  #メールアドレス検証用の正規表現
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i 
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true                                     #メールアドレスの一意性を保証

  #ユーザーがセキュアなパスワードを保持
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
end
