class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    [:ratings, :sort_by].each do |s|
      if session[s].present? and params[s].nil?
        params[s] = session[s]
      end
    end

    if params[:ratings].present?
      @ratings = params[:ratings]
      session[:ratings] = params[:ratings] 
    else
      @ratings = Hash.new
      @all_ratings.map{|m| @ratings[m] = 1}
    end

    if params[:sort_by].present?
      @movies = Movie.order("#{@sort_by=params[:sort_by]} ASC")
      session[:sort_by] = params[:sort_by]
    else
      @movies = Movie.all
    end

    @movies.keep_if { |m| @ratings.keys.include? m.rating } if params[:ratings].present?
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
