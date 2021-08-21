class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # 🚫 DEFAULT BULLET TRAIN MODEL FUNCTIONALITY
  # This section represents the default features for a Bullet Train model. Your own additions to this class should be
  # specified at the end of the file.

  include Webhooks::Outgoing::IssuingModel
  include ObfuscatesId
  include QuestionMethodsFromScopes
  include CableReady::Broadcaster

  # 🏚 i'd like to deprecate these. they're not descriptive enough.
  scope :newest, -> { order("created_at DESC") }
  scope :oldest, -> { order("created_at ASC") }

  scope :newest_created, -> { order("created_at DESC") }
  scope :oldest_created, -> { order("created_at ASC") }
  scope :newest_updated, -> { order("updated_at DESC") }
  scope :oldest_updated, -> { order("updated_at ASC") }

  # Microscope adds useful scopes targeting ActiveRecord `boolean`, `date` and `datetime` attributes.
  # https://github.com/mirego/microscope
  acts_as_microscope

  # ✅ YOUR APPLICATION'S CONFIGURATION
  # If you want to customize your application's default model behaviors, this is the place to do it. This helps avoid
  # merge conflicts in the future when Rails or Bullet Train update their own default settings.

  # 🚫 DEFAULT BULLET TRAIN MODEL FUNCTIONALITY
  # We put these at the bottom of this file to keep them out of the way. You should define your own methods above here.

  # by default we represent methods by their first string attribute.
  def self.label_attribute
    columns_hash.values.find { |column| column.sql_type_metadata.type == :string }&.name
  end

  # this is a template method you can override in activerecord models if we shouldn't just use their first string to
  # identify them.
  def label_string
    if (label_attribute = self.class.label_attribute)
      send("#{label_attribute}_was")
    else
      self.class.name.underscore.split("/").last.titleize
    end
  end

  def parent_collection
    # TODO Make this error message use reflection to try to guess which model is the parent (it's usually the first
    # `belongs_to`) andalso try to suggest what the entire method definition should actually be.
    raise "You're trying to use a feature that requires #{self.class.name} to have a `collection` method defined that returns the Active Record association that this model belongs to within its parent object."
  end
end
