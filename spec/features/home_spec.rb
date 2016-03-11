require 'rails_helper'

feature "using the team captin page" do

	scenario "MITRE CTF Registration Team Captin" do

		visit root_path
		expect(page).to have_text("Registration is now open")
	end
end