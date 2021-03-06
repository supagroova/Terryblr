require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/active_record/migration'

module Terryblr
  module Generators
    class TerryblrGenerator < Rails::Generators::Base
      namespace "terryblr"
      include Rails::Generators::Migration

      def self.source_root
        @source_root ||= File.join(File.dirname(__FILE__), '..', 'templates')
      end

      # Implement the required interface for Rails::Generators::Migration.
      def self.next_migration_number(dirname)
        next_migration_number = current_migration_number(dirname) + 1
        if ActiveRecord::Base.timestamped_migrations
          [Time.now.utc.strftime("%Y%m%d%H%M%S"), "%.14d" % next_migration_number].max
        else
          "%.3d" % next_migration_number
        end
      end

      def create_migration_file
        generate('acts_as_taggable_on:migration')
        generate('delayed_job')
        # generate('devise:install') # Run 'rails g devise:install' instead!

        %w(create_videos create_photos create_orders create_posts 
           create_pages create_likes create_comments create_messages 
           create_features create_products create_line_items create_links 
           create_votes create_tweets create_sessions create_sites 
           create_content_parts add_userid_to_resources).each do |f|
          src = "#{f}.rb"
          dst = "db/migrate/#{src}"
          migration_template(src, dst) rescue puts $!
        end
      end

      def create_configuration_file
        copy_file 'initializer.rb', 'config/initializers/terryblr.rb'
        copy_file 'string_extensions.rb', 'config/initializers/string_extensions.rb'
        copy_file 'settings.yml', 'config/settings.yml'
        copy_file 'oembed.yml', 'config/oembed.yml'
        copy_file 'assets.yml', 'config/assets.yml'
        copy_file 'devise.rb', 'config/initializers/devise.rb'
        copy_file 'locales/devise_en.yml', 'config/locales/devise_en.yml'
        copy_file 'delayed_job.rb', 'config/initializers/delayed_job.rb'
        copy_file 'formtastic_config.rb', 'config/initializers/formtastic_config.rb'
        copy_file 'disqussion.rb', 'config/initializers/disqussion.rb'
        copy_file 'em-net-http_override.rb', 'config/initializers/em-net-http_override.rb'
        
        # copy_file 'session_store.rb', 'config/initializers/session_store.rb'
        # Static assets
        copy_dir_contents 'public', 'public'
      end
      
      private
      
      def copy_dir_contents(source_dir, target_dir)
        
        ignore_if_exists = %w(public.js admin.js public.css admin.css)
        
        base_dir = File.join(File.dirname(__FILE__), '../templates', source_dir)
        raise "Base dir not found: #{base_dir}" unless Dir.exists?(base_dir)
        Dir.new(base_dir).each do |file|
          next if %w(. .. .DS_Store).include?(file)
          
          base_path = File.join(base_dir, file)
          source_path = File.join(source_dir, file)
          target_path = File.join(target_dir, file)
          
          # Skip files in ignore list if they exists
          next if ignore_if_exists.include?(File.basename(file)) and File.exists?(target_path)
          
          if File.directory?(base_path)
            # Recurse into dir
            copy_dir_contents(source_path, File.join(target_dir, file))
          else
            # Copy files
            copy_file base_path, target_path
          end
        end
      end
      
    end
  end
end
