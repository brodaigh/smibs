require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'pony'
gem     'haml', '~> 2.0'
load    'feedback.rb'

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/db/dev.sqlite3")
  DataMapper::Logger.new(STDOUT, :debug)   
end

class Order 
  include DataMapper::Resource
  property :id, Integer, :serial => true
  property :buyers_name, String
  property :buyers_email, String
  property :recipients_address, Text
  property :recipients_name, String
  property :overseas, Boolean
  property :payment_preference, String
  property :created_on, Date
  property :created_at, DateTime
  property :updated_at, DateTime
  has n, :fabrics, :through => Resource
  
end

class Fabric 
  include DataMapper::Resource
  property :id, Integer, :serial => true
  property :title, String
  property :image, String
  property :metres, Float
  property :created_on, Date
  
end

get '/' do
  @fabrics = Fabric.first(4, :metres.gt => 0)
  haml :new
end

post "/orders/create" do
  @order = Order.create(:buyers_name => params[:order_buyers_name],:buyers_email => params[:order_buyers_email],:recipients_address => params[:order_recipients_address],:recipients_name => params[:order_recipients_name],:overseas => params[:order_overseas],:payment_preference => params[:order_payment_preference  ])  
  selection = Fabric.all(:id.in => params[:fabric_ids])
  unless selection.empty?
    selection.each do |fabrics|
      @order.fabrics << fabrics
    end
    @order.fabrics.each do |f|
      sum = (f.metres - 1)
      f.update_attributes :metres => sum  
    end
  end
  @order.save!
  redirect "/order/#{@order.id}"
end

get '/order/:id' do
  @order = Order.get(params[:id])  
  @fabrics = @order.fabrics
  haml :show
end

%w( jquery.lightbox-0.5 jquery.thickbox-3.3 ).each do |stylesheet|
  get "/stylesheets/#{stylesheet}.css" do
    content_type 'text/css'
    headers "Expires" => (Time.now + 60*60*24*356*3).httpdate 
  end
end

get "/stylesheets/style.css" do
  content_type 'text/css'
  headers "Expires" => (Time.now + 60*60*24*356*3).httpdate   
  sass :"stylesheets/style"
end

helpers do
  def versioned_sassy_baby(stylesheet)
    "/stylesheets/style.css?" + File.mtime(File.join(Sinatra.application.options.views, "stylesheets", "style.sass")).to_i.to_s
  end
  def versioned_css(stylesheet)
    "/stylesheets/#{stylesheet}.css?" + File.mtime(File.join(Sinatra.application.options.public, "stylesheets", "#{stylesheet}.css")).to_i.to_s
  end #remove .css + .sass
  def versioned_js(js)
    "/javascripts/#{js}.js?" + File.mtime(File.join(Sinatra.application.options.public, "javascripts", "#{js}.js")).to_i.to_s
  end
  def versioned_favicon
    "/favicon.ico?" + File.mtime(File.join(Sinatra.application.options.public, "favicon.ico")).to_i.to_s
  end
  def text(name)
    haml(:"/text/_text_#{name}", :layout => false)
  end
  def postage_price(var)
    postage = ""
    a_dumb_string_aka_null_nada_nothing = 'Postage within Australia is $5.00, elsewhere it\'s $15.00'
    if var == true then postage = 'Postage is $10.00'
      elsif var == false then postage = 'Postage is $5.00'
      else postage = a_dumb_string_aka_null_nada_nothing
    end
  end
  def price(quantity)
    (quantity * 35).to_f
  end
  def price_with_postage(order) 
    quantity = order.fabrics.count 
    price = quantity * 35
    postage_variable = order.overseas
    postage = (postage_variable == true ? 10 : 5)
    (price + postage).to_f
  end

end