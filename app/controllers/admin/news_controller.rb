class Admin::NewsController < ApplicationController
  def index
    @search_terms = SearchTerm.all
  end

  def create
    search_params = params.require(:admin_news_path).permit([:search_term])
    @search_term = SearchTerm.new search_params
    @search_term.save
    add_to_news_table(@search_term.search_term)
    redirect_to admin_news_index_path
  end


  def destroy
    @search_term = SearchTerm.find(params[:id])
    @search_term.destroy
    Article.destroy_all

    if SearchTerm.exists?
      SearchTerm.each do |search|
        add_to_news_table(search.search_term)
      end
    end
    redirect_to admin_news_index_path
  end

  private

  def add_to_news_table(search_term)
    url = "https://www.googleapis.com/customsearch/v1?key=#{ENV["GCSE_KEY"]}&#{ENV["GCSE_CX"]}&q=#{search_term}"
    search = HTTParty.get(url)
    searchbody = JSON.parse(search.body)

    searchbody['items'].each do |news|
      Article.create({
        title: news['title'],
        link: news['link'],
        snippet: news['snippet'],
        displayLink: news['displayLink'],
        image: news['pagemap']['cse_thumbnail'][0]['src'],
        date: news['pagemap']['newsarticle'][0]['datepublished']
                     })
    end
  end
end
