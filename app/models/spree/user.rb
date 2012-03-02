module Spree
  class User < ActiveRecord::Base
    include Core::UserBanners

    devise :database_authenticatable, :token_authenticatable, :registerable, :recoverable,
           :rememberable, :trackable, :validatable, :encryptable, :encryptor => 'authlogic_sha512'

    has_many :orders
    has_and_belongs_to_many :roles, :join_table => 'spree_roles_users'
    belongs_to :ship_address, :foreign_key => 'ship_address_id', :class_name => 'Spree::Address'
    belongs_to :bill_address, :foreign_key => 'bill_address_id', :class_name => 'Spree::Address'

    before_save :check_admin
    before_validation :set_login
    before_destroy :check_completed_orders

    # Setup accessible (or protected) attributes for your model
    attr_accessible :email, :password, :password_confirmation, :remember_me, :persistence_token, :login


    # For Refinery
    accepts_nested_attributes_for :roles
    attr_accessible :roles_attributes, :roles
    has_many :plugins, :class_name => "Refinery::UserPlugin", :order => "position ASC", :dependent => :destroy
    # friendly_id :username
    accepts_nested_attributes_for :plugins
    attr_accessible :plugins_attributes, :plugins


    users_table_name = User.table_name
    roles_table_name = Role.table_name

    scope :admin, lambda { includes(:roles).where("#{roles_table_name}.name" => "admin") }
    scope :refinery_admin, lambda { includes(:roles).where("#{roles_table_name}.name" => "Refinery") }
    scope :registered, where("#{users_table_name}.email NOT LIKE ?", "%@example.net")

    class DestroyWithOrdersError < StandardError; end

    # has_role? simply needs to return true or false whether a user has a role or not.
    def has_role?(role_in_question)
      roles.any? { |role| role.name == role_in_question.to_s }
    end



    #### REFINERY STUFF HERE

      has_many :plugins, :class_name => "::Refinery::UserPlugin", :order => "position ASC", :dependent => :destroy

      def plugins=(plugin_names)
        if persisted? # don't add plugins when the user_id is nil.
          ::Refinery::UserPlugin.delete_all(:user_id => id)

          plugin_names.each_with_index do |plugin_name, index|
            plugins.create(:name => plugin_name, :position => index) if plugin_name.is_a?(String)
          end
        end
      end

      def authorized_plugins
        plugins.collect { |p| p.name } | ::Refinery::Plugins.always_allowed.names
      end
      
      def add_role(title)
        raise ArgumentException, "Role should be the title of the role not a role object." if title.is_a?(Spree::Role)
        roles << Spree::Role[title] unless has_role?(title)
      end

      def has_role?(title)
        raise ArgumentException, "Role should be the title of the role not a role object." if title.is_a?(Spree::Role)
        roles.any?{|r| r.name == title.to_s.camelize || r.name = title.to_s}
      end

      def can_edit?(user_to_edit = self)
        user_to_edit.persisted? && (
          user_to_edit == self ||
          self.has_role?(:superuser)
        )
      end
      
      def can_delete?(user_to_delete = self)
        user_to_delete.persisted? and
        id != user_to_delete.id and
        !user_to_delete.has_role?(:superuser) and
        Spree::Role[:refinery].users.count > 1
      end

      def title
        self.name
      end

    #### END OF REFINERY STUFF


    # Creates an anonymous user.  An anonymous user is basically an auto-generated +User+ account that is created for the customer
    # behind the scenes and its completely transparently to the customer.  All +Orders+ must have a +User+ so this is necessary
    # when adding to the "cart" (which is really an order) and before the customer has a chance to provide an email or to register.
    def self.anonymous!
      token = Spree::User.generate_token(:persistence_token)
      Spree::User.create(:email => "#{token}@example.net", :password => token, :password_confirmation => token, :persistence_token => token)
    end

    def self.admin_created?
      Spree::User.admin.count > 0
    end

    def anonymous?
      email =~ /@example.net$/
    end

    def send_reset_password_instructions
      generate_reset_password_token!
      UserMailer.reset_password_instructions(self).deliver
    end

    protected
      def password_required?
        !persisted? || password.present? || password_confirmation.present?
      end

    private

      def check_completed_orders
        raise DestroyWithOrdersError if orders.complete.present?
      end

      def check_admin
        return if self.class.admin_created?
        admin_role = Role.find_or_create_by_name 'admin'
        self.roles << admin_role
      end

      def set_login
        # for now force login to be same as email, eventually we will make this configurable, etc.
        self.login ||= self.email if self.email
      end

      # Generate a friendly string randomically to be used as token.
      def self.friendly_token
        SecureRandom.base64(15).tr('+/=', '-_ ').strip.delete("\n")
      end

      # Generate a token by looping and ensuring does not already exist.
      def self.generate_token(column)
        loop do
          token = friendly_token
          break token unless find(:first, :conditions => { column => token })
        end
      end

      def self.current
        Thread.current[:user]
      end

      def self.current=(user)
        Thread.current[:user] = user
      end
  end
end
