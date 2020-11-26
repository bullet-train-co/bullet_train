# Examples for the `buttons` Field Partial

## Define Available Buttons via Localization Yaml

If you invoke the field partial in `app/views/account/some_class_name/_form.html.erb` like so:

<pre><code><%= render 'shared/fields/buttons', form: form, method: :enabled %></code></pre>

You can define the available buttons in `config/locales/en/some_class_name.en.yml` like so:

<pre><code>en:
  some_class_name:
    fields:
      enabled:
        name: &enabled Enabled
        label: Should this item be enabled?
        heading: Enabled?
        options:
          yes: "Yes, this item should be enabled."
          no: "No, this item should be disabled."
</code></pre>

## Generate Buttons Programmatically

You can generate the available buttons using a collection of database objects by passing the `options` option like so:

<pre><code><%= render 'shared/fields/buttons', form: form, method: :category_id,
  options: Category.all.map { |category| [category.id, category.label_string] } %></code></pre>

## Allow Multiple Button Selections

You can allow multiple buttons to be selected using the `multiple` option, like so:

<pre><code><%= render 'shared/fields/buttons', form: form, method: :category_ids,
  options: Category.all.map { |category| [category.id, category.label_string] }, multiple: true %></code></pre>
