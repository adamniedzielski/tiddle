module Tiddle
  class ModelName
    def with_underscores(model)
      model.model_name.to_s.underscore.upcase
    end

    def with_dashes(model)
      with_underscores(model).dasherize
    end
  end
end
