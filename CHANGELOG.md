## v0.8.0

### News

- Adds `unscoped_rating` option to calculate the rating counting all resource record ignoring the scope.

## v0.7.0

### News

- Support to configure `uniqueness` validation via YAML into Rating::Rate model;
- Support to multiple scopes via `extra_scopes` option.

### Updates

- Reverts v0.6.0, since we need this validation because we cannot edit the Rate model by ourself.

## v0.6.0

### Updates

- The author unique validations was removed to enable custom validations

## v0.5.0

### News

- Adds `rating.yml` config to support to change the tables where Rating will write the data;
- Adds `scoping` option to support to generates zero based rating via scope.

### Updates

- The migrate was separated in two to improve in troubleshoot. (iondrimba)

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
