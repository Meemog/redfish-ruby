class TemplateSerializer
  def self.call(template)
    Rails.logger.debug "Serializing template #{template.id}"
    {
      id: template.id,
      name: template.name,
      paths: template.template_paths.map do |path|
        {
          id: path.id,
          path: path.path,
          name: path.name
        }
      end
    }
  end
end
