class ForecastController < ApplicationController
  def index

    # https://qiita.com/mogulla3/items/a4bff2e569dfa7da1896

    begin
      # 日本語対応parse
      baseURL = "http://api.openweathermap.org/data/2.5/weather"
      apiKey  = "63df98d478d5a027a6ce26a69bc6887a"
      param   = "?q=#{params[:id]},jp&units=metric&appid=#{apiKey}"
      uri = URI.parse("#{baseURL}#{param}")

      # 新しくHTTPセッションを開始し、結果をresponseへ格納
      response = Net::HTTP.start(uri.host, uri.port) do |http|
        # 接続最大秒数
        http.open_timeout = 5
        # 読み込み中の最大秒数
        http.read_timeout = 10
        # WebAPIの実行
        http.get(uri.request_uri)
      end

      case response
      when Net::HTTPSuccess
        # responseのbody要素をJSON形式で解釈し、hashに変換
        @result = JSON.parse(response.body)
        # 表示用の変数に結果を格納
        @cityName     = @result["name"]
        @temperature  = @result["main"]["temp"]
        @we           = @result["weather"][0]["main"]
      # 別のURLに飛ばされた場合
      when Net::HTTPRedirection
        @message = "Redirection: code=#{response.code} message=#{response.message}"
      # その他エラー
      else
        @message = "HTTP ERROR: code=#{response.code} message=#{response.message}"
      end
    # エラー時処理
    rescue IOError => e
      @message = "e.message"
    rescue TimeoutError => e
      @message = "e.message"
    rescue JSON::ParserError => e
      @message = "e.message"
    rescue => e
      @message = "e.message"
    end

    @posts = [
      "#{@cityName}の現在の気温は、#{@temperature}度です。",
      "#{@we}です。",
      "明日の気温は、21度",
      "曇りでしょう",
    ]
  end
end
