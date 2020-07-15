# Essential Guide 3: Person Index, Show, Transition

Welcome to the third part of the 10-step-guide of setting up a working Rails CRUD app with `matestack-ui-core`!

## Introduction
In the [previous guide](guides/essential/02_active_record.md), we added an ActiveRecord model to our project, added some fake persons to our database and displayed them on our `matestack` app.

In this guide, we will
- add proper page to display all the persons in our database
- a detail page for every person
- dive into the concept of page transitions by switching back and forth between the list of all persons and the detail page

## Prerequisites
We expect you to have successfully finished the [previous guide](guides/essential/02_active_record.md) and no uncommited changes in your project.

## Person controller & routes

Let's kick it off by creating a dedicated controller for our **person** model. Add the content below to `app/controllers/persons_controller.rb`:

```ruby
class PersonsController < ApplicationController

  def index
    responder_for(Pages::DemoApp::Person::Index)
  end

  def show
    @person = Person.find_by(id: params[:id])
    responder_for(Pages::DemoApp::Person::Show)
  end

end
```

Also, make sure to update the routes like this:

```ruby
Rails.application.routes.draw do
  root to: 'persons#index'

  get '/first_page', to: 'demo_app#first_page'
  get '/second_page', to: 'demo_app#second_page'

  resources :persons, only: [:index, :show]
end
```

## Page transitions
In `app/matestack/apps/demo_app.rb`, remove line 17-24 and add

```ruby
br
transition path: :persons_path, text: 'All persons'
hr
```

below line 13. By doing this, we make sure the person index page will be reachable from all pages. Also, the horizontal ruler (`hr`) tag makes it easier to distinguish between the wrapping `matestack` app and the `page_content`!

## Person index page
For the index page (where all the persons in the database get displayed), create a file called `app/matestack/pages/demo_app/persons/index.rb` and add the content below:

```ruby
class Pages::DemoApp::Persons::Index < Matestack::Ui::Page

	def prepare
		@persons = Person.all
	end

	def response
		components {
			ul do
				@persons.each do |person|
					li do
						plain "#{person.first_name} #{person.last_name} "
						transition path: :person_path, params: {id: person.id}, text: '(Details)'
					end
				end
			end
		}
	end

end
```

Like before, we loop through all records and display them as list items. But this time, we enhance things by adding a transition link to their detail page by passing their `id` to the `params` as shown above!

## Person detail page
In the `app/matestack/pages/demo_app/persons/` directory, add a file called `show.rb` with the contents below:

```ruby
class Pages::DemoApp::Persons::Show < Matestack::Ui::Page

  def response
    components {
      transition path: :persons_path, text: 'Back to index'
      heading size: 2, text: "Name: #{@person.first_name} #{@person.last_name}"
      paragraph text: "Active: #{@person.active}"
      paragraph text: "Role: #{@person.role}"
    }
  end

end
```

This is our detail page, featuring not only the person's name, but also their status (whether they're active or not) and their role. To make things easy for page visitors, there's also a "back" link to get back to our index page!

## Further introduction: Page transitions
Now that we've used them a couple of times, let's focus on the `transition` component a bit longer:

When you want to change between different pages within the same `matestack` app, using a `transition` component gives you a neat advantage: After clicking the link, instead of doing a full page reload, only the page content within your app gets replaced - this leads to a better performance (faster page load) and a more app-like feeling for your users or page visitors!

For links that go outside your `matestack` app, require a full page reload or reference URLs outside your domain, make sure to use the [link component](/docs/components/link.md) instead!

To learn more, check out the [complete API documentation](docs/components/transition.md) for the `transition` component.

## Local testing
Run `rails s` and head over to [localhost:3000](http://localhost:3000/) to test the changes! You should be able to browse through the various persons in the database and switch between the different pages using the transition links.

## Saving the status quo
As usual, we want to commit the progress to Git. In the repo root, run

```sh
git add . && git commit -m "Add index/show matestack pages for person model (incl. controller, routes), update demo matestack app"
```

## Deployment

After you've finished all your changes and commited them to Git, run

```sh
git push heroku master
```

to deploy your latest changes (unlike last time, no migrations are needed since the database schema remains unchanged). Check the results via

```sh
heroku open
```

and be proud of yourself - you're getting somewhere with this!

## Recap & outlook
Our **person** model now has a dedicated index and detail (=show) page, and the pages within our `matestack` app are properly linked to each other.

Let's continue and add the necessary functionality for adding new persons and editing existing ones in the [next part of the series](/guides/essential/04_form_create_update_delete.md).