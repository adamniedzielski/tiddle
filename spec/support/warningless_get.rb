def warningless_get(path, headers:)
  if Gem::Requirement.new(">= 5") =~ Rails.gem_version
    get path, headers: headers
  else
    get path, {}, headers
  end
end
