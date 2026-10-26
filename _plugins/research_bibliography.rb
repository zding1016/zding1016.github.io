# Customize coauthor lines and paper links while keeping the theme's paper cards.
require "jekyll/scholar"
require "nokogiri"

module Jekyll
  class ResearchBibliographyTag < Scholar::BibliographyTag
    PAPER_LINKS = { "ssrn" => "SSRN", "publisher_url" => "Publisher" }.freeze

    def bibliography_tag(entry, index)
      card = Nokogiri::HTML.fragment(super)
      add_paper_links(card, entry)
      author_line = card.at_css(".author")
      return card.to_html unless author_line

      identity = site.config.fetch("scholar", {})
      authors = liquidify(entry).fetch("author_array", []).reject do |author|
        last_name = author.fetch("last", "").gsub(/[*∗†‡§¶‖&^]/, "")
        Array(identity["first_name"]).include?(author["first"]) &&
          Array(identity["last_name"]).include?(last_name)
      end
      names = authors.map do |author|
        %w[first prefix last suffix].map { |part| author[part].to_s.strip }.reject(&:empty?).join(" ")
      end

      if names.empty?
        author_line.remove
      else
        name_list = names.length > 1 ? "#{names[0...-1].join(', ')} and #{names.last}" : names.first
        author_line.content = "with #{name_list}"
      end
      card.to_html
    end

    private

    def add_paper_links(card, entry)
      links = card.at_css(".links")
      return unless links

      PAPER_LINKS.each do |field, label|
        url = entry[field].to_s.strip
        next if url.empty?

        link = Nokogiri::XML::Node.new("a", card.document)
        link["href"] = url
        link["class"] = "btn btn-sm z-depth-0"
        link["role"] = "button"
        link.content = label
        links.add_child(link)
      end
    end
  end
end

Liquid::Template.register_tag("research_bibliography", Jekyll::ResearchBibliographyTag)
