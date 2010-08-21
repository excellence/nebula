class Character < ActiveRecord::Base
  belongs_to :corporation
  belongs_to :alliance
  belongs_to :account
  belongs_to :user
  has_many :proposals
  has_many :votes
  has_many :amendments
  has_many :state_changes
    
  validates_presence_of :user_id
  validates_presence_of :account_id
  validates_presence_of :corporation_id
  validates_presence_of :name
  validates_presence_of :bloodline
  validates_presence_of :race
  validates_presence_of :gender
  validates_length_of :name, :within => 1..35
  validates_length_of :bloodline, :within => 1..9
  validates_length_of :gender, :within => 1..6
  validates_length_of :race, :within => 1..8
  
  # Get character portrait in the specified size, where size is one of 256, 64, 32 and 16.
  # If the appropriate size is not found on the file system, will fetch/resize/save all sizes.
  # Stores saved portraits in RAILS_ROOT/public/system/characters/characterid_size.jpg
  # Returns the absolute path for use in templates.
  def portrait(size)
    unless File.exists? "#{RAILS_ROOT}/public/system/characters/#{self.id}_#{size.to_i}.jpg"
      begin
        File.open("#{RAILS_ROOT}/public/system/characters/#{self.id}_256.jpg","wb") do |f|
          Net::HTTP.start("image.eveonline.com") do |http|
            resp = http.get("/Character/#{self.id}_256.jpg")
            f << resp.body
          end
        end
        # Now use MiniMagick to bake some 16/32 images from the larger source
        
        image = MiniMagick::Image.from_file("#{RAILS_ROOT}/public/system/characters/#{self.id}_256.jpg")
        image.resize "16x16"
        image.write("#{RAILS_ROOT}/public/system/characters/#{self.id}_16.jpg")
  
        image = MiniMagick::Image.from_file("#{RAILS_ROOT}/public/system/characters/#{self.id}_256.jpg")
        image.resize "32x32"
        image.write("#{RAILS_ROOT}/public/system/characters/#{self.id}_32.jpg")
        
        image = MiniMagick::Image.from_file("#{RAILS_ROOT}/public/system/characters/#{self.id}_256.jpg")
        image.resize "64x64"
        image.write("#{RAILS_ROOT}/public/system/characters/#{self.id}_64.jpg")
      rescue
        return "/images/logo_not_found_#{size}.jpg"
      end
    end
    return "/system/characters/#{self.id}_#{size.to_i}.jpg"
  end
end
