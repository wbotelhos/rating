# Rating

[![Build Status](https://travis-ci.org/wbotelhos/rating.svg)](https://travis-ci.org/wbotelhos/rating)
[![Gem Version](https://badge.fury.io/rb/rating.svg)](https://badge.fury.io/rb/rating)
[![Maintainability](https://api.codeclimate.com/v1/badges/cc5efe8b06bc1d5e9e8a/maintainability)](https://codeclimate.com/github/wbotelhos/rating/maintainability)
[![Patreon](https://img.shields.io/badge/donate-%3C3-brightgreen.svg)](https://www.patreon.com/wbotelhos)

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

author.rate resource, 3
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

All rating received.

```ruby
Article.first.rates
```

It will return a collection of `Rate` object.

### rated

All rating given.

```ruby
Author.first.rated
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
author.rate resource, 3, scope: category_1
author.rate resource, 5, scope: category_2
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

### Extra Scopes

Maybe you need to use more than one scope to make a rate, so you can use the `extra_scopes` options.
This feature is enable **only** to restrict the rate, the rating calculation will **ignore** it.

Example situation: I have a Profile (resource) that belongs to some Category (scope) and the Client (author) will rate
this Profile based on each Lead (extra scope) this Profile made. The Client can vote just one time on each lead, but many
times to that Profile. The Profile has a rating score based on all leads made on that Category.

```ruby
scope    = Category.first
author   = Client.last
resource = Profile.last
lead     = Lead.last

author.rate resource, 5, extra_scopes: { lead_id: lead.id }, scope: scope
```

* The extra scopes fields is not present into gem, so you cannot use `{ lead: lead }`, for example.

All methods listed on [Scope](#scope) session allows `extra_scopes` as additional condition too.

### Records

Maybe you want to recover all records with or without scope, so you can add the suffix `_records` on relations:

```ruby
category_1 = Category.first
category_2 = Category.second
author     = Author.last
resource   = Article.last

author.rate resource, 1
author.rate resource, 3, scope: category_1
author.rate resource, 5, scope: category_2

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

### Metadata

Maybe you want include a `comment` together your rating or even a `fingerprint` field to make your rating more secure.
So, first you will need to add more fields to the `Rating::Rate` table:

```ruby
class AddCommentAndFingerprintOnRatingRates < ActiveRecord::Migration
  def change
    add_column :rating_rates, :comment, :text

    add_reference :rating_rates, :fingerprint, foreign_key: true, index: true, null: false
  end
end
```

As you can seed, we can add any kind of field we want. Now we just provide this values when we make the rate:

```ruby
author      = Author.last
resource    = Article.last
comment     = 'This is a very nice rating. s2'
fingerprint = Fingerprint.new(ip: '127.0.0.1')

author.rate resource, 3, metadata: { comment: comment, fingerprint: fingerprint }
```

Now you can have this data into your model normally:


```ruby
author = Author.last
rate   = author.rates.last

rate.comment     # 'This is a very nice rating. s2'
rate.fingerprint # <Fingerprint id:...>
rate.value       # 3
```

### Scoping

If you need to warm up a record with scope, you need to setup the `scoping` relation.

```ruby
class Resource < ApplicationRecord
  rating scoping: :categories
end
```

Now, when a resource is created, the cache will be generated for each related `category` as `scopeable`.

### Table Name

You can choose the table where Rating will write the data via YAML config.
You should just to provide a `config/rating.yml` file with the following content:

```yml
rating:
  rate_table: reviews
  rating_table: review_ratings
```

Now the rates will be written on `reviews` table over `rating_rates` and calculation will be on `review_ratings` over `rating_ratings`.
You can change one table o both of them.

### Validations

#### Rate Uniqueness

Since you can to use [Extra Scopes](#extra_scopes) to restrict rates and the original model `Rating::Rate` is inside gem, you can configure the uniqueness validation, from outside, to include this extra scopes.

```yml
rating:
  validations:
    rate:
      uniqueness:
        case_sensitive: false

        scope:
          - author_type
          - resource_id
          - resource_type
          - scopeable_id
          - scopeable_type
          - scope_1
          - scope_2
```

### Unscoped Rating

All rating values are grouped by its own scope, but you can disable it and group all of them together.

```ruby
rating unscoped_rating: true

author   = User.last
resource = Article.last
scope    = Category.last

author.rate resource, 1, scope: scope
author.rate resource, 2, scope: scope
author.rate resource, 3
```

Now the `sum` will be `6` and the `total` will be `3` because all rating will be calculated into just one rating record ignoring the `scopeable` object.
The rating record is *always* saved on the record with `scopeable` as `nil`.

### where

The `where` option can be used to filter the `Rating::Rate` records used to create the final `Rating::Rating`. You can filter only approved rates, for exemplo:

```ruby
rating where: 'approved = true'

author   = User.last
resource = Article.last

author.rate resource, 1, extra_scope: { approved: false }
author.rate resource, 5, extra_scope: { approved: true }
```

As you can see, now, only the rate with value `5` will be included on the final rating.

### References

- [Evan Miller](http://www.evanmiller.org/ranking-items-with-star-ratings.html)
