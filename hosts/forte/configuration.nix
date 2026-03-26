{ ... }:

{
  imports = [
    ../../profiles/darwin/roles/laptop

    ../../modules/darwin/virtualization/virt-manager
  ];

  system.primaryUser = "sysop";

  modules.virtualization.virt-manager.enable = true;
}
