require 'spec_helper'

describe Terryblr::PostsController do
  
  before do
    @post = Factory(:post, :published_at => 1.hour.ago, :site => Terryblr::Site.default)
  end
  
  describe "GET /posts" do
    it "should GET the index" do
      get :index
      response.should be_success
    end
  end

  describe "GET /posts/show" do
    it "should GET the post" do
      get :show, :id => @post.id, :slug => @post.slug
      response.should be_success
    end

    it "should log the post view, with author and tag data, to google analytics" do
      @post = Factory(:published_post)
      @analytical = mock("analytical")
      controller.stub!(:analytical).and_return(@analytical)
      @analytical.should_receive(:custom_event).with('Tag', 'view', 'test_tag')
      @analytical.should_receive(:custom_event).with('Tag', 'view', 'other_tag')
      @analytical.should_receive(:custom_event).with('Author', 'view', @post.author.email)
      get :show, :id => @post.id
    end
  end

  describe "GET /posts/tagged" do
    it "should GET the post" do
      tag = 'party'
      @post.tag_list = [tag]
      get :tagged, :tag => tag
      response.should be_success
    end
  end

  describe "GET /posts/archive" do
    it "should GET the archives" do
      get :archives
      response.should be_success
    end
  end

  describe "GET /posts/next,previous" do
    before do
      Terryblr::Post.delete_all
      @posts = []
      3.times do |i|
        @posts << Factory(:post, :published_at => i.hours.ago, :site => Terryblr::Site.default)
      end
    end

    it "should redirect to the next post" do
      @posts.all?(&:valid?).should eql(true)
      
      get :next, :id => @posts[1].id
      response.should be_redirect
      response.should redirect_to(post_path(@posts[0], @posts[0].slug))
    end

    it "should redirect to the previous post" do
      get :previous, :id => @posts[1].id
      response.should be_redirect
      response.should redirect_to(post_path(@posts[2], @posts[2].slug))
    end
  end

  describe "POST /posts/preview" do
    
    it "previews a new post" do
      # Send post to preview and make sure it renders with posted attributes
      post_atts = Factory.attributes_for(:published_post).symbolize_keys
      post_atts[:parts_attributes] = [Factory.attributes_for(:content_part_text).symbolize_keys]
      post_atts.delete(:parts)
      
      # Standard post
      post :preview, :post => post_atts
      response.should be_success
      
      post_atts.each_pair do |key, val|
        case key
        when :id
          assigns(:resource).send(key).should eql(0)
        when :state
          assigns(:resource).send(key).should eql('published')
        when :published_at
          assigns(:resource).send(key).to_s.should eql(val.to_s)
        when :parts_attributes
        else
          assigns(:resource).send(key).should eql(val)
        end
      end

      # Video post
      post :preview, :post => post_atts.merge({
        :post_type => "video"
      })

      response.should be_success
    end
    
    it "previews an existing post" do
      # Send post to preview and make sure it renders with posted attributes
      post_atts = Factory(:post_to_be_published_now).attributes.symbolize_keys
      
      # Standard post
      post :preview, :post => post_atts
      response.should be_success
      post_atts.each_pair do |key, val|
        case key
        when :id
          assigns(:resource).send(key).should eql(0)
        when :state
          assigns(:resource).send(key).should eql('published')
        when :published_at
          # assigns(:resource).send(key).to_s.should eql(val.to_s) # TODO - why is it always 1min diff and failing where it works above?? Fix!
        else
          assigns(:resource).send(key).should eql(val)
        end
      end

      # Video post
      post :preview, :post => post_atts.merge({
        :post_type => "video"
      })

      response.should be_success
    end
  end
  
end