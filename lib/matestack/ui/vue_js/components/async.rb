module Matestack
  module Ui
    module VueJs
      module Components
        class Async < Matestack::Ui::VueJs::Vue
          vue_name 'matestack-ui-core-async'

          required :id
          optional :show_on, :hide_on, :rerender_on, :defer

          # register itself as an async component in the context
          def initialize(html_tag = nil, text = nil, options = {}, &block)
            super(html_tag, text, options, &block)
            Matestack::Ui::Core::Context.async_components = {} if Matestack::Ui::Core::Context.async_components.nil?
            Matestack::Ui::Core::Context.async_components[self.ctx.id] = self
          end

          def create_children(&block)
            self.response &block
          end

          def response
            if params[:component_key]
              div id: ctx.id, class: 'matestack-async-component-root', 'v-if': 'showing' do
                yield
              end
            else
              vue_component do
                div class: 'matestack-async-component-container', 'v-bind:class': '{ "loading": loading === true }' do
                  div class: 'matestack-async-component-wrapper', 'v-if': 'asyncTemplate == null', 'v-bind:class': '{ "loading": loading === true }' do
                    div id: ctx.id, class: 'matestack-async-component-root', 'v-if': 'showing' do
                      yield unless is_deferred?
                    end
                  end
                  div class: 'matestack-async-component-wrapper', 'v-if': 'asyncTemplate != null', 'v-bind:class': '{ "loading": loading === true }' do
                    div id: ctx.id, class: 'matestack-async-component-root', 'v-if': 'showing' do
                      Matestack::Ui::Core::Base.new('v-runtime-template', ':template': 'asyncTemplate')
                    end
                  end
                end
              end
            end
          end

          def config
            {
              component_key: ctx.id,
              show_on: ctx.show_on,
              hide_on: ctx.hide_on,
              rerender_on: ctx.rerender_on,
              defer: ctx.defer
            }
          end

          def is_deferred?
            ctx.defer
          end

          def is_not_requested?
            params[:component_key].present? && params[:component_key] != ctx.id
          end

        end
      end
    end
  end
end