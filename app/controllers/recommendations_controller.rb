class RecommendationsController < ApplicationController

  before_filter :login_required, :except => [:index, :show]
  
  def index
    # Should really change this so that the order is the last updated description.
    @recommendations = Recommendation.find(:all,
                                        :order => "updated_at DESC")

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @recommendations.to_xml }
    end
  end
  
  # GET /recommendations/1
  # GET /recommendations/1.xml
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

  # GET /recommendations/new
  def new
    @recommendation = Recommendation.new
  end

  # GET /recommendations/1;edit
  def edit
    @recommendation = Recommendation.find(params[:id])
    @description = Description.find(:first, :conditions => ["recommendation_id = ?", @recommendation.id], :order => ["created_at DESC"])
    
        if request.post?
            @description = Description.new
            @description.description = params[:description][:description]
            @description.recommendation_id = @recommendation.id
            @description.save

              if @description.save
                flash[:notice] = 'Recommendation was successfully updated.'
                redirect_to recommendation_url(@recommendation) 
              else
              end
        end    
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

  # PUT /recommendations/1
  # PUT /recommendations/1.xml
  def update
    @recommendation = Recommendation.find(params[:id])
    
     respond_to do |format|
        if @recommendation.update_attributes(params[:recommendation])
          flash[:notice] = 'Justification was successfully updated.'
          format.html { redirect_to recommendation_url(@recommendation) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @recommendation.errors.to_xml }
        end
      end

        
  end

  # DELETE /recommendations/1
  # DELETE /recommendations/1.xml
  def destroy
    @recommendation = Recommendation.find(params[:id])
    @recommendation.delete

    respond_to do |format|
      format.html { redirect_to recommendations_url }
      format.xml  { head :ok }
    end
  end
end
