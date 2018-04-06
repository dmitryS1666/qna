class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, omniauth_providers: %i[facebook twitter]

  def author?(resource)
    resource.user_id == self.id
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return authorization.user if authorization

    return unless auth.info && auth.info[:email]

    email = auth.info[:email]
    user = User.find_by(email: email)

    unless user
      password = Devise.friendly_token[0, 20]
      user = User.new(email: email, password: password, password_confirmation: password)
      user.save!
      user.create_authorization(auth)
    end

    user.create_authorization(auth)
    user
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

end