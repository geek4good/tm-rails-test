require "spec_helper"

feature "Authorization" do
  given(:email) { "admin@example.com" }
  given(:password) { "password" }
  given(:superuser) { false }

  background do
    create_admin_user(email, password, superuser)
    sign_in_admin_user(email, password)
  end

  context "as campaign manager" do
    context "regarding user management" do
      before do
        create_admin_user("another_user@example.com", "p@ssw0rd")
      end

      scenario "listing is allowed" do
        visit admin_admin_users_path
        expect(page).to have_xpath("//h2[@id='page_title'][text()='Admin Users']")
      end

      scenario "viewing details is allowed" do
        visit admin_admin_user_path(AdminUser.last)
        expect(page).to have_content("another_user@example.com")
      end

      scenario "adding is off limits" do
        visit new_admin_admin_user_path
        expect(page).to have_content("not authorized")
      end

      scenario "editing the own attributes is allowed" do
        visit edit_admin_admin_user_path(AdminUser.first)
        expect(page).to have_content("Edit Admin User")
      end

      scenario "editing the attributes of others is off limits" do
        visit edit_admin_admin_user_path(AdminUser.last)
        expect(page).to have_content("not authorized")
      end
    end

    context "regarding platform management" do
      before do
        create_platforms(%w(Android iOS))
      end

      scenario "listing is allowed" do
        visit admin_platforms_path
        expect(page).to have_xpath("//h2[@id='page_title'][text()='Platforms']")
      end

      scenario "viewing details is allowed" do
        visit admin_platform_path(Platform.first)
        expect(page).to have_content("Android")
      end

      scenario "adding is off limits" do
        visit new_admin_platform_path
        expect(page).to have_content("not authorized")
      end

      scenario "editing is off limits" do
        visit edit_admin_platform_path(Platform.first)
        expect(page).to have_content("not authorized")
      end
    end

    context "regarding campaign management" do
      before do
        create_campaign("Laser Shark", 1_000_000, %w(Symbian Bada))
      end

      scenario "listing is allowed" do
        visit admin_campaigns_path
        expect(page).to have_xpath("//h2[@id='page_title'][text()='Campaigns']")
      end

      scenario "viewing details is allowed" do
        visit admin_campaign_path(Campaign.first)
        expect(page).to have_content("Laser Shark")
      end

      scenario "adding is allowed" do
        visit new_admin_campaign_path
        expect(page).to have_xpath("//h2[@id='page_title'][text()='New Campaign']")
      end

      scenario "editing is allowed" do
        visit edit_admin_campaign_path(Campaign.last)
        expect(page).to have_xpath("//h2[@id='page_title'][text()='Edit Campaign']")
      end

    end

    context "regarding commenting" do
      before do
        create_campaign("Laser Shark", 1_000_000, %w(Symbian Bada))
      end

      scenario "adding to campaigns is allowed" do
        visit admin_campaign_path(Campaign.first)
        fill_in :active_admin_comment_body, with: "*tock, tock, tock*\nIs this thing on?"
        click_on "Add Comment"

        expect(page).to have_content("Comment was successfully created")
      end

      scenario "adding to anything else is off limits" do
        create_admin_user("another_user@example.com", "p@ssw0rd")
        visit admin_admin_user_path(AdminUser.last)
        fill_in :active_admin_comment_body, with: "*tock, tock, tock*\nIs this thing on?"
        click_on "Add Comment"

        expect(page).to have_content("not authorized")
      end
    end
  end
end

