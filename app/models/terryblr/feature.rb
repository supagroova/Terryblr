class Terryblr::Feature < Terryblr::Base

  #
  # Behaviours
  #
  include Terryblr::Base::Taggable
  include Terryblr::Base::AasmStates
  include Terryblr::Base::Validation

  #
  # Associatons
  #
  belongs_to :photo
  belongs_to :post, :class_name => "Terryblr::Post"
  belongs_to :site, :class_name => "Terryblr::Site"

  #
  # Constants
  #
  attr_accessor :photo_url
  accepts_nested_attributes_for :photo, :allow_destroy => true

  #
  # Validations
  #
  include ActiveRecord::Validations
  validates_presence_of :photo, :display_order, :if => Proc.new{|f| !f.pending? && !f.post_id? }
  validates_numericality_of :display_order
  validates :url, :presence => true, :url => true, :if => :url?
  validates :tag_list, :presence => true, :allow_blank => false
  

  #
  # Scopes
  #
  default_scope order("features.display_order asc, features.id desc")

  #
  # Callbacks
  #
  after_initialize :set_tag_list

  def set_tag_list
    self.tag_list = [Settings.tags.posts.features.first] if self.tag_list.empty? rescue []
  end

  #
  # Class Methods
  #
  class << self
  end

  #
  # Instance Methods
  #
  
  def thumbnail(size = :thumb)
    # Find the first thumbnail image
    post_id? ? post.thumbnail : "/images/missing_thumb.png"
  end

  def photo
    if post_id?
      part = post.parts.detect{|p|p.content_type && p.content_type.photos?}
      part ? part.photos.first : nil
    elsif photo_id?
      @photo ||= Terryblr::Photo.find(photo_id)
    end
  end
  
  def video
    if post_id?
      part = post.parts.detect{|p|p.content_type && p.content_type.videos?}
      part ? part.videos.first : nil
    end
  end

  private

  include Terryblr::Extendable
end
