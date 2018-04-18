require_relative '../acceptance_helper'

feature 'Subscriptions', %q{
  In order to view information of new answer in question
  As an autenfication user
  I want to subsribe to answers of question
} do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }

  scenario 'Non-Autorized user try subsribe to question' do
    visit question_path(question)

    expect(page).to_not have_button 'Subscribe'
  end

  describe 'Non-author of question user' do
    before do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'Author dont see subsribe link in his question' do
      expect(page).to_not have_button 'Subscribe'
      expect(page).to have_button "Unsubscribe"
    end

    scenario 'Author can unsubsribe from his question', js: true do
      click_on 'Unsubscribe'

      expect(page).to have_button 'Subscribe'
      expect(page).to_not have_button "Unsubscribe"
    end
  end

  describe 'Non-author of question user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'view a subsribe button to foreign question' do
      expect(page).to have_button 'Subscribe'
    end

    scenario 'can subsribe to foreign question', js: true do
      click_on 'Subscribe'

      expect(page).to_not have_button 'Subscribe'
      expect(page).to have_button "Unsubscribe"
    end

    scenario 'can unsubsribe to foreign question', js: true do
      click_on 'Subscribe'
      click_on 'Unsubscribe'

      expect(page).to have_button 'Subscribe'
      expect(page).to_not have_button "Unsubscribe"
    end
  end
end