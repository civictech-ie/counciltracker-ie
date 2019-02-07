# README

This runs [counciltracker.ie](https://www.counciltracker.ie) which tracks and publishes the motions, amendments, and votes of Dublin City councillors. It's a fairly straightforward Rails app with a few little hacks to speed up the annoying data entry involved in keeping this up to date. It needs more documentation and test coverage!

## Get set up

        $ bundle
        $ rake db:create
        $ rake db:migrate
        $ rake db:seed

Customise the environmental variables:

        $ cp .env.sample .env

The app assumes you're using S3 for storing councillor portraits, but if you're not you can edit `/config/initializers/carrierwave.rb` to store images somewhere else.

I use Foreman to run things locally:

        $ foreman start

I have this set up for deployment on Heroku. But you can deploy it elsewhere, I bet.

## Some notes

This code exists to run counciltracker.ie and would need some amount of rejiggering to work for other councils or bodies. I'm not maintaining it as an open-source project, but you're most welcome to take the code and use it for ... whatever. If you add a feature we might find useful, I welcome pull requests.

## Contact

Email me at [brian@elbow.ie](mailto:brian@elbow.ie) and I'd be happy to answer any questions.

## License

[Apache 2.0](LICENSE)