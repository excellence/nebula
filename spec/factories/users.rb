Factory.define :user do |u|
  u.email 'userfour@test.evenebula.org'
  u.password 123456
  u.password_confirmation 123456
  u.current_sign_in_ip "192.168.0.17"    
  u.last_sign_in_ip "192.168.0.17"
end

Factory.define :account do |a|
  a.user { |u| u.association(:user) }
  a.api_uid 1
  a.api_key 'xxxxLYFftalJIvmR05ipFgKag0mOb220lfuyVk4HheCq7ZV4Nu8M4zqnTnhbEUxx'
  a.validated false
end
