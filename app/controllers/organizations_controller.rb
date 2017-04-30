  class OrganizationsController < ApplicationController

    def new
    @organization = Organization.new
    end

    def index
      @organizations = Organization.all.order('created_at DESC')
    end

    def show
          @organization = Organization.find params[:id]
          @technology = Technology.new
      end

    def create
      @organization = Organization.new organization_params
      if @organization.save
        redirect_to organization_path(@organization)
      else
        render :new
      end
    end

    def edit
      @organization = Organization.find params[:id]
      @user = current_user
    end
    def confirm
      @organization = Organization.find params[:id]
      @user = current_user

    end

    def update_confirm
      @organization = Organization.find params[:id]
      @user = current_user
      @user.update({organization_id: params[:id], org_approved: false})
      redirect_to organization_path(@organization), notice: 'Thanks for claming. We will get back to you soon!'
    end


    def update

      # redirect_to admin_index_path, notice: 'Pending'

    end

      private

        def find_organization
          @organization = Organization.find params[:id]
        end

        def organization_params
          params.require(:organization).permit([:name, :manager, :website, :twitter, :overview, { technology_id: [] } ])
        end

  end
