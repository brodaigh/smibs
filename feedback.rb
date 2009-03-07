get '/feedback/new' do
  haml :"feedback/new", :layout => false
end

post '/feedback/send' do
  Pony.mail :to => 'brodaigh@gmail.com',
    :from => 'brodaigh@gmail.com',
    :subject => 'Fuck you\re hot!'
  redirect "/feedback/success"
end

get '/feedback/success' do
  haml :"feedback/success", :layout => false
end
