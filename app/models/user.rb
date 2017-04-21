# frozen_string_literal: true

# user model
class User
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps

  # has_many will have this error
  # mongoid-6.1.0/lib/mongoid/relations/binding.rb:155:in `respond_to?': nil is
  # not a symbol nor a string (TypeError)
  # rubocop:disable Rails/HasAndBelongsToMany
  has_and_belongs_to_many :words, inverse_of: nil
  # rubocop:enable Rails/HasAndBelongsToMany
  has_many :tasks

  # find a specific user from a provider or create it when not found, or
  # update its name whenever it's been changed.
  # return the found/updated/created user
  # keep the minimum fields only :provider, :uid, :name from the hash +auth+
  def self.find_init_update(auth)
    usr = { provider: auth[:provider], uid: auth[:uid],
            name: auth[:info][:name] }
    user = find_or_create_by provider: usr[:provider], uid: usr[:uid]
    user.update name: usr[:name] if user && user[:name] != usr[:name]
    user
  end

  # return user name by its db object id string: +id+
  def self.fullname(id)
    i(id)&.name
  end

  # associate the user +id+ with a word instance +aword+
  def self.associate(user, aword)
    user.words << aword
    user.save
  end

  # get user instance from its id
  def self.i(uid)
    find uid
  end

  def associate(aword)
    words << aword
    save
  end

  def de_associate(aword)
    words.delete aword
  end

  def associated?(word)
    words.where(word: word).exists?
  end
end
