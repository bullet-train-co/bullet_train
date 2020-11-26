# Examples for the `select` Field Partial

## Define Available Buttons via Localization Yaml

If you invoke the field partial in `app/views/account/some_class_name/_form.html.erb` like so:

<pre><code><%= render 'shared/fields/select', form: form, method: :response_behavior %></code></pre>

You can define the available options in `config/locales/en/some_class_name.en.yml` like so:

<pre><code>en:
  some_class_name:
    fields:
      response_behavior:
        name: &response_behavior Response Behavior
        label: When should this object respond to new submissions?
        heading: Responds
        choices:
          immediate: Immediately
          after_10_minutes: After a 10 minute delay
          disabled: Doesn't respond
</code></pre>

## Specify Available Choices Inline

Although it's recommended to define any static list of choices in the localization Yaml file (so your application remains easy to translate into other languages), you can also specify these choices using the `choices` option from the underlying select form field helper:

<pre><code><%= render 'shared/fields/select', form: form, method: :response_behavior,
  choices: [['Immediately', 'immediate'], ['After a 10 minute delay', 'after_10_minutes'] ["Doesn't respond", 'disabled']] %></code></pre>

## Generate Choices Programmatically

You can generate the available buttons using a collection of database objects by passing the `options` option like so:

<pre><code><%= render 'shared/fields/select', form: form, method: :category_id,
  choices: Category.all.map { |category| [category.id, category.label_string] } %></code></pre>

## Allowing Multiple Button Selections

If you're looking to allow users to select multiple items, definitely use the [`super_select`](/docs/field-partials/super-select) field partial, which leverages the Select2 JavaScript library to provide a really great user experience for this (in contrast to the vanilla browser experience for this, which is horrible).
