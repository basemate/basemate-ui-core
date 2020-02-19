module Matestack::Ui::Core::App

  # TODO: Similar to page, App doesn't need everything base offers atm
  class App < Matestack::Ui::Core::Component::Base

    def show(page_id, page_nodes, &block)
      @page_id = page_id
      @page_nodes = page_nodes
      prepare
      response
      render(view: :app, &block)
    end

    def page_content
      # TODO ;)
    end
  end
end
