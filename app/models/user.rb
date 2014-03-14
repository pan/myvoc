class User
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps

  # find a specific user from a provider or create it when not found, or
  # update its name whenever it's been changed.
  # return the found/updated/created user
  # keep the minimum fields only :provider, :uid, :name from the hash +auth+
  def self.find_init_update auth
    usr = {provider: auth[:provider], uid: auth[:uid], name: auth[:info][:name]}
    user = find_by provider: usr[:provider], uid: usr[:uid]
    if user 
      user.update name: usr[:name] if user[:name] != usr[:name]
    else
      user = create usr
    end
    user
  end

  # return user name by its db object id
  def self.fullname oid
    u=find oid
    u.name if u
  end

end
