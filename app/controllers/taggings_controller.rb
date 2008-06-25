class TaggingsController < ApplicationController

  before_filter :login_required, :except => [:index, :show]

  def index
    @taggings = Tagging.find(:all)

    respond_to do |format|
      format.html
      format.xml  { render :xml => @taggings.to_xml }
    end
  end

  def show
    @tagging = Tagging.find(params[:id])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @tagging.to_xml }
    end
  end

  def new
    @tagging = Tagging.new
  end

  def edit
    @tagging = Tagging.find(params[:id])
  end

  def create
    @tagging = Tagging.new(params[:tagging])
    @recommendation = Recommendation.find(@tagging.recommendation_id)

    @tagging.tag_text = @tagging.tag_text.strip
    tag_name = @tagging.tag_text.downcase
    

    @tag = Tag.find_by_name(tag_name)
    
    if @tag == nil
      @tag = Tag.new
      @tag.name = tag_name
      @tag.save!
    end
    
    @tagging.tag = @tag
    
    @tagging.user_id = current_user.id

    respond_to do |format|
      if @tagging.save
        format.html { redirect_to recommendation_url(@recommendation) }
        format.xml  { head :created, :location => recommendation_url(@recommendation) }
      else
        flash[:notice] = "Error adding tag"
        format.html { redirect_to recommendation_url(@recommendation) }
        format.xml  { render :xml => @tagging.errors.to_xml }
      end
    end
  end

  def destroy
    @tagging = Tagging.find(params[:id])
    @tagging.destroy

    respond_to do |format|
      format.html { redirect_to recommendation_url(@tagging.recommendation.id) }
      format.xml  { head :ok }
    end
  end
end
