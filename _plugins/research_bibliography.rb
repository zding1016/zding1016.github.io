# Keep the theme's paper cards while displaying every coauthor in citation order.
require "jekyll/scholar"
require "nokogiri"

module Jekyll
  class ResearchBibliographyTag < Scholar::BibliographyTag
    def bibliography_tag(entry, index)
      card = Nokogiri::HTML.fragment(super)
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
        author_line.content = "with #{names.join(', ')}"
      end
      card.to_html
    end
  end
end

Liquid::Template.register_tag("research_bibliography", Jekyll::ResearchBibliographyTag)
