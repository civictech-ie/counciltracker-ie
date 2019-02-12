CouncilSession.destroy_all
CouncilSession.create!(commenced_on: Date.new(2014,5,23)) # TODO: elections should _create_ these

# Parties

[ {name: "Sinn Féin", colour_hex: '008800'},
  {name: "Fianna Fáil", colour_hex: '66BB66'},
  {name: "Fine Gael", colour_hex: '6699FF'},
  {name: "Labour Party", colour_hex: 'CC0000'},
  {name: "People Before Profit", colour_hex: '660000'},
  {name: "Green Party", colour_hex: '99CC33'},
  {name: "Anti-Austerity Alliance", colour_hex: 'FFFF00'},
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

Election.destroy_all

Election.create_from_date_and_csv!(Date.new(2014,5,23), File.read('./db/election-20140523.csv'))

Event.uncommitted.order('occurred_on asc').each { |e| e.commit! }

# Changes in Affiliation

ChangeOfAffiliation.create!(
  councillor: Councillor.find_by!(full_name: 'Éilis Ryan'),
  outgoing_party: Party.find_by!(name: 'Independent'),
  incoming_party: Party.find_by!(name: "Workers' Party"),
  occurred_on: Date.new(2015,1,1)
)

ChangeOfAffiliation.create!(
  councillor: Councillor.find_by!(full_name: 'Gary Gannon'),
  outgoing_party: Party.find_by!(name: 'Independent'),
  incoming_party: Party.find_by!(name: 'Social Democrats'),
  occurred_on: Date.new(2015,9,1)
)

ChangeOfAffiliation.create!(
  councillor: Councillor.find_by!(full_name: 'Pat Dunne'),
  outgoing_party: Party.find_by!(name: 'United Left'),
  incoming_party: Party.find_by!(name: 'Independent'),
  occurred_on: Date.new(2015,12,1)
)

ChangeOfAffiliation.create!(
  councillor: Councillor.find_by!(full_name: 'Noeleen Reilly'),
  outgoing_party: Party.find_by!(name: 'Sinn Féin'),
  incoming_party: Party.find_by!(name: 'Independent'),
  occurred_on: Date.new(2018,2,1)
)

ChangeOfAffiliation.create!(
  councillor: Councillor.find_by!(full_name: 'John Lyons'),
  outgoing_party: Party.find_by!(name: 'People Before Profit'),
  incoming_party: Party.find_by!(name: 'Independent'),
  occurred_on: Date.new(2019,1,6)
)

# Co-Options

CoOption.create!(
  outgoing_seat: Seat.find_by_councillor_name('Jonathan Dowdall'),
  incoming_councillor: Councillor.find_or_create_by!(full_name: 'Gaye Fagan'),
  incoming_party: Party.find_by!(name: 'Sinn Féin'),
  reason: 'Resigned from the council',
  occurred_on: Date.new(2015,2,1)
)

CoOption.create!(
  outgoing_seat: Seat.find_by_councillor_name('Noel Rock'),
  incoming_councillor: Councillor.find_or_create_by!(full_name: 'Norma Sammon'),
  incoming_party: Party.find_by!(name: 'Fine Gael'),
  reason: 'Elected to Dáil Éireann',
  occurred_on: Date.new(2016,2,1)
)

CoOption.create!(
  outgoing_seat: Seat.find_by_councillor_name("Kate O'Connell"),
  incoming_councillor: Councillor.find_or_create_by!(full_name: 'Anne Feeney'),
  incoming_party: Party.find_by!(name: 'Fine Gael'),
  reason: 'Elected to Dáil Éireann',
  occurred_on: Date.new(2016,2,1)
)

CoOption.create!(
  outgoing_seat: Seat.find_by_councillor_name("Jim O'Callaghan"),
  incoming_councillor: Councillor.find_or_create_by!(full_name: "Claire O'Connor"),
  incoming_party: Party.find_by!(name: 'Fianna Fáil'),
  reason: 'Elected to Dáil Éireann',
  occurred_on: Date.new(2016,2,1)
)

CoOption.create!(
  outgoing_seat: Seat.find_by_councillor_name("Bríd Smith"),
  incoming_councillor: Councillor.find_or_create_by!(full_name: "Hazel De Nortúin"),
  incoming_party: Party.find_by!(name: 'People Before Profit'),
  reason: 'Elected to Dáil Éireann',
  occurred_on: Date.new(2016,2,1)
)

CoOption.create!(
  outgoing_seat: Seat.find_by_councillor_name('Denise Mitchell'),
  incoming_councillor: Councillor.find_or_create_by!(full_name: 'Edel Moran'),
  incoming_party: Party.find_by!(name: 'Sinn Féin'),
  reason: 'Elected to Dáil Éireann',
  occurred_on: Date.new(2016,2,1)
)

CoOption.create!(
  outgoing_seat: Seat.find_by_councillor_name("Seán Haughey"),
  incoming_councillor: Councillor.find_or_create_by!(full_name: "Seán Paul Mahon"),
  incoming_party: Party.find_by!(name: 'Fianna Fáil'),
  reason: 'Elected to Dáil Éireann',
  occurred_on: Date.new(2016,2,1)
)

CoOption.create!(
  outgoing_seat: Seat.find_by_councillor_name("Catherine Ardagh"),
  incoming_councillor: Councillor.find_or_create_by!(full_name: "Michael Mullooly"),
  incoming_party: Party.find_by!(name: 'Fianna Fáil'),
  reason: 'Elected to Seanad Éireann',
  occurred_on: Date.new(2016,4,1)
)

# Run all events

Event.uncommitted.order('occurred_on asc').each do |e|
  e.commit!
end
