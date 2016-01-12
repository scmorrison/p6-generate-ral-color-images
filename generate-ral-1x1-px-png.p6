#!/usr/bin/env perl6

use v6;

use Text::CSV;
use Image::PNG::Portable;

# Read/parse CSV
my $csv = Text::CSV.new();
my $fh  = open "./ral-colors.csv", :r, chomp => False;
my $sort = 0;

say "title,value,thumbnail,thumbnail_size_x,thumbnail_size_y,info,sort_order";
while (my @row = $csv.getline($fh)) {
  # Category
  my ($ral, $ral_rgb, $ral_hex, $deutsch, $english, $français, $español, $italian, $nederlands) = @row;
  # Skip if first row
  $ral !~~ "RAL" or next;
  # Start a new image, set width/height
  my $ral_image = Image::PNG::Portable.new: :width(1), :height(1);
  # Convert string to array of integers and append it to pixel location
  my @image_params = append([0,0], +«$ral_rgb.split("-")); # +« converts the list of strings to Int
  # my @image_params = append([0,0], $ral_rgb.split("-").map(*.Int) );
  # Confirm we have the correct param count
  @image_params.elems == 5 or next;
  # Create image
  $ral_image.set: |@image_params;
  # Save image
  $ral_image.write: 'images/' ~ $ral.split(' ')[1] ~ '-1x1.png';

  ###shell("convert -size 50x50 xc:" ~ $ral_hex ~ " images/" ~ $ral.split(' ')[1]~ "-50x50.png");

  # Prepare row for output CSV
  my $title = "$ral";
  #my $title = "$ral\<br />$français\<br />$english";
  my $value = $ral;
  my $thumbnail = "https://s3-eu-west-1.amazonaws.com/ral-images/" ~ $ral.split(' ')[1]~ "-50x50.png";
  # Print row
  say "$title,$value,$thumbnail,50,50,,$sort";
  $sort++;
}

# Close the csv
$fh.close;
