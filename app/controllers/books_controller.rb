class BooksController < ApplicationController
  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    @books = Book.all
    @user = current_user
    if @book.save
    flash[:notice] = "You have created book successfully."
    redirect_to book_path(@book)
    else
    render :index
    end

  end

  def index
    @user = current_user
    @book = Book.new
    
    @books = Book.includes(:favorited_users).sort {|a,b| 
    b.favorited_users.includes(:favorites).size  <=> 
    a.favorited_users.includes(:favorites).size}
    
  end

  def show
    @booknew = Book.new
    @book = Book.find(params[:id])
    @user = @book.user
    @book_comment = BookComment.new
    
        #DM機能
    @currentUserEntry=Entry.where(user_id: current_user.id)
    @userEntry=Entry.where(user_id: @user.id)
    unless @user.id == current_user.id
  
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          if cu.room_id == u.room_id then
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      if @isRoom
      else
        @room = Room.new
        @entry = Entry.new
      end
    end

  end

  def edit
    @book = Book.find(params[:id])
    if @book.user != current_user
    redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "You have updated book successfully."
      redirect_to book_path(@book.id)
    else
    render :edit
    end
  end

  def destroy
    book = Book.find(params[:id]) #データ(レコード)を一件取得
    book.destroy  #データ（レコード）を削除
    redirect_to books_path

  end

  private


  def book_params
    params.require(:book).permit(:title, :body)
  end

end
