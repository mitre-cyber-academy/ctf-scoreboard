Geocoder.configure(
  timeout: 15
)

if Rails.env.test?
  Geocoder.configure(:lookup => :test)

  Geocoder::Lookup::Test.set_default_stub(
    [
      {
        'country'      => 'United States',
        'country_code' => 'US'
      }
    ]
  )
end
