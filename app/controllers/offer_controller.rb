class OfferController < ApplicationController
  def index
  end

  def show
    if fyber_params[:uid].length > 0
      @offer = FyberConsumer::Offer.new(fyber_params[:uid], fyber_params[:pub0],fyber_params[:page])
    else
      render :index
    end
  end

  def fyber_params
    params.require(:fyber).permit(:uid, :pub0, :page)
  end
end
