require 'bundler'
Bundler.require
#Flashcards with buttons and inserting HTML, or canvas thing.
include BCrypt

DB = Sequel.connect(ENV['DATABASE_URL'] || 'sqlite://db/main.db')
require './models.rb'

use Rack::Session::Cookie, :key => 'rack.session',
    :expire_after => 2592000,
    :secret => SecureRandom.hex(64)



get '/' do

  if session[:visited] == true
    @layoutuser = User.first(:id => session[:id])


    redirect '/landing'
  else
    erb :login
  end

end

get '/landing' do

  if session[:visited] == true
    @layoutuser = User.first(:id => session[:id])


    @nameme = User.first(:id => session[:id])
    puts @layoutuser.picurl
    erb :landing
  else
    redirect '/'
  end
end


get '/user/new' do
  @layoutuser = User.first(:id => session[:id])


  erb :createuser
end

get '/course/new' do
  if session[:visited] == true
    @layoutuser = User.first(:id => session[:id])


    erb :createcourse
  else
    redirect '/'
  end

end
get '/me/courses' do

  if session[:visited] == true
    @layoutuser = User.first(:id => session[:id])


    @me = User.first(:id => session[:id])
    @cme = @me.courses



    erb :usercourses
  else
    redirect '/'
  end

end
get '/post/help' do
  if session[:visited] == true
    @layoutuser = User.first(:id => session[:id])


    erb :topnotes
  else
    redirect '/'
  end

end
get '/course/all' do
  if session[:visited] == true
    @layoutuser = User.first(:id => session[:id])


    @course = Course.all
    erb :courseslist
  else
    redirect '/'
  end

end
get '/user/all' do
  if session[:visited] == true
    @layoutuser = User.first(:id => session[:id])


    @users = User.all
    erb :usersall
  else
    redirect '/'
  end
end
get '/user/notes/:id' do
  if session[:visited] == true
    @layoutuser = User.first(:id => session[:id])


    @name = User.first(:id => params[:id])
    #@courseu = Course.first(:id => @name.course_id)
    @unotes = @name.notes
    erb :userpage
  else
    redirect '/'
  end

end
get '/course/:id' do
  if session[:visited] == true
    @layoutuser = User.first(:id => session[:id])
    @course = Course.first(:id => params[:id])
    #How would i check if person is joined?
    @notes = @course.notes
    @users = @course.users
    erb :coursepage
  else
    redirect '/'
  end

end
get '/rules' do
  @layoutuser = User.first(:id => session[:id])


  erb :rules
end
get '/note/new/:id' do
  @layoutuser = User.first(:id => session[:id])


  @id = params[:id]
  erb :newnote
end
get '/logout' do
  session.clear
  redirect '/'
  end
get '/note/:id' do
  @layoutuser = User.first(:id => session[:id])


  @note = Note.first(:id => params[:id])
  array = @layoutuser.course
  puts array.inspect

  @comments = @note.comments
  erb :notepage
end
get '/comment/new/:id' do
  @layoutuser = User.first(:id => session[:id])

  @id2 = params[:id]
  erb :createcomment
end
get '/settings' do
  @layoutuser = User.first(:id => session[:id])
  erb :settings
end
get '/user/profile' do
  @layoutuser = User.first(:id => session[:id])
  erb :userprofile
end
#######################################################

post '/user/create' do
  u = User.new
  u.username = params[:username]
  u.password = Password.create(params[:password])
  u.picurl = "http://shs.westport.k12.ct.us/assets/static/img/logo.png"
  u.save
  puts "hi"
  redirect '/'

end

post '/course/result' do
  @layoutuser = User.first(:id => session[:id])
  @result2 = Course.where(:name => params[:name])
  @result = @result2.first(:teacher => params[:teacher])
  if @result != nil
    erb :coursesearch
  else
    redirect '/course/all'
  end
end
post '/user/auth' do
  @u = User.first(:username => params[:username])
  if @u && Password.new(@u.password) == params[:password]
    session[:id] = @u.id
    session[:visited] = true
    redirect '/landing'
  else
    redirect '/'
  end



end
post '/course/create' do
  cc = Course.new
  cc.name = params[:name]
  cc.teacher = params[:teacher]
  cc.save
  u = User.first(:id => session[:id])
  cc.add_user(u)

  redirect '/course/all'
end
post '/course/search/:id' do
  @course = Course.where(:id => params[:id])
  puts @course
  @c = Course.first(:name => params[:coursesearch])

end
post '/course/join/:id' do
  @cou = Course.first(:id => params[:id])
  u = User.first(:id => session[:id])
  u.add_course(@cou)

  redirect '/landing'
end
post '/post/create/:id' do
  #what is witht the no conversion from string error thing when content is given from text area?
  time = Time.new
  @t = time.strftime("Note created on %A, %b %d %Y at %l:%M %p")
  puts @t
  u = User.first(:id => session[:id])
  t = Course.first(:id => params[:id])
  n = Note.new
  n.title = params[:name]
  n.content = params[:content]
  n.user_id = u.id
  n.course_id = t.id
  n.date = time
  puts n.content
  n.save
  redirect '/me/courses'
end
post '/comment/create/:id' do
  time = Time.new
  u = User.first(:id => session[:id])
  n = Note.first(:id => params[:id])
  com = Comment.new
  com.title = params[:title]
  com.content = params[:content]
  com.user_id = u.id
  com.note_id = n.id
  com.date = time
  com.save
  redirect '/course/all'
end
post '/setprofile' do
u = User.first(:id => session[:id])
  u.picurl = params[:picurl]
  u.save
  redirect '/landing'
end
