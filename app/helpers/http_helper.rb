module HttpHelper
  def get(url)
    uri = URI.parse(url)
    req = Net::HTTP::Get.new(uri.to_s)
    res = Net::HTTP.start(uri.host, uri.port) { |http| http.request(req) }

    JSON.parse(res.body)
  end
end