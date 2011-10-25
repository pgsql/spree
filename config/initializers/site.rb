# To change this template, choose Tools | Templates
# and open the template in the editor.
#Spree::Config.set(:allow_guest_checkout => false)

Spree::Config.set(:allow_ssl_in_production=> false)
Spree::Config.set(:allow_ssl_in_development_and_test=> false)
Spree::Config.set(:site_url=> "69.164.203.69:8888")
Spree::Config.set(:site_name=>"StyckrParty")
Spree::Config.set(:cache_static_content=> true)
Spree::Config.set(:products_per_page=> 50)
#Spree::Config.set(:html_invoice_logo_path => "company-logo.png")
#Spree::Config.set(:html_buttons => "invoice,packaging_slip") #comma separated list
