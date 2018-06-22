class ApplicationController < ActionController::API
  HOSTNAME = `hostname`.strip
  def index
    render plain: "#{HOSTNAME} | Count: #{BackgroundJob.count}"
  end
end
