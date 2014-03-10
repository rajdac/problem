**THIS README IS FOR THE STANDLONE RUBY SCRIPT problem.rb.**

SUMMARY
-------

Foot-Traffic Analysis

program that takes a formatted log file that describes the overall gallery's foot-traffic on a minute-to-minute basis. 
From this data you must compute the average time spent in each room, and how many visitors there were in each room. 

 Input Description 
 
 You will be first given an integer N which represents the following N-number of lines of text. Each line represents either a visitor entering or leaving a room: it starts with an integer, representing a visitor's unique identifier. Next on this line is another integer, representing the room index. Note that there are at most 100 rooms, starting at index 0, and at most 1,024 visitors, starting at index 0. Next is a single character, either 'I' (for "In") for this visitor entering the room, or 'O' (for "out") for the visitor leaving the room. Finally, at the end of this line, there is a time-stamp integer: it is an integer representing the minute the event occurred during the day. This integer will range from 0 to 1439 (inclusive). All of these elements are space-delimited. 
 You may assume that all input is logically well-formed: for each person entering a room, he or she will always leave it at some point in the future. A visitor will only be in one room at a time. 
 Note that the order of events in the log are not sorted in any way; it shouldn't matter, as you can solve this problem without sorting given data. Your output (see details below) must be sorted by room index, ascending.
 
 Output Description 

 For each room that had log data associated with it, print the room index (starting at 0), then print the average length of time visitors have stayed as an integer (round down), and then finally print the total number of visitors in the room. All of this should be on the same line and be space delimited; you may optionally include labels on this text, like in our sample output 1.
 Sample Inputs & Outputs

 Sample Input 1 

 4
 0 0 I 540
 1 0 I 540
 0 0 O 560
 1 0 O 560

 Sample Output 1 
 Room 0, 20 minute average visit, 2 visitor(s) total
 
 Sample Input 2

 36
 0 11 I 347
 1 13 I 307
 2 15 I 334
 3 6 I 334
 4 9 I 334
 5 2 I 334
 6 2 I 334
 7 11 I 334
 8 1 I 334
 0 11 O 376
 1 13 O 321
 2 15 O 389
 3 6 O 412
 4 9 O 418
 5 2 O 414
 6 2 O 349
 7 11 O 418
 8 1 O 418
 0 12 I 437
 1 28 I 343
 2 32 I 408
 3 15 I 458
 4 18 I 424
 5 26 I 442
 6 7 I 435
 7 19 I 456
 8 19 I 450
 0 12 O 455
 1 28 O 374
 2 32 O 495
 3 15 O 462
 4 18 O 500
 5 26 O 479
 6 7 O 493
 7 19 O 471
 8 19 O 458

* Sample Output 2

* Room 1, 85 minute average visit, 1 visitor total
* Room 2, 48 minute average visit, 2 visitors total
* Room 6, 79 minute average visit, 1 visitor total
* Room 7, 59 minute average visit, 1 visitor total
* Room 9, 85 minute average visit, 1 visitor total
* Room 11, 57 minute average visit, 2 visitors total
* Room 12, 19 minute average visit, 1 visitor total
* Room 13, 15 minute average visit, 1 visitor total
* Room 15, 30 minute average visit, 2 visitors total
* Room 18, 77 minute average visit, 1 visitor total
* Room 19, 12 minute average visit, 2 visitors total
* Room 26, 38 minute average visit, 1 visitor total
* Room 28, 32 minute average visit, 1 visitor total
* Room 32, 88 minute average visit, 1 visitor total
*

**Note: The master branch is the fully functioning version.**

Solution
----------

Assumptions
----------

* There are possibly 2 sources of data one already existing in memory and other in the external file "log.txt" which is in the same directory.
* All the data is in the prescribed format so no validation of data is done.
* There will always a checkin prior to chekout so no need to check if data corresponds to checkin or checkout reason being
  if there exists a room entry corresponding to the visitor then the first one will be the checkin corresponding to the room.
  

Installation
-------------
ru


To use a stable build of Spree, you can manually add Spree to your
Rails 4.0.x application. To use the 2-1-stable branch of Spree, add this line to
your Gemfile.

```ruby
gem 'spree', github: 'spree/spree', branch: '2-1-stable'
```

Alternatively, if you want to use the bleeding edge version of Spree, use this
line:

```ruby
gem 'spree', github: 'spree/spree'
```



If you wish to have authentication included also, you will need to add the
`spree_auth_devise` gem as well. Either this:

```ruby
gem 'spree_auth_devise', github: 'spree/spree_auth_devise', branch: '2-1-stable'
```

Or this:

