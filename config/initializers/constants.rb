# Limit country and territory pages that can be seen in the dropdown, to just actual countries, 
# i.e. member states, which is what this CSV contains
# Subsequently going through each row and then extracting out the ISO3 code of each country
ALLOWED_COUNTRIES = CSV.read('lib/data/countries.csv', headers: true).map do |row|
  row.to_hash.values.first if row.to_hash['STATUS'] == 'Member State'
end