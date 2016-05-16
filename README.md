# my_dashboard

[![Code Climate](https://codeclimate.com/github/danilovaz/my_dashboard.png)](https://codeclimate.com/github/danilovaz/my_dashboard)
[![Coverage Status](https://coveralls.io/repos/danilovaz/my_dashboard/badge.png?branch=master)](https://coveralls.io/r/danilovaz/my_dashboard?branch=master)
[![Build Status](https://travis-ci.org/danilovaz/my_dashboard.png?branch=master)](https://travis-ci.org/danilovaz/my_dashboard)
[![Dependency Status](https://gemnasium.com/danilovaz/my_dashboard.svg)](https://gemnasium.com/danilovaz/my_dashboard)

my_dashboard is the Rails Engine version of [Dashing by Shopify](http://shopify.github.io/dashing/) who **uses flexbox** instead [gridster](http://gridster.net/). This is totally inspired by [Dashing-Rails](https://github.com/gottfrois/dashing-rails).
A huge thanks to Shopify and [Pierre-Louis Gottfrois](https://github.com/gottfrois) for their great work.

<img src="https://dl.dropboxusercontent.com/u/29838807/dashing-rails.png" width="600" />

## Introduction

my_dashboard is a Rails engine that lets you build beautiful dashboards with  [flexbox]().

Check out our demo over [here]().

Key features:

* Use premade widgets, or fully create your own with scss, html, and javascript.
* Dashboards tottally responsive's using all the power of FlexBox.
* Widgets harness the power of data bindings to keep things DRY and simple. Powered by batman.js.
* Use the API to push data to your dashboards, or make use of a simple ruby DSL for fetching data.
* Drag & Drop interface for re-arranging your widgets.
* Host your dashboards on Heroku in less than 30 seconds.

## Requirements

* Ruby >=1.9.3
* Rails 4
* Redis
* Multi Threaded server ([puma](https://github.com/puma/puma), [rainbows](http://rainbows.rubyforge.org/))


## Getting Started

1. Install the gem by adding the following in your `Gemfile`:

  ```ruby
  gem 'my_dashboard'
  ```

2. Install puma server by adding the following in your `Gemfile`:

  ```ruby
  gem 'puma'
  ```

3. Bundle install

  ```
  $ bundle
  ```

4. Install the dependencies using the following command:

  ```
  $ rails g my_dashboard:install
  ```

5. Start redis server:

  ```
  $ redis-server
  ```

6. Open `config/environments/development.rb` and add:

  ```ruby
  config.allow_concurrency = true
  ```

7. Start your server (must be a multi threaded server - See [Requirements](https://github.com/danilovaz/my_dashboard#requirements))

  ```
  $ rails s
  ```

8. Point your browser at [http://localhost:3000/my_dashboard/dashboards](http://localhost:3000/my_dashboard/dashboards) and have fun!


**Important Note:** *We need to update the configuration in development to handle multiple requests at the same time. One request for the page we’re working on, and another request for the Server Sent Event controller.*

- - -

Every new my_dashboard project comes with sample widgets & sample dashboards for you to explore. The directory is setup as follows:

* `app/views/my_dashboard/dashboards` — One .erb file for each dashboard that contains the layout for the widgets.
* `app/jobs` — Your ruby jobs for fetching data (e.g for calling third party APIs like twitter).
* `app/assets/javascripts/my_dashboard/widgets/` — A widget's name `.js` file containing your widget's js.
* `app/assets/stylesheets/my_dashboard/widgets/` — A widget's name `.scss` file containing your widget's css.
* `app/views/my_dashboard/widgets/` — A widget's name `.html` file containing your widget's html.
* `app/views/layouts/my_dashboard/` — All your custom layouts where your dashboards and widgets will be included.

## Getting Data Into Your Widgets

Providing data to widgets is easy. You specify which widget you want using a widget id, and then pass in the JSON data. There are two ways to do this:

### Jobs

my_dashboard uses [rufus-scheduler](http://rufus.rubyforge.org/rufus-scheduler/) to schedule jobs. You can make a new job with `rails g my_dashboard:job sample_job`, which will create a file in the jobs directory called `sample_job.rb`.

Example:

```ruby
# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
MyDashboard.scheduler.every '1m', first_in: 1.second.since do |job|
  MyDashboard.send_event('karma', { current: rand(1000) })
end
```

This job will run every minute, and will send a random number to ALL widgets that have `data-id` set to `"karma"`.

You send data using the following method:

```ruby
MyDashboard.send_event(widget_id, json_formatted_data)
```

Jobs are where you put stuff such as fetching metrics from a database, or calling a third party API like Twitter. Since the data fetch is happening in only one place, it means that all instances of widgets are in sync.

[Server Sent Events](http://www.html5rocks.com/en/tutorials/eventsource/basics/) are used in order to stream data to the dashboards.

### Redis

my_dashboard uses [Redis](http://redis.io/) to push and pull data and feed your widgets. Since my_dashboard [Requirements](https://github.com/danilovaz/my_dashboard#requirements) can be quite frustrating, I thought it might be useful to use redis.

This way you can have a seperate Rails 4 application (with puma) running your dashboards and push your data to redis from your main Rails 3 application for example.

You can specify my_dashboard redis credentials in `config/initializers/my_dashboard.rb`:

```ruby
config.redis_host     = '127.0.0.1'
config.redis_port     = '6379'
config.redis_password = '123456'
```

By default my_dashboard subscribed to the following namespace in redis:

```
my_dashboard_events.*
```

where `*` can be anything. This give you all the flexibility you need to push to redis. For example the `send_event` method provided by my_dashboard uses the following namespace:

```ruby
redis.publish("my_dashboard_events.create", {})
```

You can configure the redis namespace in `config/initializers/my_dashboard.rb`:

```ruby
config.redis_namespace = 'your_redis_namespace'
```

### API

#### Widgets

Your widgets can be updated directly over HTTP. Post the data you want in json to `/my_dashboard/widgets/widget_id`. For security, you will also have to include your `auth_token` (which you can generate in `config/initializers/my_dashboard.rb`).

Example:

```
curl -X PUT http://localhost:3000/my_dashboard/widgets/welcome -d "widget[text]=my_dashboard is awesome"
```

or

```
curl -X PUT http://localhost:3000/my_dashboard/widgets/karma -d "widget[current]=100" -d "auth_token=YOUR_AUTH_TOKEN"
```

or

```ruby
HTTParty.post('http://localhost:3000/my_dashboard/widgets/karma',
  body: { auth_token: "YOUR_AUTH_TOKEN", current: 1000 }.to_json)
```

#### Dasboards

The `reload` action provided by [Shopify Dashing](http://shopify.github.io/dashing/) is currently not available.

## Create a new Widget

In order to create or add a custom widget to my_dashboard, simply follow the following steps:

1. Run `$ rails g my_dashboard:widget my_widget`

2. Edit `app/views/my_dashboard/widgets/my_widget.html`

3. Edit `app/assets/javascripts/my_dashboard/widgets/my_widget.js`

4. Edit `app/assets/stylesheets/my_dashboard/widgets/my_widget.scss`

## Additional Resources

Check out the [wiki](https://github.com/danilovaz/my_dashboard/wiki) for interesting tips such as hosting on Heroku, adding authentication or adding custom widgets.

## Browser Compatibility

Tested in Chrome, Safari 6+, and Firefox 15+.

Does not work in Internet Explorer because it relies on [Server Sent Events](http://www.html5rocks.com/en/tutorials/eventsource/basics/).

## Contributors

* [Shopify Dashing contributors](https://github.com/Shopify/dashing/graphs/contributors)
* [Dashing-rails contributors](https://github.com/gottfrois/dashing-rails/contributors)
* [my_dashboard contributors](https://github.com/danilovaz/my_dashboard/contributors)


Special thanks to [Pierre-Louis Gottfrois](https://github.com/gottfrois) for his [Dashing-rails](https://github.com/gottfrois/dashing-rails).

All contributions are more than welcome; especially new widgets with supports for flexbox and responsive.

Please add spec to your Pull Requests and run them using: ```$ rake```

## License

my_dashboard is released under the [MIT license](https://github.com/danilovaz/my_dashboard/blob/master/MIT-LICENSE)
