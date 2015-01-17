module Authorization::Condition
  class RoleIdEqualPrincipalRole < Base
    table Role
    table PrincipalRole

    def arel_statement(**ignored)
      principal_roles[:role_id].eq(roles[:id])
    end
  end
end
