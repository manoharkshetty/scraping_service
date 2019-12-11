##### Prerequisites

The setups steps expect following tools installed on the system.

- Github
- Ruby [2.5.1]
- Rails [6.0.1]

##### 1. Clone the repo 

##### 2. Install the gems

```ruby
  bundle install
  rails webpacker:install
```
##### 3. Create and setup the database

Run the following commands to create and setup the database.

```ruby
bundle exec rake db:create
bundle exec rake db:setup
bundle exec rake db:migrate
```

##### 3. Setup seed data

```ruby
bundle exec rails c
Package.import_packages
```

##### 4. Start the Rails server

You can start the rails server using the command given below.

```ruby
bundle exec rails s
```

And now you can visit the site with the URL http://localhost:3000

#### For reviewer:
* Most of the Logic sits in Package model and PackageScraper service. 
* I have added a smaller identity concern that parses the name and email.

#### Notes:

1. Copied the Dcf gem into the app to modify for speed.
2. Tests are making externals, need to stub them.
3. Using Parallel gem to make the scraping fasting. but even on a 8 core machine, it takes around 14 seconds. 
4. I am loading just 20MB of packages file which is enough for 50 packages(should fetch around 100)
4. Optimize the data read/write better. 
5. I am not so happy for not implementing the Refresh data functionality. I at least want to setup the seed data or a refresh button on the UI. But It take extra time.
6. Should delete authors and maintainers data on deletions of Packages
7. Should add test for  un happy paths 
