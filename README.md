# Ocean+ Habitats

## Setup

* Install and configure dependencies
  - `bundle install`
  - `yarn install`
  - Please ask for latest `.env` file

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