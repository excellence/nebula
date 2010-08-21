class Alliance < ActiveRecord::Base
  has_many :corporations
  
  validates_presence_of :name
  validates_presence_of :ticker
  validates_length_of :name, :within => 3..100
  validates_length_of :ticker, :within => 1..5
  # Updates the alliance list with the API. Since this is an expensive operation, we do all alliances at once
  # and update all known corporations with their alliances.
  def self.do_update
    alliances = self.find(:all)
    alliance_ids = alliances.map{|a|a.id}
    api_alliances = Reve::API.new.alliances
    current_corps = Corporation.find(:all, :select => 'id,alliance_id')
    api_alliances.each do |alliance|
      a = self.find_or_initialize_by_id(alliance.id)
      a.id = alliance.id
      a.name = alliance.name
      a.ticker = alliance.short_name
      a.member_count = alliance.member_count
      a.corporation_count = alliance.member_corporations.size
      a.save
      alliance.member_corporations.each do |mc|
        if current_corps.map{|c|c.id}.include?(mc.id)
          c = Corporation.find(mc.id)
          c.alliance_id = alliance.id
          c.save
        end
      end
    end
  end
  # Helper function
  def logo(size)
    return Alliance.get_logo(self.id,size)
  end
  # Lazy alias! This is the same method name as the equivalent function in Character.
  def portrait(size)
    return Alliance.get_logo(self.id,size)
  end
  # Get specified alliance ID's logo in the specified size, where size is one of 256, 64, 32 and 16.
  # If the appropriate size is not found on the file system, will fetch/resize/save all sizes.
  # Stores saved logos in RAILS_ROOT/public/system/alliances/allianceid_size.jpg
  # Returns the absolute path for use in templates.
  def self.get_logo(id,size)
    unless File.exists? "#{RAILS_ROOT}/public/system/alliances/#{id}_#{size.to_i}.png"
      begin
        File.open("#{RAILS_ROOT}/public/system/alliances/#{id}_128.png","wb") do |f|
          Net::HTTP.start("image.eveonline.com") do |http|
            resp = http.get("/Alliance/#{id}_128.png")
            f << resp.body
          end
        end
        # Now use MiniMagick to bake some 16/32 images from the larger source
        
        image = MiniMagick::Image.from_file("#{RAILS_ROOT}/public/system/alliances/#{id}_128.png")
        image.resize "16x16"
        image.write("#{RAILS_ROOT}/public/system/alliances/#{id}_16.png")
  
        image = MiniMagick::Image.from_file("#{RAILS_ROOT}/public/system/alliances/#{id}_128.png")
        image.resize "32x32"
        image.write("#{RAILS_ROOT}/public/system/alliances/#{id}_32.png")
        
        image = MiniMagick::Image.from_file("#{RAILS_ROOT}/public/system/alliances/#{id}_128.png")
        image.resize "64x64"
        image.write("#{RAILS_ROOT}/public/system/alliances/#{id}_64.png")
      rescue
        return "/images/logo_not_found_#{size}.png"
      end
    end
    return "/system/alliances/#{id}_#{size.to_i}.png"
  end
  
end
