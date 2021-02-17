# frozen_string_literal: true

class HomepageController < ApplicationController
  def index
    @jmxs = Jmx.order(created_at: :asc)
    if search_params
      jmeters = Jmeter.where("jmx_name Like ? AND testing_type = ?", "%#{search_params[:search]}%", "stress-test")
    else
      jmeters = Jmeter
    end
    @jmeters = jmeters.page(params[:page]).order(created_at: :desc)
    @jmeters
  end

  private

    def search_params
      if params[:jmeter]
        params.require(:jmeter).permit(:search)
      end
    end
end
