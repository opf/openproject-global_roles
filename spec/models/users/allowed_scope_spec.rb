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

require 'spec_helper'

describe User, 'allowed scope' do
  let(:user) { member.principal }
  let(:anonymous) { FactoryGirl.build(:anonymous) }
  let(:project) { FactoryGirl.build(:project, is_public: false) }
  let(:project2) { FactoryGirl.build(:project, is_public: false) }
  let(:role) { FactoryGirl.build(:role) }
  let(:role2) { FactoryGirl.build(:role) }
  let(:anonymous_role) { FactoryGirl.build(:anonymous_role) }
  let(:member) { FactoryGirl.build(:member, :project => project,
                                            :roles => [role]) }

  let(:action) { :the_one }
  let(:other_action) { :another }
  let(:public_action) { :view_project }
  let(:global_permission) { Redmine::AccessControl.permissions.find { |p| p.global? } }
  let(:global_role) { FactoryGirl.build(:global_role, :permissions => [global_permission.name]) }

  before do
    user.save!
    anonymous.save!
  end

  describe "w/o the context being a project
            w/o the user being member in a project
            w/ the user having the global role
            w/ the global role having the necessary permission" do
    before do
      global_role.save!

      principal_role = FactoryGirl.build(:empty_principal_role)
      principal_role.principal = user
      principal_role.role = global_role
      principal_role.save!
    end

    it "should be the user" do
      User.allowed(global_permission.name).should =~ [user]
    end
  end

  describe "w/o the context being a project
            w/o the user being member in a project
            w/ the user having the global role
            w/o the global role having the necessary permission" do

    before do
      global_role.permissions = []
      global_role.save!

      principal_role = FactoryGirl.build(:empty_principal_role)
      principal_role.principal = user
      principal_role.role = global_role
      principal_role.save!
    end

    it "should be empty" do
      User.allowed(global_permission.name).should =~ []
    end
  end

  describe "w/o the context being a project
            w/o the user being member in a project
            w/o the user having the global role
            w/ the global role having the necessary permission" do

    before do
      global_role.permissions = []
      global_role.save!
    end

    it "should be empty" do
      User.allowed(global_permission.name).should =~ []
    end
  end

  describe "w/o the context being a project
            w/o the user being member in a project
            w/o the user having the global role
            w/ the user being admin" do

    before do
      user.update_attribute(:admin, true)
    end

    it "should be the user" do
      User.allowed(global_permission.name).should =~ [user]
    end
  end

  describe "w/ the context being a project
            w/o the user being member in the project
            w/ the user having the global role
            w/ the global role having the necessary permission" do
    before do
      global_role.save!

      principal_role = FactoryGirl.build(:empty_principal_role)
      principal_role.principal = user
      principal_role.role = global_role
      principal_role.save!
    end

    it "should be the user" do
      User.allowed(global_permission.name, project).should =~ [user]
    end
  end

  describe "w/ the context being a project
            w/o the user being member in the project
            w/ the user having the global role
            w/o the global role having the necessary permission" do
    before do
      global_role.permissions = []
      global_role.save!

      principal_role = FactoryGirl.build(:empty_principal_role)
      principal_role.principal = user
      principal_role.role = global_role
      principal_role.save!
    end

    it "should be empty" do
      User.allowed(global_permission.name, project).should =~ []
    end
  end

  describe "w/ the context being a project
            w/o the user being member in a project
            w/o the user having the global role
            w/ the global role having the necessary permission" do

    before do
      global_role.permissions = []
      global_role.save!
    end

    it "should be empty" do
      User.allowed(global_permission.name, project).should =~ []
    end
  end

  describe "w/ the context being a project
            w/o the user being member in a project
            w/o the user having the global role
            w/ the user being admin" do

    before do
      user.update_attribute(:admin, true)
    end

    it "should be the user" do
      User.allowed(global_permission.name, project).should =~ [user]
    end
  end
end

