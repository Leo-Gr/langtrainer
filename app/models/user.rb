class User < ActiveRecord::Base
  include TokenAuthenticatable

  EXERCISES_MAX = 1
  SENTENCES_MAX = 3

  has_many :providers, :class_name => 'UserProvider', :dependent => :destroy
  has_many :sentences
  has_many :corrections
  has_many :exercises
  has_many :feedbacks
  has_one :email_confirmation, validate: true
  accepts_nested_attributes_for :providers

  authenticates_with_sorcery!
  rolify

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role_ids, :as => :admin

  attr_accessible :email, :providers_attributes

  validates :email, uniqueness: true,
                    format: { with: Langtrainer.email_regexp },
                    if: 'email.present?'
  validates :email, presence: true, if: :email_required?

  validates :username, presence: true,
                       uniqueness: true,
                       if: :have_bound_auth?

  after_create :assign_default_languages
  after_create :assign_default_role
  before_save :ensure_authentication_token

  scope :admins, -> { with_role(:admin) }

  def after_token_authentication
    reset_authentication_token!
  end

  def title
    email || username
  end

  def language
    Language.find(language_id)
  end

  def assign_default_role
    return unless roles.empty?
    roles << Role.default
    save
  end

  def admin?
    has_role? :admin
  end

  private

  def assign_default_languages
    self.language_id = Language.russian
    save!
  end

  def email_required?
    providers.empty?
  end

  def have_bound_auth?
    providers.any?
  end
end
