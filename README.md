# Rating

[![Build Status](https://travis-ci.org/wbotelhos/rating.svg)](https://travis-ci.org/wbotelhos/rating)
[![Gem Version](https://badge.fury.io/rb/rating.svg)](https://badge.fury.io/rb/rating)
[![Maintainability](https://api.codeclimate.com/v1/badges/cc5efe8b06bc1d5e9e8a/maintainability)](https://codeclimate.com/github/wbotelhos/rating/maintainability)
[![LiberPay](https://img.shields.io/badge/donate-%3C3-brightgreen.svg)](https://liberapay.com/wbotelhos)

A true Bayesian rating system with scope and cache enabled.

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
class Author < ApplicationRecord
  rating
end
```

Now this model can vote or receive votes.

### rate

You can vote on some resource:

```ruby
author   = Author.last
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
author   = Author.last
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
author   = Author.last
resource = Article.last

author.rated? resource
```

### rates

You can retrieve all rates received by some resource:

```ruby
resource = Article.last

resource.rates
```

It will return a collection of `Rate` object.

### rated

In the same way you can retrieve all rates that some author received:

```ruby
author = Author.last

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

### Scope

All methods support scope query, since you may want to vote on items of a resource instead the resource itself.
Let's say an article belongs to one or more categories and you want to vote on some categories of this article.

```ruby
category_1 = Category.first
category_2 = Category.second
author     = Author.last
resource   = Article.last
```

In this situation you should scope the vote of article with some category:

**rate**

```ruby
author.rate resource, 3, scopeable: category_1
author.rate resource, 5, scopeable: category_2
```

Now `resource` has a rating for `category_1` and another one for `category_2`.

**rating**

Recovering the rating values for resource, we have:

```ruby
resource.rating
# nil
```

But using the scope to make the right query:

```ruby
resource.rating scope: category_1
# { average: 3, estimate: 3, sum: 3, total: 1 }

resource.rating scope: category_2
# { average: 5, estimate: 5, sum: 5, total: 1 }
```

**rated**

On the same way you can find your rates with a scoped query:

```ruby
author.rated scope: category_1
# { value: 3, scopeable: category_1 }
```

**rates**

The resource still have the power to consult its rates:

```ruby
article.rates scope: category_1
# { value: 3, scopeable: category_1 }

article.rates scope: category_2
# { value: 3, scopeable: category_2 }
```

**order_by_rating**

To order the rating you do the same thing:

```ruby
Article.order_by_rating scope: category_1
```

### Records

Maybe you want to recover all records with or without scope, so you can add the suffix `_records` on relations:

```ruby
category_1 = Category.first
category_2 = Category.second
author     = Author.last
resource   = Article.last

author.rate resource, 1
author.rate resource, 3, scopeable: category_1
author.rate resource, 5, scopeable: category_2

author.rating_records
# { average: 1, estimate: 1, scopeable: nil       , sum: 1, total: 1 },
# { average: 3, estimate: 3, scopeable: category_1, sum: 3, total: 1 },
# { average: 5, estimate: 5, scopeable: category_2, sum: 5, total: 1 }

author.rated_records
# { value: 1 }, { value: 3, scopeable: category_1 }, { value: 5, scopeable: category_2 }

article.rates_records
# { value: 1 }, { value: 3, scopeable: category_1 }, { value: 5, scopeable: category_2 }
```

### As

If you have a model that will only be able to rate but not to receive a rate, configure it as `author`.
An author model still can be rated, but won't genarate a Rating record with all values as zero to warm up the cache.

```ruby
rating as: :author
```

## Love it!

Via [PayPal](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=X8HEP2878NDEG&item_name=rating) or [Gratipay](https://gratipay.com/rating). Thanks! (:
