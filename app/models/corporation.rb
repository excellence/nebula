class Corporation < ActiveRecord::Base
  belongs_to :alliance
  has_many :characters
  
  validates_presence_of :name
  validates_presence_of :ticker
  validates_length_of :name, :within => 1..100
  validates_length_of :ticker, :within => 1..5
  
  # Helper function
  def logo(size)
    return Corporation.get_logo(self.id,size)
  end
  # Lazy alias! This is the same method name as the equivalent function in Character.
  def portrait(size)
    return Corporation.get_logo(self.id,size)
  end
  # Get specified corporation ID's logo in the specified size, where size is one of 256, 64, 32 and 16.
  # If the appropriate size is not found on the file system, will fetch/resize/save all sizes.
  # Stores saved logos in RAILS_ROOT/public/system/corporations/corporationid_size.jpg
  # Returns the absolute path for use in templates.
  def self.get_logo(id,size)
    unless File.exists? "#{RAILS_ROOT}/public/system/corporations/#{id}_#{size.to_i}.png"
      begin
        File.open("#{RAILS_ROOT}/public/system/corporations/#{id}_256.png","wb") do |f|
          Net::HTTP.start("image.eveonline.com") do |http|
            resp = http.get("/Corporation/#{id}_256.png")
            f << resp.body
          end
        end
        # Now use MiniMagick to bake some 16/32 images from the larger source
  
        image = MiniMagick::Image.from_file("#{RAILS_ROOT}/public/system/corporations/#{id}_256.png")
        image.resize "16x16"
        image.write("#{RAILS_ROOT}/public/system/corporations/#{id}_16.png")
  
        image = MiniMagick::Image.from_file("#{RAILS_ROOT}/public/system/corporations/#{id}_256.png")
        image.resize "32x32"
        image.write("#{RAILS_ROOT}/public/system/corporations/#{id}_32.png")
        
        image = MiniMagick::Image.from_file("#{RAILS_ROOT}/public/system/corporations/#{id}_256.png")
        image.resize "64x64"
        image.write("#{RAILS_ROOT}/public/system/corporations/#{id}_64.png")
      rescue
        return "/images/logo_not_found_#{size}.png"
      end 
      
    end
    return "/system/corporations/#{id}_#{size.to_i}.png"
  end
end
