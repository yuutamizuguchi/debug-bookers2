class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @book = Book.find(params[:id])
    @newbook = Book.new
  end

  def index
    @book = Book.new
    @user = current_user
    @books = Book.all

  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    @books = Book.all
    if @book.save
      redirect_to book_path(@book.id), notice: "You have created book successfully."
    else
      @user = current_user
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end



  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      flash[:notice] = "error"
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private
  def ensure_correct_user
       book = Book.find(params[:id])
       unless current_user.id == book.user_id
      redirect_to books_path
    end
  end

  def book_params
    params.require(:book).permit(:title, :body)
  end

end
