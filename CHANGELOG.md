## v2.0.0

### Break Changes

- Ruby 3.0, and 3.1 and 3.2 are no longer supported. The minimum Ruby version is now 3.3;
- The `estimate` field is now computed via Evan Miller's lower bound of the confidence interval
  (https://www.evanmiller.org/ranking-items-with-star-ratings.html) instead of the previous weighted
  Bayesian average. The new formula uses the full vote distribution (not just the mean), so it ranks
  consistent ratings above polarized ones with the same mean, and items with few votes below items
  with many votes;
- The `estimate` and `average` columns increased from `DECIMAL(11, 2)` to `DECIMAL(12, 8)`. Existing
  apps must run a manual upgrade migration:

  ```ruby
  class UpgradeRatingPrecision < ActiveRecord::Migration[7.0]
    def change
      change_column :rating_ratings, :average,  :decimal, precision: 12, scale: 8, default: 0, null: false
      change_column :rating_ratings, :estimate, :decimal, precision: 12, scale: 8, default: 0, null: false
    end
  end
  ```

  After running the migration, the new `estimate` values will be populated on the next vote per
  resource. To force a recalculation now, iterate over your rated resources and call `Rating::Rating.update_rating(resource, scope)`;
- The `.round(2)` previously applied to `estimate` and `average` is removed. Values are stored at
  full column precision. Round at the view layer if needed for display;
- The `Rating::Rate#value` validation changed from `1..100` to `1..Rating::Config.rating_levels`
  (default 5) and now requires an integer. If your app uses a different scale, configure
  `rating_levels` (see below);
- New configuration: `Rating::Config.rating_levels` (default `5`) defines the maximum value of your
  rating scale. `Rating::Config.rating_z_score` (default `1.96`, i.e. 95% confidence) tunes how
  aggressively low-confidence items are penalized in the estimate.

### Bug Fixes

- Fixes #8: `PG::NumericValueOutOfRange` overflow that occurred when a `resource_type` accumulated
  1000+ rates. The new formula does not compute the `total_count / distinct_count` ratio that
  caused the overflow.

### Updates

- Fixes a typo in the migration generator template (`mull: false` → `null: false`);
- The `mysql2` and `pg` gems are no longer transitive dev dependencies of the gem. Contributors
  install only the adapter they need via the Gemfile groups (`bundle install --without mysql` or
  `--without postgres`).

## v1.0.0

### Break Changes

- The attributes `estimate` and `average` now is rounded by two decimal numbers;
- The method `order_by_rating` now receives a hash parameter to avoid scope and so support Ruby 3.2;

## v0.12.0

### News

- Officially Supports Postgres;

### Updates

- Migrates the CI to GitHub Actions;
- This gem does not depends on `git` package anymore;
- Makes this gem requires MFA for security;
- Adds coverage test;
- The method `rated?` now uses a better query;

## v0.11.0

### Updates

- Same rate value hits DB to update metadata.

## v0.10.0

### News

- Add option `where` to be able adds conditions on `Rating::Rate`.

## v0.9.0

### News

- Order index keys of the template the same way Rails does the query;
- Limits the `_type` columns to avoid overflow bytes in DBs like MySQL < 5.7.

### Updates

- Update Ruby to 2.6.5;
- Update ActiveRecord to the last version;

## v0.8.0

### News

- Adds `unscoped_rating` option to calculate the rating by counting all resource records ignoring the scope.

## v0.7.0

### News

- Support to configure `uniqueness` validation via YAML into Rating::Rate model;
- Support multiple scopes via `extra_scopes` option.

### Updates

- Reverts v0.6.0, since we need this validation because we cannot edit the Rate model by ourselves.

## v0.6.0

### Updates

- The author's unique validations were removed to enable custom validations

## v0.5.0

### News

- Adds `rating.yml` config to support changing the tables where Rating will write the data;
- Adds `scoping` option to support generating zero-based rating via scope.

### Updates

- The migration was separated in two to improve troubleshooting. [#1](https://github.com/wbotelhos/rating/pull/1) by [iondrimba](https://github.com/iondrimba)

## v0.4.0

### News

- Adds support to MySQL using decimal over float cast on calculations.

### Updates

- Grows up the decimal precision to enable billion of records count.

## v0.3.0

### News

- The `vote` method now can receive `metadata` to be persisted with vote data.

## v0.2.0

### News

- Scope support to be possible rate item from a resource;
- Author model type where zero rating record is not generated on record creation.

## v0.1.0

- First release.
