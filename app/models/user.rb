class User < Gunclip::Model::Base

  extend ::Devise::Models

  devise :database_authenticatable, :confirmable, :lockable,
         :rememberable, :trackable, :validatable, :registerable, :recoverable,
         :encryptable, :omniauthable, :encryptor => :sha512


 #we don't have any callbaks

  #after_create  :send_on_create_confirmation_instructions, :if => :send_confirmation_notification?
  #before_update :postpone_email_change_until_confirmation, :if => :postpone_email_change?
  #after_update  :send_confirmation_instructions, :if => :reconfirmation_required?

  def id
    (@request["email"] || @request["_id"] || @request["id"])
  end

  def save save_attrs = {validate: true}
    set_timestamps if with_timestamps

    if save_attrs[:validate]
      return false  unless  valid?
    end

    generate_confirmation_token() unless confirmation_token

    attrs = delete_system_attrs
    if id
      request = request(:put, make_url(get_id_rev), attrs)
    else
      request = request(:post, make_url(get_id_rev), attrs)
    end
    raise UpdateConflictError if request.status == 409
    @request = Oj.load request.body
    merge_params(attrs)
    self
  end

  #devise

  def persisted?
    true
  end

  def email_changed?
    false
  end

  def self.to_adapter
    self
  end

  def self.find_first args
    # To do implement find by token
    puts args
    nil
  end

  #def find_for_token_authentication(conditions)
    #find_for_authentication(:authentication_token => conditions[token_authentication_key])
  #end

  def system_fields
    %w(id _id rev _rev password password_confirmation)
  end

  def delete_system_attrs
    self.password = @request["password"] if @request["password"]
    super
  end

end