## v1.0.0

### Break Change

- The attributes `estimate` and `average` now is rounded by two decimal numbers;

### Updates

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
