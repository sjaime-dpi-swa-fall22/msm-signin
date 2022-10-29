class BookmarksController < ApplicationController
  
  before_action(:load_current_user) # call this method before you execute any of the code in any of the mothods below, 
                                    # i.e. load_current_user is called as the first line of code for each of the
                                    # methods in this file
                                    # note that this is inherited from the ApplicationCOntroller file. If we wanted
                                    # all controllers to start with this, we could add this code in there. It's there now
                                    # automatically, as part of draft account generator' terminal command.
                                    # that means we have access to this instance variable at our disposal in every
                                    # controller, action, view template. Didn't know this when I wrote this code and
                                    # didn't bother cleaning it up, so noting it here.

  def load_current_user
    # putting this here. Since it's a common function we may use for every/most methods in this file.
    # common way of doing this.
    @user = User.where({:id => session["user_id"]})[0]
  end
  
  def index

      # self.load_current_user  don't need to call this since have  before_action(:load_current_user) at the top

      # matching_bookmarks = Bookmark.where({:user_id => user_id}) instead of this, did the line below
      matching_bookmarks = @user.bookmarks

      @list_of_bookmarks = matching_bookmarks.order({ :created_at => :desc })
      @list_of_available_movies=Array.new
      Movie.all.each do |movie|
        if @user.movies.include?(movie)==false
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
