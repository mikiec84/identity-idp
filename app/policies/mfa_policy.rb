class MfaPolicy
  def initialize(user, is_signing_up = false)
    @mfa_user = MfaContext.new(user)
    @signing_up = is_signing_up
  end

  def no_factors_enabled?
    mfa_user.enabled_mfa_methods_count.zero?
  end

  def two_factor_enabled?
    mfa_user.two_factor_configurations.any?(&:mfa_enabled?)
  end

  def multiple_factors_enabled?
    mfa_user.enabled_mfa_methods_count > 1
  end

  def more_than_two_factors_enabled?
    mfa_user.enabled_mfa_methods_count > 2
  end

  def sufficient_factors_enabled?
    mfa_user.enabled_mfa_methods_count > 1 ||
      (mfa_user.backup_code_configurations != BackupCodeConfiguration.none &&
       !signing_up)
  end

  def unphishable?
    mfa_user.phishable_configuration_count.zero? &&
      mfa_user.unphishable_configuration_count.positive?
  end

  private

  attr_reader :mfa_user
  attr_reader :signing_up
end
