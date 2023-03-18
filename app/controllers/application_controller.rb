class ApplicationController < ActionController::Base
  before_filter :redirect_to_https

  def default_url_options
    { host: ENV["DOMAIN"] || "localhost:3000" }
  end

  def redirect_to_https
    redirect_to :protocol => "https://" unless (request.ssl? || request.local?)
  end
end
