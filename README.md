# README

This runs [counciltracker.ie](https://www.counciltracker.ie) which tracks and publishes the motions, amendments, and votes of Dublin City councillors. It's a fairly straightforward Rails app with a few little hacks to speed up the annoying data entry involved in keeping this up to date. It needs more documentation and test coverage!

## Get set up

Setting up the database and running `rake db:seed` will provide CouncilTracker with the composition of Dublin City Council as of February 2019 (councillors, party affiliations, etc).

        $ bundle
        $ rake db:create
        $ rake db:migrate
        $ rake db:seed

Customise the environmental variables:

        $ cp .env.sample .env

The app assumes you're using S3 for storing councillor portraits, but if you're not you can edit `/config/initializers/carrierwave.rb` to store images somewhere else.

Start Foreman:

        $ foreman start

And visit `http://localhost:5000/`

I have this set up for deployment on Heroku. But you can deploy it elsewhere, I bet.

## Some notes

This code exists to run counciltracker.ie and would need some amount of rejiggering to work for other councils or bodies. I'm not actively maintaining it as an open-source project, but you're most welcome to take the code and use it for ... whatever. If you add a feature we might find useful, I welcome pull requests.

One thing I'd love to do is abstract out the councillors/events into a separate Pobal-like service.

## Contact

Email me at [brian@civictech.ie](mailto:brian@civictech.ie) and I'd be happy to answer any questions.

## License

[Apache 2.0](LICENSE)