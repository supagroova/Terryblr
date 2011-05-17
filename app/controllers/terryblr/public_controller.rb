class Terryblr::PublicController < Terryblr::ApplicationController

  unloadable
  inherit_resources

  analytical :modules => Settings.analytics_backends, :use_session_store => true

  # caches_page # for making static sites
  around_filter :cache
  
  # Set HTTP caching headers
  before_filter :set_expires
  before_filter :set_fresh_when

  layout 'public'

  if Rails.env.production? # || Rails.env.staging?
    rescue_from 'Exception' do |exception|
      
      Rails.logger.info "Exception: #{exception}"
      Rails.logger.info exception.backtrace.join("\n")
      
      case exception.class.to_s
      when ActiveRecord::RecordNotFound.to_s
        render :template => 'terryblr/errors/404', :layout => 'public', :status => 404
      else
        render :template => 'terryblr/errors/500', :layout => 'public', :status => 500
      end
    end
  end

  protected

  def track_resource_analytics
    resource.tag_list.each { |tag|
      analytical.custom_event 'Tag', 'view', tag
    }
    analytical.custom_event 'Author', 'view', resource.author.email
  end

end