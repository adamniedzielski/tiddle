def warningless_get(path, headers:)
  # rubocop:disable Performance/RegexpMatch
  if Gem::Requirement.new(">= 5") =~ Rails.gem_version
    get path, headers: headers
  else
    get path, {}, headers
  end
  # rubocop:enable Performance/RegexpMatch
end
