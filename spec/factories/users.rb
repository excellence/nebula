Factory.define :user do |u|
  u.email "userfour@test.evenebula.org"
  u.password '123456'
  u.password_confirmation '123456'
  u.current_sign_in_ip "192.168.0.17"    
  u.last_sign_in_ip "192.168.0.17"
end
Factory.define :validated_user, :parent => :user do |u|
  u.email "userfive@test.evenebula.org"
end

Factory.define :character do |c|
  c.account { Account.find_by_api_uid(2) || Factory(:account) }
  c.id 642510006
  c.name 'Makurid'
  c.gender 'Male'
  c.race 'Caldari'
  c.bloodline 'Deteis'
  c.skill_points 3_000_001
  c.user_id { User.find_by_email('userfour@test.evenebula.org').id }
  c.corporation_id 1594257695
  c.alliance_id 1900696668
end

Factory.define :validated_character, :parent => :character do |c|
  c.name 'Makurid validated'
  c.user { User.find_by_email('userfive@test.evenebula.org') || Factory(:user) }
  c.id 642510007
end

Factory.define :account do |a|
  a.user { User.find_by_email('userfour@test.evenebula.org') || Factory(:user) }
  a.character_id 642510006
  a.api_uid 2 #rand(100000)
  a.api_key 'xxxxLYFftalJIvmR05ipFgKag0mOb220lfuyVk4HheCq7ZV4Nu8M4zqnTnhbEUxx'
  a.validated false
end

Factory.define :validated_account, :class => :account do |a|
  a.association :user, :factory => :validated_user
  a.association :character, :factory => :validated_character
  a.character_id 642510007
  a.api_uid 3
  a.api_key '1xxxLYFftalJIvmR05ipFgKag0mOb220lfuyVk4HheCq7ZV4Nu8M4zqnTnhbEUxx'
  a.validated true
end

Factory.define :proposal do |p|
  p.user { User.find_by_email("userfour@test.evenebula.org") || Factory(:user) }
  p.character { Character.find_by_name('Makurid') || Factory(:character) }
  p.title "Test Proposal"
  p.body "This is the test content of the test proposal 1"
  p.score 0
end

Factory.define :validated_proposal, :parent => :proposal do |p|
  p.character { Character.find_by_name('Makurid validated') || Factory(:validated_character) }
end
