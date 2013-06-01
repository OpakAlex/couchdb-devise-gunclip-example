class GunclipTestModel < Gunclip::Model::Base

  validates_presence_of :body

  validates_uniqueness_of :body

end