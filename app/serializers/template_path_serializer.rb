class TemplatePathSerializer
  def self.call(template_path)
    {
      id: template_path.id,
      path: template_path.path,
      name: template_path.name
    }
  end
end
