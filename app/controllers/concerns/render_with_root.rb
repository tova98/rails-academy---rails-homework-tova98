module RenderWithRoot
  def render_with_root(root)
    root ||= '1'
    entity = instance_variable_get("@#{controller_name}")
    serializer_name = "#{controller_name.classify}Serializer"
    case root
    when '1'
      payload = serializer_name.constantize.render(entity, root: :"#{controller_name}")
    when '0'
      payload = serializer_name.constantize.render(entity)
    end
    render json: payload
  end
end
