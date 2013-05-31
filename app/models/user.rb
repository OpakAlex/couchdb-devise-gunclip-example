class User < Gunclip::Model::Base

  extend ::Devise::Models

  devise :database_authenticatable, :confirmable, :lockable,
         :rememberable, :trackable, :validatable, :registerable, :recoverable,
         :encryptable, :omniauthable, :encryptor => :sha512



end