class Api::V1::LinesController < ApplicationController
  def index
    @lines = Line.all
    render json: @lines
  end
end
