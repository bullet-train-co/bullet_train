class BulletTrain::FormBuilder < ActionView::Helpers::FormBuilder
  attr_accessor :onchange
  delegate :render, :tag, to: :@template

  # <%= bullet_train_form_with model: [:account, Post.new], autosubmit: true do |form| %>
  def initialize(*, options)
    @onchange = "this.form.requestSubmit()" if options.delete(:autosubmit)
    super
  end

  # <%= form.buttons :post_at_shortcuts, %w[now this_week next_week].index_with(&:titleize) %>
  def buttons(method, button_field_options, onchange: @onchange, **)
    render "shared/fields/buttons", form: self, method:, button_field_options:, options: {onchange:, **}
  end

  # <%= form.date_field :post_at %>
  def date_field(method, onchange: @onchange, **)
    render "shared/fields/date_field", form: self, method:, options: {onchange:, **}
  end

  # <%= form.super_select :status, Post.statuses.keys.index_by(&:titleize) %>
  def super_select(method, choices = nil, html_options: {}, multiple: false, **options)
    html_options[:onchange] = onchange if onchange
    html_options[:multiple] = multiple if multiple
    render "shared/fields/super_select", form: self, method:, choices:, options:, html_options:
  end
end

module ApplicationHelper
  include Helpers::Base

  def current_theme
    :light
  end

  def bullet_train_form_with(*, **, &)
    form_with(*, **, builder: BulletTrain::FormBuilder, &)
  end
end
