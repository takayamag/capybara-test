require 'spec_helper.rb'

# export BROWSER=chrome; bundle install && bundle exec rspec spec/features/example_console_spec.rb
describe '楽天グループサイト' do

  # 楽天グループのサービス一覧(抜粋)のURLリスト
  urls = [
    'https://www.rakuten.co.jp/',
    'https://travel.rakuten.co.jp/',
    'https://mobile.rakuten.co.jp/',
    'https://books.rakuten.co.jp/',
    'https://magazine.rakuten.co.jp/',
    'https://music.rakuten.co.jp/',
    'https://www.rakuten-bank.co.jp/',
    'https://www.rakuten-card.co.jp/',
    'https://www.rakuten-sec.co.jp/',
    'https://www.rakuten-life.co.jp/',
    'https://product.rakuten.co.jp/',
    'https://coupon.rakuten.co.jp/',
    'https://gora.golf.rakuten.co.jp/',
    'https://www.rakuteneagles.jp/',
    'https://ticket.rakuten.co.jp/',
    'https://insurance.rakuten.co.jp/',
    'https://buyback.rakuten.co.jp/',
    'https://tv.rakuten.co.jp/'
  ]

  urls.each do |url|
    it "コンソール上で問題のあるエラーが発生しないこと: `#{url}`" do
      visit(url)
      puts page.title
      logs = page.driver.browser.manage.logs.get(:browser)
      severe_count = 0
      warning_count = 0
      unless logs.nil?
        logs.each do |log|
          if log.level == 'SEVERE'
            puts "[SEVERE] #{log.message}"
            severe_count += 1
          elsif log.level == 'WARNING' && log.message.include?('Mixed')
            # `Mixed Content`は`SEVERE`と`WARNING`どちらもある
            puts "[WARNING] #{log.message}"
            warning_count += 1
          end
        end
      end
      # `SEVERE`や`Mixed Content`の`WARNING`が 0 であること
      expect(severe_count + warning_count).to eq 0
    end
  end

end
