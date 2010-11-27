require 'rubygems'
require 'spec'
require 'rack/test'
require 'active_support'
require 'active_support/core_ext/numeric/time'
require 'sass'
require 'sass/plugin'
require File.dirname(__FILE__) + '/../lib/hassle'
SASS_OPTIONS = Sass::Plugin.options.dup

def write_sass(location, css_file = "screen")
  FileUtils.mkdir_p(location)
  sass_path = File.join(location, "#{css_file}.scss")

  File.open(sass_path, "w") do |f|
    f.write <<EOF
%h1 {
  font-size: 42em
}
EOF
  end

  File.join(@hassle.css_location(location), "#{css_file}.css") if @hassle
end

Spec::Matchers.define :be_compiled do
	match do |given|
		File.exists?(given) && File.read(given) =~ /h1 \{/
	end
end

Spec::Matchers.define :have_tmp_dir_removed do |stylesheets|
	match do |given|
    given == stylesheets.map { |css| css.gsub(File.join(Dir.pwd, "tmp", "hassle"), "") }
	end
end

Spec::Matchers.define :have_served_sass do
	match do |last_response|
		last_response.status == 200 && last_response.body.should =~ /h1 \{/ 
	end
end

def reset
  Sass::Plugin.options.clear
  Sass::Plugin.options = SASS_OPTIONS
  FileUtils.rm_rf([File.join(Dir.pwd, "public"), File.join(Dir.pwd, "tmp")])
end
