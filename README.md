# Ocean+ Habitats

[![codecov](https://codecov.io/gh/unepwcmc/ocean-plus-habitats/branch/main/graph/badge.svg?token=VE88OFJS5F)](https://codecov.io/gh/unepwcmc/ocean-plus-habitats)

## Setup

* Install and configure dependencies
  - `bundle install`
  - `yarn install`
  - Obtain latest `.env` file from Lastpass

* Setup database
  - `bundle exec rake db:drop db:create db:migrate`
  - `bundle exec rake db:seed`

* If you simply want to regenerate your statistics, you don't have to drop your database. Just run `rake import:refresh` instead.

## Data

We are still trying to see if it is feasible to generate map tiles and data dynamically using Carto and in the meantime we are using static data.

Data is fetched from CartoDB using the `Carto` module defined in `lib/modules`.
Some details about the layers in Carto are in `config/habitats.yml`.

At the moment static data is provided related to the protected areas coverage.
Ideally, the protected areas coverage data should always be dynamically generated, as this depends on the WDPA release
which is updated every month.

Habitats data changes less often, so the coverage calculations are stored in the `Habitat` object.
When the data changes, a new calculation process should be performed using the `calculate_global_coverage` method in
the `Habitat` model.

Old coverage data is stored within `lib/data/countries` for the various habitats. The new coverage data can be found within
`lib/data/habitat_coverage_protection/<habitat>_country_output.csv` 

Redlist data for the various species is store in `lib/data/iucn_redlist`. If you need to update just the occurrences of each
species run `rake import:occurrences`.

## Testing

Testing is done with RSpec and FactoryBot. To run all tests, run `bundle exec rspec` 

To lint your factories, run `rake factory_bot:lint`

## CSV downloads

- Generating zip downloads of CSVS for habitat statistics in each country, can be done simply via `rake generate:national_csvs`, which are dumped into `public/downloads/national` and are labelled according to their ISO3 code. 
- Global statistics are provided as a prefab zip in the same folder

## Statistics updates

### High level update overview

1. Pull latest from `main` and ensure `develop` up to date with `main`.
2. Checkout your stats update branch e.g. `git checkout -b chore/update-statistics-2022-01` from `develop`.
3. Pull in *country* stats to `lib/data/habitat_coverage_protection/country/*.csv`.
4. Check CSV formatting is correct, especially headers.
5. Update `habitats.yml` with `total_area` and `protected_area` from *global* stats.
6. Check whether you need to do anything else with O+ team.
7. Check the documentation is still relevant, and update if neccessary.
8. Commit everything and push to GitHub. Then create a PR and review it yourself for any mistakes.
9. Merge your update into develop.
10. Pull down your merge from develop and return to develop branch.
11. Checkout a release branch e.g. `git checkout -b release-1.4.2`
12. Update the `CHANGELOG.md` following previous examples of format.
13. Commit and push to GitHub.
14. Return to `main` and merge release into main e.g. `git merge --no-ff release-1.4.2`.
15. Push to GitHub.
16. Go to GitHub releases and [draft a new release ](https://github.com/unepwcmc/ocean-plus-habitats/releases/new).
17. Come back to terminal and deploy with pre-deploy task for habitat stats refresh e.g. `bundle exec cap production deploy TASK=import:refresh`.
18. That's it, you're done. But [go and check everything is working](http://ocean-plus-habitats.web-supported-production.linode.unep-wcmc.org/).

### Low-level overview

The current procedure for updating statistics is as follows:

* Obtain the global and country statistics from the Ocean Plus Habitats team.
* Ensure the country statistics CSVs conform to the format: `<habitat-type><plural-modifier>_country_output_<YYYY>-<MM>-01.csv`.
I.e. ensure that the match the current format within `lib/data/habitat_coverage_protection/country/*.csv`.

:sos:

###### If received over Slack, you can quickly save to the simplest location on disk possible (as there is currently no "download all") and then move all by command line e.g. `mv ~/Desktop/*country*01-01.csv lib/data/habitat_coverage_protection/country/`.

* In each CSV, check that the columns are correct and that the data format appears to be the same according to previous months.
Most commonly, you will need to rename `"iso3"` to `"iso3"` as the ISO column in each CSV.

As of writing, the global statistics needs to be copied in from each CSV provided into the corresponding habitat within `config/habitats.yml`.
Previously, this data would have been calculated automatically based on the country statistics. But due to inaccuracies
caused (perhaps) by borders and non-national areas not being included within the counts, we currently depend on the data
being made available in the habitats YAML file.

* Copy in the `total_area` and `protected_area` from each CSV into each habitat in `config/habitats.yml`.

* Finally, update the `CHANGELOG.md` with a minor version increment e.g. `1.3.4` -> `1.3.5`. Add a suitable line within
the file to describe changes that have been applied in this release. Be sure to check whether any commits have since
been made that will become part of `main` that might be included in this release. If that is so, then you may need to
figure out the most appropriate version, and add further change notes.

That is everything. If you are working from main, then make sure you `git checkout -b chore/update-statistics-<YYYY>-<MM>`
and `git push origin <name of branch>`. 

* Push the changes, (hopefully from a chore branch) to origin, do a self-review and merge them into `main`.
* [Create a new release](https://github.com/unepwcmc/ocean-plus-habitats/releases/new) via Github and copy the format of
previous releases. The version starts with `v` and the title does not. 

Once everything is complete, you are ready to deploy. We will deploy using TASK hook to trigger the `import:refresh`
task before finishing the deployment. The reason we do this is to ensure that statistics do not change if the deployment
fails for some reason. The deployment TASK hook has this functionality.

* Ensure you have the latest `main` with `git checkout main; git pull origin main`
* Deploy with `bundle exec cap production deploy TASK=import:refresh`

## Update Redlist species timestamp

To update the timestmap, just run `bundle exec rake import:update_redlist_timestamp`
on the server. You can also run `bundle exec cap production deploy TASK=import:update_redlist_timestamp`
to do this from your own machine, but it will include a new deploy.
