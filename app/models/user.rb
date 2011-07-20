class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :time_zone

  acts_as_authentic do |config|
    # Can set up various configuration options here
  end

  validates_each :time_zone do |u, attr, value|
    unless value.blank? || ActiveSupport::TimeZone[value]
      u.errors.add(attr, 'is not a valid time zone')
    end
  end

  scope :name_like, lambda { |substr| {:conditions => ['LOWER(login) like ?', "%#{substr}%"] } }

  # devctm_template starts out with a single admin user loaded into the
  # database.  For larger projects, adding an admin column, or even having
  # roles-based authentication may make sense.  If so, change this.

  def admin?
    return !new_record? && login == 'admin'
  end
end
