# Themes

Bullet Train has a theme subsystem designed to allow you the flexibility to either extend or completely replace the stock “Light” and “Clean” UI templates.

## Inheritance Structure

To reduce duplication of code across themes, Bullet Train implements an inheritance structure. For example, the official Bullet Train themes are structured hierarchically like so:

- “Base”
  - “Bootstrap”
    - “Clean”
  - “Tailwind”
    - “Light”
    - “Bold”

Any component partials that can be shared are pushed up the inheritance structure. For example, [Bullet Train's library of field partials](/docs/field-partials.md) provide a good example of this, illustrating the power of the approach we’ve taken here:

 - The most general field styling varies substantially between Tailwind CSS and Bootstrap, so a `_field.html.erb` component partial exists in both the foundational “Tailwind” and “Bootstrap” themes, but also a further customized version exists in themes like “Light”.
 - However, many concrete field types like `_text_field.html.erb` and `_phone_field.html.erb` leverage `_field.html.erb`, and they themselves are completely framework agnostic as a result. These partials can live in the shared “Base” theme.

At run-time, this means:

- When rendering `_text_field.html.erb`, it renders from “Base”.
- However, when `_text_field.html.erb` references `_field.html.erb`, that renders from “Light”.
- If you extend “Light” and override `_field.html.erb`, rendering `_text_field.html.erb` will now use your theme’s `_field.html.erb`.

## Theme Component Usage

To use a theme component, simply include it from "within" `shared` like so:

```
<%= render 'shared/fields/text_field', method: :text_field_value %>
```

We say "within" because while a `shared` view partial directory does exist, the referenced `shared/fields/_text_field.html.erb` doesn't actually exist within it. Instead, the theme engine picks up on `shared` and also works its way through the theme directories to find the appropriate match.

### Tools for Indirection

This small bit of indirection does buy us an incredible amount of power in building and extending themes. But indirection also comes at a small cognitive cost. Here are two ways to offset that cost:

#### 1. Xray

We include [Xray](https://github.com/brentd/xray-rails) in Bullet Train by default to ensure it's always crystal clear when viewing the page source where any series of partials are being rendered from. This is an invaluable tool when working with theme component partials.

For example, our earlier example renders the following comments into the page's HTML source in the development environment:

```
<!--XRAY START 192 .../app/views/themes/base/fields/_text_field.html.erb-->
<!--XRAY START 191 .../app/views/themes/light/fields/_field.html.erb-->
...
<!--XRAY END 191-->
<!--XRAY END 192-->
```

This doesn't only help you understand which smaller components a higher-level component is composed of, but it also allows you to quickly identify where in the theme inheritance structure each of those smaller components are being pulled in from.

#### 2. IDE Fuzzy Search

If you don't already, you'll want to use a fuzzy search in your IDE to drill down into `shared` view partials. For example, to drill down into the view partial in the example above, you would search for `fields/text_field`, and choose the appropriate instance of that file from within the themes directory.

## Theme Configuration

You can specify the theme you’d like to use and its inheritance structure in `app/helpers/theme_helper.rb`. The code there is well commented to help you.

## Theme Structure

Themes are represented in a few places. Taking “Light” as an example, we have:

- A directory of theme-specific component partials in `app/views/themes/light`, including a layout ERB template.
- A theme-specific stylesheet in `app/javascript/stylesheets/light/application.scss`.
- A theme-specific pack in `app/javascript/packs/light.js`. You’ll see there that the actual JavaScript dependencies and code are shared across all themes. The whole purpose of this theme-specific pack is to serve up the theme-specific stylesheet.
- Theme-specific logos and images in `app/javascript/images/light`.

## Adding a New Theme

To extend the “Light” theme in a new theme called “Tokyo”, we would:

1. Copy `app/javascript/packs/light.js` to `app/javascript/packs/tokyo.js` and update references to `light` therein to `tokyo`.
2. Copy `app/views/themes/light/layouts` to `app/views/themes/tokyo/layouts` and update references to `light` in the contained files to `tokyo`. It's possible this is too much duplication, but in practice most people want to customize these two layouts in their custom themes.
3. Create a new file at `app/javascript/stylesheets/tokyo/application.scss`. To start just add `@import "../light/application";` at the top, which represents the fact that “Tokyo” extends “Light”. Any custom styles can be added below that.
4. Add `"tokyo"` as the first item in the `THEME_DIRECTORY_ORDER` array in `app/helpers/theme_helper.rb`.

You should be good to go! We'll try to add a generator for this in the future.

## Additional Guidance and Principles

### Should you extend or replace?

For most development projects, the likely best path for customizing the UI is to extend “Light” or another complete Bullet Train theme. It’s difficult to convey how many hours have gone into making the Bullet Train themes complete and coherent from end to end. Every type of field partial, all the third-party libraries, all the responsiveness scenarios, etc. It’s taken many hours and many invoices.

Extending an existing theme is like retaining an option on shipping. By extending a theme that is already complete, you allow yourself to say “enough is enough” at a certain point and just living with some inherited defaults in exchange for shipping your product sooner. You can always do more UI work later, but it doesn’t look unpolished now!

On the other hand, if you decide to try to build a theme from the ground up, you risk getting to that same point, but not being able to stop because there are bits around the edges that don’t feel polished and cohesive.

### Don’t reference theme component partials directly, even within the same theme!

#### ❌ Don’t do this, even in theme partials:

```
<%= render "themes/light/box" do |p| %>
  ...
<% end %>
```

#### ✅ Instead, always do this:

```
<%= render "shared/box" do |p| %>
  ...
<% end %>
```

This allows the theme engine to resolve which theme in the inheritance chain to include the `box` partial from. For example:

 - It might come from the “Light” theme today, but if you switch to the “Bold” theme later, it’ll can start pulling it from there.
 - If you start extending “Light”, you can override its `box` implementation and your application will pick up the new customized version from your theme automatically.
 - If (hypothetically) `box` became generalized and move into the parent “Tailwind” theme, your application would pick it up from the appropriate place.

### Avoid modifying the stock templates.

It's not the end of the world if you do, but it sets you up for merge conflicts down the road. It's better if you go through the steps above to create your own theme that extends the theme you're primarily using.

### Let your designer name their theme.

You're going to have to call your theme something and there are practical reasons to not call it something generic. If you're pursuing a heavily customized design, consider allowing the designer or designers who are creating the look-and-feel of your application to name their own masterpiece. Giving it a distinct name will really help differentiate things when you're ready to start introducing additional facets to your application or a totally new look-and-feel down the road.
