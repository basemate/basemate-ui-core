module Matestack
  module Ui
    module Core
      class App < Base
        
        def initialize(options = {})
          @controller = Context.controller
          super(nil, nil, options)
        end

        def component_attributes
          {
            is: 'matestack-ui-core-app',
            'inline-template': true,
          }
        end

        def loading_state_element
        end
        
      end
    end
  end
end