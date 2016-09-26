# So.. BitTorrent peers routine use GET /announce and GET /scrape as part of normal, centralized host tracking.
# Unfortunately, the protocol sends URL-encoded raw byte values for several query parameters,
# which is odd for the web and (rightly) breaks rack's query parameter parsing prior to hitting Rails.
#
# To get around this, we install the following piece of middleware before Rack's normal handling,
# and rewrite the offending query paramer binary values to *hexadecimal* strings.
# Worse, there appears to be some platform-dependent behavior going on prior to hitting this middleware,
# because the raw values are *something* URL-encoded, and sometimes not.
#
# Anyway, once all this rewrite nonsense is done, the request is passed to whatever would normally be first.
#
# Author: Preston Lee
#
Rails.application.configure do
    config.middleware.insert_before(Rack::Runtime, Rack::Rewrite) do
        rewrite /^\/(announce|scrape)\?(.*)/, lambda { |match, rack_env|
            # byebug
            query = Rack::Utils.parse_nested_query(rack_env['QUERY_STRING'])
            # puts "IH #{query['info_hash'].size}"
            if query['info_hash'] # && query['info_hash'] !~ /^[a-z0-9]{40}$/
                hex = query['info_hash'].unpack('H*')[0]
                hex = URI.decode(query['info_hash']).unpack('H*')[0] if hex.length != 40
                puts "info_hash rewrite: #{query['info_hash']} -> #{hex}"
                query['info_hash'] = hex
            end
            # puts "PI #{query['peer_id'].size}"
            if query['peer_id'] # && query['peer_id'] !~ /^[a-z0-9]{40}$/
                hex = query['peer_id'].unpack('H*')[0]
                hex = URI.decode(query['peer_id']).unpack('H*')[0] if hex.length != 40
                puts "peer_id rewrite: #{query['peer_id']} -> #{hex}"
                query['peer_id'] = hex
            end
            rack_env['QUERY_STRING'] = URI.encode_www_form(query)
            # puts "Rewrote query string to #{rack_env['QUERY_STRING']}"
            r = "/#{match[1]}?#{rack_env['QUERY_STRING']}"
        }
    end
end
