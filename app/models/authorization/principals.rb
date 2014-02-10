#-- copyright
# OpenProject is a project management system.
#
# Copyright (C) 2010-2013 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

Authorization.scope(:principals) do
  table :principal_roles
  table :global_roles, Authorization::Table::GlobalRoles

  condition :principal_role_id_equal_principal, Authorization::Condition::PrincipalRoleIdEqualPrincipal
  condition :role_id_equal_principal_role, Authorization::Condition::RoleIdEqualPrincipalRole
  alter_condition :member_in_project, member_in_project.or(role_id_equal_principal_role)

  principals.left_join(principal_roles, :before => roles)
            .on(principal_role_id_equal_principal)
end
