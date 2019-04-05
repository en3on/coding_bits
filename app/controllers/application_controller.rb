class ApplicationController < Sinatra::Base

  use Rack::Flash

  configure do
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'password_security'
  end

  get '/' do
    erb :landing
  end

  get '/signup' do
    erb :'users/signup'
  end

  post '/signup' do
    @user = User.new(username: params['username'], email: params['email'], password: params['password'])

    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = 'You have successfully registered'
      puts @user.username
      puts @user.email
      puts @user.password
      puts @user.id
      redirect '/profile'
    else
      @errors = @user.errors.map { |e| e }
      erb :'users/signup'
    end
  end

  get '/login' do
    erb :'users/login'
  end

  post '/login' do
    @user = User.find_by(username: params['username'])

    if @user
      if @user.password == params['password']
        session[:user_id] = @user.id
        redirect '/profile'
      end
    end
    session[:user_id] = nil
    flash[:notice] = 'Incorrect username or password!'
    redirect '/login'
  end

  get '/profile' do
    @user = User.find(session[:user_id])
    erb :'users/profile'
  end

  get '/new_bit' do
    erb :'users/new_bit'
  end

  post '/new_bit' do
    @bit = Bit.new(title: params['title'], content: params['content'])

    @bit.user_id = session[:user_id]

    if @bit.save
      redirect '/profile'
    else
      flash[:notice] = "Couldn't save bit! Please try again"
      redirect '/new_bit'
    end
  end

  get '/delete' do
    Bit.destroy(params[:bit_id].to_i)
    flash[:deleted] = 'Bit deleted'
    redirect '/profile'
  end
end
