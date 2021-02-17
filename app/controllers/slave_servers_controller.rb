# frozen_string_literal: true

class SlaveServersController < ApplicationController
  def index
    @slave_servers = SlaveServer.all
  end

  def show
    @slave_server = SlaveServer.find(params[:id])
  end

  def new
    @slave_server = SlaveServer.new
  end

  def create
    @slave_server = SlaveServer.new(slave_server_params)
    if @slave_server.save
      redirect_to @slave_server
    else
      render "new"
    end
  end

  def update
    @slave_server = SlaveServer.find(params[:id])
    if @slave_server.update(slave_server_params)
      redirect_to @slave_server
    else
      render "edit"
    end
  end

  def edit
    @slave_server = SlaveServer.find(params[:id])
  end

  def destroy
    @slave_server = SlaveServer.find(params[:id])
    @slave_server.destroy

    redirect_to slave_servers_path
  end

  private

    def slave_server_params
      params.require(:slave_server).permit(:host, :username, :password, :port, :slave_type, :slave_status)
    end
end
