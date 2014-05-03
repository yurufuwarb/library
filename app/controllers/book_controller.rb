class BookController < ApplicationController

  before_action :check_params

  def check_params
    case action_name
    when 'create'
      render_error(-1, 1, "typeパラメータを指定してください。") and return unless params.include?(:type)
      render_error(-1, 1, "nameパラメータを指定してください。") and return unless params.include?(:name)
      render_error(-1, 1, "outlineパラメータを指定してください。") and return unless params.include?(:outline)
    when 'destroy'
    end
  end

  # GET /books
  def index
    p "-----"
    p params[:type]
    p "-----"
    render json: {test: "test"}
  end

  # POST /books
  def create
    type = params[:type]
    name = params[:name]
    outline = params[:outline]

    # フォーマットチェック
    render_error(-1, 2, "typeは 0 または 1 で指定してください。") and return unless (0..1).include?(type.to_i)
    render_error(-1, 3, "nameは30文字以内で指定してください。") and return if is_exceeded(name, 30)
    render_error(-1, 4, "outlineは50文字以内で指定してください。") and return if is_exceeded(outline, 50)

    # 登録・更新データ
    book = Book.where(id: params[:id]).first_or_initialize
    book.type = type
    book.name = name
    book.outline = outline

    # true：新規登録、false：既存更新
    is_created = book.new_record?

    # 登録・更新
    book.save!

    # 実行結果
    render json: {
      result: 0,
      is_created: is_created,
      book: book.attributes
    }
  end

  # DELETE /books/:id
  def destroy
    p "-----"
    p params[:id]
    p "-----"
    render json: {test: "test"}
  end

  def is_exceeded(data, max_length)
    data.length > max_length
  end

  def render_error(result, error_code, error_message = nil)
    render json: {
      result: result,
      error: {
        error_code: error_code,
        error_message: error_message
      }
    }
  end
end
