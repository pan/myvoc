# frozen_string_literal: true

require 'test_helper'

class WordsHelperTest < ActionView::TestCase
  test 'level symbol name should be mapped to its full name' do
    assert_equal 'Advanced', level_name('C1')
    assert_nil level_name 'Not-Exist'
  end

  test 'add two slashes onto ipa' do
    assert_equal '/film/', ipastr('film')
  end

  test 'how many words' do
    assert_equal '[10]', how_many(10)
    assert_equal 'No word in DB', how_many(0)
  end

  test 'current word' do
    session[:word] = 'zoom'
    assert_equal ' current', current('zoom')
  end

  test 'struct2hash' do
    Contact = Struct.new(:phone, :email)
    Person = Struct.new(:name, :contact)
    m_contact = Contact.new(99_551_234, 'mike@json.me')
    mike = Person.new('Michael', m_contact)
    expected_hash = { name: 'Michael',
                      contact: { phone: 99_551_234, email: 'mike@json.me' } }
    assert_equal expected_hash, struct2hash(mike)
  end
end
