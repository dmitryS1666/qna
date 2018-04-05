require_relative '../acceptance_helper'

feature 'Create question', %q{
   In order to get answer
   As an authenticated user
   I want to be able to ask questions
 } do

  given!(:user) { create(:user) }

  scenario 'Authenticated user creates question with valid attributes' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text'
    click_on 'Create'

    expect(page).to have_content 'Your question was successfully created'
    expect(page).to have_content user.questions.last.title
    expect(page).to have_content user.questions.last.body
  end

  scenario 'Authenticated user creates question with invalid attributes' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: ''
    fill_in 'Body', with: 'text text'
    click_on 'Create'

    expect(page).to have_content "Title can't be blank"
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  context 'mulitple sessions' do
    scenario "question appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        page.find("#add_question_btn").trigger('click')

        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'test text'
        click_on 'Save'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'test text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
      end
    end
  end

end 