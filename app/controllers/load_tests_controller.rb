# frozen_string_literal: true

class LoadTestsController < ApplicationController
  def index
    if search_params
      load_tests = LoadTest.where("jmx_name Like ?", "%#{search_params[:search]}%")
    else
      load_tests = LoadTest
    end
    @load_tests = load_tests.page(params[:page]).order(created_at: :desc)
    @load_tests
  end

  def new
    @load_test = LoadTest.new
  end

  def create
    @load_test = LoadTest.new(load_test_params)
    if @load_test.save
      redirect_to @load_test
    else
      render "new"
    end
  end

  def update
    @load_test = LoadTest.find(params[:id])
    if @load_test.update(load_test_params)
      redirect_to @load_test
    else
      render "edit"
    end
  end

  def edit
    @load_test = LoadTest.find(params[:id])
  end

  def show
    load_test_id = params[:id]
    @load_test = LoadTest.find(load_test_id)
    labels = LoadTestReport.where(load_test_id: load_test_id).pluck(:label).uniq
    @load_test_reports = []
    labels.each do |label|
      @load_test_reports << LoadTestReport.where(label: label).where(load_test_id: load_test_id).last
    end
  end

  def destroy
    @load_test = LoadTest.find(params[:id])
    @load_test.destroy

    redirect_to load_tests_path
  end

  private

    def load_test_params
      params.require(:load_test).permit(:jmx_id, :csv, :squad, :note, :telegram_id, :threshold)
    end

    def search_params
      if params[:jmeter]
        params.require(:jmeter).permit(:search)
      end
    end
end
