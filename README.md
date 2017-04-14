== README

The 'My Vocabulary' application helps me learn English new words and phrases, as
well as idiomatic sayings and sentences.

You need these things to run this application.

* Ruby version: 2.3.0+

* System dependencies
  Rails(gem) 5.0.2
  one of the ExecJS runtimes, such as therubyracer(gem)
  redis

* Installation and Configuration
  install ruby
```shell
  bundle install
  apt-get install redis-server (see redios.io for other OS)
```

* Database creation
  This application uses a non-sql DB Mongodb.

* Database initialization
  Edit the configuration file config/mongoid.yml

* How to run the test suite
  populate the sample data with `RAILS_ENV=test rails r db/seeds.rb`

* Services (job queues, cache servers, search engines, etc.)
  This app uses sidekiq for job queues. Launch it with,

    $ export RAILS_ENV=production
    $ bundle exec sidekiq -d

  To stop it,

    $ sidekiqctl stop tmp/pids/sidekiq.pid

* Deployment instructions
