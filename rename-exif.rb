#!/usr/bin/env ruby
# Rename image files in the current directory by Exif
#
# Copyright 2015 Hidetake Iwata
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require 'rubygems'
require 'exifr'
include EXIFR

FILE_DATE_TIME = '%Y%m%d-%H%M%S'
FILE_EXT       = '.jpg'

Dir.entries('.').select {|e|
  File.file? e and not File.zero? e
}.map {|filename|
  begin
    exif = JPEG.new(filename)
    if exif.date_time.is_a? Time
      { :from => filename, :to => exif.date_time.strftime(FILE_DATE_TIME) }
    else
      puts "# skipped #{filename} (timestamp not found)"
    end
  rescue MalformedJPEG => reason
    puts "# skipped #{filename} (#{reason})"
  end
}.select {|e| e.is_a? Hash}.group_by {|rename| rename[:to]
}.flat_map {|k, renames|
  if renames.one?
    [{ :from => renames.first[:from], :to => "#{renames.first[:to]}#{FILE_EXT}" }]
  else
    renames.map.with_index(1) {|rename ,index|
      { :from => rename[:from], :to => "#{rename[:to]}-#{index}#{FILE_EXT}" }
    }
  end
}.select {|rename| rename[:from] != rename[:to] }.each {|rename|
  puts "mv -nv '#{rename[:from]}' '#{rename[:to]}'"
}
