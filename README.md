# JIT Provisioning in Sandboxes with Salesforce Identity

This repository contains an Apex handler for JIT provisioning that makes it easy to use Salesforce Identity to create users in your sandbox JIT. The functionality that this provides over standard JIT provisioning is:

- Only set some attributes on create. This means that you can change the profile of users in your sandboxes without having them reverted every time that they log in. Be default this behavior applies to
  - Username
  - ProfileId
  - Roleid

To add attributes to this handler, use the same syntax that you would for native provisioning. See [this](https://help.salesforce.com/s/articleView?id=sf.sso_jit_requirements.htm&type=5) document for details. For clarity, in order to set a user field, the syntax is `User.Username`.

Make sure that your custom attributes have a value for every required field. See [this](https://help.salesforce.com/s/articleView?id=000327115&type=1) article for details.

**Note that this only works for internal users.**

Installation URLs:

- [Production](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t8b000001RvnhAAC)
- [Sandbox](https://test.salesforce.com/packaging/installPackage.apexp?p0=04t8b000001RvnhAAC)
