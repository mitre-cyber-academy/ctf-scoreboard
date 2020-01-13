Geocoder.configure(
  timeout: 15
)

if Rails.env.test?
  Geocoder.configure(:lookup => :test)
end
