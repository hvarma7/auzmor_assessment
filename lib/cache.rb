class Cache

  class << self

    # Set default cache duration to 1 day
    # @param [Integer] expiry
    def set_cache_duration(expiry)
      !expiry.zero? ? expiry : 86400
    end

    # Get data from cache
    # @param [String] key
    def get(key)
      data = $memcached.get(key)
      data.nil? ? nil : JSON.parse(data)
    end

    # Persist data to cache
    # @param [String] key
    # @param [String] data
    # @param [Integer] expiry
    def set(key, data = 0, expiry = 0)
      $memcached.set(key, data, set_cache_duration(expiry), raw: true)
    end

    # Increment cache counter
    def increment(key, value = 1)
      $memcached.incr(key, value)
    end

    def update_ttl(key, expiry = 0)
      $memcached.touch(key, set_cache_duration(expiry))
    end

    # Delete data from cache
    # @param [String] key
    def delete(key)
      $memcached.delete(key)
    end

  end

end