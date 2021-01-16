# Examples for the `super_select` Field Partial

The vast majority of behavior is inherited from the [`select`](/docs/field-partials/select.md) field partial, so start there. In addition to all that behavior, the `super_select` partials also invokes the [Select2](https://select2.org) to provide powerful search and multi-select functionality out-of-the-box.

## Allowing Multiple Button Selections

Here is an example allowing multiple team members to be assigned to a (hypothetical) `Project` model:

<pre><code><%= render 'shared/fields/super_select', form: form, method: :membership_ids,
  choices: @project.valid_memberships.map { |membership| [membership.name, membership.id] },
  html_options: {multiple: true} %>
</code></pre>

The `html_options` key is just inherited from the underlying Rails select form field helper.
