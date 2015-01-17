module Authorization::Condition
  class PrincipalRoleIdEqualPrincipal < Base
    table Principal, :principals
    table PrincipalRole

    def arel_statement(**ignored)
      principal_roles[:principal_id].eq(principals[:id])
    end
  end
end
