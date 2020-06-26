# Ocean+ Habitats

## Setup

* Install and configure dependencies
  - `bundle install`
  - `yarn install`
  - Please ask for latest `.env` file

* Setup database
  - `bundle exec rake db:drop db:create db:migrate`
  - `bundle exec rake db:seed`

* Import the static CSV data
  - `bundle exec rake import:regions`
  - `bundle exec rake import:prebakedstats`
  - `bundle exec rake import:redlist_data`
  - `rake import:global_change`

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
