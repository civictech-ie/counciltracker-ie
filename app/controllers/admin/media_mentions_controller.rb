class Admin::MediaMentionsController < Admin::ApplicationController
  def new
    @mentionable = if params[:motion_id].present?
      Motion.find_by(hashed_id: params[:motion_id])
    elsif params[:councillor_id].present?
      Councillor.find_by(slug: params[:councillor_id])
    end

    @media_mention = @mentionable.media_mentions.new
  end

  def create
    @mentionable = if params[:motion_id].present?
      Motion.find_by(hashed_id: params[:motion_id])
    elsif params[:councillor_id].present?
      Councillor.find_by(slug: params[:councillor_id])
    end
    @media_mention = @mentionable.media_mentions.new(media_mention_params)
    if @media_mention.save
      redirect_to [:admin, @media_mention.mentionable]
    else
      render :new
    end
  end

  def show
    @media_mention = MediaMention.find(params[:id])
  end

  def edit
    @media_mention = MediaMention.find(params[:id])
  end

  def update
    @media_mention = MediaMention.find(params[:id])

    if @media_mention.update(media_mention_params)
      redirect_to [:admin, @media_mention.mentionable]
    else
      render :edit
    end
  end

  def destroy
    @media_mention = MediaMention.find(params[:id])
    @mentionable = @media_mention.mentionable
    @media_mention.destroy!
    redirect_to [:admin, @mentionable]
  end

  private

  def media_mention_params
    params.require(:media_mention).permit(
      :body,
      :url,
      :source,
      :published_on
    )
  end
end
