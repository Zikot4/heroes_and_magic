class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.admin
      can :manage, :all
    else
      can :join, Lobby do |lobby|
        user_account = Account.where(user_id: user.id,).all
        account = lobby.accounts.where(id: user_account).first
        !account.nil?
      end
      can :step, Lobby do |lobby|
        units_under_attack = Unit.units_under_attack(lobby.accounts).all
        current_account = Account.current_account(lobby.accounts,user).first
        (!units_under_attack.exists?) == (current_account.current_step)
      end
      can :heal,Lobby do |lobby|
        current_account = Account.current_account(lobby.accounts,user).first
        unit = Unit.current_units(current_account, lobby.lap).first
        !(unit.nil?) ? Object.const_get(unit.variety)::CAN_HEAL : false
      end
    end

    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
