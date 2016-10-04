def warningless_get(path, headers:)
  if Rails::VERSION::MAJOR >= 5
    get path, headers: headers
  else
    get path, {}, headers
  end
end
