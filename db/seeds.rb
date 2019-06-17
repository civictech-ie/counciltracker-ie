Event.destroy_all
CouncilSession.destroy_all
Election.destroy_all

# Parties

[ {name: "Sinn Féin", colour_hex: '008800'},
  {name: "Fianna Fáil", colour_hex: '66BB66'},
  {name: "Fine Gael", colour_hex: '6699FF'},
  {name: "Labour Party", colour_hex: 'CC0000'},
  {name: "People Before Profit", colour_hex: '660000'},
  {name: "Green Party", colour_hex: '99CC33'},
  {name: "Solidarity", colour_hex: 'BF2D2E'},
  {name: "United Left", colour_hex: 'FF5555'},
  {name: "Independent", colour_hex: 'EFEFEF'},
  {name: "Social Democrats", colour_hex: '752F8B'},
  {name: "Workers' Party", colour_hex: 'D73D3D'}
].each do |params|
  party = Party.find_or_initialize_by(name: params[:name])
  party.update(params)
end

# Local electoral areas

['Ballyfermot-Drimnagh', 'Ballymun', 'Beaumont-Donaghmede', 'Cabra-Finglas', 'Clontarf', 'Crumlin-Kimmage', 'North Inner City', 'Pembroke-South Dock', 'Rathgar-Rathmines'].each do |local_electoral_area_name|
  LocalElectoralArea.find_or_create_by!(name: local_electoral_area_name)
end

# Election

Election.create_from_date_and_csv!(Date.new(2014,5,23), File.read('./db/election-20140523.csv'))