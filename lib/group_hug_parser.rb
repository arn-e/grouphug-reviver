require_relative '../app/models/confession'
require 'mechanize'

class GroupHugParser
  attr_reader :confessions

  def self.import
    ghp = GroupHugParser.new("http://web.archive.org/web/20071025014638/http://grouphug.us/", 5)
    ghp.extract_confessions
  end

	def initialize(url, n)
    @base_url = url
    @agent = Mechanize.new
    @pages = [@agent.get(@base_url)]
    get_pages(n)
  end

	def get_pages(n)
    return if n == 1

    current_page = @pages.last
    next_page_link = get_next_page_link(current_page)

    @pages << @agent.get(next_page_link)
    get_pages(n-1)
	end

  def get_next_page_link(page)
    page.search('tr').last.css('#nav-pages-next').children[1].attributes['href'].value
  end

  def extract_posts(page)
    ids, confessions = [], []

    page.search('.conf-id').each {|i| ids << i.children.text.strip }
    page.search('.conf-text').each {|i| confessions << i.children.text.strip }
    
    ids.map! {|elt| [:number, elt]}
    confessions.map! {|elt| [:text, elt]}

    ids.zip(confessions)
  end

  def extract_confessions
    confs = []
    @pages.each do |page|
      extract_posts(page).each do |confession|
        confs << Confession.new(Hash[confession])          
      end
    end
    p confs
    results = confs.map(&:save)
    p results
    return results.select{|r| r}.length
  end

end

# GroupHugParser.new("http://web.archive.org/web/20071025014638/http://grouphug.us/", 5)
