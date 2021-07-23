class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  rescue_from ActiveRecord::RecordNotFound, with: :rescue_from_not_found

  def rescue_from_not_found
    render json: { errors: ["#{controller_name.classify} not found."] }
  end

  def render_with_serializer(serializer)
    if serializer.blank? || serializer == 'blueprinter'
      render_with_blueprinter
    elsif serializer == 'JSON:API'
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

  def render_with_root(root)
    entity = instance_variable_get("@#{controller_name}")
    serializer_name = "#{controller_name.classify}Serializer"
    if root.blank? || root == '1'
      render json: serializer_name.constantize.render(entity, root: :"#{controller_name}")
    elsif root == '0'
      render json: serializer_name.constantize.render(entity)
    end
  end
end
