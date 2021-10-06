## 1.3.3

* chore: update statistics for October 2021

## 1.3.2

* Update the URLs and names of the data sources for the WDPA and WD-0ECM layers that are being pulled from ArcGis. Bug of them not displaying is now fixed.

## 1.3.1

* correctly merge develop into release and re-release

## 1.3.0

* chore: add `/TAGS` to .gitignore
* chore: upgrade puma from 3.7 ~> 4.3
* fix: add missing "`WHERE geo_entities.iso3 IS NOT NULL`" to *countries* scope in `geo_entity.rb` and "`WHERE geo_entities.iso3 <> 'GBL'`" to *country_stats* scope in `geo_entity_stat.rb`
* fix: change global protection stats to be static within habitats table, as there was a problem with the automatic generation of global stats not including non-member state data yet.
* refactor: partially automate country last-updated by using the geo_entity's `updated_at` property
* refactor: set Red List last updated date (`@red_list_last_updated`) in site & countries controller
* feat: add rake invoke task to deploy.rb so that you can run any specified rake task before the deploy is published e.g. `bundle exec cap staging deploy TASK=import:refresh`
* feat: add `BRANCH=` option `cap staging deploy` so you can specify the branch to deploy to staging (default to develop)
* refactor: raise more informative exception in Esri class if the response is not what was expected
* feat: add utilities/files.rb with `latest_file_by_glob` method to help select the latest filename-timestamped CSV that is used in the _habitat coverage protection_ imports
* refactor: add more informative error when a CSV is missing an expected header
* fix: wrap _import:refresh_ within a DB transaction so that it doesn't commit anything on failure

## 1.2.0

* RSpec + Capybara test suite created, with unit tests for statistics, request specs and 
system specs. Also included is a FactoryBot linter for linting factories. A couple of
redundant methods have also been removed from the models.
* Merged in a number of PRs fixing vulnerabilities on the frontend and backend that were 
opened by Dependabot.

## 1.1.0

* Revamp importers to delete and recreate Habitat instances, as well as during seeds
  to avoid duplication of Habitats
* Use correct name for global_statistics zip on the homepage for purposes of GA tracking
* Revert emergency hotfixes

## 1.0.0

**Ocean+ Habitats refresh**

* Site refresh including underlying data and frontend
* Features individual country pages as well as global overview

## 0.0.1

**Ocean+ Habitats first release**

* Full user journey implementation
* Dyanimic charts
* Mapbox map with WDPA Carto layer and ArcGIS habitats layers
* Import static stats from file
