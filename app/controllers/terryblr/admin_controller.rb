class Terryblr::AdminController < Terryblr::ApplicationController

  unloadable
  before_filter :work_around_rails_middleware_bug
  def work_around_rails_middleware_bug
    request.env["action_dispatch.request.parameters"] = nil
    params.merge! request.params
  end


#  include Settings.authentication.to_s.constantize
  load_and_authorize_resource
  rescue_from CanCan::AccessDenied do |exception|
    if current_user && !current_user.admin?
      @message = exception.message
      render 'admin/common/access_denied'
      # raise exception
    else
      redirect_to new_user_session_path, :notice => exception.message
    end
  end

#  before_filter :authenticate
  before_filter :set_date, :only => [:index, :filter]
  before_filter :set_expires, :only => [:analytics]
  skip_before_filter :verify_authenticity_token, :only => [:analytics]
  around_filter :cache, :only => [:analytics]
  after_filter :set_last_modified

  layout 'admin'

  index {
    before {
      @show_as_dash = true
    }
    wants.html {}
  }

  def analytics
    @since = 1.month.ago.to_date

    # Visitors
    gs = Gattica.new({:email => Settings.ganalytics.email, :password => Settings.ganalytics.password, :profile_id => Settings.ganalytics.profile_id})
    @reports = {
      :visitors => {
        :dimensions => %w(day),
        :metrics => %w(visits)
      },
      :top_referrers => {
        :dimensions => %w(source),
        :metrics => %w(visits),
        :sort => %w(-visits)
      },
      :top_landing_pages => {
        :dimensions => %w(landingPagePath),
        :metrics => %w(uniquePageviews),
        :sort => %w(-uniquePageviews)
      }
    }
    @reports.each do |k, v|
      v[:results] = gs.get(v.update({ :start_date => @since.to_s, :end_date => Date.today.to_s}))
    end

    # Twitter mentions
    # Group by the date of the tweet
    @tweets = Terryblr::Tweet.analytics(@since)
    @tweet_exposure = Terryblr::Tweet.exposure(@since)
    @tweet_reach = Terryblr::Tweet.reach(@since)
  end

  def search
    @query = params[:search].to_s.strip
    like_q = "%#{@query}%".downcase
    conds  = ["LOWER(state) like ? or LOWER(body) like ? or LOWER(title) like ?", like_q, like_q, like_q]
    tag    = Terryblr::Tag.find_by_name(@query)
    joins  = nil
    @results = {
      :posts    => Post.all(   :conditions => conds, :joins => joins, :include => :photos).paginate(:page => 1),
      :pages    => Terryblr::Page.all(   :conditions => conds, :joins => joins, :include => :photos).paginate(:page => 1)
    }
    respond_to do |wants|
      wants.html {
       render :action => "terryblr/admin/search"
      }
    end
  end

  def object_url
    send("#{url_name}_path", object)
  end

  def collection_url
    send("#{url_name.pluralize}_path")
  end

  def url_name
    ctrl_parts = params[:controller].split('/')
    ctrl_parts.delete("terryblr")
    ctrl_parts.join('_').singularize
  end

  private

  def model_name
    ctrl_name = params[:controller].split('/').last.strip
    if ctrl_name=='admin'
      'Terryblr::Post'
    else
      "Terryblr::#{ctrl_name.singularize.camelize}"
    end
  end

  def route_name
    ctrl_parts = params[:controller].split('/')
    ctrl_parts.delete("terryblr")
    ctrl_parts.join('_')
  end

  def object
    @object ||= end_of_association_chain.find_by_slug(params[:id]) || end_of_association_chain.find(params[:id])
  end

  def build_object
    @object ||= (new_obj = end_of_association_chain.pending.first) ? (new_obj.attributes = object_params; new_obj) : end_of_association_chain.new(object_params)
  end

  def collection
    conditions = "state = '#{params[:state] || 'published'}'"
    unless params[:search].blank?
      search_str = "%#{params[:search].downcase}%"
      conditions = ["#{conditions} AND (LOWER(title) like ? OR LOWER(state) like ?)", search_str, search_str]
    end
    @collection ||= model_name.constantize.paginate(:conditions => conditions, :order => "published_at desc, created_at desc", :page => params[:page])
  end

  def set_date
    @date ||= if params[:month] || params[:year]
      "1-#{params[:month]}-#{params[:year] || Date.today.year}".to_date rescue Date.today
    else
      Date.today
    end
  end

  def tw_client
    if @tw_client.nil?
      oauth = Twitter::OAuth.new(Settings.twitter.consumer_key, Settings.twitter.consumer_secret)
      oauth.authorize_from_access(Settings.twitter.app_user_token, Settings.twitter.app_user_secret)
      @tw_client = Twitter::Base.new(oauth)
    end
    @tw_client
  end

  def set_expires
    expires_in (last_modified+6.hours), :private => false, :public => true
    fresh_when(:etag => last_modified.utc.to_i, :last_modified => last_modified.utc, :public => true)
  end

  def last_modified
    case controller_name
    when 'admin'
      now = Time.now
      mod = now.hour%6
      last_modified = (now-mod.hours).change(:min => 0, :sec => 0, :usec => 0)
    else
      super
    end
  end

end
