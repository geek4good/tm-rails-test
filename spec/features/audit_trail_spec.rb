require "spec_helper"

feature "Audit trail" do
  given(:campaign_name) { "Kansas City Shuffle" }
  given(:campaign_budget) { 1000 }
  given(:platform_names) { %w(Android iOS Firefox\ OS) }
  given(:email) { "campaign_manager@example.com" }
  given(:password) { "password" }

  before do
    create_platforms(platform_names)
    create_campaign(campaign_name, campaign_budget, platform_names - ["iOS"])
    create_admin_user(email, password)
    sign_in_admin_user(email, password)
  end

  scenario "changes to a campaign's platform settings are logged" do
    visit edit_admin_campaign_path(Campaign.first)
    check "iOS"
    uncheck "Firefox OS"
    click_on "Update Campaign"

    expect(page).to have_content("#{email} has added the platform iOS")
    expect(page).to have_content("#{email} has removed the platform Firefox OS")
  end

  context "when campaign budget is less than 1000" do
    given(:campaign_budget) { 999 }

    scenario "changes to a campaign's platform settings are not logged" do
      visit edit_admin_campaign_path(Campaign.first)
      check "iOS"
      uncheck "Firefox OS"
      click_on "Update Campaign"

      expect(page).to have_content("No comments yet")
    end
  end
end
