## Description
This scraper is written using ActiveRecord to make it more minimalistic and concise.
It can scrape any kind of information you want about all real estate in section.

I've used:
* SQLite as NoSQL storage(with JSON field)
* [Watir](https://github.com/watir/watir) for parsing JS logic
* [ruby-tesseract-ocr](https://github.com/meh/ruby-tesseract-ocr) to decode phone numbers from base64

## Setup
* `bundle`
* `pry app/avito_scraper.rb sync`

## XSLX
![xslx](https://i.imgur.com/lcB7oGA.png)
