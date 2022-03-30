module Tiddle
  class ModelName
    def with_underscores(model)
      colon_to_underscore(model).underscore.upcase
    end

    def with_dashes(model)
      with_underscores(model).dasherize
    end

    private

    def colon_to_underscore(model)
      model.model_name.to_s.tr(':', '_')
    end
  end
end
