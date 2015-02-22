rename-exif
===========

A command line tool to rename image files to each Exif time.

How to Run
----------

Ruby and [exifr](https://github.com/remvee/exifr) is required.

```sh
gem install exifr
```

Run the tool in the directory which contains image files.

```sh
cd /path/to/images
/path/to/rename-exif.rb
```

The tool generates a script to rename files, except invalid files, as follows:

```sh
# skipped DSC_0016.JPG
mv -nv DSC_0588.JPG 20150103-114423.jpg
mv -nv DSC_0589.JPG 20150103-114426-1.jpg
mv -nv DSC_0590.JPG 20150103-114426-2.jpg
```

So we can actually rename files after checking the generated script.

```sh
/path/to/rename-exif.rb | sh
```

Customize
---------

We can customize filename format and extension placed in the header of script.

Contribution
------------

This is an open source software licensed under the Apache License Version 2.0.

