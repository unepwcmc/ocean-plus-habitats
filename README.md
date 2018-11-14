# Ocean+ Habitats

## Setup

* Install and configure dependencies
  - `bundle install`
  - `yarn install`
  - Please ask for latest `.env` file

* Setup database
  - `bundle exec rake db:drop db:create db:migrate`
  - `bundle exec rake db:seed`

## Data

Data is fetched from CartoDB using the `Carto` module defined in `lib/modules`.
Some details about the layers in Carto are in `config/habitats.yml`.

At the moment static data is provided related to the protected areas coverage.
Ideally, the protected areas coverage data should always be dynamically generated, as this depends on the WDPA release
which is updated every month.

Habitats data changes less often, so the coverage calculations are stored in the `Habitat` object.
When the data changes, a new calculation process should be performed using the `calculate_global_coverage` method in
the `Habiat` model.
