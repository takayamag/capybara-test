class NavigationListener < Selenium::WebDriver::Support::AbstractEventListener

  def initialize(log)
    @log = log
    @tag_name_before_click = ''
  end

  def after_find(by, what, driver)
    @log.info "次の要素が見つかりました: type: #{by}, value: #{what}"
  end

  def before_click(element, driver)
    # リンクをクリックして別のページに遷移した後、 "after_click" で
    # 前ページの要素を参照すると例外が発生するため、タグ名をインスタンス変数に保存しておく
    @tag_name_before_click = element.tag_name
    if @tag_name_before_click == 'a'
      href = element.attribute('href')
      @log.info "link to: #{href}"
    end
  end

  def after_click(element, driver)
    @log.info "次の要素をクリックしました: #{@tag_name_before_click}"
    @tag_name_before_click = ''
  end

  def after_navigate_to(url, driver)
    # @log.info "次のURLへ遷移しました: #{url}"
  end

  def before_close(driver)
    @log.info "次のウィンドウ(タブ)を閉じようとしています: #{driver.window_handle if driver}"
  end

  def after_close(driver)
    @log.info 'ウィンドウ(タブ)を閉じました'
  end

  def after_quit(driver)
    @log.info 'ブラウザーを終了しました'
  end

  def before_execute_script(script, driver)
    @log.info "次のスクリプトを実行しようとしています: #{script}"
  end

  def after_execute_script(script, driver)
    @log.info 'スクリプトを実行しました'
  end

  def before_change_value_of(element, driver)
    @log.info "次の要素に関する値を変更しようとしています: tag_name: #{element.tag_name} class: #{element.attribute(:class) if element}"
  end

  def after_change_value_of(element, driver)
    @log.info "次の要素に関する値を変更しました: tag_name: #{element.tag_name} class: #{element.attribute(:class) if element}"
  end

end
