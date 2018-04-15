require_relative '../spec_helper.rb'

Capybara.configure do |config|
  # 参照: http://www.rubydoc.info/github/jnicklas/capybara/Capybara.configure

  # DSL Options:
  config.default_driver = :chrome
  config.javascript_driver = :chrome

  # Configurable options:
  config.run_server = false            # ローカルのRack Serverを使用しない (Default: true)
  config.default_selector = :css       # デフォルトのセレクターを`:css`または`:xpath`で指定する (Default: :css)
  config.default_max_wait_time = 5     # Ajaxなどの非同期プロセスが終了するまで待機する最大秒数 (seconds, Default: 2)
  config.ignore_hidden_elements = true # ページ上の隠れた要素を無視するかどうか (Default: true)
  config.automatic_reload = false      # Capybaraが待機しているときに自動的に要素をリロードするかどうか (Default: true)
  config.save_path = Dir.pwd           # save_(page|screenshot), save_and_open_(page|screenshot)を使用した時にファイルが保存されるパス (Default: Dir.pwd)
  config.automatic_label_click = false # チェックボックスやラジオボタンが非表示の場合に関連するラベル要素をクリックするかどうか (Default: false)
end

Capybara.register_driver :chrome do |app|
  # 参考: https://seleniumhq.github.io/selenium/docs/api/rb/Selenium/WebDriver/Chrome/Options.html
  # 参考: https://github.com/SeleniumHQ/selenium/wiki/Ruby-Bindings
  # 参考: https://github.com/SeleniumHQ/selenium/blob/master/rb/spec/unit/selenium/webdriver/chrome/options_spec.rb

  # WebDriverのログの出力レベルを変更する
  # Selenium::WebDriver.logger.level = :debug

  options = Selenium::WebDriver::Chrome::Options.new

  # セキュリティに影響を及ぼす設定の変更は、アクセス先が安全であることを確認してから行なって下さい。
  # options.add_argument('disable-web-security')      # CORS（Cross-Origin Resource Sharing）を無視する
  # options.add_argument('ignore-certificate-errors') # SSLサーバ証明書のエラーを無視する
  # options.add_argument('disable-popup-blocking')    # ポップアップブロックを無効にする

  options.add_argument('disable-notifications')       # Web通知やPush APIによる通知を無視する
  options.add_argument('disable-translate')           # 翻訳ツールバーを無効にする
  options.add_argument('disable-extensions')          # 拡張機能を無効にする
  options.add_argument('disable-infobars')            # インフォバーの表示を無効にする
  options.add_argument('window-size=1280,960')        # ブラウザーのサイズを指定する
  # options.add_argument('user-agent="Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.1.4322; .NET CLR 2.0.50727)"') # IE6

  # Headlessモードの設定
  # 参考: https://github.com/SeleniumHQ/selenium/blob/master/rb/lib/selenium/webdriver/chrome/options.rb#L133
  headless = 'false'
  headless = ENV['HEADLESS'] unless ENV['HEADLESS'].nil?
  options.headless! if headless.casecmp('true').zero? # Headlessモードを有効にする

  # ChromeのSPエミュレーションを使用する
  # Device Toolbarで選択出来るEmulated Devicesを指定する
  browser = :chrome
  browser = ENV['BROWSER'].to_sym unless ENV['BROWSER'].nil?
  options.add_emulation(device_name: 'iPhone 5/SE') if browser == :chrome_sp

  # ダウンロードファイルの保存場所を指定する
  # download_dir = File.join(Dir.pwd, 'files/downloads')
  # FileUtils.mkdir_p(download_dir)
  # prefs = { prompt_for_download: false, default_directory: download_dir }
  # options.add_preference(:download, prefs)

  # Consoleログを取得出来るようにする
  options.add_preference(:loggingPrefs, browser: 'ALL')

  # ChromeやFirefoxの実行パスを明示的に指定する
  # options.add_option(:binary, '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome') # Stable版
  # options.add_option(:binary, '/Applications/Google Chrome Canary.app/Contents/MacOS/Google Chrome Canary') # Canary版

  # プロキシーサーバー一覧を登録する
  PROXY_LIST = {
    proxy1: '192.168.0.6:8888'
  }.freeze

  # プロキシーサーバーを設定する
  unless ENV['PROXY'].nil?
    name = ENV['PROXY']
    url = PROXY_LIST[name.to_sym]
    raise "`#{ENV['PROXY']}`はプロキシーサーバー一覧に存在しません" if url.nil?
    options.add_argument("proxy-server=#{url}")
    # PACファイルを使用する場合は`--proxy-pac-url`を使用するようです
  end

  logger = Logger.new(STDOUT)
  logger.datetime_format = '%Y-%m-%d %H:%M:%S'
  logger.formatter = proc do |severity, timestamp, progname, msg|
    "\t#{timestamp}: #{msg}\n"
  end

  # Selenium Serverを使用するかどうかのフラグを取得する
  remote = 'false'
  remote = ENV['REMOTE'] unless ENV['REMOTE'].nil?

  # WebDriverのインスタンスを作成する
  if remote.casecmp('true').zero?
    # ブラウザーをリモートマシン上で起動する
    Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      options: options,
      listener: NavigationListener.new(logger),
      url: 'http://localhost:4444/wd/hub') # `localhost`の部分は環境に合わせて修正する
  else
    # ブラウザーをローカルマシン上で起動する
    Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      options: options,
      listener: NavigationListener.new(logger))
  end
end
