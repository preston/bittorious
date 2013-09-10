require 'digest/sha1'
require 'bencode'
module Paperclip
  class RewriteAnnounce < Processor
    
    class InstanceNotGiven < ArgumentError; end
    

    def update_torrent
      b = BEncode.load_file(@file.path)
      b['announce'] = Torrent.announce_url
      b["announce-list"] = [[Torrent.announce_url]]
      b["info"]["private"] = 1
      b.to_bencoding
    end 
    
    def initialize(file, options = {}, attachment = nil)
      super
      @file = file
      @instance = options[:instance]
      @current_format   = File.extname(@file.path)
      @basename         = File.basename(@file.path, @current_format)
      @format         = options[:format]
    end
    
    def make
      dst = Tempfile.new([@basename, @format].compact.join("."))
      dst.open
      dst.binmode
      dst.write update_torrent
      dst.open
      dst
    end

  end
end