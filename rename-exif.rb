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
    if exif.date_time
      { :from => filename, :to => exif.date_time.strftime(FILE_DATE_TIME) }
    end
  rescue MalformedJPEG
    puts "# skipped #{filename}"
  end
}.select {|e| e.is_a? Hash}.group_by {|rename| rename[:to]
}.each {|k, renames|
  if renames.one?
    puts "mv -nv #{renames.first[:from]} #{renames.first[:to]}#{FILE_EXT}"
  else
    renames.each.with_index(1) {|rename ,index|
      puts "mv -nv #{rename[:from]} #{rename[:to]}-#{index}#{FILE_EXT}"
    }
  end
}
