module ActionView
  module Template::Handlers
    class Prawn < Template::Handler
      include ActionView::Template::Handlers::Compilable
      self.default_format = Mime::PDF
      def compile(template)
        "pdf = Prawn::Document.new; #{template.source}; pdf.render;"
      end
    end
  end
end

ActionView::Template.register_template_handler(:prawn, ActionView::Template::Handlers::Prawn)

