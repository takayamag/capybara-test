require 'spec_helper.rb'

# export BROWSER=chrome_sp; bundle install && bundle exec rspec spec/features/example_sp_spec.rb
describe 'ヤフオク!' do

  before(:each) do
    visit 'https://auctions.yahoo.co.jp/'
  end

  it 'タイトルが`ヤフオク! - 日本NO.1のネットオークション、フリマアプリ`であること' do
    expect(page).to have_title('ヤフオク! - 日本NO.1のネットオークション、フリマアプリ')
  end

  it '検索フォームのパーツの要素が存在すること' do
    expect(page).to have_css('#SbWrap')
    expect(page).to have_css('input#SbIpt')
    expect(page).to have_css('input#SbSbmtBtn')
  end

  it 'ナビアイコンの4番目に`オークション出品`が存在すること' do
    expect(page).to have_selector(:xpath, '(//li[@class="NaviIcon__item"])[4]/a', text: 'オークション出品')
  end

  it '`ピックアップ`のテキストが存在すること' do
    expect(page).to have_selector 'h2.Products__title', text: 'ピックアップ'
  end

  context '検索ワードを未入力で検索した時' do
    it '検索結果ページに`検索したい言葉（キーワード）が入力されていません。`が表示されること' do
      within('#SbWrap') do
        find(:xpath, '//input[@id="SbIpt"]').click
        find(:xpath, '//input[@id="SbIpt"]').set('')
        find(:xpath, '//input[@id="SbSbmtBtn"]').click
      end
      expect(page).to have_field('SbIpt', with: '')
      expect(page).to have_selector('div#Sac h2', text: '検索したい言葉（キーワード）が入力されていません。')
    end
  end

  context '検索ワードに`カピバラさん`を指定した時' do
    it '検索結果ページの入力フィールドに検索ワードが入力されていること' do
      within('#SbWrap') do
        find(:xpath, '//input[@id="SbIpt"]').click
        find(:xpath, '//input[@id="SbIpt"]').set('カピバラさん')
        find(:xpath, '//input[@id="SbSbmtBtn"]').click
      end
      expect(page).to have_field('SbIpt', with: 'カピバラさん')
    end
  end

end
