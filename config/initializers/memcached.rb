require 'dalli'

$memcached = Dalli::Client.new(['127.0.0.1:11211'], { :compress => true })
