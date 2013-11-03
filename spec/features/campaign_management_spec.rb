require "spec_helper"

feature "Campaign management" do
  given(:platform_names) { %w(Android iOS) }
  given(:email) { "admin@example.com" }
  given(:password) { "password" }

  background do
    create_platforms(platform_names)
    create_admin_user(email, password)
    sign_in_admin_user(email, password)
  end

  context "when creating a campaign" do
    background do
      visit new_admin_campaign_path
    end

    scenario "following the happy path" do
      fill_in("Name", with: "Pink Rabbit")
      fill_in("Budget", with: 1001)
      check("Android")
      click_on "Create Campaign"

      expect(page).to have_content("successfully created")
    end

    context "when omitting the platform" do
      scenario "an error message is displayed" do
        fill_in("Name", with: "Pink Rabbit")
        fill_in("Budget", with: 1001)
        click_on "Create Campaign"

        expect(find("#campaign_platforms_input .inline-errors").text)
        .to eql("can't be blank")
      end
    end
  end

  context "when listing campaigns" do
    background do
      create_campaign("Pink Rabbit", 1001, platform_names)
    end

    scenario "the campaigns' platforms are displayed" do
      visit admin_campaigns_path
      expect(page).to have_xpath("//td[@class='platform'][text()='Android, iOS']")
    end
  end

  context "when showing a campaign's details" do
    background do
      create_campaign("Pink Rabbit", 1001, platform_names)
    end

    scenario "the campaign's platforms are displayed" do
      visit admin_campaign_path(Campaign.last)
      expect(page).to have_xpath("//tr[@class='row']/td[text()='Android, iOS']")
    end
  end

  context "when adding a new platform later" do
    background do
      create_campaign("Pink Rabbit", 1001, platform_names)
      create_platforms(["Firefox OS"])
    end

    scenario "it is automatically listed on the campaign form" do
      visit edit_admin_campaign_path(Campaign.last)
      expect(page).to have_xpath("//li[@id='campaign_platforms_input']//label[text()='Firefox OS']")
    end
  end
end
