# Examples for the `super_select` Field Partial

The `super_select` partial provides a wonderful default UI (in contrast to the vanilla browser experience for this, which is horrible) with optional search and multi-select functionality out-of-the-box. It invokes the [Select2](https://select2.org) library to provide you these features.

## Define Available Buttons via Localization Yaml

If you invoke the field partial in `app/views/account/some_class_name/_form.html.erb` like so:

<pre><code><%= render 'shared/fields/super_select', form: form, method: :response_behavior %></code></pre>

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

<pre><code><%= render 'shared/fields/super_select', form: form, method: :response_behavior,
  choices: [['Immediately', 'immediate'], ['After a 10 minute delay', 'after_10_minutes'] ["Doesn't respond", 'disabled']] %></code></pre>

## Generate Choices Programmatically

You can generate the available buttons using a collection of database objects by passing the `options` option like so:

<pre><code><%= render 'shared/fields/super_select', form: form, method: :category_id,
  choices: Category.all.map { |category| [category.label_string, category.id] } %></code></pre>

## Allowing Multiple Option Selections

Here is an example allowing multiple team members to be assigned to a (hypothetical) `Project` model:

<pre><code><%= render 'shared/fields/super_select', form: form, method: :membership_ids,
  choices: @project.valid_memberships.map { |membership| [membership.name, membership.id] },
  html_options: {multiple: true} %>
</code></pre>

The `html_options` key is just inherited from the underlying Rails select form field helper.

## Allowing Search

Here is the same example, with search enabled:

<pre><code><%= render 'shared/fields/super_select', form: form, method: :membership_ids,
  choices: @project.valid_memberships.map { |membership| [membership.name, membership.id] },
  html_options: {multiple: true}, other_options: {search: true} %>
</code></pre>
