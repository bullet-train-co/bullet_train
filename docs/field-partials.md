# Field Partials
Bullet Train includes a collection of view partials that are intended to [DRY-up](https://en.wikipedia.org/wiki/Don't_repeat_yourself) as much redundant presentation logic as possible for different types of form fields without taking on a third-party dependency like Formtastic.

## Responsibilities
These form field partials standardize and centralize the following behavior across all form fields that use them:

 - Apply theme styling and classes.
 - Display any error messages for a specific field inline under the field itself.
 - Display a stylized asterisk next to the label of fields that are known to be required.
 - Any labels, placeholder values, and help text are defined in a standardized way in the model's localization Yaml file.
 - For fields presenting a static list of options (e.g. a list of buttons or a select field) the options can be defined in the localization Yaml file.

It's a simple set of responsibilities, but putting them all together in one place cleans up a lot of form view code. One of the most compelling features of this "field partials" approach is that they're just HTML in ERB templates using standard Rails form field helpers within the standard Rails `form_with` method. That means there are no "last mile" issues if you need to customize the markup being generated. There's no library to fork or classes to override.

## The Complete Package
Each field partial can optionally include whichever of the following are required to fully support it:

 - **Controller assignment helper** to be used alongside Strong Parameters to convert whatever is submitted in the form to the appropriate ActiveRecord attribute value.
 - **Turbo-compatible JavaScript invocation** of any third-party library that helps support the field partial.
 - **Theme-compatible styling** to ensure any third-party libraries "fit in".
 - **Capybara testing helper** to ensure it's easy to inject values into a field partial in headless browser tests.

## Basic Usage
The form field partials are designed to be a 1:1 match for [the native Rails form field helpers](https://guides.rubyonrails.org/form_helpers.html) developers are already used to using. For example, consider the following basic Rails form field helper invocation:

```
<%= form.text_field :text_field_value, autofocus: true %>
```

Using the field partials, the same field would be implemented as follows:

```
<%= render 'shared/fields/text_field', form: form, method: :text_field_value, options: {autofocus: true} %>
```

At first blush it might look like a more verbose invocation, but that doesn't take into account that the first vanilla Rails example doesn't handle the field label or any other related functionality.

Breaking down the invocation:

 - `text_field` matches the name of the native Rails form field helper we want to invoke.
 - The `form` option passes a reference to the form object the field will exist within.
 - The `method` option specifies which attribute of the model the field represents, in the same way as the first parameter of the basic Rails `text_field` helper.
 - The `options` option is basically a passthrough, allowing you to specify options which will passed directly to the underlying Rails form field helper.

The 1:1 relationship between these field partials and their underlying Rails form helpers is an important design decision. For example, the way `options` is passed through to native Rails form field helpers means that experienced Rails developers will still be able to leverage what they remember about using Rails, while those of us who don't readily remember all the various options of those helpers can make use of [the standard Rails documentation](https://guides.rubyonrails.org/form_helpers.html) and the great wealth of Rails code examples available online and still take advantage of these field partials. That means the amount of documentation we need to maintain for these field partials is strictly for those features that are in addition to what Rails provides by default.

Individual field partials might have additional options available based on the underlying Rails form field helper. Links to the documentation for individual form field partials are listed at the end of this page.

## Reducing Repetition
When you're including multiple fields, you can DRY up redundant settings (e.g. `form: form`) like so:

```
<% with_field_settings form: form do %>
  <%= render 'shared/fields/text_field', method: :text_field_value, options: {autofocus: true} %>
  <%= render 'shared/fields/buttons', method: :button_value %>
  <%= render 'shared/fields/cloudinary_image', method: :cloudinary_image_value %>
<% end %>
```

## Enhanced field partials that invoke supporting JavaScript libraries
Some of the form field partials lean on specific JavaScript libraries to provide functionality beyond what's available from standard HTML fields. For example:

 - `date_field` and `date_and_time_field` use the [Date Range Picker](https://www.daterangepicker.com) library and provide another ~45 lines of JavaScript to polish up the user experience interacting with the fields in the context of a Bullet Train application.
 - `super_select` field partial uses [Select2](https://select2.org) to provide powerful option search and multi-select functionality out-of-the-box.
 - `phone_field` uses the [International Telephone Input](https://intl-tel-input.com) library to ensure any telephone numbers that are entered by users are in a format that can be used by third-party service providers like Twilio.
 - `ckeditor` invokes [CKEditor 5](https://ckeditor.com/ckeditor-5/). Bullet Train has already tackled the work involved in getting CKEditor 5 building from source in the context of a Rails application, so you can easily mix-in any of the powerful add-ons available.
 - `trix_editor` invokes [Trix](https://github.com/basecamp/trix) to provide basic HTML-powered formatting features as well as support for at-mentions amongst team members.

## Field partials that integrate with third-party service providers
 - `cloudinary` makes it trivial to upload photos and images to [Cloudinary](https://cloudinary.com) and store their resulting Cloudinary ID as an attribute of the model backing the form.

## Yaml Configuration
The localization Yaml file (where you configure label and option values for a field) is automatically generated when you run Super Scaffolding for a model. If you haven't done this yet, the localization Yaml file for `Scaffolding::CompletelyConcrete::TangibleThing` serves as a good example. Under `en.scaffolding/completely_concrete/tangible_things.fields` you'll see definitions like this:

<pre><code>text_field_value:
  name: &text_field_value Text Field Value
  label: *text_field_value
  heading: *text_field_value
</code></pre>

This might look redundant at first glance, as you can see that by default the same label ("Text Field Value") is being used for both the form field label (`label`) and the heading (`heading`) of the show view and table view. It's also used when the field is referred to in a validation error message. However, having these three values defined separately gives us the flexibility of defining much more user-friendly labels in the context of a form field. In my own applications, I'll frequently configure these form field labels to be much more verbose questions (in an attempt to improve the UX), but still use the shorter label as a column header on the table view and the show view:

<pre><code>text_field_value:
  name: &text_field_value Text Field Value
  label: "What should the value of this text field be?"
  heading: *text_field_value
</code></pre>

You can also configure some placeholder text (displayed in the field when in an empty state) or some inline help text (to be presented to users under the form field) like so:

<pre><code>text_field_value:
  name: &text_field_value Text Field Value
  label: "What should the value of this text field be?"
  heading: *text_field_value
  placeholder: "Type your response here"
  help: "The value can be anything you want it to be!"
</code></pre>

Certain form field partials like `buttons` and `super_select` can also have their selectable options configured in this Yaml file. See their respective documentation for details, as usage varies slightly.

## Specific Field Partials
 - [`buttons`](/docs/field-partials/buttons.md)
 - [`super_select`](/docs/field-partials/super-select.md)
