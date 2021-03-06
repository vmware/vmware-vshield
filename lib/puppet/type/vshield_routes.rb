require 'pathname'
vmware_module = Puppet::Module.find('vmware_lib', Puppet[:environment].to_s)
require File.join vmware_module.path, 'lib/puppet/property/vmware'

Puppet::Type.newtype(:vshield_routes) do
  @doc = 'Manage vShield static routes'

  newparam(:scope_name, :namevar => true) do
    desc 'name of the vshield edge to configure route on'
  end

  newproperty(:default_route, :parent => Puppet::Property::VMware_Hash) do
    desc 'default route'

    alias :parent_insync? :insync?

    def insync?(is)
      # allow empty hash to cause removal of default route
      # parent does the opposite of this
      return parent_insync?(is) unless should.empty?
      return is.empty?
    end
  end

  newproperty(:static_routes, :array_matching => :all, :key => 'network', :parent => Puppet::Property::VMware_Array_Hash) do
    desc 'array of static routes'
  end
 
  newparam(:inclusive) do
    desc 'whether the resource value is inclusive'
    newvalues(:true, :false)
    defaultto(:true)
  end

  newparam(:preserve) do
    desc 'whether existing resource values are preserved'
    newvalues(:true, :false)
    defaultto(:false)
  end

  autorequire(:vshield_edge) do
    self[:name]
  end

end
