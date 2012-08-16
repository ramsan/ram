class Visit < ActiveRecord::Base
  
  #Validations
  validates_uniqueness_of :email, :on => :create, :message => "has been registered already."
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => " is invalid, please correct it and submit it again."

end
