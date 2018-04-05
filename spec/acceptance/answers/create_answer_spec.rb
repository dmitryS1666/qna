require_relative '../acceptance_helper'

feature 'Create answer', %q{
  In order to contribute to community
  As an authenticated user
  I want to be able to give answers
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Authenticated user creates answer', js: true do
    sign_in(user)

    visit question_path(question)
    expect(page).to have_content 'Give your answer'
    fill_in 'answer[body]', with: 'test answer'
    click_on 'Add answer'

    within '.answers' do
      expect(page).to have_content 'test answer'
    end
    expect(current_path).to eq question_path(question)
  end

  scenario 'Authenticated user tries to create answer with invalid attributes', js: true do
    sign_in(user)

    visit question_path(question)
    click_on 'Add answer'
    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Non-authenticated user tries to create answer' do
    visit question_path(question)
    expect(page).to_not have_content 'Give your answer'
  end

  context 'multiple sessions', :cable do
    scenario 'all users see new answer in real-time' do
      Capybara.using_session('author') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('author') do
        page.find('#add_answer_btn').trigger('click')

        within '#new_answer_form' do
          fill_in 'Body', with: 'test text'
          click_on 'Save'
        end

        expect(page).to have_content 'Your answer has been successfully created'
        expect(page).to have_content 'test text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'test text'
      end
    end

end