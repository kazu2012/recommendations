class RecommendationsController < ApplicationController

  before_filter :login_required, :except => [:index, :show]
  
  def index
    @recommendations = Recommendation.find(:all,
                                        :conditions => "deleted_at IS NULL",
                                        :order => "updated_at DESC"
                                        )

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @recommendations.to_xml }
      format.rss
      format.atom
    end
  end
  
  def untagged
    @recommendations = Recommendation.find(:all,
                                        :conditions => "deleted_at IS NULL and taggings_count = 0",
                                        :order => "updated_at DESC"
                                        )
  end
  
  def show
    @recommendation = Recommendation.find(params[:id])
    
    if @recommendation.is_deleted == true 
      redirect_to homepage_path
      #raise exception
    else
      @description = Description.find(:first, :conditions => ["recommendation_id = ?", @recommendation.id], :order => ["created_at DESC"])

      respond_to do |format|
        format.html # show.rhtml
        format.xml  { render :xml => @recommendation.to_xml }
      end
    end
  end
  
  def justification
    @recommendation = Recommendation.find(params[:id])
    @justification = Justification.find(:first, :conditions => ["recommendation_id = ?", @recommendation.id], :order => ["created_at DESC"])
  end

  def new
    @recommendation = Recommendation.new
  end

  def edit
    @recommendation = Recommendation.find(params[:id])
    @description = Description.find(:first, :conditions => ["recommendation_id = ?", @recommendation.id], :order => ["created_at DESC"])
  end

  def create
    @recommendation = Recommendation.new(params[:recommendation])
    @recommendation.user_id = current_user.id

    respond_to do |format|
      if @recommendation.save
        format.html { redirect_to recommendation_url(@recommendation) }
        format.xml  { head :created, :location => recommendation_url(@recommendation) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @recommendation.errors.to_xml }
      end
    end
  end

  def update
    @recommendation = Recommendation.find(params[:id])
    
     respond_to do |format|
        if @recommendation.update_attributes(params[:recommendation])
          format.html { redirect_to recommendation_url(@recommendation) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @recommendation.errors.to_xml }
        end
      end

        
  end

end
