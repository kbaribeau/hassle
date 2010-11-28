module ActionView
	module Helpers
		module AssetTagHelper
			def expand_stylesheet_sources(sources, recursive)
				if sources.first == :all
					#this is probably naive, and skips some rails options
					compiler = Hassle::Compiler.new
					compiler.stylesheets
				else
					sources.collect do |source|
						determine_source(source, @@stylesheet_expansions)
					end.flatten
				end
			end
		end
	end
end
