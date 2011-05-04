require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe Admin::Terryblr::PostsController do

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    sign_in Factory.create(:user_admin)
  end
  
  describe "GET index" do
    before do
      Factory(:drafted_post, :created_at => 1.month.ago)
      Factory(:drafted_post)
      Factory(:published_post)
      Factory(:published_post)
    end
  
    it "assigns all published posts as @posts" do
      get :index
      assigns(:posts).all? { |post| post.published?.should be true }
    end
  
    describe "drafted posts" do
      before do
        get :index, :state => "drafted", :month => Date.today.month, :year => Date.today.year
      end
  
      it "assigns only drafted posts as @posts" do
        assigns(:posts).empty?.should_not be true
        assigns(:posts).all? { |post| post.drafted?.should be true }
      end
    end
  end

  describe "GET new" do
    it "assigns a new post as @post" do
      get :new, :type => 'photos'
      response.should be_success
      assigns(:post).class.should be Terryblr::Post
    end
  end

  describe "GET edit" do
    it "assigns the requested post as @post" do
      post = Factory(:published_post)
      get :edit, :id => post.id
      response.should be_success
      assigns(:post).should eql post
    end
  end

  describe "POST create" do
    describe "with valid params" do

      it "creates a newly created draft post as @post" do
        params = Factory.attributes_for(:drafted_post)
        params[:parts] = []
        post :create, :post => params
        assigns(:post).valid?.should be true
      end
      
      describe "with valid photos params" do

        it "assigns a newly created post as @post with multiple content parts" do
          
          photo = Factory(:photo)
          video = Factory(:video)
          parts = []
          parts << Factory.attributes_for(:content_part_text).symbolize_keys
          parts << Factory.attributes_for(:content_part_photos).symbolize_keys.update(:photo_ids => [photo.id], :photos => [], :photos_attributes => [photo.attributes.symbolize_keys])
          parts << Factory.attributes_for(:content_part_videos).symbolize_keys.update(:video_ids => [video.id], :videos => [], :videos_attributes => [video.attributes.symbolize_keys])

          params = Factory.attributes_for(:published_post, :published_at => 1.minute.ago).symbolize_keys
          params.delete(:parts)
          params.update({
            :part_ids => [],
            :parts_attributes => parts  # nested Photos attributes
          })
          post :create, :post => params

          # puts assigns(:post).errors.full_messages.to_sentence unless assigns(:post).valid?
          # puts assigns(:post).parts.map{|p|p.errors.full_messages.to_sentence}.join('; ') unless assigns(:post).valid?
          response.should be_redirect
          response.should redirect_to(admin_posts_url)
        end

      end
    end
  end

  describe "PUT update" do
    describe "with valid post params" do
      it "assigns a updated post as @post" do
        new_body = "Updated body"
        drafted = Factory(:drafted_post)
        drafted.parts.first.body = new_body
        
        put :update, :id => drafted.id, :post => { :part_ids => drafted.parts.map(&:id), :parts_attributes => drafted.parts.map(&:attributes) }
        assigns(:post).valid?.should be true
        assigns(:post).parts.first.body.should eql(new_body)
      end
      
      describe "with valid post params and photos" do
        before do
          published_post = Factory(:published_post)
          published_post.parts << Factory(:content_part_photos) # Fake uploaded photo
        end
        
        it "assigns an updated post as @post with a new photo" do
        end
        
        it "assigns an updated post as @post with many new photos" do
        end
      end
    end
  end
  
  describe "DELETE destroy" do
    it "redirects to the posts list" do
      post = Factory(:published_post)
      delete :destroy, :id => post.id
      response.should redirect_to(admin_posts_url)
    end
  end
end