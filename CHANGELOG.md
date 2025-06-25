## 1.4.17

* Update "eez_map_datasets_serializer.rb" to fix the WMS 'mangrove' => 'Mangrove_Protection' rather than 'Mangrove_Projection'

## 1.4.16

* Update the statistics download folder for May 2025.
* Update global and country habitat stats for 2025-05 period.
* Update the README about Carto decommissioned

## 1.4.15

* Display banner to explain divestment of other related products

## 1.4.14

* Hide the banner

## 1.4.13

* Update the statistics download folder for March 2025.
* Update global and country habitat stats for 2025-03 period.

## 1.4.12

* Update the statistics download folder for Dec 2024.
* Update global and country habitat stats for 2024-12 period.

## 1.4.11

* Update the statitics download folder for Nov 2024.
* Update global and country habitat stats for 2024-11 period.
* Update "eez_map_datasets_serializer.rb" to fix the WMS 'seagrasses' (plural) => 'Seagrasses_Projection' rather than 'seagrass' (singular)

## 1.4.10

* Update the statitics download folder for Nov 2023.
* update Readme for updating the global_statistics file.

## 1.4.9

* Update global and country habitat stats for 2023-11 period.

## 1.4.8

* Update global and country habitat stats for 2023-07 period.

## 1.4.7

* Update global and country habitat stats for 2023-02 period.

## 1.4.6

* Update global and country habitat stats for 2022-08 period.

## 1.4.5

* Update stats for IUCN Red List for 2022/06.

## 1.4.4

* Update global and country habitat stats for 2022-05 period.

## 1.4.3

* Update docs to correct path to country habitat stats (again).
* Update global and country habitat stats for 2022-04 period.

## 1.4.2

* Update docs to correct path to country habitat stats.
* Update global and country habitat stats for 2022-01 period.

## 1.4.1

* Do not automatically update the Redlist species timestamp.
* Add docs in readme on how to trigger a timestamp update.

## 1.4.0

* Automate update of Redlist Species last updated timestamp by using a dotfile
stored in the `tmp` directory. Defaults to the last known manual update Oct 2021
if not present.

The file is touched with `RedlistSpeciesLastUpdated.touch!` after the
`import_new_redlist_data` Rake task is completed.

If a deployment fails, there is a chance that this might be touched prematurely.
There is currently no way to automatically revert this if such an event occurs.
But we think it's negligible.

* Rename the variable used for the last updated formatted date.
* Update the docs for the statistics instructions to convey that the country
statistics CSVs' filename should be checked against the specified format.

## 1.3.7

* Adjust value of Dial total_value so that it does not show
zero for a value that is less than 0.1

## 1.3.6

* Correct filenames for the habitat country CSVs - must be plural.
* Update documentation to specify plural in CSV more clearly.

## 1.3.5

* Update the documentation to detail how to do a statistics update.

## 1.3.4

* chore: update statistics for December 2021

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
