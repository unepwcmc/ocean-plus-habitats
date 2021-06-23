## 0.0.1

**Ocean+ Habitats first release**

* Full user journey implementation
* Dyanimic charts
* Mapbox map with WDPA Carto layer and ArcGIS habitats layers
* Import static stats from file

## 1.0.0

**Ocean+ Habitats refresh**

* Site refresh including underlying data and frontend
* Features individual country pages as well as global overview

## 1.1.0

* Revamp importers to delete and recreate Habitat instances, as well as during seeds
  to avoid duplication of Habitats
* Use correct name for global_statistics zip on the homepage for purposes of GA tracking
* Revert emergency hotfixes

## 1.2.0

* RSpec + Capybara test suite created, with unit tests for statistics, request specs and 
system specs. Also included is a FactoryBot linter for linting factories. A couple of
redundant methods have also been removed from the models.
* Merged in a number of PRs fixing vulnerabilities on the frontend and backend that were 
opened by Dependabot.