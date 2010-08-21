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

  
end
