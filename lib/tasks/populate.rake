namespace :test do
  desc "generate the test data(needs Internet connection)"
  task :populate
end

task "test:populate" do
  ENV["RAILS_ENV"] ||= "test"
  require File.expand_path('../../../config/environment', __FILE__)

  unless User.find_by uid: 199
    User.create name: "Tester Amenda", uid: 199
  end
  words = %w(moon cook mushroom film)
  words.each { |sample|
    word = Word.find_by word: sample
    unless word
      word = Word.create word: sample
      raw_definitions = Camdict::Client.new.html_definition(sample)
      raw_definitions.each { |html_def| 
        html_def.each_pair { |key, value|
          word.rawhtmls.build entry_id: key, htmldef: value
        }
      }
      word.save
      Word.init_definition sample
    end
  }
end
