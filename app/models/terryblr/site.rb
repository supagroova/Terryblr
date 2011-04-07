class Terryblr::Site < Terryblr::Base

  #
  # Constants
  #

  #
  # Associatons
  #
  has_many :posts
  has_many :pages
  has_many :features

  #
  # Validations
  #
  validates :name, :presence => true, :uniqueness => true
  validates :lang, :presence => true, :inclusion => { :in => I18n.available_locales }
  before_validation :validate_lang
  
  #
  # Scopes
  #
  default_scope :order => "id asc"
  
  #
  # Callbacks
  #
  def validate_lang
    # Set the default value
    self.lang ||= I18n.locale if new_record?
  end

  #
  # Class Methods
  #
  class << self
    
    # Use www or go for the first one
    def default
      find_by_name('www') || first || create(:name => 'www', :lang => I18n.locale)
    end
    
  end
  
  #
  # Instance methods
  #
  def lang
    # Symbolize to make easier to integrate w I18n
    read_attribute(:lang) ? read_attribute(:lang).to_sym : nil
  end

  include Terryblr::Extendable
end