require_relative 'slots'
module Matestack
  module Ui
    module Core
      module TagHelper
        extend Gem::Deprecate
        include Slots
        
        # can't take content or a block
        VOID_TAGS = %i[area base br col hr img input link meta param command keygen source]
        
        TAGS = [:a, :abbr, :acronym, :address, :applet, :area, :article, :aside, :audio, :b, :base, :basefont, :bdi, :bdo, :big, :blockquote, :body, :br, :button, :canvas, :caption, :center, :cite, :code, :col, :colgroup, :data, :datalist, :dd, :del, :details, :dfn, :dialog, :dir, :div, :dl, :dt, :em, :embed, :fieldset, :figcaption, :figure, :font, :footer, :form, :frame, :frameset, :h1, :h2, :h3, :h4, :h5, :h6, :head, :header, :hr, :html, :i, :iframe, :img, :input, :ins, :kbd, :label, :legend, :li, :link, :main, :map, :mark, :meta, :meter, :nav, :noframes, :noscript, :object, :ol, :optgroup, :option, :output, :paragraph, :param, :picture, :pre, :progress, :q, :rp, :rt, :ruby, :s, :samp, :script, :section, :select, :small, :source, :span, :strike, :strong, :style, :sub, :summary, :sup, :svg, :table, :tbody, :td, :template, :textarea, :tfoot, :th, :thead, :time, :title, :tr, :track, :tt, :u, :ul, :var, :video, :wbr]
        
        VOID_TAGS.each do |tag|
          define_method tag do |options = {}|
            Matestack::Ui::Core::Base.new(tag, nil, options)
          end
        end
        
        TAGS.each do |tag|
          define_method tag do |text = nil, options = {}, &block|
            tag = :p if tag == :paragraph
            Matestack::Ui::Core::Base.new(tag, text, options, &block)
          end
        end
        
        def plain(text)
          Matestack::Ui::Core::Base.new(nil, text, nil)
        end
        
        def unescape(text)
          Matestack::Ui::Core::Base.new(nil, text.html_safe, escape: false)
        end
        alias unescaped unescape
        deprecate :unescaped, :unescape, 2021, 10
        
        def matestack(&block)
          div(id: 'matestack-ui') do
            Base.new(:component, component_attributes) do
              div(class: 'matestack-app-wrapper', &block)
            end
          end
        end

        # override image in order to implement automatically using rails assets path
        def img(text = nil, options = {}, &block)
          # if :src attribut given try to replace automatically
          if src = text.delete(:path)
            text[:src] = ActionController::Base.helpers.asset_path(src)
          end
          Matestack::Ui::Core::Base.new(:img, text, options, &block)
        end
        
        def link(text = nil, options = {}, &block)
          Matestack::Ui::Core::Base.new(:a, text, options, &block)
        end

        def rails_render(options = {})
          plain render options
        end

      end
    end
  end
end