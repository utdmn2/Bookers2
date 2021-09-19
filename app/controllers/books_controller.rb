class BooksController < ApplicationController
  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    @books = Book.all
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
    @books = Book.all
  end

  def show
    @booknew = Book.new
    @book = Book.find(params[:id])
    @user = @book.user
  end

  def edit
    @book = Book.find(params[:id])
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
