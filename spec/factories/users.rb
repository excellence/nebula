Factory.define :user do |u|
  u.email "user#{rand(10000)}@test.evenebula.org"
  u.password '123456'
  u.password_confirmation '123456'
  u.current_sign_in_ip "192.168.0.17"    
  u.last_sign_in_ip "192.168.0.17"
end

Factory.define :character do |c|
  c.account { |a| a.association(:account) }
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

Factory.define :account do |a|
  a.user { |u| u.association(:user) }
  a.api_uid 2 #rand(100000)
  a.api_key 'xxxxLYFftalJIvmR05ipFgKag0mOb220lfuyVk4HheCq7ZV4Nu8M4zqnTnhbEUxx'
  a.validated false
end



Factory.define :proposal do |p|
  p.association :user
  p.association :character
  p.state_id 1
  p.state_change_id 1
  p.title "Test Proposal"
  p.body "Test test test test"
end