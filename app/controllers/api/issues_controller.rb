class Api::IssuesController < ApiController
  
  def latest
    @issues = current_product.issues.public.latest(5)
    respond_to do |format|
      format.xml { render :xml => @issues.to_xml(xml_options) }
    end
  end
  
  def my
    @issues = current_product.issues.for_contact(params[:crm_id])
    respond_to do |format|
      format.xml { render :xml => @issues.to_xml(xml_options) }
    end
  end
  
  def index
    @issues = current_product.issues.public
    respond_to do |format|
      format.xml { render :xml => @issues.to_xml(xml_options) }
    end
  end
  
  def show
    respond_to do |format|
      id  = params[:id].match(/.*-(\d+)$/)[1]
      format.xml { render :xml => current_product.issues.find(id).to_xml(xml_options) }
    end
  end
  
  def create
    @issue = current_product.issues.build(params[:issue])
    respond_to do |format|
      if @issue.save
        format.xml { render :xml => @issue, :status => :created, :location => @issue }
      else
        format.xml { render :xml => @issue.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    id     = params[:id].match(/.*-(\d+)$/)[1]
    @issue = current_product.issues.find(params[:id])
    respond_to do |format|
      if @issue.update_attributes(params[:issue])
        format.xml { head :ok }
      else
        format.xml { render :xml => @issue.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
  
    def xml_options
      {
        :include => {
          :contact => {
            :only => [ :email, :first_name, :last_name, :id, :username ]
          },
          :category => {},
          :comments => {
            :include => {
              :commenter => {
                :only => [ :email, :first_name, :last_name, :id, :username ]
              }
            }
          }
        }
      }
    end
  
end