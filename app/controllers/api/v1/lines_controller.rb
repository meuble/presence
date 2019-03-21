class Api::V1::LinesController < ApplicationController
  def index
    @lines = Line.all
    render json: @lines.as_json(line_controlled_json_attributes)
  end

  def create
    permitted_params = line_params
    @line = User.last.lines.new(permitted_params)
    if @line.save
      render json: @line.as_json(line_controlled_json_attributes), status: :created
    else
      render json: {errors: @line.errors}, status: :bad_request
    end
  end

private
  def line_params
    params[:applies_on] = Date.parse(params[:applies_on]) if params[:applies_on]
    params.permit(:electricity_metric, :water_metric, :applies_on)
  end
  
  def line_controlled_json_attributes
    { 
      only: [:id, :type, :applies_on, :electricity_metric, :water_metric],
      include: { user: { only: [:id, :name, :email] } }
    }
  end
end
