## bencoding.rb -- parse and generate bencoded values.
## Copyright 2004 William Morgan.
##
## This file is part of RubyTorrent. RubyTorrent is free software;
## you can redistribute it and/or modify it under the terms of version
## 2 of the GNU General Public License as published by the Free
## Software Foundation.
##
## RubyTorrent is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
## General Public License (in the file COPYING) for more details.

require 'uri'
require 'digest/sha1'
 
module RubyTorrent

## we mess in the users' namespaces in this file. there's no good way
## around it. i don't think it's too egregious though.

class BEncodingError < StandardError; end

class BStream
  include Enumerable

  @@classes = []

  def initialize(s)
    @s = s
  end

  def self.register_bencoded_class(c)
    @@classes.push c
  end

  def each
    happy = true
    begin
      happy = false
      c = @s.getc
      @@classes.each do |klass|
        if klass.bencoded? c
          o = klass.parse_bencoding(c, @s)
          happy = true
          yield o
          break
        end
      end unless c.nil?
      unless happy
        @s.ungetc c unless c.nil?
      end
    end while happy
    self
  end
end

end

class String
  def to_bencoding
    self.length.to_s + ":" + self.to_s
  end

  def self.bencoded?(c)
    (?0 .. ?9).include? c
  end

  def self.parse_bencoding(c, s)
    lens = c.chr
    while ((x = s.getc) != ?:)
      unless (?0 .. ?9).include? x
        s.ungetc x
        raise RubyTorrent::BEncodingError, "invalid bencoded string length #{lens} + #{x}" 
      end
      lens += x.chr
    end
    raise RubyTorrent::BEncodingError, %{invalid length #{lens} in bencoded string} unless lens.length <= 20
    len = lens.to_i
    raise RubyTorrent::BEncodingError, %{invalid length #{lens} in bencoded string} unless len >= 0
    (len > 0 ? s.read(len) : "")
  end

  RubyTorrent::BStream.register_bencoded_class self
end

class Integer
  def to_bencoding
    "i" + self.to_s + "e"
  end

  def self.bencoded?(c)
    c == ?i
  end

  def self.parse_bencoding(c, s)
    ints = ""
    while ((x = s.getc.chr) != 'e')
      raise RubyTorrent::BEncodingError, "invalid bencoded integer #{x.inspect}" unless x =~ /\d|-/
      ints += x
    end
    raise RubyTorrent::BEncodingError, "invalid integer #{ints} (too long)" unless ints.length <= 20
    int = ints.to_i
    raise RubyTorrent::BEncodingError, %{can't parse bencoded integer "#{ints}"} if (int == 0) && (ints !~ /^0$/) #'
    int
  end

  RubyTorrent::BStream.register_bencoded_class self
end

class Time
  def to_bencoding
    self.to_i.to_bencoding
  end
end

module URI
  def to_bencoding
    self.to_s.to_bencoding
  end
end

class Array
  def to_bencoding
    "l" + self.map { |e| e.to_bencoding }.join + "e"
  end

  def self.bencoded?(c)
    c == ?l
  end

  def self.parse_bencoding(c, s)
    ret = RubyTorrent::BStream.new(s).map { |x| x }
    raise RubyTorrent::BEncodingError, "missing list terminator" unless s.getc == ?e
    ret
  end

  RubyTorrent::BStream.register_bencoded_class self
end

class Hash
  def to_bencoding
    "d" + keys.sort.map do |k|
      v = self[k]
      if v.nil?
        nil
      else
        [k.to_bencoding, v.to_bencoding].join
      end
    end.compact.join + "e"
  end

  def self.bencoded?(c)
    c == ?d
  end

  def self.parse_bencoding(c, s)
    ret = {}
    key = nil
    RubyTorrent::BStream.new(s).each do |x|
      if key == nil
        key = x
      else
        ret[key] = x
        key = nil
      end
    end

    raise RubyTorrent::BEncodingError, "no dictionary terminator" unless s.getc == ?e
    ret
  end

  RubyTorrent::BStream.register_bencoded_class self
end