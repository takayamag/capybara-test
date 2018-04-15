require 'spec_helper.rb'
require_relative '../pages/google.rb'

# export BROWSER=chrome; bundle install && bundle exec rspec spec/features/example_site_prism_spec.rb
describe 'Site_Prism Example' do

  # スペック実行時に最初に実行される処理
  before :all do
    @home = Google::Home.new
  end

  # テスト(it)が実行される前に毎回実行される処理
  before :each do
    @home.load
    page.save_screenshot "files/screenshots/#{Time.now().strftime('%Y%m%d-%H%M%S.%L')}.png"
  end

  it 'トップページ最上部に各メニューが表示されていること' do
    @home.wait_for_menu
    expect(@home).to have_menu
    expect(@home.menu).to have_gmail
    expect(@home.menu).to have_images
    expect(@home.menu).to have_google_apps
    expect(@home.menu).to have_login_button
  end

  it 'トップページのフッターに各メニューが表示されていること' do
    @home.wait_for_footer
    expect(@home).to have_footer
    expect(@home.footer).to have_ads
    expect(@home.footer).to have_services
    expect(@home.footer).to have_about
    expect(@home.footer).to have_privacy
    expect(@home.footer).to have_policies
    expect(@home.footer).to have_preferences
  end

  it 'トップページに検索フォームの要素が存在すること' do
    @home.wait_for_search_form
    expect(@home).to have_search_form
    expect(@home).to have_search_field
    expect(@home).to have_search_button
  end

  it '検索結果の1ページ目に検索対象のページタイトルが表示されること' do
    @home.search_field.set 'Selenium'
    @home.search_field.native.send_keys(:tab) # Suggestionsメニューを閉じる
    @home.search_button.click
    @results_page = Google::SearchResults.new
    expect(@results_page).to be_displayed
    @results_page.wait_for_search_results
    expect(@results_page).to have_search_results count: 10
    expect(@results_page.search_result_links).to include 'Selenium - Web Browser Automation'
  end

end
