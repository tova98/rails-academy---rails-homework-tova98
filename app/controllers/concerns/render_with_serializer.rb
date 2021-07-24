module RenderWithSerializer
  def render_with_serializer(serializer)
    serializer ||= 'blueprinter'
    case serializer
    when 'blueprinter'
      render_with_blueprinter
    when 'JSON:API'
      render_with_jsonapi
    end
  end

  def render_with_blueprinter
    entity = instance_variable_get("@#{controller_name.singularize}")
    serializer_name = "#{controller_name.classify}Serializer"
    render json: serializer_name.constantize.render(entity,
                                                    root: :"#{controller_name.singularize}")
  end

  def render_with_jsonapi
    entity = instance_variable_get("@#{controller_name.singularize}")
    serializer_name = "JsonApi::#{controller_name.classify}Serializer"
    render json: serializer_name.constantize.new(entity).serializable_hash
  end
end
