class Api::V1::LinesController < ApplicationController
  def index
    @lines = Line.all
    render json: @lines
  end

  def create
    permitted_params = line_params
    @line = User.last.lines.new(permitted_params)
    if @line.save
      render json: @line, status: :created
    else
      render json: {errors: @line.errors}, status: :bad_request
    end
  end

private
  def line_params
    params[:applies_on] = Date.parse(params[:applies_on]) if params[:applies_on]
    params.permit(:electricity_metric, :water_metric, :applies_on)
  end
end
