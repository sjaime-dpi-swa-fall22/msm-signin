class BookmarksController < ApplicationController
  def index
      user_id = session["user_id"]
      @user = User.where({:id => user_id})[0]
      matching_bookmarks = Bookmark.where({:user_id => user_id})

      @list_of_bookmarks = matching_bookmarks.order({ :created_at => :desc })
      @list_of_available_movies=Array.new
      Movie.all.each do |movie|
        if @user.movies.include?(movie)==false
          puts "hi #{movie.title}"
          @list_of_available_movies.push(movie)
        end
      end

      render({ :template => "bookmarks/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_bookmarks = Bookmark.where({ :id => the_id })

    @the_bookmark = matching_bookmarks.at(0)

    render({ :template => "bookmarks/show.html.erb" })
  end

  def create
    the_bookmark = Bookmark.new
    the_bookmark.user_id = session["user_id"]
    the_bookmark.movie_id = params.fetch("movie_id")

    if the_bookmark.valid?
      the_bookmark.save
      redirect_to("/bookmarks", { :notice => "Bookmark created successfully." })
    else
      redirect_to("/bookmarks", { :alert => the_bookmark.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_bookmark = Bookmark.where({ :id => the_id }).at(0)

    the_bookmark.user_id = params.fetch("query_user_id")
    the_bookmark.movie_id = params.fetch("query_movie_id")

    if the_bookmark.valid?
      the_bookmark.save
      redirect_to("/bookmarks/#{the_bookmark.id}", { :notice => "Bookmark updated successfully."} )
    else
      redirect_to("/bookmarks/#{the_bookmark.id}", { :alert => the_bookmark.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_bookmark = Bookmark.where({ :id => the_id }).at(0)

    the_bookmark.destroy

    redirect_to("/bookmarks", { :notice => "Bookmark deleted successfully."} )
  end
end
