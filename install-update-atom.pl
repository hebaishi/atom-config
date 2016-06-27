#!/usr/bin/perl
sub SplitVersionString {
  my ($str) = @_;
  $str =~ /(\d+)\.(\d+)\.(\d+)/g;
  @version = ($1, $2, $3);
  return @version;
}

sub secondVersionGreater {
  my ($old_ver, $new_ver) = @_;
  @old_version = SplitVersionString($old_ver);
  @new_version = SplitVersionString($new_ver);
  $newer_flag = 0;

  if ($#old_version == 2 && $#new_version == 2){
    for ($i = 0 ; $i <= $#old_version ; $i++){
      if ($new_version[$i] > $old_version[$i]) {
        $newer_flag = 1;
      }
    }
  } else {
    die "Invalid version strings!!";
  }
  return $newer_flag;
}

sub command_present {
  my ($command) = @_;
  $present = `which $command`;
  chomp $present;
  if ($present =~ m/^$/g) {
    return 0;
  } else {
    return 1;
  }
}

sub getCleanVersion{
  my ($str) = @_;
  chomp $str;
  if ($str =~ m/\/tag\/v(\d+\.\d+\.\d+)/g){
    $str = $1;
  } elsif ($str =~ m/Atom.*(\d+\.\d+\.\d+)/g){
    $str = $1;
  }
  return $str;
}

if (!(command_present("curl"))) {die "curl not found! Please install curl to continue\n";}

$install_flag = "";

print "Checking for latest version of atom\n";
$latest_version = getCleanVersion(`curl -sss https://github.com/atom/atom/releases/latest`);

if (!(command_present("atom"))) {
  $install_flag = "i";
} else {
  $current_version = getCleanVersion(`atom --version`);
  if (secondVersionGreater($current_version, $latest_version)) {
    $install_flag = "u";
  }
}

if ($install_flag ne "") {
  if ($install_flag eq "i") {
    print "Atom not found. ";
  } elsif ($install_flag eq "u") {
    print "Atom update found. ";
  }
  print "Installing Atom v$latest_version\n";
  $url = "https://github.com/atom/atom/releases/download/v" . $latest_version . "/atom-amd64.deb";
  `rm -f /tmp/atom-amd64.deb`;
  `wget -P /tmp $url`;
  `dpkg -i /tmp/atom-amd64.deb`;
} else {
  print "Current version of atom (v$current_version) is the latest version\n";
}

# Tests
# $test_results = "";
# $test_results .= (secondVersionGreater("v1.1.0", "v1.1.2") == 1) . "\n";
# $test_results .= (secondVersionGreater("v1.1.0", "v1.2.0") == 1) . "\n";
# $test_results .= (secondVersionGreater("v1.1.0", "v2.3.4") == 1) . "\n";
# $test_results .= (secondVersionGreater("v1.1.0", "v1.1.0") == 0) . "\n";
# $test_results .= (command_present("curl") == 1) . "\n";
# $test_results .= (command_present("curls") == 0) . "\n";
# print $test_results;
# print (command_present("curls") == 0)
