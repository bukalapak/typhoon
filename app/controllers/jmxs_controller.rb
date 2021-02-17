# frozen_string_literal: true

class JmxsController < ApplicationController
  def new
    @jmx = jmx.new
  end

  def create
    jmx = Jmx.new
    jmx.script.attach(create_params[:script])
    if jmx.save
      redirect_back(fallback_location: root_path)
    else
      redirect_to root_path, flash[:jmx] = jmx.errors
    end
  end

  def destroy
    if destroy_params.empty?
      flash[:jmx_select] = "Please Select File"
      redirect_to root_path
    else
      jmx = Jmx.find(destroy_params[:jmx_id])
      jmx.destroy
      redirect_back(fallback_location: root_path)
    end
  end

  private

    # :reek:DuplicateMethodCall
    def create_params
      params.require(:jmx).permit(:script)
    end

    def destroy_params
      params.require(:jmeter).permit(:jmx_id)
    end
end
