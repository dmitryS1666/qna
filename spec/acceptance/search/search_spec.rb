require_relative 'acceptance_helper'

feature 'Search', %q{
  In order to get more information from app
  As user
  I want to search a view info
} do
  given!(:question) { create(:question, title: "what we search") }
  given!(:answer) { create(:answer, body: "we search what?") }
  given!(:comment) { create(:comment, body: "search what we!") }
  given!(:user) { create(:user, email: "search@what.we") }

  context 'All users' do
    scenario 'can view search field with attributes' do
      visit root_path

      %w(Everywhere Questions Answers Comments Users).each do |attr|
        expect(page).to have_content attr
      end
    end

    scenario 'can search and view result page', js: true do
      ThinkingSphinx::Test.run do
        visit root_path
        fill_in 'query', with: 'Search something!'
        click_on 'Search'

        expect(page).to have_content "No results"
      end
    end

    scenario 'can search anything', js: true do
      ThinkingSphinx::Test.run do
        visit root_path
        fill_in 'query', with: "search"
        click_on 'Search'
        within '.results' do
          expect(page).to have_content question.title
          expect(page).to have_content answer.body
          expect(page).to have_content comment.body
          expect(page).to have_content user.email
        end
      end
    end

    scenario "can search in category Questions", js: true do
      ThinkingSphinx::Test.run do
        visit root_path
        fill_in 'query', with: "search"
        select "Questions", from: 'category'
        click_on 'Search'

        within '.results' do
          expect(page).to have_content question.title
          expect(page).to_not have_content answer.body
          expect(page).to_not have_content comment.body
          expect(page).to_not have_content user.email
        end
      end
    end

    scenario "can search in category Answers", js: true do
      ThinkingSphinx::Test.run do
        visit root_path
        fill_in 'query', with: "search"
        select "Answers", from: 'category'
        click_on 'Search'

        within '.results' do
          expect(page).to_not have_content question.title
          expect(page).to have_content answer.body
          expect(page).to_not have_content comment.body
          expect(page).to_not have_content user.email
        end
      end
    end

    scenario "can search in category Comments", js: true do
      ThinkingSphinx::Test.run do
        visit root_path
        fill_in 'query', with: "search"
        select "Comments", from: 'category'
        click_on 'Search'

        within '.results' do
          expect(page).to_not have_content question.title
          expect(page).to_not have_content answer.body
          expect(page).to have_content comment.body
          expect(page).to_not have_content user.email
        end
      end
    end

    scenario "can search in category Users", js: true do
      ThinkingSphinx::Test.run do
        visit root_path
        fill_in 'query', with: "search"
        select "Users", from: 'category'
        click_on 'Search'

        within '.results' do
          expect(page).to_not have_content question.title
          expect(page).to_not have_content answer.body
          expect(page).to_not have_content comment.body
          expect(page).to have_content user.email
        end
      end
    end
  end
end