module Personal
  module Routes
    class Base < Sinatra::Application
      configure do
        set :views, 'app/views'
        set :root, File.expand_path('../../../', __FILE__)

        disable :method_override
        disable :protection
        disable :static

        set :erb, escape_html: true,
                  layout_options: {views: 'app/views/layouts'}

        enable :use_code
      end

      register Extensions::Assets
      helpers Helpers
      helpers Sinatra::ContentFor

      get '/' do
        erb :index
      end

      get '/to_pdf' do
        headers({'Content-Type' => 'application/pdf'})
        html = haml(:pdf)
        PDFKit.configure do |config|
          config.wkhtmltopdf = "/usr/local/bin/wkhtmltopdf"
        end
        kit = PDFKit.new(html)
        kit.to_pdf
      end
    end
  end
end