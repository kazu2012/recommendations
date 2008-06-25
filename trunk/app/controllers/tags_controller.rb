class TagsController < ApplicationController

  def index
    @tags = Tag.find(:all, :order => "taggings_count DESC")

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @tags.to_xml }
    end
  end

  def show
    @tag = Tag.find_by_name(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @tag.to_xml }
    end
  end


end
