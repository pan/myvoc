# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the
# db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
amenda = User.find_or_create_by(uid: 199, name: 'Tester Amanda',
                                provider: 'github')

test_words = %w[moon mushroom associate]
test_words.each { |word| Word.add_asso(amenda.id.to_s, word) }
