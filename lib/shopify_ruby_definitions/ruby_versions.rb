# frozen_string_literal: true

module ShopifyRubyDefinitions
  module RubyVersions
    VERSIONS_DIRECTORY = File.expand_path("../../../rubies", __FILE__)
    ALL_VERSIONS = Dir["#{VERSIONS_DIRECTORY}/*"].map { |f| File.basename(f) }
    VERSION_OVERRIDES = ALL_VERSIONS.sort_by do |version|
      version.scan(/\d+/).map(&:to_i)
    end.to_h do |version|
      [version.split("-").first, version]
    end.freeze

    def version_overrides
      VERSION_OVERRIDES
    end

    def resolve_version(version)
      if version.match?(/\A\d+\.\d+\z/)
        pattern = /\A#{Regexp.escape(version)}\.(\d+)\z/
        versions = version_overrides.keys.grep(pattern)
        unless versions.empty?
          version = versions.max_by { |v| v.match(pattern)[1].to_i }
        end
      end
      version_overrides.fetch(version, version)
    end
  end
end
