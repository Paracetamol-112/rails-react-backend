class Api::V1::StudentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_student, only: [:edit, :update, :destroy]
  def index
    @students = Student.all
    render json: @students
  end

  def show
    @student = Student.find(params[:id])
    render json: @student
  end

  def create
    @student = Student.new(student_params)
    if @student.save
      render json: { message: 'Record Created successfully' }, status: :created
    else
      render json: @student.errors, status: :unprocessable_entity
    end
  end

    def batch_create
    students_data = params[:students]

    if students_data.blank? || !students_data.is_a?(Array)
      return render json: { error: 'Invalid data format. Expected an array of students.' },
                     status: :bad_request
    end

    # Use transaction so it either creates all or none
    created_students = []
    ActiveRecord::Base.transaction do
      students_data.each do |student_params|
        student = Student.create!(student_params.permit(:name, :email, :rollnumber))
        created_students << student
      end
    end

    render json: {
      message: "#{created_students.count} students created successfully",
      students: created_students
    }, status: :created

  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

   def edit
    render json: @student
  end

  def update
    if @student.update(student_params)
      render json: { message: 'Record Updated successfully' }, status: :ok
    else
      render json: @student.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @student.destroy
      render json: { message: 'Record Deleted successfully' }, status: :ok
    else
      render json: @student.errors, status: :unprocessable_entity
    end
  end

  private

  def student_params
    params.fetch(:student, {}).permit(:name, :email, :rollnumber)
  end

  def set_student
    @student = Student.find(params[:id])
  end
end







