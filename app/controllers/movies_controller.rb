class MoviesController < ApplicationController

  def show    
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # code for part 3 (remember settings)    
    session[:ratings] = params[:ratings] if params[:ratings]
    session[:sort_order] = params[:sort_order] if params[:sort_order]
    # redirect to RESTful path if session contains more info than provided in params
#    if (!params[:ratings] && session[:ratings]) || (!params[:sort_order] && session[:sort_order])
#      redirect_to movies_path(ratings: session[:ratings], sort_order: session[:sort_order])
#    end

    @movies = Movie.all
    @q = Movie.search params[:q]
    @movies = @q.result

    # adding code

    @all_ratings = Movie.all_ratings
    
    # for redirect management 
    redirect = false
    commit = nil
    #debugger 
    if params[:ratings]!= nil    
      #are there any params sent?   
      @checked_ratings = (params[:ratings].respond_to? "keys") ? params[:ratings].keys  : params[:ratings]
    elsif params[:commit]!= nil   
      #if not, determine whether it is intended to have sent none (when the user uncheks all checkboxes).
      @checked_ratings = []   
    elsif session[:ratings]!= nil
      #it is not intended to sent none, so lookup session for old values.
      @checked_ratings = session[:ratings]
      redirect = true
    else
      #no old values found, it must be a first request to this controller action. Select all ratings.
      @checked_ratings = @all_ratings 
    end
    
#    sort = nil;
    if params[:sort] != nil
      sort = params[:sort]
    elsif params[:sort] == nil && session[:sort] != nil
      sort = session[:sort]
      redirect = true
    end
    
    # to be sure that RESTful URLs are displayed correctly, redirect, so that every parameter needed is contained in the request
 #   if redirect 
 #     redirect_to :action => "index", :sort => sort, :ratings => @checked_ratings#, :commit => params[:commit]
 #   end
    
    session[:ratings] = @checked_ratings 
    session[:sort] = params[:sort] unless params[:sort] == nil # if you cannot find sort parameter, use the old one
        
    if session[:sort] == "title"
      @movies = Movie.find(:all, :order => 'title', :conditions => { :rating => @checked_ratings})
      @title_class = "hilite"
    elsif session[:sort] == "release_date" 
      @movies = Movie.find(:all, :order => 'release_date', :conditions => { :rating => @checked_ratings})
      @release_date_class = "hilite"
    else 
      @movies = Movie.find(:all, :conditions => { :rating => @checked_ratings})
    end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
end