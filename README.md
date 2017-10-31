# Rating

[![Build Status](https://travis-ci.org/wbotelhos/rating.svg)](https://travis-ci.org/wbotelhos/rating)
[![Gem Version](https://badge.fury.io/rb/rating.svg)](https://badge.fury.io/rb/rating)

A true Bayesian rating system with cache enabled.

## JS Rating?

This is **Raty**: https://github.com/wbotelhos/raty :star2:

## Description

Rating uses the know as "True Bayesian Estimate" inspired on [IMDb rating](http://www.imdb.com/help/show_leaf?votestopfaq) with the following formula:

```
(WR) = (v ÷ (v + m)) × R + (m ÷ (v + m)) × C
```

**IMDb Implementation:**

`WR`: weighted rating

`R`:  average for the movie (mean) = (Rating)

`v`:  number of votes for the movie = (votes)

`m`:  minimum votes required to be listed in the Top 250

`C`:  the mean vote across the whole report

**Rating Implementation:**

`WR`: weighted rating

`R`:  average for the resource

`v`:  number of votes for the resource

`m`:  average of the number of votes

`C`:  the average rating based on all resources

## Install

Add the following code on your `Gemfile` and run `bundle install`:

```ruby
gem 'rating'
```

Run the following task to create a Rating migration:

```bash
rails g rating:install
```

Then execute the migrations to create the to create tables `rating_rates` and `rating_ratings`:

```bash
rake db:migrate
```

## Usage

Just add the callback `rating` to your model:

```ruby
class User < ApplicationRecord
  rating
end
```

Now this model can vote or be voted.

### rate

You can vote on some resource:

```ruby
author   = User.last
resource = Article.last

author.rate(resource, 3)
```

### rating

A voted resource exposes a cached data about it state:

```ruby
resource = Article.last

resource.rating
```

It will return a `Rating` object that keeps:

`average`: the normal mean of votes;

`estimate`: the true Bayesian estimate mean value (you should use this over average);

`sum`: the sum of votes for this resource;

`total`: the total of votes for this resource.

### rate_for

You can retrieve the rate of some author gave to some resource:

```ruby
author   = User.last
resource = Article.last

author.rate_for resource
```

It will return a `Rate` object that keeps:

`author`: the author of vote;

`resource`: the resource that received the vote;

`value`: the value of the vote.

### rated?

Maybe you want just to know if some author already rated some resource and receive `true` or `false`:

```ruby
author   = User.last
resource = Article.last

author.rated? resource
```

### rates

You can retrieve all rates made by some author:

```ruby
author = User.last

author.rates
```

It will return a collection of `Rate` object.

### rated

In the same way you can retrieve all rates that some author received:

```ruby
author = User.last

author.rated
```

It will return a collection of `Rate` object.

### order_by_rating

You can list resource ordered by rating data:

```ruby
Article.order_by_rating
```

It will return a collection of resource ordered by `estimate desc` as default.
The order column and direction can be changed:

```ruby
Article.order_by_rating :average, :asc
```

It will return a collection of resource ordered by `Rating` table data.

## Love it!

Via [PayPal](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=X8HEP2878NDEG&item_name=rating) or [Gratipay](https://gratipay.com/rating). Thanks! (:
