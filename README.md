# Fyber API Consumer

Web application which consumes the Fyber Offer API and renders its responses.

Live demo on Heroku: https://infinite-mesa-6047.herokuapp.com/

Ruby 2.0.0 used to develop lib, Ruby on Rails 4.2.0 used as a framework.
RSpec used as a testing framework. VCR use to replay HTTP requests. Webmock to simulate HTTP error responses.

# Params
* uid - mondatory
* pub0 - optional
* page - optional

# Approach

Developed consumer as a lib so it can be extracted to seperate gem.

Each class responsible for one work work.

Signature works only with generating and validating hashkeys

Api class responsible only for transport of data.

Offer class reads data and prepare it for use.

To speedup tests VCR used for replaying requests.

#### Bug found during challenge