```ruby
gem 'spree_auth_devise', github: 'spree/spree_auth_devise'
```

Once you've done that, then you can install these gems using this command:

```shell
bundle install
```

Use the install generator to set up Spree:

```shell
rails g spree:install --sample=false --seed=false
```

At this point, if you are using spree_auth_devise you will need to change this
line in `config/initializers/spree.rb`:

```ruby
Spree.user_class = "Spree::LegacyUser"
```

To this:

```ruby
Spree.user_class = "Spree::User"
```

You can avoid running migrations or generating seed and sample data by passing
in these flags:

```shell
rails g spree:install --migrate=false --sample=false --seed=false
```

You can always perform the steps later by using these commands.

```shell
bundle exec rake railties:install:migrations
bundle exec rake db:migrate
bundle exec rake db:seed
bundle exec rake spree_sample:load
```

Browse Store
------------

http://localhost:nnnn

Browse Admin Interface
----------------------

http://localhost:nnnn/admin



Working with the edge source (latest and greatest features)
-----------------------------------------------------------

The source code is essentially a collection of gems. Spree is meant to be run
within the context of Rails application. You can easily create a sandbox
application inside of your cloned source directory for testing purposes.


1. Clone the Git repo

```shell
git clone git://github.com/spree/spree.git
cd spree
```

2. Install the gem dependencies

```shell
bundle install
```

3. Create a sandbox Rails application for testing purposes (and automatically
perform all necessary database setup)

```shell
bundle exec rake sandbox
```

4. Start the server

```shell
cd sandbox
rails server
```

Performance
-----------

You may notice that your Spree store runs slowly in development mode.  This is
a side-effect of how Rails works in development mode which is to continuously reload
your Ruby objects on each request.  The introduction of the asset pipeline in
Rails 3.1 made default performance in development mode significantly worse. There
are, however, a few tricks to speeding up performance in development mode.

You can precompile your assets as follows:

```shell
bundle exec rake assets:precompile:nondigest
```

If you want to remove precompiled assets (recommended before you commit to Git
and push your changes) use the following rake task:

```shell
bundle exec rake assets:clean
```

Use Dedicated Spree Devise Authentication
-----------------------------------------
Add the following to your Gemfile

```ruby
gem 'spree_auth_devise', github: 'spree/spree_auth_devise'
```

Then run `bundle install`. Authentication will then work exactly as it did in
previous versions of Spree.

This line is automatically added by the `spree install` command.

If you're installing this in a new Spree 1.2+ application, you'll need to install
and run the migrations with

```shell
bundle exec rake spree_auth:install:migrations
bundle exec rake db:migrate
```

change the following line in `config/initializers/spree.rb`
```ruby
Spree.user_class = 'Spree::LegacyUser'
```
to
```ruby
Spree.user_class = 'Spree::User'
```

In order to set up the admin user for the application you should then run:

```shell
bundle exec rake spree_auth:admin:create
```

Running Tests
-------------

[![Team City](http://www.jetbrains.com/img/logos/logo_teamcity_small.gif)](http://www.jetbrains.com/teamcity)

We use [TeamCity](http://www.jetbrains.com/teamcity/) to run the tests for Spree.

You can see the build statuses at [http://ci.spree.fm](http://ci.spree.fm/guestLogin.html?guest=1).

---

Each gem contains its own series of tests, and for each directory, you need to
do a quick one-time creation of a test application and then you can use it to run
the tests.  For example, to run the tests for the core project.
```shell
cd core
bundle exec rake test_app
bundle exec rspec spec
```

If you would like to run specs against a particular database you may specify the
dummy apps database, which defaults to sqlite3.
```shell
DB=postgres bundle exec rake test_app
```

If you want to run specs for only a single spec file
```shell
bundle exec rspec spec/models/state_spec.rb
```

If you want to run a particular line of spec
```shell
bundle exec rspec spec/models/state_spec.rb:7
```

You can also enable fail fast in order to stop tests at the first failure
```shell
FAIL_FAST=true bundle exec rspec spec/models/state_spec.rb
```

If you want to run the simplecov code coverage report
```shell
COVERAGE=true bundle exec rspec spec
```

If you're working on multiple facets of Spree, you may want
to run this command at the root of the Spree project to
generate test applications and run specs for all the facets:
```shell
bash build.sh
```

Further Documentation
------------
Spree has a number of really useful guides online at [http://guides.spreecommerce.com](http://guides.spreecommerce.com). 

Contributing
------------

Spree is an open source project and we encourage contributions. Please see the
[contributors guidelines](http://spreecommerce.com/documentation/contributing_to_spree.html)
before contributing.
