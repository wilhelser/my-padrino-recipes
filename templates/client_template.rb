#
# Generates a basic skeleton app I use for client projects.
#

# Path to the shared source files/templates.
source_path = File.join(File.dirname(__FILE__), 'source')

#
# Ask all the questions we want to know first.
#
use_html5 = yes? 'Use HTML5?'
use_css_reset = yes? 'Use CSS reset?'
use_css_960 = yes? 'Use 960 grid CSS?'

#
# Generate main project.
#
project :test => :shoulda, :renderer => :haml, :script => :jquery, :orm => :datamapper

#
# Create a set of common routes used for most clients.
#
app_init = %Q{
  get '/' do
    render 'home'
  end

  get '/contact' do
    render 'contact'
  end

  get '/about' do
    render 'about'
  end
}
inject_into_file 'app/app.rb', app_init, :before => /^end$/
create_file 'app/views/home.haml', '%h1 Homepage'
create_file 'app/views/contact.haml', '%h1 Contact'
create_file 'app/views/about.haml', '%h1 About'

#
# Create main layout/css/javascript based on options.
#

stylesheets, javascripts, haml_attributes, html_attributes = [], [], [], []

if use_css_reset
  copy_file File.join(source_path, 'stylesheets', 'reset.css'), 'public/stylesheets/reset.css'
  stylesheets << 'reset'
end
haml_attributes << ':format => :html5' if use_html5
html_attributes << ":xmlns => 'http://www.w3.org/1999/xhtml'" unless use_html5


# Clean up the variables and join them ready for their correct placement.
html_attributes = "{ #{html_attributes.join(', ')} }" unless html_attributes.blank?

# For haml always set :attr_wrapper to ", as I personally perfer this.
haml_attributes << ":attr_wrapper => '\"'"
haml_attributes = haml_attributes.join(', ')

layout_init = %Q{!!!doctype
%html#{html_attributes}
  %head
    %title #{fetch_app_name}
    =stylesheet_link_tag 'master'
    =javascript_include_tag 'jquery', 'application'
  %body
    =yield
}
# Note the space so it's spaced correctly in app/app.rb.
haml_init = %Q{  set :haml, { #{haml_attributes} }\n}

inject_into_file 'app/app.rb', haml_init, :before => "  # set :raise_errors, true"
create_file 'app/views/layouts/application.haml', layout_init
create_file 'public/stylesheets/master.css', '/* Add styles! */'