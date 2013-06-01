class User < Gunclip::Model::Base

  extend ::Devise::Models

  devise :database_authenticatable, :confirmable, :lockable,
         :rememberable, :trackable, :validatable, :registerable, :recoverable,
         :encryptable, :omniauthable, :encryptor => :sha512

  def id
    (@request["email"] || @request["_id"] || @request["id"])
  end

end