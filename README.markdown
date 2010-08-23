# Nebula

Nebula is a proposal management system for the Council of Stellar Management, the player-elected stakeholder in EVE Online. It takes the form of a Ruby on Rails based hosted web application. It is entirely open source.

The general idea is to make proposals easier to track, create, amend, categorize, find/search (as a player or CSM member), and to permit clearer communication about proposals from the CSM/CCP back to the players.

## Getting Involved

It is highly recommended to join irc.coldfront.net, channels #excellence and #eve-dev, and catch the devs in there to discuss getting involved before you just dive into the code.

However, all are welcome to do so as long as they are vaugely technically competent and able to follow some specifications. Since we are developing software for the CSM, we are in constant communication with some of the current and past delegates, who contribute by providing feedback on the specifications and proposed changes to the existing specs. Drop into IRC - you'll run into a few of them amongst the devs.

## Development

Nebula is openly developed and planned. The requirements for developing Nebula are:

* Ruby 1.9.1 (or later recommended; should work with 1.8.7)
* Rails 2.3.8
* Linux/OSX development environments, Windows not supported
* Redis server (will run on anything POSIX compliant, used by Resque job queue)
* PostgreSQL or MySQL database server

### Getting Started with Nebula

You need Ruby. This is most easily installed from source on Linux, or using a package manager if you so choose.

You need Redis, which is easily installed with a package manager or from source. Default configuration options should work fine.

You'll need your database server of choice, and the appropriate gem for connecting to it- that's `sudo gem install pg` for PostgreSQL, or `sudo gem install mysql` for MySQL.

To develop for Nebula you'll also need to install some other gems. You'll have to install bundler first:

    sudo gem install bundler
  
Then you can just let it do the work for you:

    sudo bundle install
  
You'll need to create a file, `config/initializers/encryption.rb`, which has the following line:

    API_KEY_ENCRYPTION_KEY = 'LOADS OF GIBBERISH (rake secret can generate some)'
  
This key is used to encrypt all stored API keys. Store the file securely! Do not lose it or you will lose all keys in the DB!
  
This should install all the gems you need in your system gems.

Production environments can be set up using:

    sudo bundle install --without development test

### Testing Nebula

Nebula uses test driven development. To run the tests and see what passes and what fails, run `rake spec`. This will run all the specs in the spec folder, and produce output in rspec.html in the root directory of the project.

If you commit to the Nebula main repository, your build will be executed by the continuous integration server, and build output displayed in the aforementioned IRC channel.